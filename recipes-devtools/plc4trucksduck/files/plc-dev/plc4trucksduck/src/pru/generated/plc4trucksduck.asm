;******************************************************************************
;* PRU C/C++ Codegen                                              Unix v2.3.3 *
;* Date/Time created: Wed Feb 19 17:58:49 2025                                *
;******************************************************************************
	.compiler_opts --abi=eabi --endian=little --hll_source=on --object_format=elf --silicon_version=3 --symdebug:none 
	.global	__PRU_CREG_PRU_CFG
	.global	__PRU_CREG_PRU_INTC
	.weak	||CT_CFG||
||CT_CFG||:	.usect	".creg.PRU_CFG.noload.near",68,1
	.weak	||CT_INTC||
||CT_INTC||:	.usect	".creg.PRU_INTC.noload.far",5380,1
	.global	||my_irq_rsc||
	.sect	".pru_irq_map:retain", RW
	.retain
	.align	1
	.elfsym	||my_irq_rsc||,SYM_SIZE(2)
||my_irq_rsc||:
	.bits		0,8
			; my_irq_rsc.type @ 0
	.bits		0x1,8
			; my_irq_rsc.num_evts @ 8
	.bits		0x11,8
			; my_irq_rsc[0].event @ 16
	.bits		0,8
			; my_irq_rsc[0].chnl @ 24
	.bits		0,8
			; my_irq_rsc[0].host @ 32

	.global	||resourceTable||
	.sect	".resource_table:retain", RW
	.retain
	.align	1
	.elfsym	||resourceTable||,SYM_SIZE(88)
||resourceTable||:
	.bits		0x1,32
			; resourceTable.base.ver @ 0
	.bits		0x1,32
			; resourceTable.base.num @ 32
	.bits		0,32
			; resourceTable.base.reserved[0] @ 64
	.bits		0,32
			; resourceTable.base.reserved[1] @ 96
	.bits		0x14,32
			; resourceTable.offset[0] @ 128
	.bits		0x3,32
			; resourceTable.rpmsg_vdev.type @ 160
	.bits		0x7,32
			; resourceTable.rpmsg_vdev.id @ 192
	.bits		0,32
			; resourceTable.rpmsg_vdev.notifyid @ 224
	.bits		0x1,32
			; resourceTable.rpmsg_vdev.dfeatures @ 256
	.bits		0,32
			; resourceTable.rpmsg_vdev.gfeatures @ 288
	.bits		0,32
			; resourceTable.rpmsg_vdev.config_len @ 320
	.bits		0,8
			; resourceTable.rpmsg_vdev.status @ 352
	.bits		0x2,8
			; resourceTable.rpmsg_vdev.num_of_vrings @ 360
	.bits		0,8
			; resourceTable.rpmsg_vdev.reserved[0] @ 368
	.bits		0,8
			; resourceTable.rpmsg_vdev.reserved[1] @ 376
	.bits		0xffffffff,32
			; resourceTable.rpmsg_vring0.da @ 384
	.bits		0x10,32
			; resourceTable.rpmsg_vring0.align @ 416
	.bits		0x10,32
			; resourceTable.rpmsg_vring0.num @ 448
	.bits		0,32
			; resourceTable.rpmsg_vring0.notifyid @ 480
	.bits		0,32
			; resourceTable.rpmsg_vring0.reserved @ 512
	.bits		0xffffffff,32
			; resourceTable.rpmsg_vring1.da @ 544
	.bits		0x10,32
			; resourceTable.rpmsg_vring1.align @ 576
	.bits		0x10,32
			; resourceTable.rpmsg_vring1.num @ 608
	.bits		0,32
			; resourceTable.rpmsg_vring1.notifyid @ 640
	.bits		0,32
			; resourceTable.rpmsg_vring1.reserved @ 672

	.global	||transmitBuf||
	.common	||transmitBuf||,496,1
	.global	||receiveBuf||
	.common	||receiveBuf||,255,1
;	optpru /tmp/TI12w0wSjS2 /tmp/TI12wMdqMzV 
;	acpiapru -@/tmp/TI12wkvKX40 
	.sect	".text:uartPutC"
	.clink
	.global	||uartPutC||
