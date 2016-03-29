
#include "helloworld.h"



XIicPs i2c_dev;
XIicPs_Config *i2c_config = NULL;
u8 SendBuffer[IIC_BUFFER_SIZE];    /**< Buffer for Transmitting Data */

XGpio Power_Clock_GPIO;

//XGpio Dma_GPIO;
u32 frame_status[3];

XAxiCdma xcdma;
XAxiCdma_Config * CdmaCfgPtr = NULL;

XScuGic Gic;			/* PS GIC -- interrupt*/
XScuGic_Config *GicConfig = NULL;

volatile static int Done = 0;	/* Dma transfer is done */
volatile static int Error = 0;	/* Dma Bus Error occurs */

int exit_infinite_while = 0;
int frame_log_idx = 0;
int ps2pl_log_idx = 0;
int pl2ps_log_idx = 0;



u8 image_buffer[NUM_BUFFERS][BYTES_PER_IMAGE];
u8 dvs_curr_buffer = 0;
u8 dvs_curr_block = 0;
u8 vga_curr_block = 0;
u8 writing = 0;
u8 reading = 0;
u8 done_writing = 0;
u8 done_reading = 0;


void new_frame_intr_handler(void *InstancePtr){
//	xil_printf("Frame number (%d)\r\n", exit_infinite_while);
//	xil_printf("\t=================================================================\r\n");

	u8 dvs_next_buffer = dvs_curr_buffer + 1;
    if (dvs_next_buffer == NUM_BUFFERS){
    	dvs_next_buffer = 0;
    }
    memcpy(image_buffer[dvs_next_buffer], image_buffer[dvs_curr_buffer], BYTES_PER_IMAGE);

    dvs_curr_block = 0;
    dvs_curr_buffer = dvs_next_buffer;


	exit_infinite_while += 1;
}

void vga_new_block_intr_handler(void *InstancePtr){
	u32 Status;
	u32 buffer_address;

	u8 vga_curr_buffer = dvs_curr_buffer - 1;
	if (vga_curr_buffer == 255){
		vga_curr_buffer = NUM_BUFFERS - 1;
	}
	xil_printf("Frame number (%d), buffer number (%d), block number (%d)\r\n",
			   exit_infinite_while, vga_curr_buffer, vga_curr_block);

	buffer_address = (u32)&(image_buffer[vga_curr_buffer][vga_curr_block*BYTES_PER_BLOCK]);
//	xil_printf("reading block address = 0x%08x\r\n", buffer_address);

//    XTime_GetTime(&tStart);
	Status = XAxiCdma_SimpleTransfer(&xcdma, buffer_address, (u32)VGA_CDMA_BRAM_MEMORY,
									 BYTES_PER_BLOCK, NULL, NULL);
	while (XAxiCdma_IsBusy(&xcdma));

	vga_curr_block += 1;
	if (vga_curr_block >= BLOCKS_PER_IMAGE){
		vga_curr_block = 0;
	}

}

void pl2ps_line_intr_handler(void *InstancePtr){
	u32 Status;
	u32 buffer_address;

	// start Copy from PL to DDR

	xil_printf("Frame number (%d), buffer number (%d), block number (%d)\r\n", exit_infinite_while, dvs_curr_buffer, dvs_curr_block);

	buffer_address = (u32)&(image_buffer[dvs_curr_buffer][dvs_curr_block*BYTES_PER_BLOCK]);

	Status = XAxiCdma_SimpleTransfer(&xcdma, (u32)CDMA_BRAM_MEMORY, buffer_address,
									 BYTES_PER_BLOCK, NULL, NULL);
	while (XAxiCdma_IsBusy(&xcdma));



	dvs_curr_block += 1;
	if (dvs_curr_block >= BLOCKS_PER_IMAGE){
		dvs_curr_block = BLOCKS_PER_IMAGE - 1; // or 0 ???
	}

	// start Copy from DDR to PL

	buffer_address = (u32)&(image_buffer[dvs_curr_buffer][dvs_curr_block*BYTES_PER_BLOCK]);


	Status = XAxiCdma_SimpleTransfer(&xcdma, buffer_address, (u32)CDMA_BRAM_MEMORY,
									 BYTES_PER_BLOCK, NULL, NULL);
	while (XAxiCdma_IsBusy(&xcdma));
}

