/*
 * ov5642_registers.h
 *
 *  Created on: 11 Nov 2015
 *      Author: pinedagg
 */

#ifndef OV5642_REGISTERS_H_
#define OV5642_REGISTERS_H_

#include "xil_types.h"

typedef struct reg_vals{
	u16 reg;
	u8 val;
}reg_val;


//From App notes
//from https://github.com/manakeri/android_kernel_samsung_xcover/blob/2e48c9301c2387ee34c5619bfdba3e954fe823db/common/drivers/media/video/pxa95x-ov5642.c


const reg_val OV5642_YUV_QVGA[583];


const reg_val OV5642_set_BnW[4];

const reg_val OV5642_set_RGB[4];


const reg_val OV5642_set_VGA[5];

const reg_val OV5642_set_QVGA[5];

const reg_val OV5642_set_CIF[5];

const reg_val OV5642_set_QCIF[5];



const reg_val OV5642_CIF_PREVIEW[25];

const reg_val OV5642_QCIF_PREVIEW[25];

const reg_val OV5642_SET_PCLK_2X[8];

const reg_val OV5642_QVGA_30FPS[502];


//from lwn.net/Articles/6587779/



#endif /* OV5642_REGISTERS_H_ */


//from lwn.net/Articles/6587779/









