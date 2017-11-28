   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.5 - 29 Dec 2015
   3                     ; Generator (Limited) V4.4.4 - 27 Jan 2016
   4                     ; Optimizer V4.4.4 - 27 Jan 2016
  21                     	bsct
  22  0000               _time2:
  23  0000 00            	dc.b	0
  24  0001               _time3:
  25  0001 00            	dc.b	0
  26  0002               _time4:
  27  0002 00            	dc.b	0
  28  0003               _time5:
  29  0003 00            	dc.b	0
  30  0004               _time6:
  31  0004 00            	dc.b	0
  32  0005               _testind:
  33  0005 00            	dc.b	0
  34  0006               _yar:
  35  0006 00            	dc.b	0
  36  0007               _timesec:
  37  0007 03e7          	dc.w	999
  38  0009               _sleeptime:
  39  0009 00            	dc.b	0
  40  000a               _waitreset:
  41  000a 01            	dc.b	1
  42  000b               _waiterror:
  43  000b 00            	dc.b	0
  44  000c               _dataok:
  45  000c 00            	dc.b	0
  46  000d               _indicator:
  47  000d 00000000      	dc.l	0
  48  0011               _stoptim:
  49  0011 00            	dc.b	0
 101                     ; 34 void sendindicator(void) {
 103                     .text:	section	.text,new
 104  0000               _sendindicator:
 106  0000 5205          	subw	sp,#5
 107       00000005      OFST:	set	5
 110                     ; 36 	u32 dd = indicator;
 112  0002 be0f          	ldw	x,_indicator+2
 113  0004 1f04          	ldw	(OFST-1,sp),x
 114  0006 be0d          	ldw	x,_indicator
 115  0008 1f02          	ldw	(OFST-3,sp),x
 117                     ; 41 	stoptim=1;
 119  000a 35010011      	mov	_stoptim,#1
 120                     ; 44 	IND_WIRE_0;
 122  000e 721d500a      	bres	20490,#6
 123                     ; 45 	_delay_us(10);
 125  0012 ae0006        	ldw	x,#6
 127  0015               L6:
 128  0015 5a            	decw	X
 129  0016 26fd          	jrne	L6
 130  0018 9d            	nop	
 132                     ; 46 	IND_WIRE_1;	
 135  0019 721c500a      	bset	20490,#6
 136                     ; 47 	_delay_us(480);
 138  001d ae0140        	ldw	x,#320
 140  0020               L01:
 141  0020 5a            	decw	X
 142  0021 26fd          	jrne	L01
 143  0023 9d            	nop	
 145                     ; 52 	for (i=0;i<32;i++) {
 148  0024 0f01          	clr	(OFST-4,sp)
 150  0026               L33:
 151                     ; 53 		if (dd & 1) {
 153  0026 7b05          	ld	a,(OFST+0,sp)
 154  0028 a501          	bcp	a,#1
 155  002a 2719          	jreq	L14
 156                     ; 54 			disableInterrupts();
 159  002c 9b            	sim	
 161                     ; 55 			IND_WIRE_0;			
 164  002d 721d500a      	bres	20490,#6
 165                     ; 56 			_delay_us(10);
 167  0031 ae0006        	ldw	x,#6
 169  0034               L21:
 170  0034 5a            	decw	X
 171  0035 26fd          	jrne	L21
 172  0037 9d            	nop	
 174                     ; 57 			IND_WIRE_1;
 177  0038 721c500a      	bset	20490,#6
 178                     ; 58 			enableInterrupts();
 181  003c 9a            	rim	
 183                     ; 59 			_delay_us(55);
 186  003d ae0024        	ldw	x,#36
 188  0040               L41:
 189  0040 5a            	decw	X
 190  0041 26fd          	jrne	L41
 194  0043 2015          	jra	L34
 195  0045               L14:
 196                     ; 61 			IND_WIRE_0;			
 198  0045 721d500a      	bres	20490,#6
 199                     ; 62 			_delay_us(65);
 201  0049 ae002b        	ldw	x,#43
 203  004c               L61:
 204  004c 5a            	decw	X
 205  004d 26fd          	jrne	L61
 206  004f 9d            	nop	
 208                     ; 63 			IND_WIRE_1;
 211  0050 721c500a      	bset	20490,#6
 212                     ; 64 			_delay_us(5);
 214  0054 ae0003        	ldw	x,#3
 216  0057               L02:
 217  0057 5a            	decw	X
 218  0058 26fd          	jrne	L02
 220  005a               L34:
 221  005a 9d            	nop	
 222                     ; 66 		dd >>= 1;
 224  005b 0402          	srl	(OFST-3,sp)
 225  005d 0603          	rrc	(OFST-2,sp)
 226  005f 0604          	rrc	(OFST-1,sp)
 227  0061 0605          	rrc	(OFST+0,sp)
 229                     ; 52 	for (i=0;i<32;i++) {
 231  0063 0c01          	inc	(OFST-4,sp)
 235  0065 7b01          	ld	a,(OFST-4,sp)
 236  0067 a120          	cp	a,#32
 237  0069 25bb          	jrult	L33
 238                     ; 70 	stoptim=0;		
 240  006b 3f11          	clr	_stoptim
 241                     ; 71 }	
 244  006d 5b05          	addw	sp,#5
 245  006f 81            	ret	
 270                     ; 73 void sleep(void) {
 271                     .text:	section	.text,new
 272  0000               _sleep:
 276                     ; 74 	stoptim = 1;//чтобы не менять индикацию
 278  0000 35010011      	mov	_stoptim,#1
 279                     ; 77 	GPIO_Init(GPIOA,GPIO_PIN_1|GPIO_PIN_2|GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);
 281  0004 4bc0          	push	#192
 282  0006 4b0e          	push	#14
 283  0008 ae5000        	ldw	x,#20480
 284  000b cd0000        	call	_GPIO_Init
 286  000e 85            	popw	x
 287                     ; 78 	GPIO_Init(GPIOD,GPIO_PIN_2|GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6,GPIO_MODE_OUT_PP_LOW_SLOW);
 289  000f 4bc0          	push	#192
 290  0011 4b7c          	push	#124
 291  0013 ae500f        	ldw	x,#20495
 292  0016 cd0000        	call	_GPIO_Init
 294  0019 85            	popw	x
 295                     ; 79 	GPIO_Init(GPIOC,GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6|GPIO_PIN_7,GPIO_MODE_OUT_PP_LOW_SLOW);
 297  001a 4bc0          	push	#192
 298  001c 4bf8          	push	#248
 299  001e ae500a        	ldw	x,#20490
 300  0021 cd0000        	call	_GPIO_Init
 302  0024 85            	popw	x
 303                     ; 80 	GPIO_Init(GPIOB,GPIO_PIN_4|GPIO_PIN_5,GPIO_MODE_OUT_OD_LOW_SLOW);
 305  0025 4b80          	push	#128
 306  0027 4b30          	push	#48
 307  0029 ae5005        	ldw	x,#20485
 308  002c cd0000        	call	_GPIO_Init
 310  002f 3f11          	clr	_stoptim
 311  0031 85            	popw	x
 312                     ; 83 	stoptim = 0;
 314                     ; 84 }
 317  0032 81            	ret	
 320                     	bsct
 321  0012               _numbuffind:
 322  0012 00            	dc.b	0
 355                     ; 108 void assert_failed(u8* file, u32 line)
 355                     ; 109 { 
 356                     .text:	section	.text,new
 357  0000               _assert_failed:
 361  0000               L37:
 362  0000 20fe          	jra	L37
 427                     ; 122 uint32_t LSIMeasurment(void)
 427                     ; 123 {
 428                     .text:	section	.text,new
 429  0000               _LSIMeasurment:
 431  0000 520c          	subw	sp,#12
 432       0000000c      OFST:	set	12
 435                     ; 125   uint32_t lsi_freq_hz = 0x0;
 437                     ; 126   uint32_t fmaster = 0x0;
 439                     ; 127   uint16_t ICValue1 = 0x0;
 441                     ; 128   uint16_t ICValue2 = 0x0;
 443                     ; 131   fmaster = CLK_GetClockFreq();
 445  0002 cd0000        	call	_CLK_GetClockFreq
 447  0005 96            	ldw	x,sp
 448  0006 1c0009        	addw	x,#OFST-3
 449  0009 cd0000        	call	c_rtol
 452                     ; 134   AWU->CSR |= AWU_CSR_MSR;
 454  000c 721050f0      	bset	20720,#0
 455                     ; 146 	TIM1->CCER1 &= (uint8_t)(~TIM1_CCER1_CC1E);
 457  0010 7211525c      	bres	21084,#0
 458                     ; 149   TIM1->CCMR1 = (uint8_t)((uint8_t)(TIM1->CCMR1 & (uint8_t)(~(uint8_t)( TIM1_CCMR_CCxS | TIM1_CCMR_ICxF ))) | 
 458                     ; 150                           (uint8_t)(( (TIM1_ICSELECTION_DIRECTTI)) | ((uint8_t)( 0 << 4))));
 460  0014 c65258        	ld	a,21080
 461  0017 a40c          	and	a,#12
 462  0019 aa01          	or	a,#1
 463  001b c75258        	ld	21080,a
 464                     ; 151 	TIM1->CCER1 &= (uint8_t)(~TIM1_CCER1_CC1P);
 466  001e 7213525c      	bres	21084,#1
 467                     ; 152 	TIM1->CCER1 |=  TIM1_CCER1_CC1E;
 469  0022 7210525c      	bset	21084,#0
 470                     ; 156 	TIM1->CCMR1 = (uint8_t)((uint8_t)(TIM1->CCMR1 & (uint8_t)(~TIM1_CCMR_ICxPSC)) 
 470                     ; 157                           | (uint8_t)TIM1_ICPSC_DIV8);
 472  0026 c65258        	ld	a,21080
 473  0029 aa0c          	or	a,#12
 474  002b c75258        	ld	21080,a
 475                     ; 161 	TIM1->CR1 |= TIM1_CR1_CEN;
 477  002e 72105250      	bset	21072,#0
 479  0032               L331:
 480                     ; 164   while((TIM1->SR1 & TIM1_FLAG_CC1) != TIM1_FLAG_CC1);
 482  0032 72035255fb    	btjf	21077,#1,L331
 483                     ; 166   ICValue1 = TIM1_GetCapture1();
 485  0037 cd0000        	call	_TIM1_GetCapture1
 487  003a 1f05          	ldw	(OFST-7,sp),x
 489                     ; 167   TIM1_ClearFlag(TIM1_FLAG_CC1);
 491  003c ae0002        	ldw	x,#2
 492  003f cd0000        	call	_TIM1_ClearFlag
 495  0042               L141:
 496                     ; 170   while((TIM1->SR1 & TIM1_FLAG_CC1) != TIM1_FLAG_CC1);
 498  0042 72035255fb    	btjf	21077,#1,L141
 499                     ; 172   ICValue2 = TIM1_GetCapture1();
 501  0047 cd0000        	call	_TIM1_GetCapture1
 503  004a 1f07          	ldw	(OFST-5,sp),x
 505                     ; 173   TIM1_ClearFlag(TIM1_FLAG_CC1);
 507  004c ae0002        	ldw	x,#2
 508  004f cd0000        	call	_TIM1_ClearFlag
 510                     ; 176   TIM1->CCER1 &= (uint8_t)(~TIM1_CCER1_CC1E);
 512  0052 7211525c      	bres	21084,#0
 513                     ; 178   TIM1_Cmd(DISABLE);
 515  0056 4f            	clr	a
 516  0057 cd0000        	call	_TIM1_Cmd
 518                     ; 209   lsi_freq_hz = (8 * fmaster) / (ICValue2 - ICValue1);
 520  005a 1e07          	ldw	x,(OFST-5,sp)
 521  005c 72f005        	subw	x,(OFST-7,sp)
 522  005f cd0000        	call	c_uitolx
 524  0062 96            	ldw	x,sp
 525  0063 5c            	incw	x
 526  0064 cd0000        	call	c_rtol
 529  0067 96            	ldw	x,sp
 530  0068 1c0009        	addw	x,#OFST-3
 531  006b cd0000        	call	c_ltor
 533  006e a603          	ld	a,#3
 534  0070 cd0000        	call	c_llsh
 536  0073 96            	ldw	x,sp
 537  0074 5c            	incw	x
 538  0075 cd0000        	call	c_ludv
 540  0078 96            	ldw	x,sp
 541  0079 1c0009        	addw	x,#OFST-3
 542  007c cd0000        	call	c_rtol
 545                     ; 212   AWU->CSR &= (uint8_t)(~AWU_CSR_MSR);
 547  007f 721150f0      	bres	20720,#0
 548                     ; 214  return (lsi_freq_hz);
 550  0083 96            	ldw	x,sp
 551  0084 1c0009        	addw	x,#OFST-3
 552  0087 cd0000        	call	c_ltor
 556  008a 5b0c          	addw	sp,#12
 557  008c 81            	ret	
 560                     	bsct
 561  0013               _timedelay:
 562  0013 0000          	dc.w	0
 595                     ; 219 void Delay(u16 nCount)
 595                     ; 220 {
 596                     .text:	section	.text,new
 597  0000               _Delay:
 601                     ; 222     timedelay = nCount;
 603  0000 bf13          	ldw	_timedelay,x
 605  0002               L761:
 606                     ; 224 		while (timedelay);
 608  0002 be13          	ldw	x,_timedelay
 609  0004 26fc          	jrne	L761
 610                     ; 225 }
 613  0006 81            	ret	
 637                     ; 227 void mhalt(void){
 638                     .text:	section	.text,new
 639  0000               _mhalt:
 643                     ; 228 	halt();
 646  0000 8e            	halt	
 648                     ; 229 }
 652  0001 81            	ret	
 773                     ; 231 void main(void)
 773                     ; 232 {
 774                     .text:	section	.text,new
 775  0000               _main:
 777  0000 5204          	subw	sp,#4
 778       00000004      OFST:	set	4
 781                     ; 233 	u8 kol = 0;
 783  0002 0f04          	clr	(OFST+0,sp)
 785                     ; 234 	u8 napr=0;
 787  0004 0f03          	clr	(OFST-1,sp)
 789                     ; 235 	u8 demo=0;
 791                     ; 237 	CLK->PCKENR1 = CLK_PCKENR1_TIM4+CLK_PCKENR1_TIM2;
 793  0006 353050c7      	mov	20679,#48
 794                     ; 238 	CLK->PCKENR2 = 0b01110111;
 796  000a 357750ca      	mov	20682,#119
 797                     ; 240 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV8);
 799  000e a618          	ld	a,#24
 800  0010 cd0000        	call	_CLK_HSIPrescalerConfig
 802                     ; 242 	TIM2_TimeBaseInit(TIM2_PRESCALER_16, 124);//для индикации 50 000 Гц
 804  0013 ae007c        	ldw	x,#124
 805  0016 89            	pushw	x
 806  0017 a604          	ld	a,#4
 807  0019 cd0000        	call	_TIM2_TimeBaseInit
 809  001c 85            	popw	x
 810                     ; 243   TIM2_ClearFlag(TIM2_FLAG_UPDATE);
 812  001d ae0001        	ldw	x,#1
 813  0020 cd0000        	call	_TIM2_ClearFlag
 815                     ; 244 	TIM2_ITConfig(TIM2_IT_UPDATE, ENABLE);
 817  0023 ae0101        	ldw	x,#257
 818  0026 cd0000        	call	_TIM2_ITConfig
 820                     ; 245   TIM2->IER |= (uint8_t)TIM2_IT_UPDATE | TIM2_IT_CC1;
 822  0029 c65303        	ld	a,21251
 823  002c aa03          	or	a,#3
 824  002e c75303        	ld	21251,a
 825                     ; 247   TIM2_OC1Init(TIM2_OCMODE_PWM1, TIM2_OUTPUTSTATE_DISABLE,124, TIM2_OCPOLARITY_HIGH);
 827  0031 4b00          	push	#0
 828  0033 ae007c        	ldw	x,#124
 829  0036 89            	pushw	x
 830  0037 ae6000        	ldw	x,#24576
 831  003a cd0000        	call	_TIM2_OC1Init
 833  003d 5b03          	addw	sp,#3
 834                     ; 248   TIM2_OC1PreloadConfig(ENABLE);
 836  003f a601          	ld	a,#1
 837  0041 cd0000        	call	_TIM2_OC1PreloadConfig
 839                     ; 249   TIM2_ARRPreloadConfig(ENABLE);
 841  0044 a601          	ld	a,#1
 842  0046 cd0000        	call	_TIM2_ARRPreloadConfig
 844                     ; 253 	TIM4_Cmd(DISABLE);//для приема 1-wire
 846  0049 4f            	clr	a
 847  004a cd0000        	call	_TIM4_Cmd
 849                     ; 254 	TIM4_TimeBaseInit(TIM4_PRESCALER_16, 200);//8 микросекунды  один тик до 1600мкс - как таймаут!
 851  004d ae04c8        	ldw	x,#1224
 852  0050 cd0000        	call	_TIM4_TimeBaseInit
 854                     ; 255 	TIM4_SelectOnePulseMode(TIM4_OPMODE_SINGLE);//одиночный режим
 856  0053 a601          	ld	a,#1
 857  0055 cd0000        	call	_TIM4_SelectOnePulseMode
 859                     ; 256   TIM4_ClearFlag(TIM4_FLAG_UPDATE);
 861  0058 a601          	ld	a,#1
 862  005a cd0000        	call	_TIM4_ClearFlag
 864                     ; 257 	TIM4->CNTR=0;
 866  005d 725f5346      	clr	21318
 867                     ; 261 	EXTI_SetExtIntSensitivity(EXTI_PORT_GPIOD,EXTI_SENSITIVITY_FALL_ONLY);//самый высокий приоритет имеет
 869  0061 ae0302        	ldw	x,#770
 870  0064 cd0000        	call	_EXTI_SetExtIntSensitivity
 872                     ; 262   ITC_SetSoftwarePriority(ITC_IRQ_TIM2_OVF, ITC_PRIORITYLEVEL_2);
 874  0067 ae0d00        	ldw	x,#3328
 875  006a cd0000        	call	_ITC_SetSoftwarePriority
 877                     ; 263 	ITC_SetSoftwarePriority(ITC_IRQ_TIM4_OVF, ITC_PRIORITYLEVEL_2);
 879  006d ae1700        	ldw	x,#5888
 880  0070 cd0000        	call	_ITC_SetSoftwarePriority
 882                     ; 264 	ITC_SetSoftwarePriority(ITC_IRQ_PORTD, ITC_PRIORITYLEVEL_3);
 884  0073 ae0603        	ldw	x,#1539
 885  0076 cd0000        	call	_ITC_SetSoftwarePriority
 887                     ; 267 		for (i=0;i<NUMIND;i++) ind[i]=0;
 889  0079 4f            	clr	a
 890  007a 6b01          	ld	(OFST-3,sp),a
 892  007c               L152:
 895  007c 5f            	clrw	x
 896  007d 97            	ld	xl,a
 897  007e 6f22          	clr	(_ind,x)
 900  0080 0c01          	inc	(OFST-3,sp)
 904  0082 7b01          	ld	a,(OFST-3,sp)
 905  0084 a118          	cp	a,#24
 906  0086 25f4          	jrult	L152
 907                     ; 271 	BEEP_Cmd(DISABLE);
 909  0088 4f            	clr	a
 910  0089 cd0000        	call	_BEEP_Cmd
 912                     ; 274 	enableInterrupts();
 915  008c 9a            	rim	
 917                     ; 289 	TIM2_Cmd(ENABLE);
 920  008d a601          	ld	a,#1
 921  008f cd0000        	call	_TIM2_Cmd
 923                     ; 293 	sleep();
 925  0092 cd0000        	call	_sleep
 927                     ; 297 	demo = 1;
 929  0095               L752:
 930                     ; 303 			for (i=0;i<8;i++) {
 932  0095 4f            	clr	a
 933  0096 6b01          	ld	(OFST-3,sp),a
 935  0098               L362:
 936                     ; 304 				if (i<=kol) ind[i]=1; else ind[i]=0;
 938  0098 1104          	cp	a,(OFST+0,sp)
 939  009a 2205          	jrugt	L172
 942  009c cd018d        	call	LC001
 944  009f 2004          	jra	L372
 945  00a1               L172:
 948  00a1 5f            	clrw	x
 949  00a2 97            	ld	xl,a
 950  00a3 6f22          	clr	(_ind,x)
 951  00a5               L372:
 952                     ; 303 			for (i=0;i<8;i++) {
 954  00a5 0c01          	inc	(OFST-3,sp)
 958  00a7 7b01          	ld	a,(OFST-3,sp)
 959  00a9 a108          	cp	a,#8
 960  00ab 25eb          	jrult	L362
 961                     ; 307 			for (i=8;i<16;i++) {
 963  00ad a608          	ld	a,#8
 964  00af 6b01          	ld	(OFST-3,sp),a
 966  00b1               L572:
 967                     ; 308 				if (i<=kol+8) ind[i]=0; else ind[i]=1;
 969  00b1 5f            	clrw	x
 970  00b2 97            	ld	xl,a
 971  00b3 7b04          	ld	a,(OFST+0,sp)
 972  00b5 905f          	clrw	y
 973  00b7 9097          	ld	yl,a
 974  00b9 bf00          	ldw	c_x,x
 975  00bb 72a90008      	addw	y,#8
 976  00bf 90b300        	cpw	y,c_x
 977  00c2 2f08          	jrslt	L303
 980  00c4 7b01          	ld	a,(OFST-3,sp)
 981  00c6 5f            	clrw	x
 982  00c7 97            	ld	xl,a
 983  00c8 6f22          	clr	(_ind,x)
 985  00ca 2005          	jra	L503
 986  00cc               L303:
 989  00cc 7b01          	ld	a,(OFST-3,sp)
 990  00ce cd018d        	call	LC001
 991  00d1               L503:
 992                     ; 307 			for (i=8;i<16;i++) {
 994  00d1 0c01          	inc	(OFST-3,sp)
 998  00d3 7b01          	ld	a,(OFST-3,sp)
 999  00d5 a110          	cp	a,#16
1000  00d7 25d8          	jrult	L572
1001                     ; 312 			if (time2==0) {
1003  00d9 b600          	ld	a,_time2
1004  00db 2610          	jrne	L703
1005                     ; 313 				if (ind[16]) ind[16]=0;
1007  00dd 3d32          	tnz	_ind+16
1008  00df 2704          	jreq	L113
1011  00e1 b732          	ld	_ind+16,a
1013  00e3 2004          	jra	L313
1014  00e5               L113:
1015                     ; 314 				else ind[16]=1;
1017  00e5 35010032      	mov	_ind+16,#1
1018  00e9               L313:
1019                     ; 315 				time2=2;
1021  00e9 35020000      	mov	_time2,#2
1022  00ed               L703:
1023                     ; 317 			if (time3==0) {
1025  00ed b601          	ld	a,_time3
1026  00ef 2610          	jrne	L513
1027                     ; 318 				if (ind[17]) ind[17]=0;
1029  00f1 3d33          	tnz	_ind+17
1030  00f3 2704          	jreq	L713
1033  00f5 b733          	ld	_ind+17,a
1035  00f7 2004          	jra	L123
1036  00f9               L713:
1037                     ; 319 				else ind[17]=1;
1039  00f9 35010033      	mov	_ind+17,#1
1040  00fd               L123:
1041                     ; 320 				time3=1;
1043  00fd 35010001      	mov	_time3,#1
1044  0101               L513:
1045                     ; 322 			if (time4==0) {
1047  0101 b602          	ld	a,_time4
1048  0103 2610          	jrne	L323
1049                     ; 323 				if (ind[18]) ind[18]=0;
1051  0105 3d34          	tnz	_ind+18
1052  0107 2704          	jreq	L523
1055  0109 b734          	ld	_ind+18,a
1057  010b 2004          	jra	L723
1058  010d               L523:
1059                     ; 324 				else ind[18]=1;
1061  010d 35010034      	mov	_ind+18,#1
1062  0111               L723:
1063                     ; 325 				time4=1;
1065  0111 35010002      	mov	_time4,#1
1066  0115               L323:
1067                     ; 333 			if (time5==0) {
1069  0115 b603          	ld	a,_time5
1070  0117 2610          	jrne	L133
1071                     ; 334 				if (ind[19]) ind[19]=0;
1073  0119 3d35          	tnz	_ind+19
1074  011b 2704          	jreq	L333
1077  011d b735          	ld	_ind+19,a
1079  011f 2004          	jra	L533
1080  0121               L333:
1081                     ; 335 				else ind[19]=1;
1083  0121 35010035      	mov	_ind+19,#1
1084  0125               L533:
1085                     ; 336 				time5=3;
1087  0125 35030003      	mov	_time5,#3
1088  0129               L133:
1089                     ; 340 			if (napr==1) kol--; else kol++;
1091  0129 7b03          	ld	a,(OFST-1,sp)
1092  012b 4a            	dec	a
1093  012c 2604          	jrne	L733
1096  012e 0a04          	dec	(OFST+0,sp)
1099  0130 2002          	jra	L143
1100  0132               L733:
1103  0132 0c04          	inc	(OFST+0,sp)
1105  0134               L143:
1106                     ; 342 			if (kol > 7) napr=1;
1108  0134 7b04          	ld	a,(OFST+0,sp)
1109  0136 a108          	cp	a,#8
1110  0138 2504          	jrult	L343
1113  013a a601          	ld	a,#1
1114  013c 6b03          	ld	(OFST-1,sp),a
1116  013e               L343:
1117                     ; 343 			if (kol == 0) napr=0;
1119  013e 7b04          	ld	a,(OFST+0,sp)
1120  0140 2602          	jrne	L543
1123  0142 6b03          	ld	(OFST-1,sp),a
1125  0144               L543:
1126                     ; 346 			if (time6==0) {
1128  0144 b604          	ld	a,_time6
1129  0146 263c          	jrne	L743
1130                     ; 347 				for (i=0;i<20;i++) ind[i]=1;
1132  0148 6b01          	ld	(OFST-3,sp),a
1134  014a               L153:
1137  014a ad41          	call	LC001
1140  014c 0c01          	inc	(OFST-3,sp)
1144  014e 7b01          	ld	a,(OFST-3,sp)
1145  0150 a114          	cp	a,#20
1146  0152 25f6          	jrult	L153
1147                     ; 349 				for (i=12;i<123;i++) {
1149  0154 a60c          	ld	a,#12
1150  0156 6b01          	ld	(OFST-3,sp),a
1152  0158               L753:
1153                     ; 350 					yar = i;
1155  0158 ad3a          	call	LC002
1157                     ; 349 				for (i=12;i<123;i++) {
1159  015a 0c01          	inc	(OFST-3,sp)
1163  015c 7b01          	ld	a,(OFST-3,sp)
1164  015e a17b          	cp	a,#123
1165  0160 25f6          	jrult	L753
1166                     ; 355 				Delay(2000);
1168  0162 ae07d0        	ldw	x,#2000
1169  0165 cd0000        	call	_Delay
1171                     ; 357 				for (i=123;i>12;i--) {
1173  0168 a67b          	ld	a,#123
1174  016a 6b01          	ld	(OFST-3,sp),a
1176  016c               L563:
1177                     ; 358 					yar = i;
1179  016c ad26          	call	LC002
1181                     ; 357 				for (i=123;i>12;i--) {
1183  016e 0a01          	dec	(OFST-3,sp)
1187  0170 7b01          	ld	a,(OFST-3,sp)
1188  0172 a10d          	cp	a,#13
1189  0174 24f6          	jruge	L563
1190                     ; 363 				Delay(500);
1192  0176 ae01f4        	ldw	x,#500
1193  0179 cd0000        	call	_Delay
1195                     ; 365 				yar = 20;
1197  017c 35140006      	mov	_yar,#20
1198                     ; 367 				time6=5;
1200  0180 35050004      	mov	_time6,#5
1201  0184               L743:
1202                     ; 371 			Delay(20);
1204  0184 ae0014        	ldw	x,#20
1205  0187 cd0000        	call	_Delay
1208  018a cc0095        	jra	L752
1209  018d               LC001:
1210  018d 5f            	clrw	x
1211  018e 97            	ld	xl,a
1212  018f a601          	ld	a,#1
1213  0191 e722          	ld	(_ind,x),a
1214  0193 81            	ret	
1215  0194               LC002:
1216  0194 b706          	ld	_yar,a
1217                     ; 351 					TIM2->CCR1L = i;
1219  0196 c75312        	ld	21266,a
1220                     ; 352 					Delay(50);
1222  0199 ae0032        	ldw	x,#50
1223  019c cc0000        	jp	_Delay
1226                     	bsct
1227  0015               _ms:
1228  0015 00            	dc.b	0
1262                     .const:	section	.text
1263  0000               L472:
1264  0000 0088          	dc.w	L524
1265  0002 008e          	dc.w	L724
1266  0004 0095          	dc.w	L134
1267  0006 009e          	dc.w	L334
1268  0008 00a7          	dc.w	L534
1269  000a 00ad          	dc.w	L734
1270  000c 00b6          	dc.w	L144
1271  000e 00bc          	dc.w	L344
1272  0010 00c2          	dc.w	L544
1273  0012 00d1          	dc.w	L744
1274  0014 00d7          	dc.w	L154
1275  0016 00dd          	dc.w	L354
1276  0018 00e3          	dc.w	L554
1277  001a 00e9          	dc.w	L754
1278  001c 00f2          	dc.w	L164
1279  001e 00f8          	dc.w	L364
1280  0020 00fe          	dc.w	L564
1281  0022 0104          	dc.w	L764
1282  0024 010a          	dc.w	L174
1283  0026 0110          	dc.w	L374
1284                     ; 422 INTERRUPT_HANDLER(TIM2_UPD_OVF_BRK_IRQHandler, 13)
1284                     ; 423  {
1285                     .text:	section	.text,new
1286  0000               f_TIM2_UPD_OVF_BRK_IRQHandler:
1288  0000 8a            	push	cc
1289  0001 84            	pop	a
1290  0002 a4bf          	and	a,#191
1291  0004 88            	push	a
1292  0005 86            	pop	cc
1293  0006 3b0002        	push	c_x+2
1294  0009 be00          	ldw	x,c_x
1295  000b 89            	pushw	x
1296  000c 3b0002        	push	c_y+2
1297  000f be00          	ldw	x,c_y
1298  0011 89            	pushw	x
1301                     ; 427 	if (stoptim) 
1303  0012 b611          	ld	a,_stoptim
1304                     ; 429 		TIM2->SR1 = (uint8_t)(~TIM2_IT_UPDATE);
1305                     ; 430 		return;
1307  0014 2703cc0130    	jrne	L735
1308                     ; 441 		if (timedelay) timedelay--;
1310  0019 be13          	ldw	x,_timedelay
1311  001b 2703          	jreq	L705
1314  001d 5a            	decw	x
1315  001e bf13          	ldw	_timedelay,x
1316  0020               L705:
1317                     ; 445 		if (timesec==0)
1319  0020 be07          	ldw	x,_timesec
1320  0022 262b          	jrne	L115
1321                     ; 448 			timesec=999;
1323  0024 ae03e7        	ldw	x,#999
1324  0027 bf07          	ldw	_timesec,x
1325                     ; 449 			if (testind) testind--;
1327  0029 b605          	ld	a,_testind
1328  002b 2702          	jreq	L315
1331  002d 3a05          	dec	_testind
1332  002f               L315:
1333                     ; 450 			if (time2) time2--;
1335  002f b600          	ld	a,_time2
1336  0031 2702          	jreq	L515
1339  0033 3a00          	dec	_time2
1340  0035               L515:
1341                     ; 451 			if (time3) time3--;
1343  0035 b601          	ld	a,_time3
1344  0037 2702          	jreq	L715
1347  0039 3a01          	dec	_time3
1348  003b               L715:
1349                     ; 452 			if (time4) time4--;
1351  003b b602          	ld	a,_time4
1352  003d 2702          	jreq	L125
1355  003f 3a02          	dec	_time4
1356  0041               L125:
1357                     ; 453 			if (time5) time5--;
1359  0041 b603          	ld	a,_time5
1360  0043 2702          	jreq	L325
1363  0045 3a03          	dec	_time5
1364  0047               L325:
1365                     ; 454 			if (time6) time6--;
1367  0047 b604          	ld	a,_time6
1368  0049 2707          	jreq	L725
1371  004b 3a04          	dec	_time6
1372  004d 2003          	jra	L725
1373  004f               L115:
1374                     ; 457 		else timesec--;
1376  004f 5a            	decw	x
1377  0050 bf07          	ldw	_timesec,x
1378  0052               L725:
1379                     ; 461 		GPIOA->DDR &= (u8) (~ (GPIO_PIN_1|GPIO_PIN_2|GPIO_PIN_3) );
1381  0052 c65002        	ld	a,20482
1382  0055 a4f1          	and	a,#241
1383  0057 c75002        	ld	20482,a
1384                     ; 463 		GPIOD->DDR &= (u8) (~ (GPIO_PIN_2|GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6) );
1386  005a c65011        	ld	a,20497
1387  005d a483          	and	a,#131
1388  005f c75011        	ld	20497,a
1389                     ; 465 		GPIOC->DDR &= (u8) (~ (GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6|GPIO_PIN_7) );
1391  0062 c6500c        	ld	a,20492
1392  0065 a407          	and	a,#7
1393  0067 c7500c        	ld	20492,a
1394                     ; 467 		GPIOB->DDR &= (u8) (~ (GPIO_PIN_4|GPIO_PIN_5) );
1396  006a c65007        	ld	a,20487
1397  006d a4cf          	and	a,#207
1398  006f c75007        	ld	20487,a
1399                     ; 470 		if (ind[numind]) {
1401  0072 b601          	ld	a,_numind
1402  0074 5f            	clrw	x
1403  0075 97            	ld	xl,a
1404  0076 6d22          	tnz	(_ind,x)
1405  0078 2603cc0126    	jreq	L135
1406                     ; 472 		switch (numind) {	
1409                     ; 586 		break;
1410  007d a114          	cp	a,#20
1411  007f 24f9          	jruge	L135
1412  0081 5f            	clrw	x
1413  0082 97            	ld	xl,a
1414  0083 58            	sllw	x
1415  0084 de0000        	ldw	x,(L472,x)
1416  0087 fc            	jp	(x)
1417  0088               L524:
1418                     ; 473 		case 0:	
1418                     ; 474 			//четные
1418                     ; 475 			GPIO_Init(GPIOD,GPIO_PIN_5,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1420  0088 4bd0          	push	#208
1421  008a 4b20          	push	#32
1423                     ; 476 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
1425                     ; 477 		break;
1427  008c 2023          	jp	LC009
1428  008e               L724:
1429                     ; 479 		case 1:
1429                     ; 480 			//четные
1429                     ; 481 			GPIO_Init(GPIOD,GPIO_PIN_5,GPIO_MODE_OUT_PP_LOW_SLOW);//
1431  008e 4bc0          	push	#192
1432  0090 4b20          	push	#32
1434                     ; 482 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1436                     ; 483 		break;
1438  0092 cc0114        	jp	LC005
1439  0095               L134:
1440                     ; 485 		case 2:
1440                     ; 486 			//четные
1440                     ; 487 			GPIO_Init(GPIOA,GPIO_PIN_2,GPIO_MODE_OUT_PP_LOW_SLOW);//
1442  0095 4bc0          	push	#192
1443  0097 4b04          	push	#4
1444  0099 ae5000        	ldw	x,#20480
1446                     ; 488 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1448                     ; 489 		break;
1450  009c 2079          	jp	LC004
1451  009e               L334:
1452                     ; 491 		case 3:
1452                     ; 492 			//четные
1452                     ; 493 			GPIO_Init(GPIOA,GPIO_PIN_2,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1454  009e 4bd0          	push	#208
1455  00a0 4b04          	push	#4
1456  00a2 ae5000        	ldw	x,#20480
1458                     ; 494 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
1460                     ; 495 		break;
1462  00a5 2022          	jp	LC007
1463  00a7               L534:
1464                     ; 497 		case 4:
1464                     ; 498 			//четные
1464                     ; 499 			GPIO_Init(GPIOD,GPIO_PIN_6,GPIO_MODE_OUT_PP_LOW_SLOW);//
1466  00a7 4bc0          	push	#192
1467  00a9 4b40          	push	#64
1469                     ; 500 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1471                     ; 501 		break;
1473  00ab 2067          	jp	LC005
1474  00ad               L734:
1475                     ; 503 		case 5:
1475                     ; 504 			//четные
1475                     ; 505 			GPIO_Init(GPIOD,GPIO_PIN_6,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1477  00ad 4bd0          	push	#208
1478  00af 4b40          	push	#64
1479  00b1               LC009:
1480  00b1 ae500f        	ldw	x,#20495
1482                     ; 506 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
1484                     ; 507 		break;
1486  00b4 2013          	jp	LC007
1487  00b6               L144:
1488                     ; 509 		case 6:
1488                     ; 510 			//четные
1488                     ; 511 			GPIO_Init(GPIOD,GPIO_PIN_4,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1490  00b6 4bd0          	push	#208
1491  00b8 4b10          	push	#16
1493                     ; 512 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
1495                     ; 513 		break;
1497  00ba 20f5          	jp	LC009
1498  00bc               L344:
1499                     ; 515 		case 7:
1499                     ; 516 			//четные
1499                     ; 517 			GPIO_Init(GPIOD,GPIO_PIN_4,GPIO_MODE_OUT_PP_LOW_SLOW);//
1501  00bc 4bc0          	push	#192
1502  00be 4b10          	push	#16
1504                     ; 518 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1506                     ; 519 		break;
1508  00c0 2052          	jp	LC005
1509  00c2               L544:
1510                     ; 523 		case 8:
1510                     ; 524 			//четные
1510                     ; 525 			GPIO_Init(GPIOC,GPIO_PIN_4,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1512  00c2 4bd0          	push	#208
1513  00c4 4b10          	push	#16
1514  00c6               LC008:
1515  00c6 ae500a        	ldw	x,#20490
1517                     ; 526 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
1519  00c9               LC007:
1520  00c9 cd0000        	call	_GPIO_Init
1521  00cc 85            	popw	x
1531  00cd 4bc0          	push	#192
1533                     ; 527 		break;
1535  00cf 204c          	jp	LC003
1536  00d1               L744:
1537                     ; 528 		case 9:
1537                     ; 529 			//четные
1537                     ; 530 			GPIO_Init(GPIOC,GPIO_PIN_4,GPIO_MODE_OUT_PP_LOW_SLOW);//
1539  00d1 4bc0          	push	#192
1540  00d3 4b10          	push	#16
1542                     ; 531 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1544                     ; 532 		break;
1546  00d5 2016          	jp	LC006
1547  00d7               L154:
1548                     ; 533 		case 10:
1548                     ; 534 			//четные
1548                     ; 535 			GPIO_Init(GPIOC,GPIO_PIN_5,GPIO_MODE_OUT_PP_LOW_SLOW);//
1550  00d7 4bc0          	push	#192
1551  00d9 4b20          	push	#32
1553                     ; 536 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1555                     ; 537 		break;
1557  00db 2010          	jp	LC006
1558  00dd               L354:
1559                     ; 538 		case 11:
1559                     ; 539 			//четные
1559                     ; 540 			GPIO_Init(GPIOC,GPIO_PIN_5,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1561  00dd 4bd0          	push	#208
1562  00df 4b20          	push	#32
1564                     ; 541 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
1566                     ; 542 		break;
1568  00e1 20e3          	jp	LC008
1569  00e3               L554:
1570                     ; 543 		case 12:
1570                     ; 544 			//четные
1570                     ; 545 			GPIO_Init(GPIOC,GPIO_PIN_6,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1572  00e3 4bd0          	push	#208
1573  00e5 4b40          	push	#64
1575                     ; 546 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
1577                     ; 547 		break;
1579  00e7 20dd          	jp	LC008
1580  00e9               L754:
1581                     ; 548 		case 13:
1581                     ; 549 			//четные
1581                     ; 550 			GPIO_Init(GPIOC,GPIO_PIN_6,GPIO_MODE_OUT_PP_LOW_SLOW);//
1583  00e9 4bc0          	push	#192
1584  00eb 4b40          	push	#64
1585  00ed               LC006:
1586  00ed ae500a        	ldw	x,#20490
1588                     ; 551 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1590                     ; 552 		break;
1592  00f0 2025          	jp	LC004
1593  00f2               L164:
1594                     ; 553 		case 14:
1594                     ; 554 			//четные
1594                     ; 555 			GPIO_Init(GPIOC,GPIO_PIN_7,GPIO_MODE_OUT_PP_LOW_SLOW);//
1596  00f2 4bc0          	push	#192
1597  00f4 4b80          	push	#128
1599                     ; 556 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1601                     ; 557 		break;
1603  00f6 20f5          	jp	LC006
1604  00f8               L364:
1605                     ; 558 		case 15:
1605                     ; 559 			//четные
1605                     ; 560 			GPIO_Init(GPIOC,GPIO_PIN_7,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1607  00f8 4bd0          	push	#208
1608  00fa 4b80          	push	#128
1610                     ; 561 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
1612                     ; 562 		break;
1614  00fc 20c8          	jp	LC008
1615  00fe               L564:
1616                     ; 566 		case 16:
1616                     ; 567 			//четные
1616                     ; 568 			GPIO_Init(GPIOD,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1618  00fe 4bd0          	push	#208
1619  0100 4b08          	push	#8
1621                     ; 569 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
1623                     ; 570 		break;
1625  0102 20ad          	jp	LC009
1626  0104               L764:
1627                     ; 571 		case 17:
1627                     ; 572 			//четные
1627                     ; 573 			GPIO_Init(GPIOD,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
1629  0104 4bc0          	push	#192
1630  0106 4b08          	push	#8
1632                     ; 574 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1634                     ; 575 		break;
1636  0108 200a          	jp	LC005
1637  010a               L174:
1638                     ; 577 		case 18:
1638                     ; 578 			//четные
1638                     ; 579 			GPIO_Init(GPIOD,GPIO_PIN_2,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1640  010a 4bd0          	push	#208
1641  010c 4b04          	push	#4
1643                     ; 580 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW);//
1645                     ; 581 		break;
1647  010e 20a1          	jp	LC009
1648  0110               L374:
1649                     ; 582 		case 19:
1649                     ; 583 			//четные
1649                     ; 584 			GPIO_Init(GPIOD,GPIO_PIN_2,GPIO_MODE_OUT_PP_LOW_SLOW);//
1651  0110 4bc0          	push	#192
1652  0112 4b04          	push	#4
1653  0114               LC005:
1654  0114 ae500f        	ldw	x,#20495
1656                     ; 585 			GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_HIGH_SLOW);//
1658  0117               LC004:
1659  0117 cd0000        	call	_GPIO_Init
1660  011a 85            	popw	x
1670  011b 4bd0          	push	#208
1672  011d               LC003:
1673  011d 4b08          	push	#8
1674  011f ae500a        	ldw	x,#20490
1675  0122 cd0000        	call	_GPIO_Init
1676  0125 85            	popw	x
1677                     ; 586 		break;
1679  0126               L135:
1680                     ; 589 		numind++;
1682  0126 3c01          	inc	_numind
1683                     ; 590 		if (numind==20) numind=0;
1685  0128 b601          	ld	a,_numind
1686  012a a114          	cp	a,#20
1687  012c 2602          	jrne	L735
1690  012e 3f01          	clr	_numind
1691  0130               L735:
1692                     ; 595 	TIM2->SR1 = (uint8_t)(~TIM2_IT_UPDATE);
1694                     ; 596  }
1696  0130 35fe5304      	mov	21252,#254
1699  0134 85            	popw	x
1700  0135 bf00          	ldw	c_y,x
1701  0137 320002        	pop	c_y+2
1702  013a 85            	popw	x
1703  013b bf00          	ldw	c_x,x
1704  013d 320002        	pop	c_x+2
1705  0140 80            	iret	
1729                     ; 598 INTERRUPT_HANDLER(EXTI_PORTD_IRQHandler, 6) {}
1731                     .text:	section	.text,new
1732  0000               f_EXTI_PORTD_IRQHandler:
1739  0000 80            	iret	
1778                     ; 601 INTERRUPT_HANDLER(EXTI_PORTC_IRQHandler, 5)
1778                     ; 602  
1778                     ; 603  {
1779                     .text:	section	.text,new
1780  0000               f_EXTI_PORTC_IRQHandler:
1782       00000001      OFST:	set	1
1783  0000 88            	push	a
1786                     ; 610 	time = TIM4->CNTR;
1788  0001 c65346        	ld	a,21318
1789  0004 6b01          	ld	(OFST+0,sp),a
1791                     ; 612 	TIM4->CNTR=0;//сразу начинаем отсчет сначала!
1793  0006 725f5346      	clr	21318
1794                     ; 613 	TIM4->CR1 |= (uint8_t)TIM4_CR1_CEN;
1796  000a 72105340      	bset	21312,#0
1797                     ; 615 	if (dataok) return;
1799  000e 3d0c          	tnz	_dataok
1800  0010 2702          	jreq	L765
1804  0012 84            	pop	a
1805  0013 80            	iret	
1806  0014               L765:
1807                     ; 622 	if(time > 190) {//190*8 = 1520мкс таймаут и старт после прошлого пакета //тут либо 0 либо 200 с прошлого раза
1809  0014 a1bf          	cp	a,#191
1810  0016 2506          	jrult	L175
1811                     ; 623 		waitreset=1;//какая то ошибка
1813  0018 3501000a      	mov	_waitreset,#1
1815  001c 200f          	jra	L375
1816  001e               L175:
1817                     ; 624 	} else if (waitreset==1) {
1819  001e b60a          	ld	a,_waitreset
1820  0020 4a            	dec	a
1821  0021 260a          	jrne	L375
1822                     ; 625 		if (time > 50) {//50*8 = 400мкс //старт!
1824  0023 7b01          	ld	a,(OFST+0,sp)
1825  0025 a133          	cp	a,#51
1826  0027 2504          	jrult	L375
1827                     ; 626 			numbuffind=0;
1829  0029 3f12          	clr	_numbuffind
1830                     ; 627 			waitreset=0;
1832  002b 3f0a          	clr	_waitreset
1833  002d               L375:
1834                     ; 631 	if (waitreset==0) {
1836  002d b60a          	ld	a,_waitreset
1837  002f 2624          	jrne	L106
1838                     ; 633 		_delay_us(20);
1840  0031 ae000d        	ldw	x,#13
1842  0034               L403:
1843  0034 5a            	decw	X
1844  0035 26fd          	jrne	L403
1845  0037 9d            	nop	
1847                     ; 634 		if (GPIOC->IDR & GPIO_PIN_7) buffind[numbuffind]=1;
1850  0038 b612          	ld	a,_numbuffind
1851  003a 5f            	clrw	x
1852  003b 97            	ld	xl,a
1853  003c 720f500b06    	btjf	20491,#7,L306
1856  0041 a601          	ld	a,#1
1857  0043 e702          	ld	(_buffind,x),a
1859  0045 2002          	jra	L506
1860  0047               L306:
1861                     ; 635 		else buffind[numbuffind]=0;
1863  0047 6f02          	clr	(_buffind,x)
1864  0049               L506:
1865                     ; 637 		if (numbuffind>(NUMIND)) dataok=1;		
1867  0049 b612          	ld	a,_numbuffind
1868  004b a119          	cp	a,#25
1869  004d 2504          	jrult	L706
1872  004f 3501000c      	mov	_dataok,#1
1873  0053               L706:
1874                     ; 638 		numbuffind++;
1876  0053 3c12          	inc	_numbuffind
1877  0055               L106:
1878                     ; 641  }
1881  0055 84            	pop	a
1882  0056 80            	iret	
1905                     ; 643 INTERRUPT_HANDLER(TIM4_UPD_OVF_IRQHandler, 23)
1905                     ; 644  {
1906                     .text:	section	.text,new
1907  0000               f_TIM4_UPD_OVF_IRQHandler:
1911                     ; 648 	TIM4->SR1 = (uint8_t)(~TIM4_IT_UPDATE);
1913  0000 35fe5344      	mov	21316,#254
1914                     ; 650  }
1917  0004 80            	iret	
1940                     ; 653 INTERRUPT_HANDLER(TIM2_CAP_COM_IRQHandler, 14)
1940                     ; 654  {
1941                     .text:	section	.text,new
1942  0000               f_TIM2_CAP_COM_IRQHandler:
1946                     ; 662 	GPIOA->DDR &= (u8) (~ (GPIO_PIN_1|GPIO_PIN_2|GPIO_PIN_3) );
1948  0000 c65002        	ld	a,20482
1949  0003 a4f1          	and	a,#241
1950  0005 c75002        	ld	20482,a
1951                     ; 664 	GPIOD->DDR &= (u8) (~ (GPIO_PIN_2|GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6) );
1953  0008 c65011        	ld	a,20497
1954  000b a483          	and	a,#131
1955  000d c75011        	ld	20497,a
1956                     ; 666 	GPIOC->DDR &= (u8) (~ (GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6|GPIO_PIN_7) );
1958  0010 c6500c        	ld	a,20492
1959  0013 a407          	and	a,#7
1960  0015 c7500c        	ld	20492,a
1961                     ; 668 	GPIOB->DDR &= (u8) (~ (GPIO_PIN_4|GPIO_PIN_5) );
1963  0018 c65007        	ld	a,20487
1964  001b a4cf          	and	a,#207
1965  001d c75007        	ld	20487,a
1966                     ; 671 	TIM2->SR1 = (uint8_t)(~TIM2_IT_CC1);
1968  0020 35fd5304      	mov	21252,#253
1969                     ; 672  }
1972  0024 80            	iret	
2197                     	xdef	f_TIM2_CAP_COM_IRQHandler
2198                     	xdef	f_TIM4_UPD_OVF_IRQHandler
2199                     	xdef	f_EXTI_PORTC_IRQHandler
2200                     	xdef	f_EXTI_PORTD_IRQHandler
2201                     	xdef	f_TIM2_UPD_OVF_BRK_IRQHandler
2202                     	xdef	_ms
2203                     	xdef	_main
2204                     	xdef	_mhalt
2205                     	xdef	_timedelay
2206                     	switch	.ubsct
2207  0000               _command:
2208  0000 00            	ds.b	1
2209                     	xdef	_command
2210  0001               _numind:
2211  0001 00            	ds.b	1
2212                     	xdef	_numind
2213                     	xdef	_numbuffind
2214  0002               _buffind:
2215  0002 000000000000  	ds.b	32
2216                     	xdef	_buffind
2217  0022               _ind:
2218  0022 000000000000  	ds.b	24
2219                     	xdef	_ind
2220                     	xdef	_LSIMeasurment
2221                     	xdef	_Delay
2222                     	xdef	_sleep
2223                     	xdef	_sendindicator
2224                     	xdef	_stoptim
2225                     	xdef	_indicator
2226  003a               _testzn:
2227  003a 000000000000  	ds.b	50
2228                     	xdef	_testzn
2229  006c               _testtime:
2230  006c 000000000000  	ds.b	50
2231                     	xdef	_testtime
2232                     	xdef	_dataok
2233                     	xdef	_waiterror
2234                     	xdef	_waitreset
2235                     	xdef	_sleeptime
2236                     	xdef	_timesec
2237                     	xdef	_yar
2238                     	xdef	_testind
2239                     	xdef	_time6
2240                     	xdef	_time5
2241                     	xdef	_time4
2242                     	xdef	_time3
2243                     	xdef	_time2
2244                     	xdef	_assert_failed
2245                     	xref	_TIM4_ClearFlag
2246                     	xref	_TIM4_SelectOnePulseMode
2247                     	xref	_TIM4_Cmd
2248                     	xref	_TIM4_TimeBaseInit
2249                     	xref	_TIM2_ClearFlag
2250                     	xref	_TIM2_OC1PreloadConfig
2251                     	xref	_TIM2_ARRPreloadConfig
2252                     	xref	_TIM2_ITConfig
2253                     	xref	_TIM2_Cmd
2254                     	xref	_TIM2_OC1Init
2255                     	xref	_TIM2_TimeBaseInit
2256                     	xref	_TIM1_ClearFlag
2257                     	xref	_TIM1_GetCapture1
2258                     	xref	_TIM1_Cmd
2259                     	xref	_ITC_SetSoftwarePriority
2260                     	xref	_GPIO_Init
2261                     	xref	_EXTI_SetExtIntSensitivity
2262                     	xref	_CLK_GetClockFreq
2263                     	xref	_CLK_HSIPrescalerConfig
2264                     	xref	_BEEP_Cmd
2265                     	xref.b	c_x
2266                     	xref.b	c_y
2286                     	xref	c_ludv
2287                     	xref	c_uitolx
2288                     	xref	c_llsh
2289                     	xref	c_ltor
2290                     	xref	c_rtol
2291                     	end
