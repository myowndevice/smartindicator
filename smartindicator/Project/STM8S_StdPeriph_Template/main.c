/* Includes ------------------------------------------------------------------*/
#include "stm8s.h"
#include "stdlib.h"
//time
u8 time2=0;
u8 time3=0;
u8 time4=0;
u8 time5=0;
u8 time6=0;

u8 testind=0;
u8 yar=0;
u16 timesec=999;
u8 sleeptime=0;
u8 waitreset=1;
u8 waiterror=0;
u8 dataok=0;

u8 testtime[50];
u8 testzn[50];

#define US(us) ( 2000000.0 / 3000000.0 * us ) //FCPU / 3000
#define MS(ms) US(ms * 1000) // maximum 10ms

#define _delay( loops ) _asm("$N: \n decw X \n jrne $L \n nop", (u16)loops);
#define _delay_us(us) _delay(US(us))

#define IND_WIRE_1 GPIOC->ODR |= (uint8_t)GPIO_PIN_6//GPIO_WriteHigh(GPIOC,GPIO_PIN_6)
#define IND_WIRE_0 GPIOC->ODR &= (uint8_t)(~GPIO_PIN_6)  //GPIO_WriteLow(GPIOC,GPIO_PIN_6)

u32 indicator=0;
u8 stoptim=0;

void sendindicator(void) {
	//reset
	u32 dd = indicator;
	
	//dd = (u32)0b111111<<8;
	//dd = (u32)0b01011101 << 8;
	
	stoptim=1;
	
	
	IND_WIRE_0;
	_delay_us(10);
	IND_WIRE_1;	
	_delay_us(480);
	
	{
		u8 i;
		
	for (i=0;i<32;i++) {
		if (dd & 1) {
			disableInterrupts();
			IND_WIRE_0;			
			_delay_us(10);
			IND_WIRE_1;
			enableInterrupts();
			_delay_us(55);
		} else {
			IND_WIRE_0;			
			_delay_us(65);
			IND_WIRE_1;
			_delay_us(5);
		}
		dd >>= 1;
	}
	}
	
	stoptim=0;		
}	

void sleep(void) {
	stoptim = 1;//чтобы не менять индикацию
	//переключаем все выводы на GND
	//переходим в спящий режим
	GPIO_Init(GPIOA,GPIO_PIN_1|GPIO_PIN_2|GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);
	GPIO_Init(GPIOD,GPIO_PIN_2|GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6,GPIO_MODE_OUT_PP_LOW_SLOW);
	GPIO_Init(GPIOC,GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6|GPIO_PIN_7,GPIO_MODE_OUT_PP_LOW_SLOW);
	GPIO_Init(GPIOB,GPIO_PIN_4|GPIO_PIN_5,GPIO_MODE_OUT_OD_LOW_SLOW);
	
	//halt();
	stoptim = 0;
}


//long tt=0;

void Delay (u16 nCount);
uint32_t LSIMeasurment(void);

#define NUMIND 24
u8 ind[NUMIND];
u8 buffind[NUMIND+8];
u8 numbuffind=0;
u8 numind;
u8 command;

#ifdef USE_FULL_ASSERT

/**
  * @brief  Reports the name of the source file and the source line number
  *   where the assert_param error has occurred.
  * @param file: pointer to the source file name
  * @param line: assert_param error line source number
  * @retval : None
  */
void assert_failed(u8* file, u32 line)
{ 
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

  /* Infinite loop */
  while (1)
  {
  }
}
#endif


