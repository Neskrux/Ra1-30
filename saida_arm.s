/* RA1-30 / PUCPR — saida_arm.s */
.syntax unified
.cpu cortex-a9
.fpu vfpv3-d16
.arm

.equ HEX3_HEX0, 0xFF200020
.equ HEX5_HEX4, 0xFF200030
.equ LEDR_BASE, 0xFF200000

.section .text
.global _start

_start:
	ldr sp, =stack_top
	mrc p15, 0, r0, c1, c0, 2
	orr r0, r0, #0xF00000
	mcr p15, 0, r0, c1, c0, 2
	isb
	mov r0, #0x40000000
	vmsr fpexc, r0
	bl main_program
halt_loop:
	b halt_loop

main_program:
	push {r4-r11, lr}
	bl linha_0
	ldr r4, =hist
	add r4, r4, #0
	vstr d0, [r4]
	bl mostrar_d0_7seg
	bl linha_1
	ldr r4, =hist
	add r4, r4, #8
	vstr d0, [r4]
	bl mostrar_d0_7seg
	bl linha_2
	ldr r4, =hist
	add r4, r4, #16
	vstr d0, [r4]
	bl mostrar_d0_7seg
	bl linha_3
	ldr r4, =hist
	add r4, r4, #24
	vstr d0, [r4]
	bl mostrar_d0_7seg
	bl linha_4
	ldr r4, =hist
	add r4, r4, #32
	vstr d0, [r4]
	bl mostrar_d0_7seg
	bl linha_5
	ldr r4, =hist
	add r4, r4, #40
	vstr d0, [r4]
	bl mostrar_d0_7seg
	bl linha_6
	ldr r4, =hist
	add r4, r4, #48
	vstr d0, [r4]
	bl mostrar_d0_7seg
	bl linha_7
	ldr r4, =hist
	add r4, r4, #56
	vstr d0, [r4]
	bl mostrar_d0_7seg
	bl linha_8
	ldr r4, =hist
	add r4, r4, #64
	vstr d0, [r4]
	bl mostrar_d0_7seg
	bl linha_9
	ldr r4, =hist
	add r4, r4, #72
	vstr d0, [r4]
	bl mostrar_d0_7seg
	bl linha_10
	ldr r4, =hist
	add r4, r4, #80
	vstr d0, [r4]
	bl mostrar_d0_7seg
	bl linha_11
	ldr r4, =hist
	add r4, r4, #88
	vstr d0, [r4]
	bl mostrar_d0_7seg
	pop {r4-r11, pc}

linha_0:
	push {r4-r11, lr}
	ldr r0, =lit_2_0
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_3_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vadd.f64 d0, d1, d2
	vpush {d0}
	ldr r0, =lit_4_0
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_1_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vsub.f64 d0, d1, d2
	vmov.f64 d2, d0
	vpop {d1}
	vmul.f64 d0, d1, d2
	pop {r4-r11, pc}

linha_1:
	push {r4-r11, lr}
	ldr r0, =lit_10_0
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_3_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vcvt.s32.f64 s0, d1
	vcvt.s32.f64 s2, d2
	vmov r0, s0
	vmov r1, s2
	cmp r1, #0
	beq divzero_die
	bl idiv_trunc
	vmov s4, r2
	vcvt.f64.s32 d0, s4
	vpush {d0}
	ldr r0, =lit_7_0
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_5_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vcvt.s32.f64 s0, d1
	vcvt.s32.f64 s2, d2
	vmov r0, s0
	vmov r1, s2
	cmp r1, #0
	beq divzero_die
	bl idiv_trunc
	mul r3, r1, r2
	sub r3, r0, r3
	vmov s4, r3
	vcvt.f64.s32 d0, s4
	vmov.f64 d2, d0
	vpop {d1}
	vadd.f64 d0, d1, d2
	pop {r4-r11, pc}

linha_2:
	push {r4-r11, lr}
	ldr r0, =lit_2_0
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_8_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vcvt.s32.f64 s4, d2
	vmov r2, s4
	cmp r2, #0
	blt pow_neg_err
	beq pow_z_1
	cmp r2, #1
	beq pow_one_2
	vmov.f64 d0, d1
	mov r4, r2
	sub r4, r4, #1
pow_lp_4:
	vmul.f64 d0, d0, d1
	subs r4, r4, #1
	bne pow_lp_4
	b pow_fin_3
pow_one_2:
	vmov.f64 d0, d1
	b pow_fin_3
pow_z_1:
	ldr r0, =lit_one
	vldr d0, [r0]
pow_fin_3:
	vpush {d0}
	ldr r0, =lit_1_0
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_2_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vadd.f64 d0, d1, d2
	vmov.f64 d2, d0
	vpop {d1}
	vdiv.f64 d0, d1, d2
	pop {r4-r11, pc}