int main (void) {

	u8 select;
	int i, j, CDMA_Status;
    int numofbytes;
    u8 * source, * destination;
    u8 * cdma_memory_source, * cdma_memory_destination;
    u32 test_done = 0;

    XTime tStart, tEnd;

    u32 Status;

//    u8 default_mem_val = 0xB8; // red
//    u8 default_mem_val = 0x47; // green
    u8 default_mem_val = 0; // black
//    u8 default_mem_val = 0x3F; // whitest

    memset(image_buffer, default_mem_val, BYTES_PER_IMAGE*NUM_BUFFERS);

    for(i = 0; i < NUM_BUFFERS; i += 1){

    	xil_printf("Buffer %d address = 0x%08x\n\r", i, image_buffer[i]);
    	for(j = 0; j < BYTES_PER_IMAGE; j++){
    		if(image_buffer[i][j] != default_mem_val){
    			xil_printf("Image %d has non default value in pixel %d\n\r", i, j);
    		}
    	}
    }

    xil_printf("-- Simple DMA Design Example --\r\n");
    xil_printf("Words per block (%d)\r\n", WORDS_PER_BLOCK);
    xil_printf("Bytes per block (%d)\r\n", BYTES_PER_BLOCK);

    // Initialise i2c
    Status = setup_i2c(&i2c_dev, i2c_config, XPAR_PS7_I2C_0_DEVICE_ID, IIC_SCLK_RATE);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	print("i2c system initialised\r\n");

	// Setup camera gpio ports
	Status = setup_cam_gpio(&Power_Clock_GPIO, XPAR_AXI_GPIO_0_DEVICE_ID,
							PWDN_GPIO_CHANNEL, PWDN_GPIO_DIR_MASK,
							CLOCK_GPIO_CHANNEL, CLOCK_GPIO_DIR_MASK);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	print("Camera GPIO initialised\r\n");




	// Disable DCache
	Xil_DCacheDisable();

	// Setup DMA Controller

    Status = setup_cdma(&xcdma, CdmaCfgPtr, XPAR_AXI_CDMA_0_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	print("Central DMA Initialised\r\n");

	/**************************************************************************/
	// INTERRUPT SETUP

    // Initialise GIC
	Xil_ExceptionInit();

	Status = setup_interrupt(&Gic, GicConfig, XPAR_SCUGIC_SINGLE_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}


	print("Interrupt system initialised\r\n");

	Status = setup_cdma_interrupts(&Gic, &xcdma);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	print("CDMA interrupts configured\r\n");

	Status = setup_frame_stat_interrupts(&Gic);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	print("Line Status interrupts configured\r\n");

//	Xil_ExceptionEnable();
    /************************************************************************/
	// START APPLICATION	i = 0;

	Xil_ExceptionDisable();
	power_up_cam(&Power_Clock_GPIO, PWDN_GPIO_CHANNEL, CLOCK_GPIO_CHANNEL);
	program_cam(&i2c_dev, IIC_BUFFER_SIZE, IIC_SLAVE_ADDR, SendBuffer);
	print("Camera programmed!\r\n");

	Xil_ExceptionEnable();
	XAxiCdma_IntrEnable(&xcdma, XAXICDMA_XR_IRQ_ALL_MASK);
	u32 src_address;

	while(exit_infinite_while < MAX_INTERRUPT_RECORDS){
//		xil_printf("Frame number (%d)\r\n", exit_infinite_while);
//		xil_printf("\t=================================================================\r\n");
	}

	Xil_ExceptionDisable();
	print("interrupt disabled\n\r");

	for(i = 0; i < 16; i += 1){
		for(j = 0; j < 16*2; j += 1){
			if (j%2 == 1){

				xil_printf("%03d  ", image_buffer[0][i*(WIDTH*2) + j/2]);
			}
		}

		xil_printf("\r\n");
	}

	print("-- Exiting main() --\r\n");

	return 0;
}

void program_cam(XIicPs *i2c_dev, s32 buffer_size, u16 slave_address, u8 *buffer){
	int i, num_regs;
    write_i2c(i2c_dev, 0x3008, 0x80, buffer_size, slave_address, buffer); //software reset (application notes for ov5642)
    usleep(1000);
    num_regs = sizeof(OV5642_YUV_QVGA)/sizeof(struct reg_val);
    for(i = 0; i < num_regs; i++){
    	write_i2c(i2c_dev, OV5642_YUV_QVGA[i].reg, OV5642_YUV_QVGA[i].val,
    			  buffer_size, slave_address, buffer);
    }


    num_regs = sizeof(test)/sizeof(struct reg_val);
    for(i = 0; i < num_regs; i++){
    	write_i2c(i2c_dev, test[i].reg, test[i].val,
    			  buffer_size, slave_address, buffer);
    }
}

void write_i2c(XIicPs *i2c_dev, u16 address, u8 value,
		       s32 buffer_size, u16 slave_address, u8 *buffer){
    buffer[REG_ADDRESS0] = (u8)(address >> 8);
    buffer[REG_ADDRESS1] = (u8)(address & 0x00ff);
    buffer[REG_VALUE]    = value;

    XIicPs_MasterSendPolled(i2c_dev, buffer, buffer_size, slave_address);

}

int setup_cdma_interrupts(XScuGic *GicPtr, XAxiCdma  *DmaPtr){
	int Status;

	// Connect the interrupt controller interrupt handler to the hardware
	// interrupt handling logic in the processor.
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT,
			     (Xil_ExceptionHandler)XScuGic_InterruptHandler,
			     GicPtr);

	// Connect a device driver handler that will be called when an interrupt
	// for the device occurs, the device driver handler performs the specific
	// interrupt processing for the device

	Status = XScuGic_Connect(GicPtr,
			      XPAR_FABRIC_AXI_CDMA_0_CDMA_INTROUT_INTR,
				 (Xil_InterruptHandler)XAxiCdma_IntrHandler,
				 (void *)DmaPtr);
	if (Status != XST_SUCCESS)
		return XST_FAILURE;

	// Enable the interrupt for the device
	XScuGic_Enable(GicPtr, XPAR_FABRIC_AXI_CDMA_0_CDMA_INTROUT_INTR);

	return XST_SUCCESS;
}