/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
uint32_t LSIMeasurment(void)
{

  uint32_t lsi_freq_hz = 0x0;
  uint32_t fmaster = 0x0;
  uint16_t ICValue1 = 0x0;
  uint16_t ICValue2 = 0x0;

  /* Get master frequency */
  fmaster = CLK_GetClockFreq();

  /* Enable the LSI measurement: LSI clock connected to timer Input Capture 1 */
  AWU->CSR |= AWU_CSR_MSR;

#if defined (STM8S903) || defined (STM8S103) || defined (STM8S003)
  /* Measure the LSI frequency with TIMER Input Capture 1 */
  
  /* Capture only every 8 events!!! */
  /* Enable capture of TI1 */
	//TIM1_ICInit(TIM1_CHANNEL_1, TIM1_ICPOLARITY_RISING, TIM1_ICSELECTION_DIRECTTI, TIM1_ICPSC_DIV8, 0);
	
	//TI1_Config((uint8_t)TIM1_ICPOLARITY_RISING,
  //             (uint8_t)TIM1_ICSELECTION_DIRECTTI,
  //             (uint8_t)0);
	TIM1->CCER1 &= (uint8_t)(~TIM1_CCER1_CC1E);
  
  /* Select the Input and set the filter */
  TIM1->CCMR1 = (uint8_t)((uint8_t)(TIM1->CCMR1 & (uint8_t)(~(uint8_t)( TIM1_CCMR_CCxS | TIM1_CCMR_ICxF ))) | 
                          (uint8_t)(( (TIM1_ICSELECTION_DIRECTTI)) | ((uint8_t)( 0 << 4))));
	TIM1->CCER1 &= (uint8_t)(~TIM1_CCER1_CC1P);
	TIM1->CCER1 |=  TIM1_CCER1_CC1E;
	
   /* Set the Input Capture Prescaler value */
	//TIM1_SetIC1Prescaler(TIM1_ICPSC_DIV8);
	TIM1->CCMR1 = (uint8_t)((uint8_t)(TIM1->CCMR1 & (uint8_t)(~TIM1_CCMR_ICxPSC)) 
                          | (uint8_t)TIM1_ICPSC_DIV8);
	
  /* Enable TIM1 */
  //TIM1_Cmd(ENABLE);
	TIM1->CR1 |= TIM1_CR1_CEN;
  
  /* wait a capture on cc1 */
  while((TIM1->SR1 & TIM1_FLAG_CC1) != TIM1_FLAG_CC1);
  /* Get CCR1 value*/
  ICValue1 = TIM1_GetCapture1();
  TIM1_ClearFlag(TIM1_FLAG_CC1);
  
  /* wait a capture on cc1 */
  while((TIM1->SR1 & TIM1_FLAG_CC1) != TIM1_FLAG_CC1);
  /* Get CCR1 value*/
  ICValue2 = TIM1_GetCapture1();
  TIM1_ClearFlag(TIM1_FLAG_CC1);
  
  /* Disable IC1 input capture */
  TIM1->CCER1 &= (uint8_t)(~TIM1_CCER1_CC1E);
  /* Disable timer2 */
  TIM1_Cmd(DISABLE);
  
#else  
  /* Measure the LSI frequency with TIMER Input Capture 1 */
  
  /* Capture only every 8 events!!! */
  /* Enable capture of TI1 */
  TIM3_ICInit(TIM3_CHANNEL_1, TIM3_ICPOLARITY_RISING, TIM3_ICSELECTION_DIRECTTI, TIM3_ICPSC_DIV8, 0);

  /* Enable TIM3 */
  TIM3_Cmd(ENABLE);

	/* wait a capture on cc1 */
  while ((TIM3->SR1 & TIM3_FLAG_CC1) != TIM3_FLAG_CC1);
	/* Get CCR1 value*/
  ICValue1 = TIM3_GetCapture1();
  TIM3_ClearFlag(TIM3_FLAG_CC1);

  /* wait a capture on cc1 */
  while ((TIM3->SR1 & TIM3_FLAG_CC1) != TIM3_FLAG_CC1);
    /* Get CCR1 value*/
  ICValue2 = TIM3_GetCapture1();
	TIM3_ClearFlag(TIM3_FLAG_CC1);

  /* Disable IC1 input capture */
  TIM3->CCER1 &= (uint8_t)(~TIM3_CCER1_CC1E);
  /* Disable timer3 */
  TIM3_Cmd(DISABLE);
#endif

  /* Compute LSI clock frequency */
  lsi_freq_hz = (8 * fmaster) / (ICValue2 - ICValue1);
  
  /* Disable the LSI measurement: LSI clock disconnected from timer Input Capture 1 */
  AWU->CSR &= (uint8_t)(~AWU_CSR_MSR);

 return (lsi_freq_hz);
}

u16 timedelay=0;

void Delay(u16 nCount)
{
    /* Decrement nCount value */
    timedelay = nCount;
				
		while (timedelay);
}

void mhalt(void){
	halt();
}
	
