/*
 * helloworld.h
 *
 *  Created on: 24 Feb 2016
 *      Author: pinedagg
 */

#ifndef HELLOWORLD_H_
#define HELLOWORLD_H_



#include "xaxicdma.h"	// if CDMA is used
#include "xscugic.h" 	// if PS GIC is used
#include "xil_exception.h"	// if interrupt is used

#define MAX_INTERRUPT_RECORDS 1000
#define NEW_FRAME_INTERRUPT_BIT  62
#define PL2PS_LINE_INTERRUPT_BIT 63
#define VGA_LINE_INTERRUPT_BIT 64
#define VGA_FRAME_INTERRUPT_BIT 65

void read_dma_CallBack(void *CallBackRef, u32 IrqMask, int *IgnorePtr);
void write_dma_CallBack(void *CallBackRef, u32 IrqMask, int *IgnorePtr);
void new_frame_intr_handler(void *InstancePtr);
void pl2ps_line_intr_handler(void *InstancePtr);
void vga_new_block_intr_handler(void *InstancePtr);
void vga_new_frame_intr_handler(void *InstancePtr);

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



	Status = XScuGic_Connect(GicPtr,
			     VGA_FRAME_INTERRUPT_BIT,
				 (Xil_InterruptHandler)vga_new_frame_intr_handler,
				 NULL);

	if (Status != XST_SUCCESS)
		return XST_FAILURE;

	XScuGic_SetPriorityTriggerType(GicPtr, VGA_FRAME_INTERRUPT_BIT,
			                       0xA8, // high priority
			                       0b11); //active high, rising edge


	XScuGic_Enable(GicPtr, VGA_FRAME_INTERRUPT_BIT);



	return XST_SUCCESS;
}

#endif /* HELLOWORLD_H_ */
