#include "helloworld.h"
#include "functions.h"


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

XTime frame_start_time, new_block_time;

u32 image_buffer[NUM_BUFFERS][WORDS_PER_IMAGE];
u8 dvs_curr_buffer = 0;
u8 dvs_curr_block = 0;
u8 vga_curr_buffer = NUM_BUFFERS - 1;
u8 vga_curr_block = 0;
u8 vga_frame_number = 0;
u8 writing = 0;
u8 reading = 0;
u8 done_writing = 0;
u8 done_reading = 0;

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
//    u8 default_mem_val = 0; // black
//    u8 default_mem_val = 0x3F; // whitest
      u32 default_mem_val = 0xFFFFFFFF; // whitest
//    xil_printf("size of buffer memory %d == %d ? %d \n\r",
//    		    NUM_BUFFERS*WORDS_PER_IMAGE*sizeof(u32),
//    		    BYTES_PER_IMAGE*NUM_BUFFERS,
//    		    NUM_BUFFERS*WORDS_PER_IMAGE*sizeof(u32) == BYTES_PER_IMAGE*NUM_BUFFERS);
//    memset(image_buffer, default_mem_val, BYTES_PER_IMAGE*NUM_BUFFERS);
//    memset(image_buffer, default_mem_val, WORDS_PER_IMAGE*NUM_BUFFERS);

    for(i = 0; i < NUM_BUFFERS; i += 1){

    	xil_printf("Buffer %d address = 0x%08x\n\r", i, image_buffer[i]);
    	for(j = 0; j < WORDS_PER_IMAGE; j++){
    		image_buffer[i][j] = default_mem_val;
//    		if(image_buffer[i][j] != default_mem_val){
//    			xil_printf("Image %d has non default value in pixel %d\n\r", i, j);
//    		}
    	}
    }

    xil_printf("-- Simple DMA Design Example --\r\n");
    xil_printf("Words per block (%d)\r\n", WORDS_PER_BLOCK);
    xil_printf("Bytes per block (%d)\r\n", BYTES_PER_BLOCK);
    xil_printf("Transfers per block (%d)\r\n", NUM_TRANSFERS_PER_BLOCK);
    xil_printf("Words per transfer (%d)\r\n", WORDS_PER_TRANSFER);
    xil_printf("Words per transfer (%d)\r\n", WORDS_PER_BLOCK/NUM_TRANSFERS_PER_BLOCK);
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

//	Status = setup_cdma_interrupts(&Gic, &xcdma);
//	if (Status != XST_SUCCESS) {
//		return XST_FAILURE;
//	}
//	print("CDMA interrupts configured\r\n");

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

	dvs_curr_buffer = 0;
	dvs_curr_block = 0;
	vga_curr_buffer = NUM_BUFFERS - 1;
	vga_curr_block = 0;
	vga_frame_number = 0;
	writing = 0;
	reading = 0;
	done_writing = 0;
	done_reading = 0;
	Xil_ExceptionEnable();


	while(exit_infinite_while < MAX_INTERRUPT_RECORDS){
//		xil_printf("Frame number (%d)\r\n", exit_infinite_while);
//		xil_printf("\t=================================================================\r\n");
	}

	Xil_ExceptionDisable();
	print("interrupt disabled\n\r");

	for(numofbytes = 0; numofbytes < NUM_BUFFERS; numofbytes += 1){
		xil_printf("BUFFER NUMBER %d  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n\r\n\r", numofbytes);
		for(i = 0; i < 128; i += 1){
			for(j = 0; j < 1; j += 1){
//				if (j%BYTES_PER_PIXEL == 0)
//				{
					Status = i*(WORDS_PER_LINE) + j;
					//xil_printf("row = %03d, col = %03d, idx = %d   ", i, j, Status);

					xil_printf("%03d   ", (image_buffer[numofbytes][Status] >> 16 ) & 0xFF);
//					xil_printf("%03d   ", image_buffer[numofbytes][Status]);
//				}
			}

			if((i+1)%32 == 0 && i > 0)
			xil_printf("\r\n");

		}
		xil_printf("\r\n");
	}
	print("-- Exiting main() --\r\n");

	return 0;
}


void new_frame_intr_handler(void *InstancePtr){
	u8 dvs_next_buffer = dvs_curr_buffer + 1;
    if (dvs_next_buffer == NUM_BUFFERS){
    	dvs_next_buffer = 0;
    }
//    memcpy(image_buffer[dvs_next_buffer], image_buffer[dvs_curr_buffer], BYTES_PER_IMAGE);

    dvs_curr_block = 0;
    dvs_curr_buffer = dvs_next_buffer;


	exit_infinite_while += 1;
//	xil_printf("Frame number (%d)\r\n", exit_infinite_while);

	XTime_GetTime(&frame_start_time);

//	xil_printf(" Start time = ");
//	print_time_s(frame_start_time);
//	//xil_printf("=================================================================\n\r");
//	xil_printf("\n\r");

}



void vga_new_block_intr_handler(void *InstancePtr){
//	xil_printf("buffer number (%d), block number (%d)\r\n", vga_curr_buffer, vga_curr_block);
	send_block(&xcdma, &image_buffer[0][0], vga_curr_buffer, vga_curr_block, (u32)VGA_CDMA_BRAM_MEMORY);

	vga_curr_block += 1;
	if (vga_curr_block >= BLOCKS_PER_IMAGE){
		vga_curr_block = 0;
	}


}

void vga_new_frame_intr_handler(void *InstancePtr){

	vga_curr_buffer = dvs_curr_buffer - 1;

	if(vga_curr_buffer == 255){
		vga_curr_buffer = NUM_BUFFERS - 1;
	}

	vga_curr_block = 1;

//	XTime_GetTime(&frame_start_time);
//	xil_printf(" VGA Start = ");
//	print_time_s(frame_start_time);
//	//xil_printf("=================================================================\n\r");
//	xil_printf("\n\r");

}


void pl2ps_line_intr_handler(void *InstancePtr){
	if (exit_infinite_while == 1){
		return ;
	}




	u8 prev_buffer;
	// start Copy from PL to DDR
//	xil_printf("Frame number (%d), buffer number (%d), block number (%d)\r\n", exit_infinite_while, dvs_curr_buffer, dvs_curr_block);


	read_block(&xcdma, &image_buffer[0][0], dvs_curr_buffer, dvs_curr_block, (u32)CDMA_BRAM_MEMORY);

	prev_buffer = dvs_curr_buffer - 1;
	if (prev_buffer == 255){
		prev_buffer = NUM_BUFFERS - 1;
	}

	dvs_curr_block += 1;
	if (dvs_curr_block >= BLOCKS_PER_IMAGE){
		dvs_curr_block = BLOCKS_PER_IMAGE - 1; // or 0 ???
	}

	// start Copy from DDR to PL
	send_block(&xcdma, &image_buffer[0][0], prev_buffer, dvs_curr_block, (u32)CDMA_BRAM_MEMORY);
//	XTime_GetTime(&new_block_time);
	//xil_printf("BLOCK time = ");
//	print_time_ms(new_block_time - frame_start_time);
	//xil_printf("\n\r");
}