void main(void)
{
	u8 kol = 0;
	u8 napr=0;
	u8 demo=0;
		
	CLK->PCKENR1 = CLK_PCKENR1_TIM4+CLK_PCKENR1_TIM2;
	CLK->PCKENR2 = 0b01110011;
	
	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV8);
	
	TIM2_TimeBaseInit(TIM2_PRESCALER_16, 124);
  TIM2_ClearFlag(TIM2_FLAG_UPDATE);
	TIM2->IER |= (uint8_t)TIM2_IT_UPDATE | TIM2_IT_CC1;
	
  TIM2_OC1Init(TIM2_OCMODE_PWM1, TIM2_OUTPUTSTATE_DISABLE,124, TIM2_OCPOLARITY_HIGH);
  TIM2_OC1PreloadConfig(ENABLE);
  TIM2_ARRPreloadConfig(ENABLE);
	
	
	
	TIM4_Cmd(DISABLE);//для приема 1-wire
	TIM4_TimeBaseInit(TIM4_PRESCALER_16, 200);//8 микросекунды  один тик до 1600мкс - как таймаут!
	TIM4_SelectOnePulseMode(TIM4_OPMODE_SINGLE);//одиночный режим
  TIM4_ClearFlag(TIM4_FLAG_UPDATE);
	TIM4->CNTR=0;
	//TIM4->CNTRL=0;
	
	
	EXTI_SetExtIntSensitivity(EXTI_PORT_GPIOD,EXTI_SENSITIVITY_FALL_ONLY);//самый высокий приоритет имеет
  ITC_SetSoftwarePriority(ITC_IRQ_TIM2_OVF, ITC_PRIORITYLEVEL_2);
	ITC_SetSoftwarePriority(ITC_IRQ_TIM4_OVF, ITC_PRIORITYLEVEL_2);
	ITC_SetSoftwarePriority(ITC_IRQ_PORTD, ITC_PRIORITYLEVEL_3);
	{//-----инициализация индикатора - все выключено
		u8 i;
		for (i=0;i<NUMIND;i++) ind[i]=0;
	}
	
	
	BEEP_Cmd(DISABLE);
	
	/* enable interrupts */
	enableInterrupts();

  //GPIO_Init(GPIOD,GPIO_PIN_2|GPIO_PIN_3,GPIO_MODE_IN_PU_IT);//кнопки
	
	//GPIO_Init(GPIOD,GPIO_PIN_4,GPIO_MODE_OUT_PP_LOW_SLOW);//пищалка
	
	//GPIO_Init(GPIOD,GPIO_PIN_5|GPIO_PIN_6,GPIO_MODE_OUT_PP_HIGH_SLOW);//индикатор
	//GPIO_Init(GPIOA,GPIO_PIN_1|GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
	//GPIO_Init(GPIOB,GPIO_PIN_4|GPIO_PIN_5,GPIO_MODE_OUT_PP_HIGH_SLOW);//
	//GPIO_Init(GPIOC,GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6|GPIO_PIN_7,GPIO_MODE_OUT_PP_HIGH_SLOW);
	

	//halt();

	/* Enable TIM4 */
	TIM2_Cmd(ENABLE);
	
	//GPIO_Init(GPIOD,GPIO_PIN_1,GPIO_MODE_IN_PU_IT);//прием сигнала!
	
	sleep();
	
	//TIM2->CCR1L = 50;
	
	demo = 1;
	if (demo==1) {
		while(1)
		{
			u8 i;
			
			for (i=0;i<8;i++) {
				if (i<=kol) ind[i]=1; else ind[i]=0;
			}
			
			for (i=8;i<16;i++) {
				if (i<=kol+8) ind[i]=0; else ind[i]=1;
			}
			
			
			if (time2==0) {
				if (ind[16]) ind[16]=0;
				else ind[16]=1;
				time2=2;
			}
			if (time3==0) {
				if (ind[17]) ind[17]=0;
				else ind[17]=1;
				time3=1;
			}
			if (time4==0) {
				if (ind[18]) ind[18]=0;
				else ind[18]=1;
				time4=1;
				
				
				//yar++;
				//if (yar>100) yar = 21;
			
			}
			
			if (time5==0) {
				if (ind[19]) ind[19]=0;
				else ind[19]=1;
				time5=3;
			}
			
			
			if (napr==1) kol--; else kol++;
			
			if (kol > 7) napr=1;
			if (kol == 0) napr=0;
				
				
			if (time6==0) {
				for (i=0;i<20;i++) ind[i]=1;
				
				for (i=12;i<123;i++) {
					yar = i;
					TIM2->CCR1L = i;
					Delay(50);
				}
				
				Delay(2000);
				
				for (i=123;i>12;i--) {
					yar = i;
					TIM2->CCR1L = i;
					Delay(50);
				}
				
				Delay(500);
				
				yar = 20;
				
				time6=5;
			}			
				
				
			Delay(20);
		}
	}	
	
	indicator = (u32)0b10101100<<8;
	
	
	while	(1) {
		if (testind==0) {
			//indicator = ~indicator;
			sendindicator();
			
			testind = 3;
		}
		
		
		
		if (dataok) {
			//обработка данных
			u8 i=0;
			for (i=0;i<10;i++) {
				ind[i] = buffind[i+8];
			};
			
			command = 0;
			for (i=0;i<8;i++) {
				command |= (buffind[i] << i);
			}
			
			if (command) {
				//первые 7 бит яркость
				u8 tyar;
				
				tyar = command & 0b1111111;
				if (tyar) TIM2->CCR1L = tyar;
				
				//идем спать!
				if (command & 0b1000000) sleep();
			}
			
			waitreset=1;
			dataok=0;
			numbuffind=0;
		}	
	}
	
}
 