linha_3:
	push {r4-r11, lr}
	ldr r0, =lit_5_5
	vldr d0, [r0]
	ldr r0, =mem_CONTADOR
	vstr d0, [r0]
	vpush {d0}
	ldr r0, =mem_CONTADOR
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vadd.f64 d0, d1, d2
	pop {r4-r11, pc}

linha_4:
	push {r4-r11, lr}
	ldr r0, =hist
	add r0, r0, #24
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_2_0
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_3_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vmul.f64 d0, d1, d2
	vmov.f64 d2, d0
	vpop {d1}
	vadd.f64 d0, d1, d2
	pop {r4-r11, pc}

linha_5:
	push {r4-r11, lr}
	ldr r0, =lit_1_0
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_1_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vadd.f64 d0, d1, d2
	vpush {d0}
	ldr r0, =lit_2_0
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_2_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vadd.f64 d0, d1, d2
	vmov.f64 d2, d0
	vpop {d1}
	vmul.f64 d0, d1, d2
	vpush {d0}
	ldr r0, =lit_3_0
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_3_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vmul.f64 d0, d1, d2
	vmov.f64 d2, d0
	vpop {d1}
	vcvt.s32.f64 s0, d1
	vcvt.s32.f64 s2, d2
	vmov r0, s0
	vmov r1, s2
	cmp r1, #0
	beq divzero_die
	bl idiv_trunc
	vmov s4, r2
	vcvt.f64.s32 d0, s4
	pop {r4-r11, pc}

linha_6:
	push {r4-r11, lr}
	ldr r0, =lit_9_0
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_4_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vcvt.s32.f64 s0, d1
	vcvt.s32.f64 s2, d2
	vmov r0, s0
	vmov r1, s2
	cmp r1, #0
	beq divzero_die
	bl idiv_trunc
	mul r3, r1, r2
	sub r3, r0, r3
	vmov s4, r3
	vcvt.f64.s32 d0, s4
	vpush {d0}
	ldr r0, =lit_100_0
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_25_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vdiv.f64 d0, d1, d2
	vmov.f64 d2, d0
	vpop {d1}
	vmul.f64 d0, d1, d2
	pop {r4-r11, pc}

linha_7:
	push {r4-r11, lr}
	ldr r0, =lit_3_14
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_2_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vmul.f64 d0, d1, d2
	vpush {d0}
	ldr r0, =lit_1_0
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_1_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vadd.f64 d0, d1, d2
	vmov.f64 d2, d0
	vpop {d1}
	vcvt.s32.f64 s4, d2
	vmov r2, s4
	cmp r2, #0
	blt pow_neg_err
	beq pow_z_5
	cmp r2, #1
	beq pow_one_6
	vmov.f64 d0, d1
	mov r4, r2
	sub r4, r4, #1
pow_lp_8:
	vmul.f64 d0, d0, d1
	subs r4, r4, #1
	bne pow_lp_8
	b pow_fin_7
pow_one_6:
	vmov.f64 d0, d1
	b pow_fin_7
pow_z_5:
	ldr r0, =lit_one
	vldr d0, [r0]
pow_fin_7:
	pop {r4-r11, pc}

linha_8:
	push {r4-r11, lr}
	ldr r0, =lit_2_0
	vldr d0, [r0]
	ldr r0, =mem_MEMX
	vstr d0, [r0]
	vpush {d0}
	ldr r0, =mem_MEMX
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_3_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vmul.f64 d0, d1, d2
	vmov.f64 d2, d0
	vpop {d1}
	vadd.f64 d0, d1, d2
	pop {r4-r11, pc}

linha_9:
	push {r4-r11, lr}
	ldr r0, =lit_8_0
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_2_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vcvt.s32.f64 s0, d1
	vcvt.s32.f64 s2, d2
	vmov r0, s0
	vmov r1, s2
	cmp r1, #0
	beq divzero_die
	bl idiv_trunc
	vmov s4, r2
	vcvt.f64.s32 d0, s4
	vpush {d0}
	ldr r0, =lit_4_0
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_2_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vdiv.f64 d0, d1, d2
	vmov.f64 d2, d0
	vpop {d1}
	vsub.f64 d0, d1, d2
	pop {r4-r11, pc}

linha_10:
	push {r4-r11, lr}
	ldr r0, =lit_1_0
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_2_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vadd.f64 d0, d1, d2
	vpush {d0}
	ldr r0, =lit_3_0
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_4_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vadd.f64 d0, d1, d2
	vmov.f64 d2, d0
	vpop {d1}
	vmul.f64 d0, d1, d2
	vpush {d0}
	ldr r0, =lit_5_0
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_6_0
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vadd.f64 d0, d1, d2
	vmov.f64 d2, d0
	vpop {d1}
	vmul.f64 d0, d1, d2
	pop {r4-r11, pc}

