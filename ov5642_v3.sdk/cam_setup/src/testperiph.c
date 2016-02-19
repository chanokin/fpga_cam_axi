#include <stdio.h>
#include "xparameters.h"
#include "xil_cache.h"
#include "xiicps.h"
#include "xil_exception.h"
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_printf.h"
#include "xtime_l.h"
#include "xgpio.h"
#include "sleep.h"

#include "ov5642_registers.h"

//#define IIC_DEVICE_ID       XPAR_XIICPS_0_DEVICE_ID
#define IIC_DEVICE_ID       XPAR_PS7_I2C_0_DEVICE_ID
#define IIC_SLAVE_ADDR   0x3C
#define IIC_SCLK_RATE       100000
#define IIC_BUFFER_SIZE     3

#define REG_ADDRESS0        0
#define REG_ADDRESS1        1
#define REG_VALUE           2

void write_i2c(u16 address, u8 value);
//void sleep(unsigned int milliseconds);
void setup_cam_vga_rgb(void);

XIicPs I2C_dev;
XIicPs_Config *I2C_config;
u8 SendBuffer[IIC_BUFFER_SIZE];    /**< Buffer for Transmitting Data */



#define PWDN_CLK_GPIO_DEV_ID  XPAR_AXI_GPIO_0_DEVICE_ID
#define PWDN_GPIO_CHANNEL  1
#define CLOCK_GPIO_CHANNEL  2
XGpio Power_Clock_GPIO;

int main()
{
    int Status;

    Status = XGpio_Initialize(&Power_Clock_GPIO, PWDN_CLK_GPIO_DEV_ID);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    XGpio_SetDataDirection(&Power_Clock_GPIO, PWDN_GPIO_CHANNEL, 0x00);
    XGpio_SetDataDirection(&Power_Clock_GPIO, CLOCK_GPIO_CHANNEL, 0x00);

    XGpio_DiscreteWrite(&Power_Clock_GPIO, PWDN_GPIO_CHANNEL, 1);

    usleep(5000);

    XGpio_DiscreteWrite(&Power_Clock_GPIO, PWDN_GPIO_CHANNEL, 0);

    usleep(5000);

    XGpio_DiscreteWrite(&Power_Clock_GPIO, CLOCK_GPIO_CHANNEL, 1);

    usleep(5000);



    xil_printf("\r\n------------------------------------------------------------\r\n");
    xil_printf("\r\nTesting I2C comm from PS7 to CAM\r\n");

    I2C_config = XIicPs_LookupConfig(IIC_DEVICE_ID);
    if (I2C_config == NULL) {
        return XST_FAILURE;
    }
    xil_printf("I2C config acquired\r\n");


    Status = XIicPs_CfgInitialize(&I2C_dev, I2C_config, I2C_config->BaseAddress);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }
    xil_printf("I2C config applied\r\n");

    Status = XIicPs_SelfTest(&I2C_dev);
    if (Status != XST_SUCCESS) {
      return XST_FAILURE;
    }
    xil_printf("I2C self test passed!\r\n");

    Status = XIicPs_SetSClk(&I2C_dev, IIC_SCLK_RATE);
    if (Status != XST_SUCCESS) {
      return XST_FAILURE;
    }
    xil_printf("I2C set clock rate to %dKHz\r\n", IIC_SCLK_RATE/1000);

    //while(1)
//    {
    setup_cam_vga_rgb();
//    write_i2c(0x3008, 0x80);
//    usleep(10000);
//    write_i2c(0x503d, 0x80);
//    write_i2c(0x503e, 0x00);
//    sleep(100);
//    }
		while (XIicPs_BusIsBusy(&I2C_dev)) {
			xil_printf("I2C Busy...\n\r");
			/* NOP */
		}
		xil_printf("IC2 bus is free\n\r");
//    }


	xil_printf("end program!!!\n\r");



    return 0;
}

void write_i2c(u16 address, u8 value){
    SendBuffer[REG_ADDRESS0] = (u8)(address >> 8);
    SendBuffer[REG_ADDRESS1] = (u8)(address & 0x00ff);
    SendBuffer[REG_VALUE]    = value;
//    xil_printf("ADDRESS = 0x%02x%02x \r\n", SendBuffer[REG_ADDRESS0],
//                                        SendBuffer[REG_ADDRESS1]);
//    xil_printf("VALUE   = 0x%02x \r\n", SendBuffer[REG_VALUE]);
    XIicPs_MasterSendPolled(&I2C_dev, SendBuffer,
                            IIC_BUFFER_SIZE,
                            IIC_SLAVE_ADDR);
//    usleep(1000);
}



void setup_cam_vga_rgb(void){
    write_i2c(0x3008, 0x80); //software reset
    usleep(1000);

    int num_regs, i;
//    num_regs = sizeof(OV5642_YUV_QVGA)/sizeof(struct reg_val);
//    for(i = 0; i < num_regs; i++){
//    	write_i2c(OV5642_YUV_QVGA[i].reg, OV5642_YUV_QVGA[i].val);
////    	xil_printf("%d - register %x => %x\r\n", i, OV5642_YUV_QVGA[i].reg, OV5642_YUV_QVGA[i].val);
////    	usleep(500000);
//    }
//    num_regs = sizeof(OV5642_720P_30FPS)/sizeof(struct reg_val);
//    for(i = 0; i < num_regs; i++){
//    	write_i2c(OV5642_720P_30FPS[i].reg, OV5642_720P_30FPS[i].val);
////    	xil_printf("%d - register %x => %x\r\n", i, OV5642_YUV_QVGA[i].reg, OV5642_YUV_QVGA[i].val);
////    	usleep(500000);
//    }

    num_regs = sizeof(OV5642_QVGA_30FPS)/sizeof(struct reg_val);
    for(i = 0; i < num_regs; i++){
    	write_i2c(OV5642_QVGA_30FPS[i].reg, OV5642_QVGA_30FPS[i].val);
//    	xil_printf("%d - register %x => %x\r\n", i, OV5642_YUV_QVGA[i].reg, OV5642_YUV_QVGA[i].val);
//    	usleep(10000000);
    }
//    usleep(1000);
////    xil_printf("main setup done!\r\n");
////
    num_regs = sizeof(test)/sizeof(struct reg_val);
    for(i = 0; i < num_regs; i++){
    	write_i2c(test[i].reg, test[i].val);
//    	usleep(1000000);
//    	xil_printf("%d\r\n", i);
    }

}