u8 ms=0;

INTERRUPT_HANDLER(TIM2_UPD_OVF_BRK_IRQHandler, 13)
 {
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
	if (stoptim) 
	{
		TIM2->SR1 = (uint8_t)(~TIM2_IT_UPDATE);
		return;
	}	

	
		//милисекунды
		if (timedelay) timedelay--;
		
		if (timesec==0)
		{
			//секунды
			timesec=999;
			if (testind) testind--;
			if (time2) time2--;
			if (time3) time3--;
			if (time4) time4--;
			if (time5) time5--;
			if (time6) time6--;
			
		}
		else timesec--;
		
		
		//все выкл!
		GPIOA->DDR &= (u8) (~ (GPIO_PIN_1|GPIO_PIN_2|GPIO_PIN_3) );
		//GPIO_Init(GPIOA,GPIO_PIN_1|GPIO_PIN_2|GPIO_PIN_3,GPIO_MODE_IN_FL_NO_IT);
		GPIOD->DDR &= (u8) (~ (GPIO_PIN_2|GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6) );
		//GPIO_Init(GPIOD,GPIO_PIN_2|GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6,GPIO_MODE_IN_FL_NO_IT);
		GPIOC->DDR &= (u8) (~ (GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6|GPIO_PIN_7) );
		//GPIO_Init(GPIOC,GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6|GPIO_PIN_7,GPIO_MODE_IN_FL_NO_IT);
		GPIOB->DDR &= (u8) (~ (GPIO_PIN_4|GPIO_PIN_5) );
		//GPIO_Init(GPIOB,GPIO_PIN_4|GPIO_PIN_5,GPIO_MODE_IN_FL_NO_IT);
		
		if (ind[numind]) {
			
		switch (numind) {	
		case 0:	
			//четные
			GPIO_Init(GPIOD,GPIO_PIN_5,GPIO_MODE_OUT_PP_HIGH_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
		break;
		
		case 1:
			//четные
			GPIO_Init(GPIOD,GPIO_PIN_5,GPIO_MODE_OUT_PP_LOW_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
		break;
		
		case 2:
			//четные
			GPIO_Init(GPIOA,GPIO_PIN_2,GPIO_MODE_OUT_PP_LOW_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
		break;
		
		case 3:
			//четные
			GPIO_Init(GPIOA,GPIO_PIN_2,GPIO_MODE_OUT_PP_HIGH_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
		break;
		
		case 4:
			//четные
			GPIO_Init(GPIOD,GPIO_PIN_6,GPIO_MODE_OUT_PP_LOW_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
		break;
		
		case 5:
			//четные
			GPIO_Init(GPIOD,GPIO_PIN_6,GPIO_MODE_OUT_PP_HIGH_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
		break;
		
		case 6:
			//четные
			GPIO_Init(GPIOD,GPIO_PIN_4,GPIO_MODE_OUT_PP_HIGH_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
		break;
		
		case 7:
			//четные
			GPIO_Init(GPIOD,GPIO_PIN_4,GPIO_MODE_OUT_PP_LOW_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
		break;
		
		
		//вторая шкала
		case 8:
			//четные
			GPIO_Init(GPIOC,GPIO_PIN_4,GPIO_MODE_OUT_PP_HIGH_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
		break;
		case 9:
			//четные
			GPIO_Init(GPIOC,GPIO_PIN_4,GPIO_MODE_OUT_PP_LOW_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
		break;
		case 10:
			//четные
			GPIO_Init(GPIOC,GPIO_PIN_5,GPIO_MODE_OUT_PP_LOW_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
		break;
		case 11:
			//четные
			GPIO_Init(GPIOC,GPIO_PIN_5,GPIO_MODE_OUT_PP_HIGH_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
		break;
		case 12:
			//четные
			GPIO_Init(GPIOC,GPIO_PIN_6,GPIO_MODE_OUT_PP_HIGH_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
		break;
		case 13:
			//четные
			GPIO_Init(GPIOC,GPIO_PIN_6,GPIO_MODE_OUT_PP_LOW_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
		break;
		case 14:
			//четные
			GPIO_Init(GPIOC,GPIO_PIN_7,GPIO_MODE_OUT_PP_LOW_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
		break;
		case 15:
			//четные
			GPIO_Init(GPIOC,GPIO_PIN_7,GPIO_MODE_OUT_PP_HIGH_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
		break;
		
		
		//
		case 16:
			//четные
			GPIO_Init(GPIOD,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
		break;
		case 17:
			//четные
			GPIO_Init(GPIOD,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
		break;
		
		case 18:
			//четные
			GPIO_Init(GPIOD,GPIO_PIN_2,GPIO_MODE_OUT_PP_HIGH_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
		break;
		case 19:
			//четные
			GPIO_Init(GPIOD,GPIO_PIN_2,GPIO_MODE_OUT_PP_LOW_SLOW);//
			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
		break;
		}
	}
		numind++;
		if (numind==20) numind=0;
	//}
	
	
	//TIM4->CR1 |= TIM4_CR1_CEN;
	TIM2->SR1 = (uint8_t)(~TIM2_IT_UPDATE);
 }

INTERRUPT_HANDLER(EXTI_PORTD_IRQHandler, 6) {}


INTERRUPT_HANDLER(EXTI_PORTC_IRQHandler, 5)
 
 {
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
	u8 zn;
	u8 time;
	
	time = TIM4->CNTR;
	//zn = GPIOC->IDR & GPIO_PIN_7;
	TIM4->CNTR=0;//сразу начинаем отсчет сначала!
	TIM4->CR1 |= (uint8_t)TIM4_CR1_CEN;
	
	if (dataok) return;

	//testtime[testind]=time;
	//testzn[testind]=zn;
	//testind++;
	//if (testind==50) dataok=1;
  
	if(time > 190) {//190*8 = 1520мкс таймаут и старт после прошлого пакета //тут либо 0 либо 200 с прошлого раза
		waitreset=1;//какая то ошибка
	} else if (waitreset==1) {
		if (time > 50) {//50*8 = 400мкс //старт!
			numbuffind=0;
			waitreset=0;
		}
	}

	if (waitreset==0) {
		//10мкс - около 20 тактов до этого места от срабатывания прервания
		_delay_us(20);
		if (GPIOC->IDR & GPIO_PIN_7) buffind[numbuffind]=1;
		else buffind[numbuffind]=0;
		
		if (numbuffind>(NUMIND)) dataok=1;		
		numbuffind++;
		
	}
 }

INTERRUPT_HANDLER(TIM4_UPD_OVF_IRQHandler, 23)
 {
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
	TIM4->SR1 = (uint8_t)(~TIM4_IT_UPDATE);
	//waitreset=1;
 }


INTERRUPT_HANDLER(TIM2_CAP_COM_IRQHandler, 14)
 {
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
	//GPIO_WriteReverse
	//GPIOC->DDR &= (u8) (~GPIO_PIN_3); //все выключаем когда яркость достигнута!
	//GPIOC->ODR ^= (uint8_t)GPIO_PIN_3;
	TIM2->SR1 = (uint8_t)(~TIM2_IT_CC1);
	
	if (stoptim) return;
	
	GPIOA->DDR &= (u8) (~ (GPIO_PIN_1|GPIO_PIN_2|GPIO_PIN_3) );
		//GPIO_Init(GPIOA,GPIO_PIN_1|GPIO_PIN_2|GPIO_PIN_3,GPIO_MODE_IN_FL_NO_IT);
	GPIOD->DDR &= (u8) (~ (GPIO_PIN_2|GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6) );
		//GPIO_Init(GPIOD,GPIO_PIN_2|GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6,GPIO_MODE_IN_FL_NO_IT);
	GPIOC->DDR &= (u8) (~ (GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6|GPIO_PIN_7) );
		//GPIO_Init(GPIOC,GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6|GPIO_PIN_7,GPIO_MODE_IN_FL_NO_IT);
	GPIOB->DDR &= (u8) (~ (GPIO_PIN_4|GPIO_PIN_5) );
	
	
	
 }