int setup_frame_stat_interrupts(XScuGic *GicPtr){
	int Status;
	// Connect the interrupt controller interrupt handler to the hardware
	// interrupt handling logic in the processor.
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT,
			     (Xil_ExceptionHandler)XScuGic_InterruptHandler,
			     GicPtr);

	Status = XScuGic_Connect(GicPtr,
			     NEW_FRAME_INTERRUPT_BIT,
				 (Xil_InterruptHandler)new_frame_intr_handler,
				 NULL);

	if (Status != XST_SUCCESS)
		return XST_FAILURE;

	XScuGic_SetPriorityTriggerType(GicPtr,NEW_FRAME_INTERRUPT_BIT,
			                       0xA0, // low-ish priority
			                       0b11); //active high, rising edge

	XScuGic_Enable(GicPtr, NEW_FRAME_INTERRUPT_BIT);



	Status = XScuGic_Connect(GicPtr,
			     PL2PS_LINE_INTERRUPT_BIT,
				 (Xil_InterruptHandler)pl2ps_line_intr_handler,
				 NULL);

	if (Status != XST_SUCCESS)
		return XST_FAILURE;

	XScuGic_SetPriorityTriggerType(GicPtr,PL2PS_LINE_INTERRUPT_BIT,
			                       0xA0, // high priority
			                       0b11); //active high, rising edge


	XScuGic_Enable(GicPtr, PL2PS_LINE_INTERRUPT_BIT);

	Status = XScuGic_Connect(GicPtr,
			     VGA_LINE_INTERRUPT_BIT,
				 (Xil_InterruptHandler)vga_new_block_intr_handler,
				 NULL);

	if (Status != XST_SUCCESS)
		return XST_FAILURE;

	XScuGic_SetPriorityTriggerType(GicPtr, VGA_LINE_INTERRUPT_BIT,
			                       0xA8, // high priority
			                       0b11); //active high, rising edge


	XScuGic_Enable(GicPtr, VGA_LINE_INTERRUPT_BIT);


	return XST_SUCCESS;
}