;----------------------------------------------------------------------
; 126 | void uartPutC(uint8_t c) {                                             
;----------------------------------------------------------------------

;***************************************************************
;* FNAME: uartPutC                      FR SIZE:   0           *
;*                                                             *
;* FUNCTION ENVIRONMENT                                        *
;*                                                             *
;* FUNCTION PROPERTIES                                         *
;*                            0 Auto,  0 SOE     *
;***************************************************************

||uartPutC||:
;* --------------------------------------------------------------------------*
        MOV       r3.w0, r3.w2          ; [ALU_PRU] 
;----------------------------------------------------------------------
; 127 | while(!(UART_LSR & 0x20));                                             
;----------------------------------------------------------------------
        LDI32     r1, 0x481a8014        ; [ALU_PRU] |127| 
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L1||
;*
;*   Loop source line                : 127
;*   Loop closing brace source line  : 127
;*   Known Minimum Trip Count        : 1
;*   Known Maximum Trip Count        : 4294967295
;*   Known Max Trip Count Factor     : 1
;* --------------------------------------------------------------------------*
||$C$L1||:    
        LBBO      &r0, r1, 0, 4         ; [ALU_PRU] |127| 
        QBBC      ||$C$L1||, r0, 0x05   ; [ALU_PRU] |127| 
;* --------------------------------------------------------------------------*
;----------------------------------------------------------------------
; 128 | UART_THR = c;                                                          
;----------------------------------------------------------------------
        MOV       r0, r14.b0            ; [ALU_PRU] |128| c
        LDI32     r1, 0x481a8000        ; [ALU_PRU] |128| 
        SBBO      &r0, r1, 0, 4         ; [ALU_PRU] |128| 
        JMP       r3.w0                 ; [ALU_PRU] 
	.sect	".text:uartWrite"
	.clink
	.global	||uartWrite||

;***************************************************************
;* FNAME: uartWrite                     FR SIZE:   0           *
;*                                                             *
;* FUNCTION ENVIRONMENT                                        *
;*                                                             *
;* FUNCTION PROPERTIES                                         *
;*                            0 Auto,  0 SOE     *
;***************************************************************

||uartWrite||:
;* --------------------------------------------------------------------------*
;----------------------------------------------------------------------
; 131 | void uartWrite(uint8_t* buf, uint16_t len) {                           
;----------------------------------------------------------------------
        MOV       r16, r14              ; [ALU_PRU] |131| buf
        MOV       r15.w2, r3.w2         ; [ALU_PRU] 
;----------------------------------------------------------------------
; 132 | for (uint16_t i = 0; i < len; i++) {                                   
;----------------------------------------------------------------------
        LDI       r14.w1, 0x0000        ; [ALU_PRU] |132| i
        JMP       ||$C$L3||             ; [ALU_PRU] |132| 
;* --------------------------------------------------------------------------*
||$C$L2||:    
;----------------------------------------------------------------------
; 133 | uartPutC(buf[i]);                                                      
;----------------------------------------------------------------------
        LBBO      &r14.b0, r16, r14.w1, 1 ; [ALU_PRU] |133| buf,i
        JAL       r3.w2, ||uartPutC||   ; [ALU_PRU] |133| uartPutC
        ADD       r14.w1, r14.w1, 0x01  ; [ALU_PRU] |132| i,i
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L3||
;* --------------------------------------------------------------------------*
||$C$L3||:    
        LDI32     r0, 0x80000000        ; [ALU_PRU] |132| 
        XOR       r1, r15.w0, r0        ; [ALU_PRU] |132| len
        XOR       r0, r14.w1, r0        ; [ALU_PRU] |132| i
        QBLT      ||$C$L2||, r1, r0     ; [ALU_PRU] |132| 
;* --------------------------------------------------------------------------*
;----------------------------------------------------------------------
; 135 | while(!(UART_LSR & 0x20)); // Wait until the last byte is actually tran
;     | smitted                                                                
;----------------------------------------------------------------------
        LDI32     r1, 0x481a8014        ; [ALU_PRU] |135| 
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L4||
;*
;*   Loop source line                : 135
;*   Loop closing brace source line  : 135
;*   Known Minimum Trip Count        : 1
;*   Known Maximum Trip Count        : 4294967295
;*   Known Max Trip Count Factor     : 1
;* --------------------------------------------------------------------------*
||$C$L4||:    
        LBBO      &r0, r1, 0, 4         ; [ALU_PRU] |135| 
        QBBC      ||$C$L4||, r0, 0x05   ; [ALU_PRU] |135| 
;* --------------------------------------------------------------------------*
        JMP       r15.w2                ; [ALU_PRU] 
	.sect	".text:uartSoftReset"
	.clink
	.global	||uartSoftReset||
;----------------------------------------------------------------------
;  50 | void uartSoftReset() {                                                 
;----------------------------------------------------------------------

;***************************************************************
;* FNAME: uartSoftReset                 FR SIZE:   0           *
;*                                                             *
;* FUNCTION ENVIRONMENT                                        *
;*                                                             *
;* FUNCTION PROPERTIES                                         *
;*                            0 Auto,  0 SOE     *
;***************************************************************

||uartSoftReset||:
;* --------------------------------------------------------------------------*
;----------------------------------------------------------------------
;  51 | UART_SYSC = 0x1; // Set softreset bit to 1                             
;----------------------------------------------------------------------
        LDI       r0, 0x0001            ; [ALU_PRU] |51| 
        LDI32     r1, 0x481a8054        ; [ALU_PRU] |51| 
        MOV       r3.w0, r3.w2          ; [ALU_PRU] 
        SBBO      &r0, r1, 0, 4         ; [ALU_PRU] |51| 
;----------------------------------------------------------------------
;  52 | while((UART_SYSS & 0x1) == 0); // Wait until the operation completes   
;----------------------------------------------------------------------
        LDI32     r1, 0x481a8058        ; [ALU_PRU] |52| 
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L5||
;*
;*   Loop source line                : 52
;*   Loop closing brace source line  : 52
;*   Known Minimum Trip Count        : 1
;*   Known Maximum Trip Count        : 4294967295
;*   Known Max Trip Count Factor     : 1
;* --------------------------------------------------------------------------*
||$C$L5||:    
        LBBO      &r0, r1, 0, 4         ; [ALU_PRU] |52| 
        QBBC      ||$C$L5||, r0, 0x00   ; [ALU_PRU] |52| 
;* --------------------------------------------------------------------------*
        JMP       r3.w0                 ; [ALU_PRU] 
	.sect	".text:uartSetMode"
	.clink
	.global	||uartSetMode||
;----------------------------------------------------------------------
;  46 | void uartSetMode(uint8_t mode) {                                       
;----------------------------------------------------------------------

;***************************************************************
;* FNAME: uartSetMode                   FR SIZE:   0           *
;*                                                             *
;* FUNCTION ENVIRONMENT                                        *
;*                                                             *
;* FUNCTION PROPERTIES                                         *
;*                            0 Auto,  0 SOE     *
;***************************************************************

||uartSetMode||:
;* --------------------------------------------------------------------------*
;----------------------------------------------------------------------
;  47 | UART_LCR = mode;                                                       
;----------------------------------------------------------------------
        MOV       r0, r14.b0            ; [ALU_PRU] |47| mode
        LDI32     r1, 0x481a800c        ; [ALU_PRU] |47| 
        MOV       r3.w0, r3.w2          ; [ALU_PRU] 
        SBBO      &r0, r1, 0, 4         ; [ALU_PRU] |47| 
        JMP       r3.w0                 ; [ALU_PRU] 
	.sect	".text:uartGetC"
	.clink
	.global	||uartGetC||
;----------------------------------------------------------------------
; 105 | uint8_t uartGetC(uint8_t* c) {                                         
;----------------------------------------------------------------------

;***************************************************************
;* FNAME: uartGetC                      FR SIZE:   0           *
;*                                                             *
;* FUNCTION ENVIRONMENT                                        *
;*                                                             *
;* FUNCTION PROPERTIES                                         *
;*                            0 Auto,  0 SOE     *
;***************************************************************

||uartGetC||:
;* --------------------------------------------------------------------------*
;----------------------------------------------------------------------
; 106 | if (UART_LSR & 0x1) {                                                  
;----------------------------------------------------------------------
        LDI32     r0, 0x481a8000        ; [ALU_PRU] |106| $O$C1
        MOV       r3.w0, r3.w2          ; [ALU_PRU] 
        LBBO      &r1, r0, 20, 4        ; [ALU_PRU] |106| $O$C1
        QBBC      ||$C$L6||, r1, 0x00   ; [ALU_PRU] |106| 
;* --------------------------------------------------------------------------*
;----------------------------------------------------------------------
; 107 | *c = UART_RHR;                                                         
;----------------------------------------------------------------------
        LBBO      &r0, r0, 0, 4         ; [ALU_PRU] |107| $O$C1
        SBBO      &r0.b0, r14, 0, 1     ; [ALU_PRU] |107| c
;----------------------------------------------------------------------
; 108 | return 1;                                                              
;----------------------------------------------------------------------
        LDI       r14.b0, 0x01          ; [ALU_PRU] |108| 
        JMP       ||$C$L7||             ; [ALU_PRU] |108| 
;* --------------------------------------------------------------------------*
||$C$L6||:    
;----------------------------------------------------------------------
; 110 | return 0;                                                              
;----------------------------------------------------------------------
        LDI       r14.b0, 0x00          ; [ALU_PRU] |110| 
;* --------------------------------------------------------------------------*
||$C$L7||:    
        JMP       r3.w0                 ; [ALU_PRU] 
	.sect	".text:uartRead"
	.clink
	.global	||uartRead||

;***************************************************************
;* FNAME: uartRead                      FR SIZE:   1           *
;*                                                             *
;* FUNCTION ENVIRONMENT                                        *
;*                                                             *
;* FUNCTION PROPERTIES                                         *
;*                            1 Auto,  0 SOE     *
;***************************************************************

||uartRead||:
;* --------------------------------------------------------------------------*
        MOV       r17.w0, r3.w2         ; [ALU_PRU] 
        SUB       r2, r2, 0x01          ; [ALU_PRU] 
;----------------------------------------------------------------------
; 113 | uint16_t uartRead(uint8_t* buf, uint16_t len) {                        
;----------------------------------------------------------------------
        MOV       r16, r14              ; [ALU_PRU] |113| buf
;----------------------------------------------------------------------
; 114 | uint16_t count = 0;                                                    
; 115 | uint8_t c;                                                             
;----------------------------------------------------------------------
        LDI       r15.w2, 0x0000        ; [ALU_PRU] |114| count
;----------------------------------------------------------------------
; 116 | while (count < len) {                                                  
; 117 |     if (uartGetC(&c)) {                                                
;----------------------------------------------------------------------
        JMP       ||$C$L9||             ; [ALU_PRU] |116| 
;* --------------------------------------------------------------------------*
||$C$L8||:    
;----------------------------------------------------------------------
; 118 | buf[count++] = c;                                                      
; 119 | } else {                                                               
; 120 | break;                                                                 
;----------------------------------------------------------------------
        LBBO      &r0.b0, r2, 0, 1      ; [ALU_PRU] |118| c
        SBBO      &r0.b0, r16, r15.w2, 1 ; [ALU_PRU] |118| buf,count
        ADD       r15.w2, r15.w2, 0x01  ; [ALU_PRU] |118| count,count
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L9||
;* --------------------------------------------------------------------------*
||$C$L9||:    
        LDI32     r0, 0x80000000        ; [ALU_PRU] |116| 
        XOR       r1, r15.w0, r0        ; [ALU_PRU] |116| len
        XOR       r0, r15.w2, r0        ; [ALU_PRU] |116| count
        QBGE      ||$C$L10||, r1, r0    ; [ALU_PRU] |116| 
;* --------------------------------------------------------------------------*
        ADD       r14, r2, 0            ; [ALU_PRU] |117| c,c
        JAL       r3.w2, ||uartGetC||   ; [ALU_PRU] |117| uartGetC
        QBNE      ||$C$L8||, r14.b0, 0x00 ; [ALU_PRU] |117| 
;* --------------------------------------------------------------------------*
||$C$L10||:    
;----------------------------------------------------------------------
; 123 | return count;                                                          
;----------------------------------------------------------------------
        MOV       r14.w0, r15.w2        ; [ALU_PRU] |123| count
        ADD       r2, r2, 0x01          ; [ALU_PRU] 
        JMP       r17.w0                ; [ALU_PRU] 
	.sect	".text:clockWarmUp"
	.clink
	.global	||clockWarmUp||
;----------------------------------------------------------------------
;  10 | void clockWarmUp(uint8_t moduleOffset) {                               
;  11 | volatile uint32_t *ptr_cm = CM_PER_BASE;                               
;----------------------------------------------------------------------

;***************************************************************
;* FNAME: clockWarmUp                   FR SIZE:   0           *
;*                                                             *
;* FUNCTION ENVIRONMENT                                        *
;*                                                             *
;* FUNCTION PROPERTIES                                         *
;*                            0 Auto,  0 SOE     *
;***************************************************************

||clockWarmUp||:
;* --------------------------------------------------------------------------*
;----------------------------------------------------------------------
;  12 | ptr_cm[moduleOffset / 4] = CLKCTRL_ON;                                 
;----------------------------------------------------------------------
        MOV       r1, r14.b0            ; [ALU_PRU] |12| moduleOffset
        LDI32     r0, 0x44e00000        ; [ALU_PRU] |12| ptr_cm
        MOV       r3.w0, r3.w2          ; [ALU_PRU] 
        LSR       r1, r1, 0x02          ; [ALU_PRU] |12| 
        LSL       r15, r1, 0x02         ; [ALU_PRU] |12| 
        LDI       r1, 0x0002            ; [ALU_PRU] |12| 
        SBBO      &r1, r0, r15, 4       ; [ALU_PRU] |12| ptr_cm
;----------------------------------------------------------------------
;  13 | while(ptr_cm[moduleOffset / 4] & 0x00300000);                          
;----------------------------------------------------------------------
        LDI32     r15, 0x00300000       ; [ALU_PRU] |13| 
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L11||
;*
;*   Loop source line                : 13
;*   Loop closing brace source line  : 13
;*   Known Minimum Trip Count        : 1
;*   Known Maximum Trip Count        : 4294967295
;*   Known Max Trip Count Factor     : 1
;* --------------------------------------------------------------------------*
||$C$L11||:    
        MOV       r1, r14.b0            ; [ALU_PRU] |13| moduleOffset
        LSR       r1, r1, 0x02          ; [ALU_PRU] |13| 
        LSL       r1, r1, 0x02          ; [ALU_PRU] |13| 
        LBBO      &r1, r0, r1, 4        ; [ALU_PRU] |13| ptr_cm
        AND       r1, r1, r15           ; [ALU_PRU] |13| 
        QBNE      ||$C$L11||, r1, 0x00  ; [ALU_PRU] |13| 
;* --------------------------------------------------------------------------*
        JMP       r3.w0                 ; [ALU_PRU] 
	.sect	".text:uartInit"
	.clink
	.global	||uartInit||
;----------------------------------------------------------------------
;  55 | void uartInit() {                                                      
;  56 | // Start UART Clock                                                    
;----------------------------------------------------------------------

;***************************************************************
;* FNAME: uartInit                      FR SIZE:   0           *
;*                                                             *
;* FUNCTION ENVIRONMENT                                        *
;*                                                             *
;* FUNCTION PROPERTIES                                         *
;*                            0 Auto,  0 SOE     *
;***************************************************************

||uartInit||:
;* --------------------------------------------------------------------------*
        MOV       r14.w1, r3.w2         ; [ALU_PRU] 
;----------------------------------------------------------------------
;  57 | clockWarmUp(UART_CLKCTRL_OFFSET);                                      
;  59 | // Init UART per TFM                                                   
;----------------------------------------------------------------------
        LDI       r14.b0, 0x78          ; [ALU_PRU] |57| 
        JAL       r3.w2, ||clockWarmUp|| ; [ALU_PRU] |57| clockWarmUp
;----------------------------------------------------------------------
;  60 | uartSoftReset();                                                       
;----------------------------------------------------------------------
        JAL       r3.w2, ||uartSoftReset|| ; [ALU_PRU] |60| uartSoftReset
;----------------------------------------------------------------------
;  61 | UART_LCR |= 0x40; // Set break control bit. Doesn't match TRM          
;  62 | uint32_t saved_lcr = UART_LCR;                                         
;----------------------------------------------------------------------
        LDI32     r18, 0x481a8000       ; [ALU_PRU] |61| $O$C6
;----------------------------------------------------------------------
;  63 | uartSetMode(UART_CONFIG_MODE_B);                                       
;----------------------------------------------------------------------
        LDI       r14.b0, 0xbf          ; [ALU_PRU] |63| 
        ADD       r20, r18, 0x0c        ; [ALU_PRU] |61| $O$C2,$O$C6
        LBBO      &r0, r20, 0, 4        ; [ALU_PRU] |61| $O$C2
        SET       r0, r0, 0x00000006    ; [ALU_PRU] |61| 
        SBBO      &r0, r20, 0, 4        ; [ALU_PRU] |61| $O$C2
        LBBO      &r21, r20, 0, 4       ; [ALU_PRU] |62| saved_lcr,$O$C2
;----------------------------------------------------------------------
;  64 | uint32_t saved_efr = UART_EFR;                                         
;  65 | UART_EFR = (saved_efr | 0x10); // Enter TCR_TLR submode                
;----------------------------------------------------------------------
        JAL       r3.w2, ||uartSetMode|| ; [ALU_PRU] |63| uartSetMode
;----------------------------------------------------------------------
;  66 | uartSetMode(UART_CONFIG_MODE_A);                                       
;----------------------------------------------------------------------
        LDI       r14.b0, 0x80          ; [ALU_PRU] |66| 
        ADD       r17, r18, 0x08        ; [ALU_PRU] |64| $O$C3,$O$C6
        LBBO      &r19, r17, 0, 4       ; [ALU_PRU] |64| saved_efr,$O$C3
        SET       r0, r19, 0x00000004   ; [ALU_PRU] |65| saved_efr
        SBBO      &r0, r17, 0, 4        ; [ALU_PRU] |65| $O$C3
;----------------------------------------------------------------------
;  67 | uint32_t saved_mcr = UART_MCR;                                         
;  68 | UART_MCR = (saved_mcr | 0x40); // Enter TCR_TLR submode                
;  69 | // Clear the FIFOs and enable it (puts it in interrupt mode). Can't ful
;     | ly                                                                     
;  70 | // utilize UART FIFO interrupts on PRUs because:                       
;  71 | // 1) PRU don't support context switching interrupts only single regist
;     | er polling interrupts                                                  
;  72 | // 2) According to TRM section 4.4.2.2 the only UART2 system event is t
;     | x overflow.                                                            
;  73 | // Originally was 0x3. Changed to 0x7 to clear TX FIFO too and set Trig
;  74 | // levels to 16 bytes.                                                 
;  75 | UART_FCR = 0x57;                                                       
;----------------------------------------------------------------------
        JAL       r3.w2, ||uartSetMode|| ; [ALU_PRU] |66| uartSetMode
;----------------------------------------------------------------------
;  76 | uartSetMode(UART_CONFIG_MODE_B);                                       
;----------------------------------------------------------------------
        LDI       r14.b0, 0xbf          ; [ALU_PRU] |76| 
        ADD       r15, r18, 0x10        ; [ALU_PRU] |67| $O$C7,$O$C6
        LBBO      &r16, r15, 0, 4       ; [ALU_PRU] |67| saved_mcr,$O$C7
        SET       r0, r16, 0x00000006   ; [ALU_PRU] |68| saved_mcr
        SBBO      &r0, r15, 0, 4        ; [ALU_PRU] |68| $O$C7
        LDI       r0, 0x0057            ; [ALU_PRU] |75| 
        SBBO      &r0, r17, 0, 4        ; [ALU_PRU] |75| $O$C3
;----------------------------------------------------------------------
;  77 | UART_EFR = saved_efr;                                                  
;----------------------------------------------------------------------
        JAL       r3.w2, ||uartSetMode|| ; [ALU_PRU] |76| uartSetMode
;----------------------------------------------------------------------
;  78 | uartSetMode(UART_CONFIG_MODE_A);                                       
;----------------------------------------------------------------------
        LDI       r14.b0, 0x80          ; [ALU_PRU] |78| 
        SBBO      &r19, r17, 0, 4       ; [ALU_PRU] |77| $O$C3,saved_efr
        JAL       r3.w2, ||uartSetMode|| ; [ALU_PRU] |78| uartSetMode
;* --------------------------------------------------------------------------*
;----------------------------------------------------------------------
;  79 | UART_MCR = saved_mcr;                                                  
;----------------------------------------------------------------------
        SBBO      &r16, r15, 0, 4       ; [ALU_PRU] |79| $O$C7,saved_mcr
;----------------------------------------------------------------------
;  80 | UART_LCR = saved_lcr;                                                  
;  81 | uint32_t saved_reg = UART_MDR1;                                        
;----------------------------------------------------------------------
        SBBO      &r21, r20, 0, 4       ; [ALU_PRU] |80| $O$C2,saved_lcr
;----------------------------------------------------------------------
;  82 | UART_MDR1 = (saved_reg & 0xFFF8) | 0x7; // Disable UART                
;----------------------------------------------------------------------
        LDI       r15, 0xfff8           ; [ALU_PRU] |82| 
;----------------------------------------------------------------------
;  83 | uartSetMode(UART_CONFIG_MODE_B);                                       
;----------------------------------------------------------------------
        LDI       r14.b0, 0xbf          ; [ALU_PRU] |83| 
        ADD       r16, r18, 0x20        ; [ALU_PRU] |81| $O$C1,$O$C6
        LBBO      &r0, r16, 0, 4        ; [ALU_PRU] |81| saved_reg,$O$C1
        AND       r0, r0, r15           ; [ALU_PRU] |82| saved_reg
        OR        r0, r0, 0x07          ; [ALU_PRU] |82| 
        SBBO      &r0, r16, 0, 4        ; [ALU_PRU] |82| $O$C1
        JAL       r3.w2, ||uartSetMode|| ; [ALU_PRU] |83| uartSetMode
;----------------------------------------------------------------------
;  84 | saved_efr = UART_EFR;                                                  
;  85 | UART_EFR = (saved_efr | 0x10);  // Enter TCR_TLR submode               
;----------------------------------------------------------------------
        LBBO      &r19, r17, 0, 4       ; [ALU_PRU] |84| saved_efr,$O$C3
;----------------------------------------------------------------------
;  86 | uartSetMode(UART_OPERATIONAL_MODE);                                    
;----------------------------------------------------------------------
        LDI       r14.b0, 0x00          ; [ALU_PRU] |86| 
        SET       r0, r19, 0x00000004   ; [ALU_PRU] |85| saved_efr
        SBBO      &r0, r17, 0, 4        ; [ALU_PRU] |85| $O$C3
;----------------------------------------------------------------------
;  87 | UART_IER = 0x00;                                                       
;----------------------------------------------------------------------
        JAL       r3.w2, ||uartSetMode|| ; [ALU_PRU] |86| uartSetMode
;----------------------------------------------------------------------
;  88 | uartSetMode(UART_CONFIG_MODE_B);                                       
;----------------------------------------------------------------------
        LDI       r14.b0, 0xbf          ; [ALU_PRU] |88| 
        LDI       r0, 0x0000            ; [ALU_PRU] |87| 
        ADD       r21, r18, 0x04        ; [ALU_PRU] |87| $O$C4,$O$C6
        SBBO      &r0, r21, 0, 4        ; [ALU_PRU] |87| $O$C4
;----------------------------------------------------------------------
;  89 | // DLH and DLL (high and low) are combined to get a divisor. TRM indica
;     | tes                                                                    
;  90 | // 313 is appropriate for 9600 baud.                                   
;----------------------------------------------------------------------
        JAL       r3.w2, ||uartSetMode|| ; [ALU_PRU] |88| uartSetMode
;----------------------------------------------------------------------
;  91 | UART_DLL = 0x39; // Originally was 0x38=312, changed to match TRM.     
;  92 | UART_DLH = 0x01;                                                       
;----------------------------------------------------------------------
        LDI       r0, 0x0039            ; [ALU_PRU] |91| 
;----------------------------------------------------------------------
;  93 | uartSetMode(UART_OPERATIONAL_MODE);                                    
;----------------------------------------------------------------------
        LDI       r14.b0, 0x00          ; [ALU_PRU] |93| 
        SBBO      &r0, r18, 0, 4        ; [ALU_PRU] |91| $O$C6
        LDI       r18, 0x0001           ; [ALU_PRU] |92| $O$C5
        SBBO      &r18, r21, 0, 4       ; [ALU_PRU] |92| $O$C4,$O$C5
;----------------------------------------------------------------------
;  94 | // Set interrupts. Originally none, changed to enable RHR interrupts.  
;  95 | UART_IER = 0x01;                                                       
;----------------------------------------------------------------------
        JAL       r3.w2, ||uartSetMode|| ; [ALU_PRU] |93| uartSetMode
;----------------------------------------------------------------------
;  96 | uartSetMode(UART_CONFIG_MODE_B);                                       
;----------------------------------------------------------------------
        LDI       r14.b0, 0xbf          ; [ALU_PRU] |96| 
        SBBO      &r18, r21, 0, 4       ; [ALU_PRU] |95| $O$C4,$O$C5
;----------------------------------------------------------------------
;  97 | UART_EFR = saved_efr;                                                  
;  98 | // Set data bits to 8 for a total word length of 10: 1 start, 8 data, 1
;     |  stop.                                                                 
;----------------------------------------------------------------------
        JAL       r3.w2, ||uartSetMode|| ; [ALU_PRU] |96| uartSetMode
;----------------------------------------------------------------------
;  99 | UART_LCR = 0x03;                                                       
;----------------------------------------------------------------------
        LDI       r0, 0x0003            ; [ALU_PRU] |99| 
        SBBO      &r19, r17, 0, 4       ; [ALU_PRU] |97| $O$C3,saved_efr
;----------------------------------------------------------------------
; 100 | // Restore MDR which by default is normal uart x16 sample rate.        
;----------------------------------------------------------------------
        SBBO      &r0, r20, 0, 4        ; [ALU_PRU] |99| $O$C2
;----------------------------------------------------------------------
; 101 | saved_reg = UART_MDR1;                                                 
;----------------------------------------------------------------------
        LBBO      &r0, r16, 0, 4        ; [ALU_PRU] |101| saved_reg,$O$C1
;----------------------------------------------------------------------
; 102 | UART_MDR1 = (saved_reg & 0xFFF8);                                      
;----------------------------------------------------------------------
        AND       r0, r0, r15           ; [ALU_PRU] |102| saved_reg
        SBBO      &r0, r16, 0, 4        ; [ALU_PRU] |102| $O$C1
        JMP       r14.w1                ; [ALU_PRU] 
	.sect	".text:readGpioPin"
	.clink
	.global	||readGpioPin||
;----------------------------------------------------------------------
;  32 | int readGpioPin(uint8_t pin) {                                         
;----------------------------------------------------------------------

;***************************************************************
;* FNAME: readGpioPin                   FR SIZE:   0           *
;*                                                             *
;* FUNCTION ENVIRONMENT                                        *
;*                                                             *
;* FUNCTION PROPERTIES                                         *
;*                            0 Auto,  0 SOE     *
;***************************************************************

||readGpioPin||:
;* --------------------------------------------------------------------------*
;----------------------------------------------------------------------
;  33 | return GPIO_DATAIN & (1 << GPIO_PIN(pin));                             
;----------------------------------------------------------------------
        AND       r0.b0, r14.b0, 0x1f   ; [ALU_PRU] |33| pin
        MOV       r3.w0, r3.w2          ; [ALU_PRU] 
        MOV       r0, r0.b0             ; [ALU_PRU] |33| 
        QBBC      ||$C$L12||, r0, 0x07  ; [ALU_PRU] |33| 
;* --------------------------------------------------------------------------*
        FILL      &r0.b1, 3             ; [ALU_PRU] |33| 
;* --------------------------------------------------------------------------*
||$C$L12||:    
        LDI       r1, 0x0001            ; [ALU_PRU] |33| 
        LSL       r0, r1, r0            ; [ALU_PRU] |33| 
        LDI32     r1, 0x481ac138        ; [ALU_PRU] |33| 
        LBBO      &r1, r1, 0, 4         ; [ALU_PRU] |33| 
        AND       r14, r1, r0           ; [ALU_PRU] |33| 
        JMP       r3.w0                 ; [ALU_PRU] 
	.sect	".text:receiveRemainingMessage"
	.clink
	.global	||receiveRemainingMessage||

;***************************************************************
;* FNAME: receiveRemainingMessage       FR SIZE:   0           *
;*                                                             *
;* FUNCTION ENVIRONMENT                                        *
;*                                                             *
;* FUNCTION PROPERTIES                                         *
;*                            0 Auto,  0 SOE     *
;***************************************************************

||receiveRemainingMessage||:
;* --------------------------------------------------------------------------*
        MOV       r17.w2, r3.w2         ; [ALU_PRU] 
;----------------------------------------------------------------------
;  79 | int16_t receiveRemainingMessage(uint8_t* buf) {                        
;----------------------------------------------------------------------
        MOV       r16, r14              ; [ALU_PRU] |79| buf
;----------------------------------------------------------------------
;  80 | uint16_t i = 0;                                                        
;  81 | while (i < MAX_PAYLOAD_LEN) {                                          
;----------------------------------------------------------------------
        LDI       r17.w0, 0x0000        ; [ALU_PRU] |80| i
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L13||
;*
;*   Loop source line                : 81
;*   Loop closing brace source line  : 88
;*   Known Minimum Trip Count        : 1
;*   Known Maximum Trip Count        : 4294967295
;*   Known Max Trip Count Factor     : 1
;* --------------------------------------------------------------------------*
||$C$L13||:    
;----------------------------------------------------------------------
;  82 | if (uartGetC(&buf[i])) {                                               
;----------------------------------------------------------------------
        ADD       r14, r16, r17.w0      ; [ALU_PRU] |82| buf,i
        JAL       r3.w2, ||uartGetC||   ; [ALU_PRU] |82| uartGetC
        QBEQ      ||$C$L14||, r14.b0, 0x00 ; [ALU_PRU] |82| 
;* --------------------------------------------------------------------------*
;----------------------------------------------------------------------
;  83 | i++;                                                                   
;  85 | if (isBusIdle(CHECKS_TILL_MSG_FINISHED)) {                             
;  86 | break; // Exit the loop if the bus is idle                             
;----------------------------------------------------------------------
        ADD       r17.w0, r17.w0, 0x01  ; [ALU_PRU] |83| i,i
;* --------------------------------------------------------------------------*
||$C$L14||:    
        ZERO      &r15, 4               ; [ALU_PRU] |36| i
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L15||
;*
;*   Loop source line                : 36
;*   Loop closing brace source line  : 50
;*   Known Minimum Trip Count        : 1
;*   Known Maximum Trip Count        : 4294967295
;*   Known Max Trip Count Factor     : 1
;* --------------------------------------------------------------------------*
||$C$L15||:    
        LDI       r14.b0, 0x58          ; [ALU_PRU] |44| 
        JAL       r3.w2, ||readGpioPin|| ; [ALU_PRU] |44| readGpioPin
        QBNE      ||$C$L16||, r14, 0x00 ; [ALU_PRU] |44| 
;* --------------------------------------------------------------------------*
        LDI32     r0, 0x80000000        ; [ALU_PRU] |81| 
        XOR       r1, r17.w0, r0        ; [ALU_PRU] |81| i
        LDI32     r0, 0x800000ff        ; [ALU_PRU] |81| 
        QBLT      ||$C$L13||, r0, r1    ; [ALU_PRU] |81| 
;* --------------------------------------------------------------------------*
        JMP       ||$C$L17||            ; [ALU_PRU] |81| 
;* --------------------------------------------------------------------------*
||$C$L16||:    
        .newblock
        LDI32    r0, 5199
$1:     SUB      r0, r0, 1
        QBNE     $1, r0, 0             ; [ALU_PRU] |48| 
        ADD       r15, r15, 0x01        ; [ALU_PRU] |36| i,i
        LDI32     r1, 0x8000000b        ; [ALU_PRU] |36| 
        MOV       r0, r15               ; [ALU_PRU] |36| i
        XOR       r0.b3, r0.b3, 0x80    ; [ALU_PRU] |36| 
        QBLT      ||$C$L15||, r1, r0    ; [ALU_PRU] |36| 
;* --------------------------------------------------------------------------*
||$C$L17||:    
;----------------------------------------------------------------------
;  89 | return i; // Return the number of bytes received                       
;----------------------------------------------------------------------
        MOV       r14.w0, r17.w0        ; [ALU_PRU] |89| i
        JMP       r17.w2                ; [ALU_PRU] 
	.sect	".text:gpioInit"
	.clink
	.global	||gpioInit||
;----------------------------------------------------------------------
;  27 | void gpioInit() {                                                      
;----------------------------------------------------------------------

;***************************************************************
;* FNAME: gpioInit                      FR SIZE:   0           *
;*                                                             *
;* FUNCTION ENVIRONMENT                                        *
;*                                                             *
;* FUNCTION PROPERTIES                                         *
;*                            0 Auto,  0 SOE     *
;***************************************************************

||gpioInit||:
;* --------------------------------------------------------------------------*
        MOV       r14.w1, r3.w2         ; [ALU_PRU] 
;----------------------------------------------------------------------
;  28 | clockWarmUp(GPIO_CLKCTRL_OFFSET);                                      
;----------------------------------------------------------------------
        LDI       r14.b0, 0xb0          ; [ALU_PRU] |28| 
        JAL       r3.w2, ||clockWarmUp|| ; [ALU_PRU] |28| clockWarmUp
;----------------------------------------------------------------------
;  29 | GPIO_CTRL = 0;                                                         
;----------------------------------------------------------------------
        LDI       r0, 0x0000            ; [ALU_PRU] |29| 
        LDI32     r1, 0x481ac130        ; [ALU_PRU] |29| 
        SBBO      &r0, r1, 0, 4         ; [ALU_PRU] |29| 
        JMP       r14.w1                ; [ALU_PRU] 
	.sect	".text:pruInit"
	.clink
	.global	||pruInit||
;----------------------------------------------------------------------
;  54 | void pruInit(struct pru_rpmsg_transport* transport) {                  
;  55 | volatile uint8_t *status;                                              
;----------------------------------------------------------------------

;***************************************************************
;* FNAME: pruInit                       FR SIZE:   6           *
;*                                                             *
;* FUNCTION ENVIRONMENT                                        *
;*                                                             *
;* FUNCTION PROPERTIES                                         *
;*                            0 Auto,  6 SOE     *
;***************************************************************

||pruInit||:
;* --------------------------------------------------------------------------*
        SUB       r2, r2, 0x06          ; [ALU_PRU] 
;----------------------------------------------------------------------
;  58 | CT_CFG.SYSCFG_bit.STANDBY_INIT = 0;                                    
;----------------------------------------------------------------------
        LBCO      &r0, __PRU_CREG_PRU_CFG, $CSBREL(||CT_CFG||+4), 4 ; [ALU_PRU] |58| CT_CFG
;----------------------------------------------------------------------
;  61 | CT_INTC.SICR_bit.STS_CLR_IDX = FROM_ARM_HOST;                          
;----------------------------------------------------------------------
        LDI32     r1, 0xfffffc00        ; [ALU_PRU] |61| 
        SBBO      &r3.b2, r2, 0, 6      ; [ALU_PRU] 
        MOV       r4, r14               ; [ALU_PRU] |54| transport
        CLR       r0, r0, 0x00000004    ; [ALU_PRU] |58| 
        SBCO      &r0, __PRU_CREG_PRU_CFG, $CSBREL(||CT_CFG||+4), 4 ; [ALU_PRU] |58| CT_CFG
;----------------------------------------------------------------------
;  64 | status = &resourceTable.rpmsg_vdev.status;                             
;----------------------------------------------------------------------
        LDI32     r0, ||CT_INTC||+36    ; [ALU_PRU] |61| $O$C2,CT_INTC
        LBBO      &r14, r0, 0, 4        ; [ALU_PRU] |61| $O$C2
        AND       r1, r14, r1           ; [ALU_PRU] |61| 
        OR        r1, r1, 0x11          ; [ALU_PRU] |61| 
        SBBO      &r1, r0, 0, 4         ; [ALU_PRU] |61| $O$C2
;----------------------------------------------------------------------
;  65 | while (!(*status & VIRTIO_CONFIG_S_DRIVER_OK));                        
;----------------------------------------------------------------------
        LDI       r0, ||resourceTable||+44 ; [ALU_PRU] |65| resourceTable
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L18||
;*
;*   Loop source line                : 65
;*   Loop closing brace source line  : 65
;*   Known Minimum Trip Count        : 1
;*   Known Maximum Trip Count        : 4294967295
;*   Known Max Trip Count Factor     : 1
;* --------------------------------------------------------------------------*
||$C$L18||:    
        LBBO      &r1.b0, r0, 0, 1      ; [ALU_PRU] |65| 
        QBBC      ||$C$L18||, r1.b0, 0x02 ; [ALU_PRU] |65| 
;* --------------------------------------------------------------------------*
;----------------------------------------------------------------------
;  68 | pru_rpmsg_init(transport, &resourceTable.rpmsg_vring0, &resourceTable.r
;     | pmsg_vring1, TO_ARM_HOST, FROM_ARM_HOST);                              
;----------------------------------------------------------------------
        LDI       r15, ||resourceTable||+48 ; [ALU_PRU] |68| resourceTable
        LDI       r16, ||resourceTable||+68 ; [ALU_PRU] |68| resourceTable
        MOV       r14, r4               ; [ALU_PRU] |68| transport
        LDI       r17, 0x0010           ; [ALU_PRU] |68| 
        LDI       r18, 0x0011           ; [ALU_PRU] |68| 
        JAL       r3.w2, ||pru_rpmsg_init|| ; [ALU_PRU] |68| pru_rpmsg_init
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L19||
;*
;*   Loop source line                : 71
;*   Loop closing brace source line  : 71
;*   Known Minimum Trip Count        : 1
;*   Known Maximum Trip Count        : 4294967295
;*   Known Max Trip Count Factor     : 1
;* --------------------------------------------------------------------------*
||$C$L19||:    
;----------------------------------------------------------------------
;  71 | while (pru_rpmsg_channel(RPMSG_NS_CREATE, transport, CHAN_NAME, CHAN_PO
;     | RT) != PRU_RPMSG_SUCCESS);                                             
;----------------------------------------------------------------------
        LDI       r14.b0, 0x00          ; [ALU_PRU] |71| 
        MOV       r15, r4               ; [ALU_PRU] |71| transport
        LDI32     r16, $C$SL1           ; [ALU_PRU] |71| 
        LDI       r17, 0x001e           ; [ALU_PRU] |71| 
        JAL       r3.w2, ||pru_rpmsg_channel|| ; [ALU_PRU] |71| pru_rpmsg_channel
        QBNE      ||$C$L19||, r14.w0, 0x00 ; [ALU_PRU] |71| 
;* --------------------------------------------------------------------------*
;----------------------------------------------------------------------
;  73 | uartInit();                                                            
;----------------------------------------------------------------------
        JAL       r3.w2, ||uartInit||   ; [ALU_PRU] |73| uartInit
;----------------------------------------------------------------------
;  74 | gpioInit();                                                            
;----------------------------------------------------------------------
        JAL       r3.w2, ||gpioInit||   ; [ALU_PRU] |74| gpioInit
;----------------------------------------------------------------------
;  75 | uartRead(receiveBuf, MAX_PAYLOAD_LEN); // Clear anything in RX FIFO    
;  76 | memset(receiveBuf, 0, MAX_PAYLOAD_LEN); // Clear the buffer            
;  79 | int16_t receiveRemainingMessage(uint8_t* buf) {                        
;  80 | uint16_t i = 0;                                                        
;  81 | while (i < MAX_PAYLOAD_LEN) {                                          
;  82 |     if (uartGetC(&buf[i])) {                                           
;  83 |         i++;                                                           
;  85 |     if (isBusIdle(CHECKS_TILL_MSG_FINISHED)) {                         
;  86 |         break; // Exit the loop if the bus is idle                     
;  89 | return i; // Return the number of bytes received                       
;  93 | #endif /* COMMON_H */                                                  
;  94 |                                                                        
;----------------------------------------------------------------------
        LDI       r18, ||receiveBuf||   ; [ALU_PRU] |75| $O$C1,receiveBuf
        LDI       r15.w0, 0x00ff        ; [ALU_PRU] |75| 
        MOV       r14, r18              ; [ALU_PRU] |75| $O$C1
        JAL       r3.w2, ||uartRead||   ; [ALU_PRU] |75| uartRead
        LDI       r1.b0, 0x00           ; [ALU_PRU] |414| 
        LDI       r0, 0x00ff            ; [ALU_PRU] |411| length
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L20||
;*
;*   Loop source line                : 414
;*   Loop closing brace source line  : 414
;*   Known Minimum Trip Count        : 1
;*   Known Maximum Trip Count        : 4294967295
;*   Known Max Trip Count Factor     : 1
;* --------------------------------------------------------------------------*
||$C$L20||:    
;----------------------------------------------------------------------
;  95 |                                                                        
;  96 |                                                                        
;  97 |                                                                        
;  98 |                                                                        
;  99 |                                                                        
; 100 |                                                                        
; 101 |                                                                        
; 102 |                                                                        
; 103 |                                                                        
; 104 |                                                                        
; 105 |                                                                        
; 106 |                                                                        
; 107 |                                                                        
; 108 |                                                                        
; 109 |                                                                        
; 110 |                                                                        
; 111 |                                                                        
; 112 |                                                                        
; 113 |                                                                        
; 114 |                                                                        
; 115 |                                                                        
; 116 |                                                                        
; 117 |                                                                        
; 118 |                                                                        
; 119 |                                                                        
; 120 |                                                                        
; 121 |                                                                        
; 122 |                                                                        
; 123 |                                                                        
; 124 |                                                                        
; 125 |                                                                        
; 126 |                                                                        
; 127 |                                                                        
; 128 |                                                                        
; 129 |                                                                        
; 130 |                                                                        
; 131 |                                                                        
; 132 |                                                                        
; 133 |                                                                        
; 134 |                                                                        
; 135 |                                                                        
; 136 |                                                                        
; 137 |                                                                        
; 138 |                                                                        
; 139 |                                                                        
; 140 |                                                                        
; 141 |                                                                        
; 142 |                                                                        
; 143 |                                                                        
; 144 |                                                                        
; 145 |                                                                        
; 146 |                                                                        
; 147 |                                                                        
; 148 |                                                                        
; 149 |                                                                        
; 150 |                                                                        
; 151 |                                                                        
; 152 |                                                                        
; 153 |                                                                        
; 154 |                                                                        
; 155 |                                                                        
; 156 |                                                                        
; 157 |                                                                        
; 158 |                                                                        
; 159 |                                                                        
; 160 |                                                                        
; 161 |                                                                        
; 162 |                                                                        
; 163 |                                                                        
; 164 |                                                                        
; 165 |                                                                        
; 166 |                                                                        
; 167 |                                                                        
; 168 |                                                                        
; 169 |                                                                        
; 170 |                                                                        
; 171 |                                                                        
; 172 |                                                                        
; 173 |                                                                        
; 174 |                                                                        
; 175 |                                                                        
; 176 |                                                                        
; 177 |                                                                        
; 178 |                                                                        
; 179 |                                                                        
; 180 |                                                                        
; 181 |                                                                        
; 182 |                                                                        
; 183 |                                                                        
; 184 |                                                                        
; 185 |                                                                        
; 186 |                                                                        
; 187 |                                                                        
; 188 |                                                                        
; 189 |                                                                        
; 190 |                                                                        
; 191 |                                                                        
; 192 |                                                                        
; 193 |                                                                        
; 194 |                                                                        
; 195 |                                                                        
; 196 |                                                                        
; 197 |                                                                        
; 198 |                                                                        
; 199 |                                                                        
; 200 |                                                                        
; 201 |                                                                        
; 202 |                                                                        
; 203 |                                                                        
; 204 |                                                                        
; 205 |                                                                        
; 206 |                                                                        
; 207 |                                                                        
; 208 |                                                                        
; 209 |                                                                        
; 210 |                                                                        
; 211 |                                                                        
; 212 |                                                                        
; 213 |                                                                        
; 214 |                                                                        
; 215 |                                                                        
; 216 |                                                                        
; 217 |                                                                        
; 218 |                                                                        
; 219 |                                                                        
; 220 |                                                                        
; 221 |                                                                        
; 222 |                                                                        
; 223 |                                                                        
; 224 |                                                                        
; 225 |                                                                        
; 226 |                                                                        
; 227 |                                                                        
; 228 |                                                                        
; 229 |                                                                        
; 230 |                                                                        
; 231 |                                                                        
; 232 |                                                                        
; 233 |                                                                        
; 234 |                                                                        
; 235 |                                                                        
; 236 |                                                                        
; 237 |                                                                        
; 238 |                                                                        
; 239 |                                                                        
; 240 |                                                                        
; 241 |                                                                        
; 242 |                                                                        
; 243 |                                                                        
; 244 |                                                                        
; 245 |                                                                        
; 246 |                                                                        
; 247 |                                                                        
; 248 |                                                                        
; 249 |                                                                        
; 250 |                                                                        
; 251 |                                                                        
; 252 |                                                                        
; 253 |                                                                        
; 254 |                                                                        
; 255 |                                                                        
; 256 |                                                                        
; 257 |                                                                        
; 258 |                                                                        
; 259 |                                                                        
; 260 |                                                                        
; 261 |                                                                        
; 262 |                                                                        
; 263 |                                                                        
; 264 |                                                                        
; 265 |                                                                        
; 266 |                                                                        
; 267 |                                                                        
; 268 |                                                                        
; 269 |                                                                        
; 270 |                                                                        
; 271 |                                                                        
; 272 |                                                                        
; 273 |                                                                        
; 274 |                                                                        
; 275 |                                                                        
; 276 |                                                                        
; 277 |                                                                        
; 278 |                                                                        
; 279 |                                                                        
; 280 |                                                                        
; 281 |                                                                        
; 282 |                                                                        
; 283 |                                                                        
; 284 |                                                                        
; 285 |                                                                        
; 286 |                                                                        
; 287 |                                                                        
; 288 |                                                                        
; 289 |                                                                        
; 290 |                                                                        
; 291 |                                                                        
; 292 |                                                                        
; 293 |                                                                        
; 294 |                                                                        
; 295 |                                                                        
; 296 |                                                                        
; 297 |                                                                        
; 298 |                                                                        
; 299 |                                                                        
; 300 |                                                                        
; 301 |                                                                        
; 302 |                                                                        
; 303 |                                                                        
; 304 |                                                                        
; 305 |                                                                        
; 306 |                                                                        
; 307 |                                                                        
; 308 |                                                                        
; 309 |                                                                        
; 310 |                                                                        
; 311 |                                                                        
; 312 |                                                                        
; 313 |                                                                        
; 314 |                                                                        
; 315 |                                                                        
; 316 |                                                                        
; 317 |                                                                        
; 318 |                                                                        
; 319 |                                                                        
; 320 |                                                                        
; 321 |                                                                        
; 322 |                                                                        
; 323 |                                                                        
; 324 |                                                                        
; 325 |                                                                        
; 326 |                                                                        
; 327 |                                                                        
; 328 |                                                                        
; 329 |                                                                        
; 330 |                                                                        
; 331 |                                                                        
; 332 |                                                                        
; 333 |                                                                        
; 334 |                                                                        
; 335 |                                                                        
; 336 |                                                                        
; 337 |                                                                        
; 338 |                                                                        
; 339 |                                                                        
; 340 |                                                                        
; 341 |                                                                        
; 342 |                                                                        
; 343 |                                                                        
; 344 |                                                                        
; 345 |                                                                        
; 346 |                                                                        
; 347 |                                                                        
; 348 |                                                                        
; 349 |                                                                        
; 350 |                                                                        
; 351 |                                                                        
; 352 |                                                                        
; 353 |                                                                        
; 354 |                                                                        
; 355 |                                                                        
; 356 |                                                                        
; 357 |                                                                        
; 358 |                                                                        
; 359 |                                                                        
; 360 |                                                                        
; 361 |                                                                        
; 362 |                                                                        
; 363 |                                                                        
; 364 |                                                                        
; 365 |                                                                        
; 366 |                                                                        
; 367 |                                                                        
; 368 |                                                                        
; 369 |                                                                        
; 370 |                                                                        
; 371 |                                                                        
; 372 |                                                                        
; 373 |                                                                        
; 374 |                                                                        
; 375 |                                                                        
; 376 |                                                                        
; 377 |                                                                        
; 378 |                                                                        
; 379 |                                                                        
; 380 |                                                                        
; 381 |                                                                        
; 382 |                                                                        
; 383 |                                                                        
; 384 |                                                                        
; 385 |                                                                        
; 386 |                                                                        
; 387 |                                                                        
; 388 |                                                                        
; 389 |                                                                        
; 390 |                                                                        
; 391 |                                                                        
; 392 |                                                                        
; 393 |                                                                        
; 394 |                                                                        
; 395 |                                                                        
; 396 |                                                                        
; 397 |                                                                        
; 398 |                                                                        
; 399 |                                                                        
; 400 |                                                                        
; 401 |                                                                        
; 402 |                                                                        
; 403 |                                                                        
; 404 |                                                                        
; 405 |                                                                        
; 406 |                                                                        
; 407 |                                                                        
; 408 |                                                                        
; 409 |                                                                        
; 410 |                                                                        
; 411 |                                                                        
; 412 |                                                                        
; 413 |                                                                        
; 414 |                                                                        
;----------------------------------------------------------------------
        SBBO      &r1.b0, r18, 0, 1     ; [ALU_PRU] |414| m
        ADD       r18, r18, 0x01        ; [ALU_PRU] |414| m,m
        SUB       r0, r0, 0x01          ; [ALU_PRU] |414| length,length
        QBNE      ||$C$L20||, r0, 0x00  ; [ALU_PRU] |414| length
;* --------------------------------------------------------------------------*
        LBBO      &r3.b2, r2, 0, 6      ; [ALU_PRU] 
        ADD       r2, r2, 0x06          ; [ALU_PRU] 
        JMP       r3.w2                 ; [ALU_PRU] 
	.sect	".text:main"
	.clink
	.global	||main||
;----------------------------------------------------------------------
;  72 | void main() {                                                          
;  73 | struct pru_rpmsg_transport transport;                                  
;----------------------------------------------------------------------

;***************************************************************
;* FNAME: main                          FR SIZE:  73           *
;*                                                             *
;* FUNCTION ENVIRONMENT                                        *
;*                                                             *
;* FUNCTION PROPERTIES                                         *
;*                           66 Auto,  7 SOE     *
;***************************************************************

||main||:
;* --------------------------------------------------------------------------*
        SUB       r2, r2, 0x49          ; [ALU_PRU] 
;----------------------------------------------------------------------
;  74 | uint16_t src = 0;                                                      
;  75 | uint16_t dst = 0;                                                      
;  76 | uint16_t len = 0;                                                      
;----------------------------------------------------------------------
        LDI       r0.w0, 0x00           ; [ALU_PRU] |74| 
        SBBO      &r3.b2, r2, 66, 7     ; [ALU_PRU] 
;----------------------------------------------------------------------
;  78 | pruInit(&transport);                                                   
;----------------------------------------------------------------------
        ADD       r14, r2, 0            ; [ALU_PRU] |78| transport,transport
        SBBO      &r0.w0, r2, 60, 2     ; [ALU_PRU] |74| src
        SBBO      &r0.w0, r2, 62, 2     ; [ALU_PRU] |75| dst
        SBBO      &r0.w0, r2, 64, 2     ; [ALU_PRU] |76| len
;----------------------------------------------------------------------
;  79 | // Need to initialize src and dst                                      
;----------------------------------------------------------------------
        JAL       r3.w2, ||pruInit||    ; [ALU_PRU] |78| pruInit
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L21||
;*
;*   Loop source line                : 80
;*   Loop closing brace source line  : 80
;*   Known Minimum Trip Count        : 1
;*   Known Maximum Trip Count        : 4294967295
;*   Known Max Trip Count Factor     : 1
;* --------------------------------------------------------------------------*
||$C$L21||:    
;----------------------------------------------------------------------
;  80 | while(pru_rpmsg_receive(&transport, &src, &dst, transmitBuf, &len) != P
;     | RU_RPMSG_SUCCESS);                                                     
;  81 | memset(transmitBuf, 0, RPMSG_MESSAGE_SIZE);                            
;  83 | while (1) {                                                            
;  84 |     // Is there a message to transmit?                                 
;  85 |     if (transmitBuf[0] != 0 || pru_rpmsg_receive(&transport, &src, &dst
;     | , transmitBuf, &len) == PRU_RPMSG_SUCCESS) {                           
;  87 |         if (isBusIdle(CHECKS_TILL_BUS_IDLE)) {                         
;  88 |             // Send MID. Using uartWrite over uartPutC so that it waits
;     |  to                                                                    
;  89 |             // return until byte is transmitted.                       
;  90 |             uartWrite(transmitBuf, 1); // write the MID                
;  91 |             __delay_cycles(550000); // wait period for echo back (trust
;     |  me when I say this exact value is important for reading the echo back 
;     | and giving enough time for sending the rest of the message)            
;  92 |             if (uartGetC(&receiveBuf[0])) { // check if there is a mess
;     | age to receive                                                         
;  93 |                 // Arbitration: Send MID. If we recv anything and our M
;     | ID is                                                                  
;  94 |                 // greater then we lose arbitration. Otherwise continue
;  95 |                 // writing the message.                                
;  96 |                 if (transmitBuf[0] <= receiveBuf[0]) { // either no one
;     |  else is transmitting or we won arbitration                            
;  97 |                     uartWrite(transmitBuf + 1, len - 1); // write the r
;     | emaining message                                                       
;  98 |                     memset(transmitBuf, 0, RPMSG_MESSAGE_SIZE);        
;  99 |                 } else { // darn we lost arbitration                   
; 100 |                     uint16_t recvLen = receiveRemainingMessage(&receive
;     | Buf[1]);                                                               
; 101 |                     pru_rpmsg_send(&transport, dst, src, receiveBuf, re
;     | cvLen+1);                                                              
; 103 |             } else { // SSCP485 did not echo back                      
; 104 |                 // enter a safe error loop until the host resets the PR
;     | U                                                                      
; 105 |                 memset(receiveBuf, 0, MAX_PAYLOAD_LEN);                
; 106 |                 memset(transmitBuf, 0, RPMSG_MESSAGE_SIZE);            
; 107 |                 while (1) { __delay_cycles(1000000); }                 
; 110 |     } else if (uartGetC(receiveBuf)) { // Is there anything to receive?
; 111 |         uint16_t recvLen = receiveRemainingMessage(&receiveBuf[1]);    
; 112 |         pru_rpmsg_send(&transport, dst, src, receiveBuf, recvLen+1);   
; 113 |         memset(receiveBuf, 0, MAX_PAYLOAD_LEN);                        
; 117 |                                                                        
;----------------------------------------------------------------------
        ADD       r14, r2, 0            ; [ALU_PRU] |80| transport,transport
        ADD       r15, r2, 60           ; [ALU_PRU] |80| src,src
        ADD       r16, r2, 62           ; [ALU_PRU] |80| dst,dst
        LDI       r17, ||transmitBuf||  ; [ALU_PRU] |80| transmitBuf
        ADD       r18, r2, 64           ; [ALU_PRU] |80| len,len
        JAL       r3.w2, ||pru_rpmsg_receive|| ; [ALU_PRU] |80| pru_rpmsg_receive
        QBNE      ||$C$L21||, r14.w0, 0x00 ; [ALU_PRU] |80| 
;* --------------------------------------------------------------------------*
        LDI       r1, 0x01f0            ; [ALU_PRU] |411| length
        LDI       r0, ||transmitBuf||   ; [ALU_PRU] |412| m,transmitBuf
;----------------------------------------------------------------------
; 118 |                                                                        
; 119 |                                                                        
; 120 |                                                                        
; 121 |                                                                        
; 122 |                                                                        
; 123 |                                                                        
; 124 |                                                                        
; 125 |                                                                        
; 126 |                                                                        
; 127 |                                                                        
; 128 |                                                                        
; 129 |                                                                        
; 130 |                                                                        
; 131 |                                                                        
; 132 |                                                                        
; 133 |                                                                        
; 134 |                                                                        
; 135 |                                                                        
; 136 |                                                                        
; 137 |                                                                        
; 138 |                                                                        
; 139 |                                                                        
; 140 |                                                                        
; 141 |                                                                        
; 142 |                                                                        
; 143 |                                                                        
; 144 |                                                                        
; 145 |                                                                        
; 146 |                                                                        
; 147 |                                                                        
; 148 |                                                                        
; 149 |                                                                        
; 150 |                                                                        
; 151 |                                                                        
; 152 |                                                                        
; 153 |                                                                        
; 154 |                                                                        
; 155 |                                                                        
; 156 |                                                                        
; 157 |                                                                        
; 158 |                                                                        
; 159 |                                                                        
; 160 |                                                                        
; 161 |                                                                        
; 162 |                                                                        
; 163 |                                                                        
; 164 |                                                                        
; 165 |                                                                        
; 166 |                                                                        
; 167 |                                                                        
; 168 |                                                                        
; 169 |                                                                        
; 170 |                                                                        
; 171 |                                                                        
; 172 |                                                                        
; 173 |                                                                        
; 174 |                                                                        
; 175 |                                                                        
; 176 |                                                                        
; 177 |                                                                        
; 178 |                                                                        
; 179 |                                                                        
; 180 |                                                                        
; 181 |                                                                        
; 182 |                                                                        
; 183 |                                                                        
; 184 |                                                                        
; 185 |                                                                        
; 186 |                                                                        
; 187 |                                                                        
; 188 |                                                                        
; 189 |                                                                        
; 190 |                                                                        
; 191 |                                                                        
; 192 |                                                                        
; 193 |                                                                        
; 194 |                                                                        
; 195 |                                                                        
; 196 |                                                                        
; 197 |                                                                        
; 198 |                                                                        
; 199 |                                                                        
; 200 |                                                                        
; 201 |                                                                        
; 202 |                                                                        
; 203 |                                                                        
; 204 |                                                                        
; 205 |                                                                        
; 206 |                                                                        
; 207 |                                                                        
; 208 |                                                                        
; 209 |                                                                        
; 210 |                                                                        
; 211 |                                                                        
; 212 |                                                                        
; 213 |                                                                        
; 214 |                                                                        
; 215 |                                                                        
; 216 |                                                                        
; 217 |                                                                        
; 218 |                                                                        
; 219 |                                                                        
; 220 |                                                                        
; 221 |                                                                        
; 222 |                                                                        
; 223 |                                                                        
; 224 |                                                                        
; 225 |                                                                        
; 226 |                                                                        
; 227 |                                                                        
; 228 |                                                                        
; 229 |                                                                        
; 230 |                                                                        
; 231 |                                                                        
; 232 |                                                                        
; 233 |                                                                        
; 234 |                                                                        
; 235 |                                                                        
; 236 |                                                                        
; 237 |                                                                        
; 238 |                                                                        
; 239 |                                                                        
; 240 |                                                                        
; 241 |                                                                        
; 242 |                                                                        
; 243 |                                                                        
; 244 |                                                                        
; 245 |                                                                        
; 246 |                                                                        
; 247 |                                                                        
; 248 |                                                                        
; 249 |                                                                        
; 250 |                                                                        
; 251 |                                                                        
; 252 |                                                                        
; 253 |                                                                        
; 254 |                                                                        
; 255 |                                                                        
; 256 |                                                                        
; 257 |                                                                        
; 258 |                                                                        
; 259 |                                                                        
; 260 |                                                                        
; 261 |                                                                        
; 262 |                                                                        
; 263 |                                                                        
; 264 |                                                                        
; 265 |                                                                        
; 266 |                                                                        
; 267 |                                                                        
; 268 |                                                                        
; 269 |                                                                        
; 270 |                                                                        
; 271 |                                                                        
; 272 |                                                                        
; 273 |                                                                        
; 274 |                                                                        
; 275 |                                                                        
; 276 |                                                                        
; 277 |                                                                        
; 278 |                                                                        
; 279 |                                                                        
; 280 |                                                                        
; 281 |                                                                        
; 282 |                                                                        
; 283 |                                                                        
; 284 |                                                                        
; 285 |                                                                        
; 286 |                                                                        
; 287 |                                                                        
; 288 |                                                                        
; 289 |                                                                        
; 290 |                                                                        
; 291 |                                                                        
; 292 |                                                                        
; 293 |                                                                        
; 294 |                                                                        
; 295 |                                                                        
; 296 |                                                                        
; 297 |                                                                        
; 298 |                                                                        
; 299 |                                                                        
; 300 |                                                                        
; 301 |                                                                        
; 302 |                                                                        
; 303 |                                                                        
; 304 |                                                                        
; 305 |                                                                        
; 306 |                                                                        
; 307 |                                                                        
; 308 |                                                                        
; 309 |                                                                        
; 310 |                                                                        
; 311 |                                                                        
; 312 |                                                                        
; 313 |                                                                        
; 314 |                                                                        
; 315 |                                                                        
; 316 |                                                                        
; 317 |                                                                        
; 318 |                                                                        
; 319 |                                                                        
; 320 |                                                                        
; 321 |                                                                        
; 322 |                                                                        
; 323 |                                                                        
; 324 |                                                                        
; 325 |                                                                        
; 326 |                                                                        
; 327 |                                                                        
; 328 |                                                                        
; 329 |                                                                        
; 330 |                                                                        
; 331 |                                                                        
; 332 |                                                                        
; 333 |                                                                        
; 334 |                                                                        
; 335 |                                                                        
; 336 |                                                                        
; 337 |                                                                        
; 338 |                                                                        
; 339 |                                                                        
; 340 |                                                                        
; 341 |                                                                        
; 342 |                                                                        
; 343 |                                                                        
; 344 |                                                                        
; 345 |                                                                        
; 346 |                                                                        
; 347 |                                                                        
; 348 |                                                                        
; 349 |                                                                        
; 350 |                                                                        
; 351 |                                                                        
; 352 |                                                                        
; 353 |                                                                        
; 354 |                                                                        
; 355 |                                                                        
; 356 |                                                                        
; 357 |                                                                        
; 358 |                                                                        
; 359 |                                                                        
; 360 |                                                                        
; 361 |                                                                        
; 362 |                                                                        
; 363 |                                                                        
; 364 |                                                                        
; 365 |                                                                        
; 366 |                                                                        
; 367 |                                                                        
; 368 |                                                                        
; 369 |                                                                        
; 370 |                                                                        
; 371 |                                                                        
; 372 |                                                                        
; 373 |                                                                        
; 374 |                                                                        
; 375 |                                                                        
; 376 |                                                                        
; 377 |                                                                        
; 378 |                                                                        
; 379 |                                                                        
; 380 |                                                                        
; 381 |                                                                        
; 382 |                                                                        
; 383 |                                                                        
; 384 |                                                                        
; 385 |                                                                        
; 386 |                                                                        
; 387 |                                                                        
; 388 |                                                                        
; 389 |                                                                        
; 390 |                                                                        
; 391 |                                                                        
; 392 |                                                                        
; 393 |                                                                        
; 394 |                                                                        
; 395 |                                                                        
; 396 |                                                                        
; 397 |                                                                        
; 398 |                                                                        
; 399 |                                                                        
; 400 |                                                                        
; 401 |                                                                        
; 402 |                                                                        
; 403 |                                                                        
; 404 |                                                                        
; 405 |                                                                        
; 406 |                                                                        
; 407 |                                                                        
; 408 |                                                                        
; 409 |                                                                        
; 410 |                                                                        
; 411 |                                                                        
; 412 |                                                                        
; 413 |                                                                        
; 414 |                                                                        
;----------------------------------------------------------------------
        LDI       r5.b0, 0x00           ; [ALU_PRU] |414| 
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L22||
;*
;*   Loop source line                : 414
;*   Loop closing brace source line  : 414
;*   Known Minimum Trip Count        : 1
;*   Known Maximum Trip Count        : 4294967295
;*   Known Max Trip Count Factor     : 1
;* --------------------------------------------------------------------------*
||$C$L22||:    
        SBBO      &r5.b0, r0, 0, 1      ; [ALU_PRU] |414| m
        ADD       r0, r0, 0x01          ; [ALU_PRU] |414| m,m
        SUB       r1, r1, 0x01          ; [ALU_PRU] |414| length,length
        QBNE      ||$C$L22||, r1, 0x00  ; [ALU_PRU] |414| length
;* --------------------------------------------------------------------------*
        JMP       ||$C$L24||            ; [ALU_PRU] 
;* --------------------------------------------------------------------------*
||$C$L23||:    
        ADD       r14, r19, 0x01        ; [ALU_PRU] |100| $O$C3
        JAL       r3.w2, ||receiveRemainingMessage|| ; [ALU_PRU] |100| receiveRemainingMessage
        ADD       r18.w0, r14.w0, 0x01  ; [ALU_PRU] |101| recvLen
        LBBO      &r0.w0, r2, 62, 2     ; [ALU_PRU] |101| dst
        MOV       r17, r19              ; [ALU_PRU] |101| $O$C3
        ADD       r14, r2, 0            ; [ALU_PRU] |101| transport,transport
        MOV       r15, r0.w0            ; [ALU_PRU] |101| 
        LBBO      &r0.w0, r2, 60, 2     ; [ALU_PRU] |101| src
        MOV       r16, r0.w0            ; [ALU_PRU] |101| 
        JAL       r3.w2, ||pru_rpmsg_send|| ; [ALU_PRU] |101| pru_rpmsg_send
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L24||
;* --------------------------------------------------------------------------*
||$C$L24||:    
        LDI       r4, ||transmitBuf||   ; [ALU_PRU] |85| $O$C6,transmitBuf
        LBBO      &r0.b0, r4, 0, 1      ; [ALU_PRU] |85| $O$C6
        QBNE      ||$C$L26||, r0.b0, 0x00 ; [ALU_PRU] |85| 
;* --------------------------------------------------------------------------*
        ADD       r14, r2, 0            ; [ALU_PRU] |85| transport,transport
        ADD       r15, r2, 60           ; [ALU_PRU] |85| src,src
        ADD       r16, r2, 62           ; [ALU_PRU] |85| dst,dst
        MOV       r17, r4               ; [ALU_PRU] |85| $O$C6
        ADD       r18, r2, 64           ; [ALU_PRU] |85| len,len
        JAL       r3.w2, ||pru_rpmsg_receive|| ; [ALU_PRU] |85| pru_rpmsg_receive
        QBEQ      ||$C$L26||, r14.w0, 0x00 ; [ALU_PRU] |85| 
;* --------------------------------------------------------------------------*
        LDI       r14, ||receiveBuf||   ; [ALU_PRU] |110| receiveBuf
        JAL       r3.w2, ||uartGetC||   ; [ALU_PRU] |110| uartGetC
        QBEQ      ||$C$L24||, r14.b0, 0x00 ; [ALU_PRU] |110| 
;* --------------------------------------------------------------------------*
        LDI       r4, ||receiveBuf||    ; [ALU_PRU] |111| $O$C5,receiveBuf
        ADD       r14, r4, 0x01         ; [ALU_PRU] |111| $O$C5
        JAL       r3.w2, ||receiveRemainingMessage|| ; [ALU_PRU] |111| receiveRemainingMessage
        ADD       r18.w0, r14.w0, 0x01  ; [ALU_PRU] |112| recvLen
        LBBO      &r0.w0, r2, 62, 2     ; [ALU_PRU] |112| dst
        ADD       r14, r2, 0            ; [ALU_PRU] |112| transport,transport
        MOV       r15, r0.w0            ; [ALU_PRU] |112| 
        MOV       r17, r4               ; [ALU_PRU] |112| $O$C5
        LBBO      &r0.w0, r2, 60, 2     ; [ALU_PRU] |112| src
        MOV       r16, r0.w0            ; [ALU_PRU] |112| 
        JAL       r3.w2, ||pru_rpmsg_send|| ; [ALU_PRU] |112| pru_rpmsg_send
        LDI       r0, 0x00ff            ; [ALU_PRU] |411| length
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L25||
;*
;*   Loop source line                : 414
;*   Loop closing brace source line  : 414
;*   Known Minimum Trip Count        : 1
;*   Known Maximum Trip Count        : 4294967295
;*   Known Max Trip Count Factor     : 1
;* --------------------------------------------------------------------------*
||$C$L25||:    
        SBBO      &r5.b0, r4, 0, 1      ; [ALU_PRU] |414| m
        ADD       r4, r4, 0x01          ; [ALU_PRU] |414| m,m
        SUB       r0, r0, 0x01          ; [ALU_PRU] |414| length,length
        QBEQ      ||$C$L24||, r0, 0x00  ; [ALU_PRU] |414| length
;* --------------------------------------------------------------------------*
        JMP       ||$C$L25||            ; [ALU_PRU] |414| 
;* --------------------------------------------------------------------------*
||$C$L26||:    
        ZERO      &r15, 4               ; [ALU_PRU] |36| i
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L27||
;*
;*   Loop source line                : 36
;*   Loop closing brace source line  : 50
;*   Known Minimum Trip Count        : 1
;*   Known Maximum Trip Count        : 4294967295
;*   Known Max Trip Count Factor     : 1
;* --------------------------------------------------------------------------*
||$C$L27||:    
        LDI       r14.b0, 0x58          ; [ALU_PRU] |44| 
        JAL       r3.w2, ||readGpioPin|| ; [ALU_PRU] |44| readGpioPin
        QBEQ      ||$C$L24||, r14, 0x00 ; [ALU_PRU] |44| 
;* --------------------------------------------------------------------------*
        .newblock
        LDI32    r0, 5199
$1:     SUB      r0, r0, 1
        QBNE     $1, r0, 0             ; [ALU_PRU] |48| 
        ADD       r15, r15, 0x01        ; [ALU_PRU] |36| i,i
        LDI32     r1, 0x80000014        ; [ALU_PRU] |36| 
        MOV       r0, r15               ; [ALU_PRU] |36| i
        XOR       r0.b3, r0.b3, 0x80    ; [ALU_PRU] |36| 
        QBLT      ||$C$L27||, r1, r0    ; [ALU_PRU] |36| 
;* --------------------------------------------------------------------------*
        MOV       r17, r4               ; [ALU_PRU] |90| $O$C4
        LDI       r15.w0, 0x0001        ; [ALU_PRU] |90| 
        MOV       r14, r17              ; [ALU_PRU] |90| 
        JAL       r3.w2, ||uartWrite||  ; [ALU_PRU] |90| uartWrite
        .newblock
        LDI32    r18, 274999
$1:     SUB      r18, r18, 1
        QBNE     $1, r18, 0            ; [ALU_PRU] |91| 
        LDI       r19, ||receiveBuf||   ; [ALU_PRU] |92| $O$C3,receiveBuf
        MOV       r14, r19              ; [ALU_PRU] |92| 
        JAL       r3.w2, ||uartGetC||   ; [ALU_PRU] |92| uartGetC
        QBEQ      ||$C$L29||, r14.b0, 0x00 ; [ALU_PRU] |92| 
;* --------------------------------------------------------------------------*
        LDI32     r0, 0x80000000        ; [ALU_PRU] |96| 
        LBBO      &r1.b0, r19, 0, 1     ; [ALU_PRU] |96| $O$C3
        LBBO      &r14.b0, r4, 0, 1     ; [ALU_PRU] |96| $O$C4
        XOR       r1, r1.b0, r0         ; [ALU_PRU] |96| 
        XOR       r0, r14.b0, r0        ; [ALU_PRU] |96| 
        QBGT      ||$C$L23||, r1, r0    ; [ALU_PRU] |96| 
;* --------------------------------------------------------------------------*
        LBBO      &r0.w0, r2, 64, 2     ; [ALU_PRU] |97| len
        ADD       r14, r17, 0x01        ; [ALU_PRU] |97| $O$C2
        SUB       r15.w0, r0.w0, 0x01   ; [ALU_PRU] |97| 
        JAL       r3.w2, ||uartWrite||  ; [ALU_PRU] |97| uartWrite
        LDI       r0, 0x01f0            ; [ALU_PRU] |411| length
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L28||
;*
;*   Loop source line                : 414
;*   Loop closing brace source line  : 414
;*   Known Minimum Trip Count        : 1
;*   Known Maximum Trip Count        : 4294967295
;*   Known Max Trip Count Factor     : 1
;* --------------------------------------------------------------------------*
||$C$L28||:    
        SBBO      &r5.b0, r17, 0, 1     ; [ALU_PRU] |414| m
        ADD       r17, r17, 0x01        ; [ALU_PRU] |414| m,m
        SUB       r0, r0, 0x01          ; [ALU_PRU] |414| length,length
        QBEQ      ||$C$L24||, r0, 0x00  ; [ALU_PRU] |414| length
;* --------------------------------------------------------------------------*
        JMP       ||$C$L28||            ; [ALU_PRU] |414| 
;* --------------------------------------------------------------------------*
||$C$L29||:    
        LDI       r0, 0x00ff            ; [ALU_PRU] |411| length
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L30||
;*
;*   Loop source line                : 414
;*   Loop closing brace source line  : 414
;*   Known Minimum Trip Count        : 1
;*   Known Maximum Trip Count        : 4294967295
;*   Known Max Trip Count Factor     : 1
;* --------------------------------------------------------------------------*
||$C$L30||:    
        SBBO      &r5.b0, r19, 0, 1     ; [ALU_PRU] |414| m
        ADD       r19, r19, 0x01        ; [ALU_PRU] |414| m,m
        SUB       r0, r0, 0x01          ; [ALU_PRU] |414| length,length
        QBNE      ||$C$L30||, r0, 0x00  ; [ALU_PRU] |414| length
;* --------------------------------------------------------------------------*
        LDI       r0, 0x01f0            ; [ALU_PRU] |411| length
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L31||
;*
;*   Loop source line                : 414
;*   Loop closing brace source line  : 414
;*   Known Minimum Trip Count        : 1
;*   Known Maximum Trip Count        : 4294967295
;*   Known Max Trip Count Factor     : 1
;* --------------------------------------------------------------------------*
||$C$L31||:    
        SBBO      &r5.b0, r17, 0, 1     ; [ALU_PRU] |414| m
        ADD       r17, r17, 0x01        ; [ALU_PRU] |414| m,m
        SUB       r0, r0, 0x01          ; [ALU_PRU] |414| length,length
        QBNE      ||$C$L31||, r0, 0x00  ; [ALU_PRU] |414| length
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP ||$C$L32||
;*
;*   Loop source line                : 107
;*   Loop closing brace source line  : 107
;*   Known Minimum Trip Count        : 1
;*   Known Maximum Trip Count        : 4294967295
;*   Known Max Trip Count Factor     : 1
;* --------------------------------------------------------------------------*
||$C$L32||:    
        .newblock
        LDI32    r0, 499999
$1:     SUB      r0, r0, 1
        QBNE     $1, r0, 0             ; [ALU_PRU] |107| 
        JMP       ||$C$L32||            ; [ALU_PRU] |107| 
;* --------------------------------------------------------------------------*
;******************************************************************************
;* STRINGS                                                                    *
;******************************************************************************
	.sect	".rodata:.string"
||$C$SL1||:	.string	"rpmsg-pru",0
;*****************************************************************************
;* UNDEFINED EXTERNAL REFERENCES                                             *
;*****************************************************************************
	.global	||pru_rpmsg_init||
	.global	||pru_rpmsg_channel||
	.global	||pru_rpmsg_receive||
	.global	||pru_rpmsg_send||
