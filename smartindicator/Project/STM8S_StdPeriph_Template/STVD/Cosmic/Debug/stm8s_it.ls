   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.5 - 29 Dec 2015
   3                     ; Generator (Limited) V4.4.4 - 27 Jan 2016
   4                     ; Optimizer V4.4.4 - 27 Jan 2016
  50                     ; 53 INTERRUPT_HANDLER(NonHandledInterrupt, 25)
  50                     ; 54 {
  51                     .text:	section	.text,new
  52  0000               f_NonHandledInterrupt:
  56                     ; 58 }
  59  0000 80            	iret	
  81                     ; 66 INTERRUPT_HANDLER_TRAP(TRAP_IRQHandler)
  81                     ; 67 {
  82                     .text:	section	.text,new
  83  0000               f_TRAP_IRQHandler:
  87                     ; 71 }
  90  0000 80            	iret	
 112                     ; 78 INTERRUPT_HANDLER(TLI_IRQHandler, 0)
 112                     ; 79 
 112                     ; 80 {
 113                     .text:	section	.text,new
 114  0000               f_TLI_IRQHandler:
 118                     ; 84 }
 121  0000 80            	iret	
 143                     ; 91 INTERRUPT_HANDLER(AWU_IRQHandler, 1)
 143                     ; 92 {
 144                     .text:	section	.text,new
 145  0000               f_AWU_IRQHandler:
 149                     ; 96 }
 152  0000 80            	iret	
 174                     ; 103 INTERRUPT_HANDLER(CLK_IRQHandler, 2)
 174                     ; 104 {
 175                     .text:	section	.text,new
 176  0000               f_CLK_IRQHandler:
 180                     ; 108 }
 183  0000 80            	iret	
 206                     ; 115 INTERRUPT_HANDLER(EXTI_PORTA_IRQHandler, 3)
 206                     ; 116 {
 207                     .text:	section	.text,new
 208  0000               f_EXTI_PORTA_IRQHandler:
 212                     ; 120 }
 215  0000 80            	iret	
 238                     ; 127 INTERRUPT_HANDLER(EXTI_PORTB_IRQHandler, 4)
 238                     ; 128 {
 239                     .text:	section	.text,new
 240  0000               f_EXTI_PORTB_IRQHandler:
 244                     ; 132 }
 247  0000 80            	iret	
 270                     ; 157 INTERRUPT_HANDLER(EXTI_PORTE_IRQHandler, 7)
 270                     ; 158 {
 271                     .text:	section	.text,new
 272  0000               f_EXTI_PORTE_IRQHandler:
 276                     ; 162 }
 279  0000 80            	iret	
 301                     ; 209 INTERRUPT_HANDLER(SPI_IRQHandler, 10)
 301                     ; 210 {
 302                     .text:	section	.text,new
 303  0000               f_SPI_IRQHandler:
 307                     ; 214 }
 310  0000 80            	iret	
 333                     ; 221 INTERRUPT_HANDLER(TIM1_UPD_OVF_TRG_BRK_IRQHandler, 11)
 333                     ; 222 {
 334                     .text:	section	.text,new
 335  0000               f_TIM1_UPD_OVF_TRG_BRK_IRQHandler:
 339                     ; 226 }
 342  0000 80            	iret	
 365                     ; 233 INTERRUPT_HANDLER(TIM1_CAP_COM_IRQHandler, 12)
 365                     ; 234 {
 366                     .text:	section	.text,new
 367  0000               f_TIM1_CAP_COM_IRQHandler:
 371                     ; 238 }
 374  0000 80            	iret	
 397                     ; 315  INTERRUPT_HANDLER(UART1_TX_IRQHandler, 17)
 397                     ; 316  {
 398                     .text:	section	.text,new
 399  0000               f_UART1_TX_IRQHandler:
 403                     ; 320  }
 406  0000 80            	iret	
 429                     ; 327  INTERRUPT_HANDLER(UART1_RX_IRQHandler, 18)
 429                     ; 328  {
 430                     .text:	section	.text,new
 431  0000               f_UART1_RX_IRQHandler:
 435                     ; 332  }
 438  0000 80            	iret	
 460                     ; 366 INTERRUPT_HANDLER(I2C_IRQHandler, 19)
 460                     ; 367 {
 461                     .text:	section	.text,new
 462  0000               f_I2C_IRQHandler:
 466                     ; 371 }
 469  0000 80            	iret	
 491                     ; 445  INTERRUPT_HANDLER(ADC1_IRQHandler, 22)
 491                     ; 446  {
 492                     .text:	section	.text,new
 493  0000               f_ADC1_IRQHandler:
 497                     ; 450  }
 500  0000 80            	iret	
 523                     ; 479 INTERRUPT_HANDLER(EEPROM_EEC_IRQHandler, 24)
 523                     ; 480 {
 524                     .text:	section	.text,new
 525  0000               f_EEPROM_EEC_IRQHandler:
 529                     ; 484 }
 532  0000 80            	iret	
 544                     	xdef	f_EEPROM_EEC_IRQHandler
 545                     	xdef	f_ADC1_IRQHandler
 546                     	xdef	f_I2C_IRQHandler
 547                     	xdef	f_UART1_RX_IRQHandler
 548                     	xdef	f_UART1_TX_IRQHandler
 549                     	xdef	f_TIM1_UPD_OVF_TRG_BRK_IRQHandler
 550                     	xdef	f_TIM1_CAP_COM_IRQHandler
 551                     	xdef	f_SPI_IRQHandler
 552                     	xdef	f_EXTI_PORTE_IRQHandler
 553                     	xdef	f_EXTI_PORTB_IRQHandler
 554                     	xdef	f_EXTI_PORTA_IRQHandler
 555                     	xdef	f_CLK_IRQHandler
 556                     	xdef	f_AWU_IRQHandler
 557                     	xdef	f_TLI_IRQHandler
 558                     	xdef	f_TRAP_IRQHandler
 559                     	xdef	f_NonHandledInterrupt
 578                     	end