int setup_cam_gpio(XGpio *gpio, u16 dev_id, unsigned pwr_chn, u32 pwr_dir, unsigned clk_chn, u32 clk_dir){
	int Status;

    Status = XGpio_Initialize(gpio, dev_id);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    XGpio_SetDataDirection(gpio, pwr_chn, pwr_dir);
    XGpio_SetDataDirection(gpio, clk_chn, clk_dir);

	return XST_SUCCESS;
}

int setup_dma_gpio(XGpio *gpio, u16 dev_id, unsigned dma_interaction_chan, u32 dma_chan_mask){
	int Status;

    Status = XGpio_Initialize(gpio, dev_id);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    XGpio_SetDataDirection(gpio, dma_interaction_chan, dma_chan_mask);

	return XST_SUCCESS;
}

int setup_i2c(XIicPs *i2c_dev, XIicPs_Config *i2c_conf, u16 i2c_dev_id, u32 i2c_clk_freq){
	int Status;
	i2c_conf = XIicPs_LookupConfig(i2c_dev_id);
    if (i2c_conf == NULL) {
        return XST_FAILURE;
    }

    Status = XIicPs_CfgInitialize(i2c_dev, i2c_conf, i2c_conf->BaseAddress);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    Status = XIicPs_SelfTest(i2c_dev);
    if (Status != XST_SUCCESS) {
      return XST_FAILURE;
    }
    xil_printf("I2C self test passed!\r\n");

    Status = XIicPs_SetSClk(i2c_dev, i2c_clk_freq);
    if (Status != XST_SUCCESS) {
      return XST_FAILURE;
    }

    return XST_SUCCESS;
}

int setup_interrupt(XScuGic *gic_dev, XScuGic_Config *gic_conf, u16 gic_dev_id){
	int Status;
	gic_conf = XScuGic_LookupConfig(gic_dev_id);
	if (gic_conf == NULL) {
		xil_printf("XScuGic_LookupConfig(%d) failed\r\n", gic_dev_id);
		return XST_FAILURE;
	}

	Status = XScuGic_CfgInitialize(gic_dev, gic_conf, gic_conf->CpuBaseAddress);
	if (Status != XST_SUCCESS) {
		xil_printf("XScuGic_CfgInitialize failed\r\n");
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}

int setup_cdma(XAxiCdma *cdma_dev, XAxiCdma_Config *cdma_conf, u32 cdma_dev_id){
	int Status;
    cdma_conf = XAxiCdma_LookupConfig(cdma_dev_id);
   	if (cdma_conf == NULL) {
   		xil_printf("Unable to find CDMA config\r\n");
   		return XST_FAILURE;
   	}

   	Status = XAxiCdma_CfgInitialize(cdma_dev, cdma_conf, cdma_conf->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
		xil_printf("Status=%x\r\n",Status);
	}
	return XST_SUCCESS;
}

void power_up_cam(XGpio *gpio, unsigned pwr_down_chan, unsigned clk_enable_chan){
    XGpio_DiscreteWrite(gpio, pwr_down_chan, 1);
    usleep(5000);
    XGpio_DiscreteWrite(gpio, pwr_down_chan, 0);
    usleep(5000);
    XGpio_DiscreteWrite(gpio, clk_enable_chan, 1);
    usleep(5000);
}