linha_11:
	push {r4-r11, lr}
	ldr r0, =lit_0_5
	vldr d0, [r0]
	vpush {d0}
	ldr r0, =lit_0_25
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vdiv.f64 d0, d1, d2
	vpush {d0}
	ldr r0, =hist
	add r0, r0, #72
	vldr d0, [r0]
	vmov.f64 d2, d0
	vpop {d1}
	vadd.f64 d0, d1, d2
	pop {r4-r11, pc}

mostrar_d0_7seg:
	push {r0-r7, lr}
	vabs.f64 d4, d0
	vcvt.u32.f64 s8, d4
	vmov r0, s8
	ldr r7, =seg7_table
	mov r6, #0
	mov r5, #0
	mov r1, #10
	bl udiv32
	mul r3, r2, r1
	sub r3, r0, r3
	ldrb r3, [r7, r3]
	orr r6, r6, r3
	mov r0, r2
	mov r1, #10
	bl udiv32
	mul r3, r2, r1
	sub r3, r0, r3
	ldrb r3, [r7, r3]
	lsl r3, r3, #8
	orr r6, r6, r3
	mov r0, r2
	mov r1, #10
	bl udiv32
	mul r3, r2, r1
	sub r3, r0, r3
	ldrb r3, [r7, r3]
	lsl r3, r3, #16
	orr r6, r6, r3
	mov r0, r2
	mov r1, #10
	bl udiv32
	mul r3, r2, r1
	sub r3, r0, r3
	ldrb r3, [r7, r3]
	lsl r3, r3, #24
	orr r6, r6, r3
	mov r0, r2
	mov r1, #10
	bl udiv32
	mul r3, r2, r1
	sub r3, r0, r3
	ldrb r3, [r7, r3]
	lsl r3, r3, #0
	orr r5, r5, r3
	mov r0, r2
	mov r1, #10
	bl udiv32
	mul r3, r2, r1
	sub r3, r0, r3
	ldrb r3, [r7, r3]
	lsl r3, r3, #8
	orr r5, r5, r3
	mov r0, r2
	ldr r0, =HEX3_HEX0
	str r6, [r0]
	ldr r0, =HEX5_HEX4
	str r5, [r0]
	pop {r0-r7, pc}

udiv32:
	push {r4-r7, lr}
	mov r7, #0
	mov r3, #0
	mov r5, r0
	mov r6, r1
	mov r4, #31
ud32_loop:
	lsl r3, r3, #1
	lsr r2, r5, r4
	and r2, r2, #1
	orr r3, r3, r2
	cmp r3, r6
	blt ud32_skip
	sub r3, r3, r6
	mov r2, #1
	lsl r2, r2, r4
	orr r7, r7, r2
ud32_skip:
	subs r4, r4, #1
	bge ud32_loop
	mov r2, r7
	pop {r4-r7, pc}

idiv_trunc:
	push {r4-r6, lr}
	mov r4, r0
	mov r5, r1
	mov r6, #0
	cmp r4, #0
	rsblt r4, r4, #0
	orrlt r6, r6, #1
	cmp r5, #0
	rsblt r5, r5, #0
	orrlt r6, r6, #2
	mov r0, r4
	mov r1, r5
	bl udiv32
	tst r6, #1
	rsbne r2, r2, #0
	tst r6, #2
	rsbne r2, r2, #0
	pop {r4-r6, pc}


divzero_die:
	b divzero_die
pow_neg_err:
	b pow_neg_err

.section .rodata
.align 3
lit_one:
	.double 1.0
lit_0_25:
	.double 0.25
lit_0_5:
	.double 0.5
lit_1_0:
	.double 1.0
lit_10_0:
	.double 10.0
lit_100_0:
	.double 100.0
lit_2_0:
	.double 2.0
lit_25_0:
	.double 25.0
lit_3_0:
	.double 3.0
lit_3_14:
	.double 3.14
lit_4_0:
	.double 4.0
lit_5_0:
	.double 5.0
lit_5_5:
	.double 5.5
lit_6_0:
	.double 6.0
lit_7_0:
	.double 7.0
lit_8_0:
	.double 8.0
lit_9_0:
	.double 9.0

.align 2
seg7_table:
	.byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F

.section .bss
.align 3
hist:
	.space 96
mem_CONTADOR:
	.space 8
mem_MEMX:
	.space 8

.align 4
stack:
	.space 65536
stack_top:
