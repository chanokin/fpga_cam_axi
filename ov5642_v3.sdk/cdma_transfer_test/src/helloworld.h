/*
 * helloworld.h
 *
 *  Created on: 24 Feb 2016
 *      Author: pinedagg
 */

#ifndef HELLOWORLD_H_
#define HELLOWORLD_H_

#include <stdio.h>
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



#define RESET_LOOP_COUNT	10	// Number of times to check reset is done
#define BUFFER_LENGTH 32768 // source and destination buffers lengths in number of bytes
#define CDMA_BRAM_MEMORY 0xC0000000//XPAR_AXI_CDMA_0_BASEADDR // BRAM Port B mapped through 2nd BRAM Controller accessed by CDMA
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
#define CLOCK_GPIO_CHANNEL  2

void program_cam(XIicPs *i2c_dev, s32 buffer_size, u16 slave_address, u8 *buffer);
void write_i2c(XIicPs *i2c_dev, u16 address, u8 value,
		       s32 buffer_size, u16 slave_address, u8 *buffer);
void setup_cam_vga_rgb(void);
int setup_cdma_interrupts(XScuGic *GicPtr, XAxiCdma  *DmaPtr);
int setup_dma_gpio(XGpio *Gpio, u16 dev, unsigned dma_interaction_chan, u32 dma_chan_mask);

int setup_cam_gpio(XGpio *Gpio, u16 dev, unsigned pwr_down_chn, u32 pwr_down_msk,
   	 	 	 	   unsigned clk_enable_chn, u32 clk_enable_msk);
int setup_i2c(XIicPs *i2c_dev, XIicPs_Config *i2c_conf, u16 i2c_dev_id, u32 i2c_clk_freq);
int setup_interrupt(XScuGic *gic_dev, XScuGic_Config *gic_conf, u16 gic_dev_id);
int setup_cdma(XAxiCdma *cdma_dev, XAxiCdma_Config *cdma_conf, u32 cdma_dev_id);

void power_up_cam(XGpio *Gpio, u16 dev, unsigned pwr_down_chn, unsigned clk_enable_chn);


void print_cdma_error(u32 error_code){
	char *error_str = "Datamover internal err";
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
