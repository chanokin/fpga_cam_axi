/*
 * helloworld.h
 *
 *  Created on: 24 Feb 2016
 *      Author: pinedagg
 */

#ifndef HELLOWORLD_H_
#define HELLOWORLD_H_

#include <stdio.h>
#include <string.h>
#include "platform.h"
#include "xparameters.h"

#include "xaxicdma.h"	// if CDMA is used
#include "xscugic.h" 	// if PS GIC is used
#include "xil_exception.h"	// if interrupt is used
#include "xil_cache.h"
#include "xil_printf.h"
#include "xil_mmu.h"
#include <xil_cache.h>


#include "xil_cache.h"
#include "xiicps.h"
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xtime_l.h"
#include "xgpio.h"
#include "sleep.h"

#include "ov5642_registers.h"


#define NEW_FRAME_START      1
#define SEND_LINE_TO_PL      2
#define READ_LINE_FROM_PL    3

#define RESET_LOOP_COUNT	10	// Number of times to check reset is done
#define BUFFER_LENGTH 32768 // source and destination buffers lengths in number of bytes
#define CDMA_BRAM_MEMORY 0xC0000000 // BRAM Port mapped through AXI Controller accessed by CDMA
#define VGA_CDMA_BRAM_MEMORY 0xC2000000 // BRAM Port mapped through AXI Controller accessed by CDMA
#define CDMA_BASE_ADDR XPAR_AXICDMA_0_BASEADDR
#define DDR_MEMORY XPAR_PS7_DDR_0_S_AXI_BASEADDR
//#define TIMER_DEVICE_ID	XPAR_SCUTIMER_DEVICE_ID
//#define TIMER_LOAD_VALUE 0xFFFFFFFF
#define INTC_DEVICE_INT_ID XPAR_SCUGIC_SINGLE_DEVICE_ID

//#define IIC_DEVICE_ID       XPAR_XIICPS_0_DEVICE_ID
#define IIC_DEVICE_ID       XPAR_PS7_I2C_0_DEVICE_ID
#define IIC_SLAVE_ADDR   0x3C
#define IIC_SCLK_RATE       100000
#define IIC_BUFFER_SIZE     3

#define REG_ADDRESS0        0
#define REG_ADDRESS1        1
#define REG_VALUE           2

#define PWDN_CLK_GPIO_DEV_ID  XPAR_AXI_GPIO_0_DEVICE_ID
#define PWDN_GPIO_CHANNEL  1
#define PWDN_GPIO_DIR_MASK  0

#define CLOCK_GPIO_CHANNEL  2
#define CLOCK_GPIO_DIR_MASK  0

#define FRAME_STATUS_GPIO_CHANNEL   1
#define FRAME_STATUS_GPIO_DIR_MASK  7      // 0000 0111 <-- all 3 ports are inputs

#define NEW_FRAME_INTERRUPT_BIT  62
#define PL2PS_LINE_INTERRUPT_BIT 63
#define VGA_LINE_INTERRUPT_BIT 64


#define MAX_INTERRUPT_RECORDS 90

#define WIDTH 128
#define HEIGHT 128
#define BYTES_PER_PIXEL 2
#define PIXELS_PER_WORD 2
#define BLOCKS_PER_IMAGE 4
#define WORDS_PER_LINE WIDTH/PIXELS_PER_WORD
#define LINES_PER_BLOCK HEIGHT/BLOCKS_PER_IMAGE
#define WORDS_PER_BLOCK LINES_PER_BLOCK*WORDS_PER_LINE
#define WORDS_PER_IMAGE WORDS_PER_LINE*HEIGHT
#define BYTES_PER_WORD BYTES_PER_PIXEL*PIXELS_PER_WORD
#define BYTES_PER_BLOCK BYTES_PER_WORD*WORDS_PER_BLOCK
#define BYTES_PER_IMAGE WIDTH*HEIGHT*BYTES_PER_PIXEL
#define NUM_BUFFERS 3


void read_dma_CallBack(void *CallBackRef, u32 IrqMask, int *IgnorePtr);
void write_dma_CallBack(void *CallBackRef, u32 IrqMask, int *IgnorePtr);
void new_frame_intr_handler(void *InstancePtr);
void pl2ps_line_intr_handler(void *InstancePtr);
void vga_new_block_intr_handler(void *InstancePtr);

void program_cam(XIicPs *i2c_dev, s32 buffer_size, u16 slave_address, u8 *buffer);
void write_i2c(XIicPs *i2c_dev, u16 address, u8 value,
		       s32 buffer_size, u16 slave_address, u8 *buffer);
void setup_cam_vga_rgb(void);
int setup_cdma_interrupts(XScuGic *GicPtr, XAxiCdma  *DmaPtr);
int setup_frame_stat_interrupts(XScuGic *GicPtr);
//int setup_dma_gpio(XGpio *Gpio, u16 dev, unsigned dma_interaction_chan, u32 dma_chan_mask);

int setup_cam_gpio(XGpio *Gpio, u16 dev, unsigned pwr_down_chn, u32 pwr_down_msk,
   	 	 	 	   unsigned clk_enable_chn, u32 clk_enable_msk);
int setup_i2c(XIicPs *i2c_dev, XIicPs_Config *i2c_conf, u16 i2c_dev_id, u32 i2c_clk_freq);
int setup_interrupt(XScuGic *gic_dev, XScuGic_Config *gic_conf, u16 gic_dev_id);
int setup_cdma(XAxiCdma *cdma_dev, XAxiCdma_Config *cdma_conf, u32 cdma_dev_id);

void power_up_cam(XGpio *Gpio, unsigned pwr_down_chn, unsigned clk_enable_chn);


void print_cdma_error(u32 error_code){
	char *error_str = "No error was found !!!";
	switch(error_code){
		case XAXICDMA_SR_IDLE_MASK:
			error_str = "DMA channel idle";
			break;
		case XAXICDMA_SR_SGINCLD_MASK:
			error_str = "Hybrid build";
			break;
		case XAXICDMA_SR_ERR_INTERNAL_MASK:
			error_str = "Datamover internal err";
			break;
		case XAXICDMA_SR_ERR_SLAVE_MASK:
			error_str = "Datamover slave err";
			break;
		case XAXICDMA_SR_ERR_DECODE_MASK:
			error_str = "Datamover decode err";
			break;
		case XAXICDMA_SR_ERR_SG_INT_MASK:
			error_str = "SG internal err";
			break;
		case XAXICDMA_SR_ERR_SG_SLV_MASK:
			error_str = "SG slave err";
			break;
		case XAXICDMA_SR_ERR_SG_DEC_MASK:
			error_str = "SG decode err";
			break;
	}
	xil_printf("Resulting error is: %s\r\n", error_str);
}

#endif /* HELLOWORLD_H_ */
