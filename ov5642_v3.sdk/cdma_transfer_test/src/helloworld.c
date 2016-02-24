
#include "helloworld.h"



XIicPs i2c_dev;
XIicPs_Config *i2c_config = NULL;
u8 SendBuffer[IIC_BUFFER_SIZE];    /**< Buffer for Transmitting Data */

XGpio Power_Clock_GPIO;

XAxiCdma xcdma;
XAxiCdma_Config * CdmaCfgPtr = NULL;

XScuGic Gic;			/* PS GIC -- interrupt*/
XScuGic_Config *GicConfig = NULL;

volatile static int Done = 0;	/* Dma transfer is done */
volatile static int Error = 0;	/* Dma Bus Error occurs */


static void dma_CallBack(void *CallBackRef, u32 IrqMask, int *IgnorePtr)
{

	if (IrqMask & XAXICDMA_XR_IRQ_ERROR_MASK) {
		Error = 1;
	}

	if (IrqMask & XAXICDMA_XR_IRQ_IOC_MASK) {
		Done = 1;
	}

}


int main (void) {

	u8 select;
	int i, CDMA_Status;
    int numofbytes;
    u8 * source, * destination;
    u8 * cdma_memory_source, * cdma_memory_destination;
    u32 test_done = 0;


    u32 Status;


    print("-- Simple DMA Design Example --\r\n");

    // Initialise i2c
    Status = setup_i2c(&i2c_dev, i2c_config, XPAR_PS7_I2C_0_DEVICE_ID, IIC_SCLK_RATE);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	print("i2c system initialised\r\n");

    // Initialise GIC
	Status = setup_interrupt(&Gic, GicConfig, XPAR_SCUGIC_SINGLE_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	print("Interrupt system initialised\r\n");

	// Disable DCache
	Xil_DCacheDisable();

	// Setup DMA Controller
    Status = setup_cdma(&xcdma, CdmaCfgPtr, XPAR_AXI_CDMA_0_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	print("Central DMA Initialised\r\n");


	Status = setup_cdma_interrupts(&Gic, &xcdma);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	print("CDMA interrupts configured\r\n");

	Xil_ExceptionEnable();

	program_cam(&i2c_dev, IIC_BUFFER_SIZE, IIC_SLAVE_ADDR, SendBuffer);
	print("Camera programmed!\r\n");

    print("-- Exiting main() --\r\n");
    return 0;
}

void program_cam(XIicPs *i2c_dev, s32 buffer_size, u16 slave_address, u8 *buffer){
	int i, num_regs;
    write_i2c(i2c_dev, 0x3008, 0x80, buffer_size, slave_address, buffer); //software reset (application notes for ov5642)
    usleep(1000);
    num_regs = sizeof(OV5642_QVGA_30FPS)/sizeof(struct reg_val);
    for(i = 0; i < num_regs; i++){
    	write_i2c(i2c_dev, OV5642_QVGA_30FPS[i].reg, OV5642_QVGA_30FPS[i].val,
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

	Xil_ExceptionInit();

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

int setup_cam_gpio(XGpio *gpio, u16 dev, unsigned pwr_chn, u32 pwr_dir, unsigned clk_chn, u32 clk_dir){
	int Status;

    Status = XGpio_Initialize(gpio, dev);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    XGpio_SetDataDirection(gpio, pwr_chn, pwr_dir);
    XGpio_SetDataDirection(gpio, clk_chn, clk_dir);

	return XST_SUCCESS;
}

int setup_dma_gpio(XGpio *Gpio, u16 dev, unsigned dma_interaction_chan, u32 dma_chan_mask);

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

void power_up_cam(XGpio *gpio, u16 dev, unsigned pwr_down_chan, unsigned clk_enable_chan){
    XGpio_DiscreteWrite(gpio, pwr_down_chan, 1);
    usleep(5000);
    XGpio_DiscreteWrite(gpio, pwr_down_chan, 0);
    usleep(5000);
    XGpio_DiscreteWrite(gpio, clk_enable_chan, 1);
    usleep(5000);
}