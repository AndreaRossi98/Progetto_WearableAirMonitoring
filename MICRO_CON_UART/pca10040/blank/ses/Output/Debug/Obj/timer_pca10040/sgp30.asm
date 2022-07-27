	.cpu cortex-m4
	.arch armv7e-m
	.fpu fpv4-sp-d16
	.eabi_attribute 27, 1
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 38, 1
	.eabi_attribute 18, 4
	.file	"sgp30.c"
	.text
.Ltext0:
	.section	.rodata.SGP30_I2C_ADDRESS,"a"
	.type	SGP30_I2C_ADDRESS, %object
	.size	SGP30_I2C_ADDRESS, 1
SGP30_I2C_ADDRESS:
	.byte	88
	.section	.text.sgp30_check_featureset,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_check_featureset, %function
sgp30_check_featureset:
.LFB0:
	.file 1 "C:\\nrf_sdk\\nRF5_SDK_17.1.0_ddde560\\examples\\My Projects\\Progetto_WearableAirMonitoring\\sensor\\sgp30.c"
	.loc 1 105 59
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
.LCFI0:
	sub	sp, sp, #20
.LCFI1:
	mov	r3, r0
	strh	r3, [sp, #6]	@ movhi
	.loc 1 110 11
	add	r2, sp, #11
	add	r3, sp, #12
	mov	r1, r2
	mov	r0, r3
	bl	sgp30_get_feature_set_version
	mov	r3, r0
	strh	r3, [sp, #14]	@ movhi
	.loc 1 111 8
	ldrsh	r3, [sp, #14]
	cmp	r3, #0
	beq	.L2
	.loc 1 112 16
	ldrsh	r3, [sp, #14]
	b	.L6
.L2:
	.loc 1 114 22
	ldrb	r3, [sp, #11]	@ zero_extendqisi2
	.loc 1 114 8
	cmp	r3, #0
	beq	.L4
	.loc 1 115 16
	mvn	r3, #11
	b	.L6
.L4:
	.loc 1 117 20
	ldrh	r3, [sp, #12]
	.loc 1 117 8
	ldrh	r2, [sp, #6]
	cmp	r2, r3
	bls	.L5
	.loc 1 118 16
	mvn	r3, #9
	b	.L6
.L5:
	.loc 1 120 12
	movs	r3, #0
.L6:
	.loc 1 121 1 discriminator 1
	mov	r0, r3
	add	sp, sp, #20
.LCFI2:
	@ sp needed
	ldr	pc, [sp], #4
.LFE0:
	.size	sgp30_check_featureset, .-sgp30_check_featureset
	.section	.text.sgp30_measure_test,"ax",%progbits
	.align	1
	.global	sgp30_measure_test
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_measure_test, %function
sgp30_measure_test:
.LFB1:
	.loc 1 123 51
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
.LCFI3:
	sub	sp, sp, #28
.LCFI4:
	str	r0, [sp, #12]
	.loc 1 127 18
	ldr	r3, [sp, #12]
	movs	r2, #0
	strh	r2, [r3]	@ movhi
	.loc 1 129 11
	movs	r0, #88
	add	r3, sp, #20
	movs	r2, #1
	str	r2, [sp]
	ldr	r2, .L12
	movw	r1, #8242
	bl	sensirion_i2c_delayed_read_cmd
	mov	r3, r0
	strh	r3, [sp, #22]	@ movhi
	.loc 1 133 8
	ldrsh	r3, [sp, #22]
	cmp	r3, #0
	beq	.L8
	.loc 1 134 16
	ldrsh	r3, [sp, #22]
	b	.L11
.L8:
	.loc 1 136 18
	ldrh	r2, [sp, #20]
	ldr	r3, [sp, #12]
	strh	r2, [r3]	@ movhi
	.loc 1 137 9
	ldr	r3, [sp, #12]
	ldrh	r3, [r3]
	.loc 1 137 8
	cmp	r3, #54272
	bne	.L10
	.loc 1 138 16
	movs	r3, #0
	b	.L11
.L10:
	.loc 1 140 12
	mov	r3, #-1
.L11:
	.loc 1 141 1 discriminator 1
	mov	r0, r3
	add	sp, sp, #28
.LCFI5:
	@ sp needed
	ldr	pc, [sp], #4
.L13:
	.align	2
.L12:
	.word	220000
.LFE1:
	.size	sgp30_measure_test, .-sgp30_measure_test
	.section	.text.sgp30_measure_iaq,"ax",%progbits
	.align	1
	.global	sgp30_measure_iaq
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_measure_iaq, %function
sgp30_measure_iaq:
.LFB2:
	.loc 1 143 29
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
.LCFI6:
	.loc 1 144 12
	movs	r3, #88
	movw	r1, #8200
	mov	r0, r3
	bl	sensirion_i2c_write_cmd
	mov	r3, r0
	.loc 1 145 1
	mov	r0, r3
	pop	{r3, pc}
.LFE2:
	.size	sgp30_measure_iaq, .-sgp30_measure_iaq
	.section	.text.sgp30_read_iaq,"ax",%progbits
	.align	1
	.global	sgp30_read_iaq
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_read_iaq, %function
sgp30_read_iaq:
.LFB3:
	.loc 1 147 66
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
.LCFI7:
	sub	sp, sp, #20
.LCFI8:
	str	r0, [sp, #4]
	str	r1, [sp]
	.loc 1 151 11
	movs	r0, #88
	add	r3, sp, #8
	movs	r2, #2
	mov	r1, r3
	bl	sensirion_i2c_read_words
	mov	r3, r0
	strh	r3, [sp, #14]	@ movhi
	.loc 1 154 22
	ldrh	r2, [sp, #10]
	.loc 1 154 15
	ldr	r3, [sp, #4]
	strh	r2, [r3]	@ movhi
	.loc 1 155 24
	ldrh	r2, [sp, #8]
	.loc 1 155 17
	ldr	r3, [sp]
	strh	r2, [r3]	@ movhi
	.loc 1 157 12
	ldrsh	r3, [sp, #14]
	.loc 1 158 1
	mov	r0, r3
	add	sp, sp, #20
.LCFI9:
	@ sp needed
	ldr	pc, [sp], #4
.LFE3:
	.size	sgp30_read_iaq, .-sgp30_read_iaq
	.section	.text.sgp30_measure_iaq_blocking_read,"ax",%progbits
	.align	1
	.global	sgp30_measure_iaq_blocking_read
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_measure_iaq_blocking_read, %function
sgp30_measure_iaq_blocking_read:
.LFB4:
	.loc 1 161 63
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
.LCFI10:
	sub	sp, sp, #20
.LCFI11:
	str	r0, [sp, #4]
	str	r1, [sp]
	.loc 1 164 11
	bl	sgp30_measure_iaq
	mov	r3, r0
	strh	r3, [sp, #14]	@ movhi
	.loc 1 165 8
	ldrsh	r3, [sp, #14]
	cmp	r3, #0
	beq	.L19
	.loc 1 166 16
	ldrsh	r3, [sp, #14]
	b	.L20
.L19:
	.loc 1 168 5
	movw	r0, #12000
	bl	sensirion_i2c_hal_sleep_usec
	.loc 1 170 12
	ldr	r1, [sp]
	ldr	r0, [sp, #4]
	bl	sgp30_read_iaq
	mov	r3, r0
.L20:
	.loc 1 171 1
	mov	r0, r3
	add	sp, sp, #20
.LCFI12:
	@ sp needed
	ldr	pc, [sp], #4
.LFE4:
	.size	sgp30_measure_iaq_blocking_read, .-sgp30_measure_iaq_blocking_read
	.section	.text.sgp30_measure_tvoc,"ax",%progbits
	.align	1
	.global	sgp30_measure_tvoc
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_measure_tvoc, %function
sgp30_measure_tvoc:
.LFB5:
	.loc 1 173 30
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
.LCFI13:
	.loc 1 174 12
	bl	sgp30_measure_iaq
	mov	r3, r0
	.loc 1 175 1
	mov	r0, r3
	pop	{r3, pc}
.LFE5:
	.size	sgp30_measure_tvoc, .-sgp30_measure_tvoc
	.section	.text.sgp30_read_tvoc,"ax",%progbits
	.align	1
	.global	sgp30_read_tvoc
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_read_tvoc, %function
sgp30_read_tvoc:
.LFB6:
	.loc 1 177 45
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
.LCFI14:
	sub	sp, sp, #20
.LCFI15:
	str	r0, [sp, #4]
	.loc 1 179 12
	add	r3, sp, #14
	mov	r1, r3
	ldr	r0, [sp, #4]
	bl	sgp30_read_iaq
	mov	r3, r0
	.loc 1 180 1
	mov	r0, r3
	add	sp, sp, #20
.LCFI16:
	@ sp needed
	ldr	pc, [sp], #4
.LFE6:
	.size	sgp30_read_tvoc, .-sgp30_read_tvoc
	.section	.text.sgp30_measure_tvoc_blocking_read,"ax",%progbits
	.align	1
	.global	sgp30_measure_tvoc_blocking_read
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_measure_tvoc_blocking_read, %function
sgp30_measure_tvoc_blocking_read:
.LFB7:
	.loc 1 182 62
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
.LCFI17:
	sub	sp, sp, #20
.LCFI18:
	str	r0, [sp, #4]
	.loc 1 184 12
	add	r3, sp, #14
	mov	r1, r3
	ldr	r0, [sp, #4]
	bl	sgp30_measure_iaq_blocking_read
	mov	r3, r0
	.loc 1 185 1
	mov	r0, r3
	add	sp, sp, #20
.LCFI19:
	@ sp needed
	ldr	pc, [sp], #4
.LFE7:
	.size	sgp30_measure_tvoc_blocking_read, .-sgp30_measure_tvoc_blocking_read
	.section	.text.sgp30_measure_co2_eq,"ax",%progbits
	.align	1
	.global	sgp30_measure_co2_eq
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_measure_co2_eq, %function
sgp30_measure_co2_eq:
.LFB8:
	.loc 1 187 32
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
.LCFI20:
	.loc 1 188 12
	bl	sgp30_measure_iaq
	mov	r3, r0
	.loc 1 189 1
	mov	r0, r3
	pop	{r3, pc}
.LFE8:
	.size	sgp30_measure_co2_eq, .-sgp30_measure_co2_eq
	.section	.text.sgp30_read_co2_eq,"ax",%progbits
	.align	1
	.global	sgp30_read_co2_eq
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_read_co2_eq, %function
sgp30_read_co2_eq:
.LFB9:
	.loc 1 191 49
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
.LCFI21:
	sub	sp, sp, #20
.LCFI22:
	str	r0, [sp, #4]
	.loc 1 193 12
	add	r3, sp, #14
	ldr	r1, [sp, #4]
	mov	r0, r3
	bl	sgp30_read_iaq
	mov	r3, r0
	.loc 1 194 1
	mov	r0, r3
	add	sp, sp, #20
.LCFI23:
	@ sp needed
	ldr	pc, [sp], #4
.LFE9:
	.size	sgp30_read_co2_eq, .-sgp30_read_co2_eq
	.section	.text.sgp30_measure_co2_eq_blocking_read,"ax",%progbits
	.align	1
	.global	sgp30_measure_co2_eq_blocking_read
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_measure_co2_eq_blocking_read, %function
sgp30_measure_co2_eq_blocking_read:
.LFB10:
	.loc 1 196 66
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
.LCFI24:
	sub	sp, sp, #20
.LCFI25:
	str	r0, [sp, #4]
	.loc 1 198 12
	add	r3, sp, #14
	ldr	r1, [sp, #4]
	mov	r0, r3
	bl	sgp30_measure_iaq_blocking_read
	mov	r3, r0
	.loc 1 199 1
	mov	r0, r3
	add	sp, sp, #20
.LCFI26:
	@ sp needed
	ldr	pc, [sp], #4
.LFE10:
	.size	sgp30_measure_co2_eq_blocking_read, .-sgp30_measure_co2_eq_blocking_read
	.section	.text.sgp30_measure_raw_blocking_read,"ax",%progbits
	.align	1
	.global	sgp30_measure_raw_blocking_read
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_measure_raw_blocking_read, %function
sgp30_measure_raw_blocking_read:
.LFB11:
	.loc 1 202 66
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
.LCFI27:
	sub	sp, sp, #20
.LCFI28:
	str	r0, [sp, #4]
	str	r1, [sp]
	.loc 1 205 11
	bl	sgp30_measure_raw
	mov	r3, r0
	strh	r3, [sp, #14]	@ movhi
	.loc 1 206 8
	ldrsh	r3, [sp, #14]
	cmp	r3, #0
	beq	.L34
	.loc 1 207 16
	ldrsh	r3, [sp, #14]
	b	.L35
.L34:
	.loc 1 209 5
	movw	r0, #25000
	bl	sensirion_i2c_hal_sleep_usec
	.loc 1 211 12
	ldr	r1, [sp]
	ldr	r0, [sp, #4]
	bl	sgp30_read_raw
	mov	r3, r0
.L35:
	.loc 1 212 1
	mov	r0, r3
	add	sp, sp, #20
.LCFI29:
	@ sp needed
	ldr	pc, [sp], #4
.LFE11:
	.size	sgp30_measure_raw_blocking_read, .-sgp30_measure_raw_blocking_read
	.section	.text.sgp30_measure_raw,"ax",%progbits
	.align	1
	.global	sgp30_measure_raw
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_measure_raw, %function
sgp30_measure_raw:
.LFB12:
	.loc 1 214 29
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
.LCFI30:
	.loc 1 215 12
	movs	r3, #88
	movw	r1, #8272
	mov	r0, r3
	bl	sensirion_i2c_write_cmd
	mov	r3, r0
	.loc 1 216 1
	mov	r0, r3
	pop	{r3, pc}
.LFE12:
	.size	sgp30_measure_raw, .-sgp30_measure_raw
	.section	.text.sgp30_read_raw,"ax",%progbits
	.align	1
	.global	sgp30_read_raw
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_read_raw, %function
sgp30_read_raw:
.LFB13:
	.loc 1 218 79
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
.LCFI31:
	sub	sp, sp, #20
.LCFI32:
	str	r0, [sp, #4]
	str	r1, [sp]
	.loc 1 222 11
	movs	r0, #88
	add	r3, sp, #8
	movs	r2, #2
	mov	r1, r3
	bl	sensirion_i2c_read_words
	mov	r3, r0
	strh	r3, [sp, #14]	@ movhi
	.loc 1 225 32
	ldrh	r2, [sp, #10]
	.loc 1 225 25
	ldr	r3, [sp, #4]
	strh	r2, [r3]	@ movhi
	.loc 1 226 27
	ldrh	r2, [sp, #8]
	.loc 1 226 20
	ldr	r3, [sp]
	strh	r2, [r3]	@ movhi
	.loc 1 228 12
	ldrsh	r3, [sp, #14]
	.loc 1 229 1
	mov	r0, r3
	add	sp, sp, #20
.LCFI33:
	@ sp needed
	ldr	pc, [sp], #4
.LFE13:
	.size	sgp30_read_raw, .-sgp30_read_raw
	.section	.text.sgp30_get_iaq_baseline,"ax",%progbits
	.align	1
	.global	sgp30_get_iaq_baseline
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_get_iaq_baseline, %function
sgp30_get_iaq_baseline:
.LFB14:
	.loc 1 231 52
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
.LCFI34:
	sub	sp, sp, #20
.LCFI35:
	str	r0, [sp, #4]
	.loc 1 236 9
	movs	r3, #88
	movw	r1, #8213
	mov	r0, r3
	bl	sensirion_i2c_write_cmd
	mov	r3, r0
	strh	r3, [sp, #14]	@ movhi
	.loc 1 238 8
	ldrsh	r3, [sp, #14]
	cmp	r3, #0
	beq	.L41
	.loc 1 239 16
	ldrsh	r3, [sp, #14]
	b	.L45
.L41:
	.loc 1 241 5
	movw	r0, #10000
	bl	sensirion_i2c_hal_sleep_usec
	.loc 1 243 11
	movs	r0, #88
	add	r3, sp, #8
	movs	r2, #2
	mov	r1, r3
	bl	sensirion_i2c_read_words
	mov	r3, r0
	strh	r3, [sp, #14]	@ movhi
	.loc 1 246 8
	ldrsh	r3, [sp, #14]
	cmp	r3, #0
	beq	.L43
	.loc 1 247 16
	ldrsh	r3, [sp, #14]
	b	.L45
.L43:
	.loc 1 249 33
	ldrh	r3, [sp, #10]
	.loc 1 249 37
	lsls	r3, r3, #16
	.loc 1 249 62
	ldrh	r2, [sp, #8]
	.loc 1 249 44
	orrs	r2, r2, r3
	.loc 1 249 15
	ldr	r3, [sp, #4]
	str	r2, [r3]
	.loc 1 251 9
	ldr	r3, [sp, #4]
	ldr	r3, [r3]
	.loc 1 251 8
	cmp	r3, #0
	beq	.L44
	.loc 1 252 16
	movs	r3, #0
	b	.L45
.L44:
	.loc 1 253 12
	mov	r3, #-1
.L45:
	.loc 1 254 1 discriminator 1
	mov	r0, r3
	add	sp, sp, #20
.LCFI36:
	@ sp needed
	ldr	pc, [sp], #4
.LFE14:
	.size	sgp30_get_iaq_baseline, .-sgp30_get_iaq_baseline
	.section	.text.sgp30_set_iaq_baseline,"ax",%progbits
	.align	1
	.global	sgp30_set_iaq_baseline
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_set_iaq_baseline, %function
sgp30_set_iaq_baseline:
.LFB15:
	.loc 1 256 51
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
.LCFI37:
	sub	sp, sp, #20
.LCFI38:
	str	r0, [sp, #4]
	.loc 1 258 61
	ldr	r3, [sp, #4]
	lsrs	r3, r3, #16
	.loc 1 258 26
	uxth	r3, r3
	.loc 1 258 14
	strh	r3, [sp, #8]	@ movhi
	.loc 1 259 26
	ldr	r3, [sp, #4]
	uxth	r3, r3
	.loc 1 258 14
	strh	r3, [sp, #10]	@ movhi
	.loc 1 261 8
	ldr	r3, [sp, #4]
	cmp	r3, #0
	bne	.L47
	.loc 1 262 16
	mov	r3, #-1
	b	.L49
.L47:
	.loc 1 264 11
	movs	r0, #88
	add	r2, sp, #8
	movs	r3, #2
	movw	r1, #8222
	bl	sensirion_i2c_write_cmd_with_args
	mov	r3, r0
	strh	r3, [sp, #14]	@ movhi
	.loc 1 268 5
	movw	r0, #10000
	bl	sensirion_i2c_hal_sleep_usec
	.loc 1 270 12
	ldrsh	r3, [sp, #14]
.L49:
	.loc 1 271 1 discriminator 1
	mov	r0, r3
	add	sp, sp, #20
.LCFI39:
	@ sp needed
	ldr	pc, [sp], #4
.LFE15:
	.size	sgp30_set_iaq_baseline, .-sgp30_set_iaq_baseline
	.section	.text.sgp30_get_tvoc_inceptive_baseline,"ax",%progbits
	.align	1
	.global	sgp30_get_tvoc_inceptive_baseline
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_get_tvoc_inceptive_baseline, %function
sgp30_get_tvoc_inceptive_baseline:
.LFB16:
	.loc 1 273 78
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
.LCFI40:
	sub	sp, sp, #20
.LCFI41:
	str	r0, [sp, #4]
	.loc 1 276 11
	movs	r0, #33
	bl	sgp30_check_featureset
	mov	r3, r0
	strh	r3, [sp, #14]	@ movhi
	.loc 1 278 8
	ldrsh	r3, [sp, #14]
	cmp	r3, #0
	beq	.L51
	.loc 1 279 16
	ldrsh	r3, [sp, #14]
	b	.L52
.L51:
	.loc 1 281 11
	movs	r3, #88
	movw	r1, #8371
	mov	r0, r3
	bl	sensirion_i2c_write_cmd
	mov	r3, r0
	strh	r3, [sp, #14]	@ movhi
	.loc 1 284 8
	ldrsh	r3, [sp, #14]
	cmp	r3, #0
	beq	.L53
	.loc 1 285 16
	ldrsh	r3, [sp, #14]
	b	.L52
.L53:
	.loc 1 287 5
	movw	r0, #10000
	bl	sensirion_i2c_hal_sleep_usec
	.loc 1 289 12
	movs	r3, #88
	movs	r2, #1
	ldr	r1, [sp, #4]
	mov	r0, r3
	bl	sensirion_i2c_read_words
	mov	r3, r0
.L52:
	.loc 1 292 1
	mov	r0, r3
	add	sp, sp, #20
.LCFI42:
	@ sp needed
	ldr	pc, [sp], #4
.LFE16:
	.size	sgp30_get_tvoc_inceptive_baseline, .-sgp30_get_tvoc_inceptive_baseline
	.section	.text.sgp30_set_tvoc_baseline,"ax",%progbits
	.align	1
	.global	sgp30_set_tvoc_baseline
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_set_tvoc_baseline, %function
sgp30_set_tvoc_baseline:
.LFB17:
	.loc 1 294 57
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
.LCFI43:
	sub	sp, sp, #20
.LCFI44:
	mov	r3, r0
	strh	r3, [sp, #6]	@ movhi
	.loc 1 297 11
	movs	r0, #33
	bl	sgp30_check_featureset
	mov	r3, r0
	strh	r3, [sp, #14]	@ movhi
	.loc 1 299 8
	ldrsh	r3, [sp, #14]
	cmp	r3, #0
	beq	.L55
	.loc 1 300 16
	ldrsh	r3, [sp, #14]
	b	.L56
.L55:
	.loc 1 302 9
	ldrh	r3, [sp, #6]
	.loc 1 302 8
	cmp	r3, #0
	bne	.L57
	.loc 1 303 16
	mov	r3, #-1
	b	.L56
.L57:
	.loc 1 305 11
	movs	r0, #88
	add	r2, sp, #6
	movs	r3, #1
	movw	r1, #8311
	bl	sensirion_i2c_write_cmd_with_args
	mov	r3, r0
	strh	r3, [sp, #14]	@ movhi
	.loc 1 309 5
	movw	r0, #10000
	bl	sensirion_i2c_hal_sleep_usec
	.loc 1 311 12
	ldrsh	r3, [sp, #14]
.L56:
	.loc 1 312 1
	mov	r0, r3
	add	sp, sp, #20
.LCFI45:
	@ sp needed
	ldr	pc, [sp], #4
.LFE17:
	.size	sgp30_set_tvoc_baseline, .-sgp30_set_tvoc_baseline
	.section	.text.sgp30_set_absolute_humidity,"ax",%progbits
	.align	1
	.global	sgp30_set_absolute_humidity
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_set_absolute_humidity, %function
sgp30_set_absolute_humidity:
.LFB18:
	.loc 1 314 65
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
.LCFI46:
	sub	sp, sp, #20
.LCFI47:
	str	r0, [sp, #4]
	.loc 1 318 8
	ldr	r3, [sp, #4]
	cmp	r3, #256000
	bls	.L59
	.loc 1 319 16
	mov	r3, #-1
	b	.L61
.L59:
	.loc 1 322 47
	ldr	r3, [sp, #4]
	movw	r2, #16777
	mul	r3, r2, r3
	.loc 1 322 56
	lsrs	r3, r3, #16
	.loc 1 322 17
	uxth	r3, r3
	.loc 1 322 15
	strh	r3, [sp, #12]	@ movhi
	.loc 1 324 11
	movs	r0, #88
	add	r2, sp, #12
	movs	r3, #1
	movw	r1, #8289
	bl	sensirion_i2c_write_cmd_with_args
	mov	r3, r0
	strh	r3, [sp, #14]	@ movhi
	.loc 1 328 5
	movw	r0, #10000
	bl	sensirion_i2c_hal_sleep_usec
	.loc 1 330 12
	ldrsh	r3, [sp, #14]
.L61:
	.loc 1 331 1 discriminator 1
	mov	r0, r3
	add	sp, sp, #20
.LCFI48:
	@ sp needed
	ldr	pc, [sp], #4
.LFE18:
	.size	sgp30_set_absolute_humidity, .-sgp30_set_absolute_humidity
	.section	.text.sgp30_get_configured_address,"ax",%progbits
	.align	1
	.global	sgp30_get_configured_address
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_get_configured_address, %function
sgp30_get_configured_address:
.LFB19:
	.loc 1 337 40
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	.loc 1 338 12
	movs	r3, #88
	.loc 1 339 1
	mov	r0, r3
	bx	lr
.LFE19:
	.size	sgp30_get_configured_address, .-sgp30_get_configured_address
	.section	.text.sgp30_get_feature_set_version,"ax",%progbits
	.align	1
	.global	sgp30_get_feature_set_version
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_get_feature_set_version, %function
sgp30_get_feature_set_version:
.LFB20:
	.loc 1 342 62
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
.LCFI49:
	sub	sp, sp, #28
.LCFI50:
	str	r0, [sp, #12]
	str	r1, [sp, #8]
	.loc 1 346 11
	movs	r0, #88
	add	r3, sp, #20
	movs	r2, #1
	str	r2, [sp]
	movw	r2, #10000
	movw	r1, #8239
	bl	sensirion_i2c_delayed_read_cmd
	mov	r3, r0
	strh	r3, [sp, #22]	@ movhi
	.loc 1 351 8
	ldrsh	r3, [sp, #22]
	cmp	r3, #0
	beq	.L65
	.loc 1 352 16
	ldrsh	r3, [sp, #22]
	b	.L67
.L65:
	.loc 1 354 33
	ldrh	r3, [sp, #20]
	.loc 1 354 37
	uxtb	r3, r3
	uxth	r2, r3
	.loc 1 354 26
	ldr	r3, [sp, #12]
	strh	r2, [r3]	@ movhi
	.loc 1 355 37
	ldrh	r3, [sp, #20]
	.loc 1 355 51
	lsrs	r3, r3, #12
	uxth	r3, r3
	.loc 1 355 21
	uxtb	r2, r3
	.loc 1 355 19
	ldr	r3, [sp, #8]
	strb	r2, [r3]
	.loc 1 357 12
	movs	r3, #0
.L67:
	.loc 1 358 1 discriminator 1
	mov	r0, r3
	add	sp, sp, #28
.LCFI51:
	@ sp needed
	ldr	pc, [sp], #4
.LFE20:
	.size	sgp30_get_feature_set_version, .-sgp30_get_feature_set_version
	.section	.text.sgp30_get_serial_id,"ax",%progbits
	.align	1
	.global	sgp30_get_serial_id
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_get_serial_id, %function
sgp30_get_serial_id:
.LFB21:
	.loc 1 360 50
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
.LCFI52:
	sub	sp, sp, #44
.LCFI53:
	str	r0, [sp, #28]
	.loc 1 364 11
	movs	r0, #88
	add	r3, sp, #32
	movs	r2, #3
	str	r2, [sp]
	mov	r2, #500
	movw	r1, #13954
	bl	sensirion_i2c_delayed_read_cmd
	mov	r3, r0
	strh	r3, [sp, #38]	@ movhi
	.loc 1 369 8
	ldrsh	r3, [sp, #38]
	cmp	r3, #0
	beq	.L69
	.loc 1 370 16
	ldrsh	r3, [sp, #38]
	b	.L71
.L69:
	.loc 1 372 35
	ldrh	r3, [sp, #32]
	.loc 1 372 20
	uxth	r3, r3
	movs	r2, #0
	str	r3, [sp, #8]
	str	r2, [sp, #12]
	.loc 1 372 40
	mov	r2, #0
	mov	r3, #0
	ldr	r1, [sp, #8]
	movs	r3, r1
	movs	r2, #0
	.loc 1 372 66
	ldrh	r1, [sp, #34]
	.loc 1 372 51
	uxth	r1, r1
	movs	r0, #0
	mov	r10, r1
	mov	fp, r0
	.loc 1 372 71
	lsr	r7, r10, #16
	lsl	r6, r10, #16
	.loc 1 372 47
	orr	r4, r2, r6
	orr	r5, r3, r7
	.loc 1 373 35
	ldrh	r3, [sp, #36]
	.loc 1 373 40
	uxth	r3, r3
	movs	r2, #0
	mov	r8, r3
	mov	r9, r2
	.loc 1 372 78
	orr	r3, r4, r8
	str	r3, [sp, #16]
	orr	r3, r5, r9
	str	r3, [sp, #20]
	.loc 1 372 16
	ldr	r3, [sp, #28]
	ldrd	r1, [sp, #16]
	strd	r1, [r3]
	.loc 1 375 12
	movs	r3, #0
.L71:
	.loc 1 376 1 discriminator 1
	mov	r0, r3
	add	sp, sp, #44
.LCFI54:
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
.LFE21:
	.size	sgp30_get_serial_id, .-sgp30_get_serial_id
	.section	.text.sgp30_iaq_init,"ax",%progbits
	.align	1
	.global	sgp30_iaq_init
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_iaq_init, %function
sgp30_iaq_init:
.LFB22:
	.loc 1 378 26
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
.LCFI55:
	sub	sp, sp, #12
.LCFI56:
	.loc 1 379 19
	movs	r3, #88
	movw	r1, #8195
	mov	r0, r3
	bl	sensirion_i2c_write_cmd
	mov	r3, r0
	strh	r3, [sp, #6]	@ movhi
	.loc 1 380 5
	movw	r0, #10000
	bl	sensirion_i2c_hal_sleep_usec
	.loc 1 381 12
	ldrsh	r3, [sp, #6]
	.loc 1 382 1
	mov	r0, r3
	add	sp, sp, #12
.LCFI57:
	@ sp needed
	ldr	pc, [sp], #4
.LFE22:
	.size	sgp30_iaq_init, .-sgp30_iaq_init
	.section	.text.sgp30_probe,"ax",%progbits
	.align	1
	.global	sgp30_probe
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_probe, %function
sgp30_probe:
.LFB23:
	.loc 1 384 23
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{lr}
.LCFI58:
	sub	sp, sp, #12
.LCFI59:
	.loc 1 385 19
	movs	r0, #32
	bl	sgp30_check_featureset
	mov	r3, r0
	strh	r3, [sp, #6]	@ movhi
	.loc 1 387 8
	ldrsh	r3, [sp, #6]
	cmp	r3, #0
	beq	.L75
	.loc 1 388 16
	ldrsh	r3, [sp, #6]
	b	.L76
.L75:
	.loc 1 390 12
	bl	sgp30_iaq_init
	mov	r3, r0
.L76:
	.loc 1 391 1
	mov	r0, r3
	add	sp, sp, #12
.LCFI60:
	@ sp needed
	ldr	pc, [sp], #4
.LFE23:
	.size	sgp30_probe, .-sgp30_probe
	.section	.text.sgp30_init,"ax",%progbits
	.align	1
	.global	sgp30_init
	.syntax unified
	.thumb
	.thumb_func
	.type	sgp30_init, %function
sgp30_init:
.LFB24:
	.loc 1 393 25
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
.LCFI61:
	.loc 1 394 11
	b	.L78
.L79:
	.loc 1 397 9
	ldr	r0, .L81
	bl	sensirion_i2c_hal_sleep_usec
.L78:
	.loc 1 394 12
	bl	sgp30_probe
	mov	r3, r0
	.loc 1 394 11
	cmp	r3, #0
	bne	.L79
	.loc 1 401 12
	movs	r3, #0
	.loc 1 402 1
	mov	r0, r3
	pop	{r3, pc}
.L82:
	.align	2
.L81:
	.word	1000000
.LFE24:
	.size	sgp30_init, .-sgp30_init
	.section	.debug_frame,"",%progbits
.Lframe0:
	.4byte	.LECIE0-.LSCIE0
.LSCIE0:
	.4byte	0xffffffff
	.byte	0x3
	.ascii	"\000"
	.uleb128 0x1
	.sleb128 -4
	.uleb128 0xe
	.byte	0xc
	.uleb128 0xd
	.uleb128 0
	.align	2
.LECIE0:
.LSFDE0:
	.4byte	.LEFDE0-.LASFDE0
.LASFDE0:
	.4byte	.Lframe0
	.4byte	.LFB0
	.4byte	.LFE0-.LFB0
	.byte	0x4
	.4byte	.LCFI0-.LFB0
	.byte	0xe
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI1-.LCFI0
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.4byte	.LCFI2-.LCFI1
	.byte	0xe
	.uleb128 0x4
	.align	2
.LEFDE0:
.LSFDE2:
	.4byte	.LEFDE2-.LASFDE2
.LASFDE2:
	.4byte	.Lframe0
	.4byte	.LFB1
	.4byte	.LFE1-.LFB1
	.byte	0x4
	.4byte	.LCFI3-.LFB1
	.byte	0xe
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI4-.LCFI3
	.byte	0xe
	.uleb128 0x20
	.byte	0x4
	.4byte	.LCFI5-.LCFI4
	.byte	0xe
	.uleb128 0x4
	.align	2
.LEFDE2:
.LSFDE4:
	.4byte	.LEFDE4-.LASFDE4
.LASFDE4:
	.4byte	.Lframe0
	.4byte	.LFB2
	.4byte	.LFE2-.LFB2
	.byte	0x4
	.4byte	.LCFI6-.LFB2
	.byte	0xe
	.uleb128 0x8
	.byte	0x83
	.uleb128 0x2
	.byte	0x8e
	.uleb128 0x1
	.align	2
.LEFDE4:
.LSFDE6:
	.4byte	.LEFDE6-.LASFDE6
.LASFDE6:
	.4byte	.Lframe0
	.4byte	.LFB3
	.4byte	.LFE3-.LFB3
	.byte	0x4
	.4byte	.LCFI7-.LFB3
	.byte	0xe
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI8-.LCFI7
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.4byte	.LCFI9-.LCFI8
	.byte	0xe
	.uleb128 0x4
	.align	2
.LEFDE6:
.LSFDE8:
	.4byte	.LEFDE8-.LASFDE8
.LASFDE8:
	.4byte	.Lframe0
	.4byte	.LFB4
	.4byte	.LFE4-.LFB4
	.byte	0x4
	.4byte	.LCFI10-.LFB4
	.byte	0xe
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI11-.LCFI10
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.4byte	.LCFI12-.LCFI11
	.byte	0xe
	.uleb128 0x4
	.align	2
.LEFDE8:
.LSFDE10:
	.4byte	.LEFDE10-.LASFDE10
.LASFDE10:
	.4byte	.Lframe0
	.4byte	.LFB5
	.4byte	.LFE5-.LFB5
	.byte	0x4
	.4byte	.LCFI13-.LFB5
	.byte	0xe
	.uleb128 0x8
	.byte	0x83
	.uleb128 0x2
	.byte	0x8e
	.uleb128 0x1
	.align	2
.LEFDE10:
.LSFDE12:
	.4byte	.LEFDE12-.LASFDE12
.LASFDE12:
	.4byte	.Lframe0
	.4byte	.LFB6
	.4byte	.LFE6-.LFB6
	.byte	0x4
	.4byte	.LCFI14-.LFB6
	.byte	0xe
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI15-.LCFI14
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.4byte	.LCFI16-.LCFI15
	.byte	0xe
	.uleb128 0x4
	.align	2
.LEFDE12:
.LSFDE14:
	.4byte	.LEFDE14-.LASFDE14
.LASFDE14:
	.4byte	.Lframe0
	.4byte	.LFB7
	.4byte	.LFE7-.LFB7
	.byte	0x4
	.4byte	.LCFI17-.LFB7
	.byte	0xe
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI18-.LCFI17
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.4byte	.LCFI19-.LCFI18
	.byte	0xe
	.uleb128 0x4
	.align	2
.LEFDE14:
.LSFDE16:
	.4byte	.LEFDE16-.LASFDE16
.LASFDE16:
	.4byte	.Lframe0
	.4byte	.LFB8
	.4byte	.LFE8-.LFB8
	.byte	0x4
	.4byte	.LCFI20-.LFB8
	.byte	0xe
	.uleb128 0x8
	.byte	0x83
	.uleb128 0x2
	.byte	0x8e
	.uleb128 0x1
	.align	2
.LEFDE16:
.LSFDE18:
	.4byte	.LEFDE18-.LASFDE18
.LASFDE18:
	.4byte	.Lframe0
	.4byte	.LFB9
	.4byte	.LFE9-.LFB9
	.byte	0x4
	.4byte	.LCFI21-.LFB9
	.byte	0xe
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI22-.LCFI21
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.4byte	.LCFI23-.LCFI22
	.byte	0xe
	.uleb128 0x4
	.align	2
.LEFDE18:
.LSFDE20:
	.4byte	.LEFDE20-.LASFDE20
.LASFDE20:
	.4byte	.Lframe0
	.4byte	.LFB10
	.4byte	.LFE10-.LFB10
	.byte	0x4
	.4byte	.LCFI24-.LFB10
	.byte	0xe
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI25-.LCFI24
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.4byte	.LCFI26-.LCFI25
	.byte	0xe
	.uleb128 0x4
	.align	2
.LEFDE20:
.LSFDE22:
	.4byte	.LEFDE22-.LASFDE22
.LASFDE22:
	.4byte	.Lframe0
	.4byte	.LFB11
	.4byte	.LFE11-.LFB11
	.byte	0x4
	.4byte	.LCFI27-.LFB11
	.byte	0xe
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI28-.LCFI27
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.4byte	.LCFI29-.LCFI28
	.byte	0xe
	.uleb128 0x4
	.align	2
.LEFDE22:
.LSFDE24:
	.4byte	.LEFDE24-.LASFDE24
.LASFDE24:
	.4byte	.Lframe0
	.4byte	.LFB12
	.4byte	.LFE12-.LFB12
	.byte	0x4
	.4byte	.LCFI30-.LFB12
	.byte	0xe
	.uleb128 0x8
	.byte	0x83
	.uleb128 0x2
	.byte	0x8e
	.uleb128 0x1
	.align	2
.LEFDE24:
.LSFDE26:
	.4byte	.LEFDE26-.LASFDE26
.LASFDE26:
	.4byte	.Lframe0
	.4byte	.LFB13
	.4byte	.LFE13-.LFB13
	.byte	0x4
	.4byte	.LCFI31-.LFB13
	.byte	0xe
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI32-.LCFI31
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.4byte	.LCFI33-.LCFI32
	.byte	0xe
	.uleb128 0x4
	.align	2
.LEFDE26:
.LSFDE28:
	.4byte	.LEFDE28-.LASFDE28
.LASFDE28:
	.4byte	.Lframe0
	.4byte	.LFB14
	.4byte	.LFE14-.LFB14
	.byte	0x4
	.4byte	.LCFI34-.LFB14
	.byte	0xe
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI35-.LCFI34
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.4byte	.LCFI36-.LCFI35
	.byte	0xe
	.uleb128 0x4
	.align	2
.LEFDE28:
.LSFDE30:
	.4byte	.LEFDE30-.LASFDE30
.LASFDE30:
	.4byte	.Lframe0
	.4byte	.LFB15
	.4byte	.LFE15-.LFB15
	.byte	0x4
	.4byte	.LCFI37-.LFB15
	.byte	0xe
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI38-.LCFI37
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.4byte	.LCFI39-.LCFI38
	.byte	0xe
	.uleb128 0x4
	.align	2
.LEFDE30:
.LSFDE32:
	.4byte	.LEFDE32-.LASFDE32
.LASFDE32:
	.4byte	.Lframe0
	.4byte	.LFB16
	.4byte	.LFE16-.LFB16
	.byte	0x4
	.4byte	.LCFI40-.LFB16
	.byte	0xe
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI41-.LCFI40
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.4byte	.LCFI42-.LCFI41
	.byte	0xe
	.uleb128 0x4
	.align	2
.LEFDE32:
.LSFDE34:
	.4byte	.LEFDE34-.LASFDE34
.LASFDE34:
	.4byte	.Lframe0
	.4byte	.LFB17
	.4byte	.LFE17-.LFB17
	.byte	0x4
	.4byte	.LCFI43-.LFB17
	.byte	0xe
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI44-.LCFI43
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.4byte	.LCFI45-.LCFI44
	.byte	0xe
	.uleb128 0x4
	.align	2
.LEFDE34:
.LSFDE36:
	.4byte	.LEFDE36-.LASFDE36
.LASFDE36:
	.4byte	.Lframe0
	.4byte	.LFB18
	.4byte	.LFE18-.LFB18
	.byte	0x4
	.4byte	.LCFI46-.LFB18
	.byte	0xe
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI47-.LCFI46
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.4byte	.LCFI48-.LCFI47
	.byte	0xe
	.uleb128 0x4
	.align	2
.LEFDE36:
.LSFDE38:
	.4byte	.LEFDE38-.LASFDE38
.LASFDE38:
	.4byte	.Lframe0
	.4byte	.LFB19
	.4byte	.LFE19-.LFB19
	.align	2
.LEFDE38:
.LSFDE40:
	.4byte	.LEFDE40-.LASFDE40
.LASFDE40:
	.4byte	.Lframe0
	.4byte	.LFB20
	.4byte	.LFE20-.LFB20
	.byte	0x4
	.4byte	.LCFI49-.LFB20
	.byte	0xe
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI50-.LCFI49
	.byte	0xe
	.uleb128 0x20
	.byte	0x4
	.4byte	.LCFI51-.LCFI50
	.byte	0xe
	.uleb128 0x4
	.align	2
.LEFDE40:
.LSFDE42:
	.4byte	.LEFDE42-.LASFDE42
.LASFDE42:
	.4byte	.Lframe0
	.4byte	.LFB21
	.4byte	.LFE21-.LFB21
	.byte	0x4
	.4byte	.LCFI52-.LFB21
	.byte	0xe
	.uleb128 0x24
	.byte	0x84
	.uleb128 0x9
	.byte	0x85
	.uleb128 0x8
	.byte	0x86
	.uleb128 0x7
	.byte	0x87
	.uleb128 0x6
	.byte	0x88
	.uleb128 0x5
	.byte	0x89
	.uleb128 0x4
	.byte	0x8a
	.uleb128 0x3
	.byte	0x8b
	.uleb128 0x2
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI53-.LCFI52
	.byte	0xe
	.uleb128 0x50
	.byte	0x4
	.4byte	.LCFI54-.LCFI53
	.byte	0xe
	.uleb128 0x24
	.align	2
.LEFDE42:
.LSFDE44:
	.4byte	.LEFDE44-.LASFDE44
.LASFDE44:
	.4byte	.Lframe0
	.4byte	.LFB22
	.4byte	.LFE22-.LFB22
	.byte	0x4
	.4byte	.LCFI55-.LFB22
	.byte	0xe
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI56-.LCFI55
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.4byte	.LCFI57-.LCFI56
	.byte	0xe
	.uleb128 0x4
	.align	2
.LEFDE44:
.LSFDE46:
	.4byte	.LEFDE46-.LASFDE46
.LASFDE46:
	.4byte	.Lframe0
	.4byte	.LFB23
	.4byte	.LFE23-.LFB23
	.byte	0x4
	.4byte	.LCFI58-.LFB23
	.byte	0xe
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x1
	.byte	0x4
	.4byte	.LCFI59-.LCFI58
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.4byte	.LCFI60-.LCFI59
	.byte	0xe
	.uleb128 0x4
	.align	2
.LEFDE46:
.LSFDE48:
	.4byte	.LEFDE48-.LASFDE48
.LASFDE48:
	.4byte	.Lframe0
	.4byte	.LFB24
	.4byte	.LFE24-.LFB24
	.byte	0x4
	.4byte	.LCFI61-.LFB24
	.byte	0xe
	.uleb128 0x8
	.byte	0x83
	.uleb128 0x2
	.byte	0x8e
	.uleb128 0x1
	.align	2
.LEFDE48:
	.text
.Letext0:
	.file 2 "C:/Program Files/SEGGER/SEGGER Embedded Studio for ARM 5.70a/include/stdint.h"
	.section	.debug_info,"",%progbits
.Ldebug_info0:
	.4byte	0x6a2
	.2byte	0x4
	.4byte	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.4byte	.LASF678
	.byte	0xc
	.4byte	.LASF679
	.4byte	.LASF680
	.4byte	.Ldebug_ranges0+0
	.4byte	0
	.4byte	.Ldebug_line0
	.4byte	.Ldebug_macro0
	.uleb128 0x2
	.byte	0x4
	.byte	0x5
	.ascii	"int\000"
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.4byte	.LASF622
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.4byte	.LASF623
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.4byte	.LASF624
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.4byte	.LASF625
	.uleb128 0x3
	.byte	0x2
	.byte	0x7
	.4byte	.LASF626
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.4byte	.LASF627
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.4byte	.LASF628
	.uleb128 0x4
	.4byte	.LASF629
	.byte	0x2
	.byte	0x2a
	.byte	0x1c
	.4byte	0x45
	.uleb128 0x5
	.4byte	0x61
	.uleb128 0x4
	.4byte	.LASF630
	.byte	0x2
	.byte	0x2f
	.byte	0x1c
	.4byte	0x7e
	.uleb128 0x3
	.byte	0x2
	.byte	0x5
	.4byte	.LASF631
	.uleb128 0x4
	.4byte	.LASF632
	.byte	0x2
	.byte	0x30
	.byte	0x1c
	.4byte	0x4c
	.uleb128 0x4
	.4byte	.LASF633
	.byte	0x2
	.byte	0x37
	.byte	0x1c
	.4byte	0x3e
	.uleb128 0x4
	.4byte	.LASF634
	.byte	0x2
	.byte	0x45
	.byte	0x1c
	.4byte	0xa9
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.4byte	.LASF635
	.uleb128 0x6
	.4byte	.LASF636
	.byte	0x1
	.byte	0x28
	.byte	0x16
	.4byte	0x6d
	.uleb128 0x5
	.byte	0x3
	.4byte	SGP30_I2C_ADDRESS
	.uleb128 0x7
	.4byte	.LASF645
	.byte	0x1
	.2byte	0x189
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB24
	.4byte	.LFE24-.LFB24
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x8
	.4byte	.LASF637
	.byte	0x1
	.2byte	0x180
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB23
	.4byte	.LFE23-.LFB23
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x105
	.uleb128 0x9
	.ascii	"ret\000"
	.byte	0x1
	.2byte	0x181
	.byte	0xd
	.4byte	0x72
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.byte	0
	.uleb128 0x8
	.4byte	.LASF638
	.byte	0x1
	.2byte	0x17a
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB22
	.4byte	.LFE22-.LFB22
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x131
	.uleb128 0x9
	.ascii	"ret\000"
	.byte	0x1
	.2byte	0x17b
	.byte	0xd
	.4byte	0x72
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.byte	0
	.uleb128 0x8
	.4byte	.LASF639
	.byte	0x1
	.2byte	0x168
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB21
	.4byte	.LFE21-.LFB21
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x17d
	.uleb128 0xa
	.4byte	.LASF642
	.byte	0x1
	.2byte	0x168
	.byte	0x27
	.4byte	0x17d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -52
	.uleb128 0x9
	.ascii	"ret\000"
	.byte	0x1
	.2byte	0x169
	.byte	0xd
	.4byte	0x72
	.uleb128 0x2
	.byte	0x91
	.sleb128 -42
	.uleb128 0xb
	.4byte	.LASF640
	.byte	0x1
	.2byte	0x16a
	.byte	0xe
	.4byte	0x183
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.byte	0
	.uleb128 0xc
	.byte	0x4
	.4byte	0x9d
	.uleb128 0xd
	.4byte	0x85
	.4byte	0x193
	.uleb128 0xe
	.4byte	0x3e
	.byte	0x2
	.byte	0
	.uleb128 0x8
	.4byte	.LASF641
	.byte	0x1
	.2byte	0x155
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB20
	.4byte	.LFE20-.LFB20
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x1ef
	.uleb128 0xa
	.4byte	.LASF643
	.byte	0x1
	.2byte	0x155
	.byte	0x31
	.4byte	0x1ef
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xa
	.4byte	.LASF644
	.byte	0x1
	.2byte	0x156
	.byte	0x30
	.4byte	0x1f5
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x9
	.ascii	"ret\000"
	.byte	0x1
	.2byte	0x157
	.byte	0xd
	.4byte	0x72
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.uleb128 0xb
	.4byte	.LASF640
	.byte	0x1
	.2byte	0x158
	.byte	0xe
	.4byte	0x1fb
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0xc
	.byte	0x4
	.4byte	0x85
	.uleb128 0xc
	.byte	0x4
	.4byte	0x61
	.uleb128 0xd
	.4byte	0x85
	.4byte	0x20b
	.uleb128 0xe
	.4byte	0x3e
	.byte	0
	.byte	0
	.uleb128 0xf
	.4byte	.LASF646
	.byte	0x1
	.2byte	0x151
	.byte	0x9
	.4byte	0x61
	.4byte	.LFB19
	.4byte	.LFE19-.LFB19
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x8
	.4byte	.LASF647
	.byte	0x1
	.2byte	0x13a
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB18
	.4byte	.LFE18-.LFB18
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x26e
	.uleb128 0xa
	.4byte	.LASF648
	.byte	0x1
	.2byte	0x13a
	.byte	0x2e
	.4byte	0x91
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x9
	.ascii	"ret\000"
	.byte	0x1
	.2byte	0x13b
	.byte	0xd
	.4byte	0x72
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.uleb128 0xb
	.4byte	.LASF649
	.byte	0x1
	.2byte	0x13c
	.byte	0xe
	.4byte	0x85
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x8
	.4byte	.LASF650
	.byte	0x1
	.2byte	0x126
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB17
	.4byte	.LFE17-.LFB17
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2aa
	.uleb128 0xa
	.4byte	.LASF651
	.byte	0x1
	.2byte	0x126
	.byte	0x2a
	.4byte	0x85
	.uleb128 0x2
	.byte	0x91
	.sleb128 -18
	.uleb128 0x9
	.ascii	"ret\000"
	.byte	0x1
	.2byte	0x127
	.byte	0xd
	.4byte	0x72
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.byte	0
	.uleb128 0x8
	.4byte	.LASF652
	.byte	0x1
	.2byte	0x111
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB16
	.4byte	.LFE16-.LFB16
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2e6
	.uleb128 0xa
	.4byte	.LASF653
	.byte	0x1
	.2byte	0x111
	.byte	0x35
	.4byte	0x1ef
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x9
	.ascii	"ret\000"
	.byte	0x1
	.2byte	0x112
	.byte	0xd
	.4byte	0x72
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.byte	0
	.uleb128 0x8
	.4byte	.LASF654
	.byte	0x1
	.2byte	0x100
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB15
	.4byte	.LFE15-.LFB15
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x332
	.uleb128 0xa
	.4byte	.LASF655
	.byte	0x1
	.2byte	0x100
	.byte	0x29
	.4byte	0x91
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x9
	.ascii	"ret\000"
	.byte	0x1
	.2byte	0x101
	.byte	0xd
	.4byte	0x72
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.uleb128 0xb
	.4byte	.LASF640
	.byte	0x1
	.2byte	0x102
	.byte	0xe
	.4byte	0x332
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.byte	0
	.uleb128 0xd
	.4byte	0x85
	.4byte	0x342
	.uleb128 0xe
	.4byte	0x3e
	.byte	0x1
	.byte	0
	.uleb128 0x10
	.4byte	.LASF656
	.byte	0x1
	.byte	0xe7
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB14
	.4byte	.LFE14-.LFB14
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x38a
	.uleb128 0x11
	.4byte	.LASF655
	.byte	0x1
	.byte	0xe7
	.byte	0x2a
	.4byte	0x38a
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x12
	.ascii	"ret\000"
	.byte	0x1
	.byte	0xe8
	.byte	0xd
	.4byte	0x72
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.uleb128 0x6
	.4byte	.LASF640
	.byte	0x1
	.byte	0xe9
	.byte	0xe
	.4byte	0x332
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.byte	0
	.uleb128 0xc
	.byte	0x4
	.4byte	0x91
	.uleb128 0x10
	.4byte	.LASF657
	.byte	0x1
	.byte	0xda
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB13
	.4byte	.LFE13-.LFB13
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3e7
	.uleb128 0x11
	.4byte	.LASF658
	.byte	0x1
	.byte	0xda
	.byte	0x22
	.4byte	0x1ef
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x11
	.4byte	.LASF659
	.byte	0x1
	.byte	0xda
	.byte	0x40
	.4byte	0x1ef
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x12
	.ascii	"ret\000"
	.byte	0x1
	.byte	0xdb
	.byte	0xd
	.4byte	0x72
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.uleb128 0x6
	.4byte	.LASF640
	.byte	0x1
	.byte	0xdc
	.byte	0xe
	.4byte	0x332
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.byte	0
	.uleb128 0x13
	.4byte	.LASF660
	.byte	0x1
	.byte	0xd6
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB12
	.4byte	.LFE12-.LFB12
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x10
	.4byte	.LASF661
	.byte	0x1
	.byte	0xc9
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB11
	.4byte	.LFE11-.LFB11
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x445
	.uleb128 0x11
	.4byte	.LASF658
	.byte	0x1
	.byte	0xc9
	.byte	0x33
	.4byte	0x1ef
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x11
	.4byte	.LASF659
	.byte	0x1
	.byte	0xca
	.byte	0x33
	.4byte	0x1ef
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x12
	.ascii	"ret\000"
	.byte	0x1
	.byte	0xcb
	.byte	0xd
	.4byte	0x72
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.byte	0
	.uleb128 0x10
	.4byte	.LASF662
	.byte	0x1
	.byte	0xc4
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB10
	.4byte	.LFE10-.LFB10
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x47e
	.uleb128 0x11
	.4byte	.LASF663
	.byte	0x1
	.byte	0xc4
	.byte	0x36
	.4byte	0x1ef
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x6
	.4byte	.LASF664
	.byte	0x1
	.byte	0xc5
	.byte	0xe
	.4byte	0x85
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.byte	0
	.uleb128 0x10
	.4byte	.LASF665
	.byte	0x1
	.byte	0xbf
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB9
	.4byte	.LFE9-.LFB9
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4b7
	.uleb128 0x11
	.4byte	.LASF663
	.byte	0x1
	.byte	0xbf
	.byte	0x25
	.4byte	0x1ef
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x6
	.4byte	.LASF664
	.byte	0x1
	.byte	0xc0
	.byte	0xe
	.4byte	0x85
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.byte	0
	.uleb128 0x13
	.4byte	.LASF666
	.byte	0x1
	.byte	0xbb
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB8
	.4byte	.LFE8-.LFB8
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x10
	.4byte	.LASF667
	.byte	0x1
	.byte	0xb6
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB7
	.4byte	.LFE7-.LFB7
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x506
	.uleb128 0x11
	.4byte	.LASF664
	.byte	0x1
	.byte	0xb6
	.byte	0x34
	.4byte	0x1ef
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x6
	.4byte	.LASF663
	.byte	0x1
	.byte	0xb7
	.byte	0xe
	.4byte	0x85
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.byte	0
	.uleb128 0x10
	.4byte	.LASF668
	.byte	0x1
	.byte	0xb1
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB6
	.4byte	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x53f
	.uleb128 0x11
	.4byte	.LASF664
	.byte	0x1
	.byte	0xb1
	.byte	0x23
	.4byte	0x1ef
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x6
	.4byte	.LASF663
	.byte	0x1
	.byte	0xb2
	.byte	0xe
	.4byte	0x85
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.byte	0
	.uleb128 0x13
	.4byte	.LASF669
	.byte	0x1
	.byte	0xad
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB5
	.4byte	.LFE5-.LFB5
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x10
	.4byte	.LASF670
	.byte	0x1
	.byte	0xa0
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB4
	.4byte	.LFE4-.LFB4
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x59d
	.uleb128 0x11
	.4byte	.LASF664
	.byte	0x1
	.byte	0xa0
	.byte	0x33
	.4byte	0x1ef
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x11
	.4byte	.LASF663
	.byte	0x1
	.byte	0xa1
	.byte	0x33
	.4byte	0x1ef
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x12
	.ascii	"ret\000"
	.byte	0x1
	.byte	0xa2
	.byte	0xd
	.4byte	0x72
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.byte	0
	.uleb128 0x10
	.4byte	.LASF671
	.byte	0x1
	.byte	0x93
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB3
	.4byte	.LFE3-.LFB3
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x5f4
	.uleb128 0x11
	.4byte	.LASF664
	.byte	0x1
	.byte	0x93
	.byte	0x22
	.4byte	0x1ef
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x11
	.4byte	.LASF663
	.byte	0x1
	.byte	0x93
	.byte	0x36
	.4byte	0x1ef
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x12
	.ascii	"ret\000"
	.byte	0x1
	.byte	0x94
	.byte	0xd
	.4byte	0x72
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.uleb128 0x6
	.4byte	.LASF640
	.byte	0x1
	.byte	0x95
	.byte	0xe
	.4byte	0x332
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.byte	0
	.uleb128 0x13
	.4byte	.LASF672
	.byte	0x1
	.byte	0x8f
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB2
	.4byte	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x10
	.4byte	.LASF673
	.byte	0x1
	.byte	0x7b
	.byte	0x9
	.4byte	0x72
	.4byte	.LFB1
	.4byte	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x652
	.uleb128 0x11
	.4byte	.LASF674
	.byte	0x1
	.byte	0x7b
	.byte	0x26
	.4byte	0x1ef
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x6
	.4byte	.LASF675
	.byte	0x1
	.byte	0x7c
	.byte	0xe
	.4byte	0x1fb
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.uleb128 0x12
	.ascii	"ret\000"
	.byte	0x1
	.byte	0x7d
	.byte	0xd
	.4byte	0x72
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.byte	0
	.uleb128 0x14
	.4byte	.LASF681
	.byte	0x1
	.byte	0x69
	.byte	0x10
	.4byte	0x72
	.4byte	.LFB0
	.4byte	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x11
	.4byte	.LASF676
	.byte	0x1
	.byte	0x69
	.byte	0x30
	.4byte	0x85
	.uleb128 0x2
	.byte	0x91
	.sleb128 -18
	.uleb128 0x12
	.ascii	"ret\000"
	.byte	0x1
	.byte	0x6a
	.byte	0xd
	.4byte	0x72
	.uleb128 0x2
	.byte	0x91
	.sleb128 -10
	.uleb128 0x6
	.4byte	.LASF677
	.byte	0x1
	.byte	0x6b
	.byte	0xe
	.4byte	0x85
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.uleb128 0x6
	.4byte	.LASF644
	.byte	0x1
	.byte	0x6c
	.byte	0xd
	.4byte	0x61
	.uleb128 0x2
	.byte	0x91
	.sleb128 -13
	.byte	0
	.byte	0
	.section	.debug_abbrev,"",%progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x2134
	.uleb128 0x19
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x10
	.uleb128 0x17
	.uleb128 0x2119
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_pubnames,"",%progbits
	.4byte	0x2bb
	.2byte	0x2
	.4byte	.Ldebug_info0
	.4byte	0x6a6
	.4byte	0xb0
	.ascii	"SGP30_I2C_ADDRESS\000"
	.4byte	0xc2
	.ascii	"sgp30_init\000"
	.4byte	0xd9
	.ascii	"sgp30_probe\000"
	.4byte	0x105
	.ascii	"sgp30_iaq_init\000"
	.4byte	0x131
	.ascii	"sgp30_get_serial_id\000"
	.4byte	0x193
	.ascii	"sgp30_get_feature_set_version\000"
	.4byte	0x20b
	.ascii	"sgp30_get_configured_address\000"
	.4byte	0x222
	.ascii	"sgp30_set_absolute_humidity\000"
	.4byte	0x26e
	.ascii	"sgp30_set_tvoc_baseline\000"
	.4byte	0x2aa
	.ascii	"sgp30_get_tvoc_inceptive_baseline\000"
	.4byte	0x2e6
	.ascii	"sgp30_set_iaq_baseline\000"
	.4byte	0x342
	.ascii	"sgp30_get_iaq_baseline\000"
	.4byte	0x390
	.ascii	"sgp30_read_raw\000"
	.4byte	0x3e7
	.ascii	"sgp30_measure_raw\000"
	.4byte	0x3fd
	.ascii	"sgp30_measure_raw_blocking_read\000"
	.4byte	0x445
	.ascii	"sgp30_measure_co2_eq_blocking_read\000"
	.4byte	0x47e
	.ascii	"sgp30_read_co2_eq\000"
	.4byte	0x4b7
	.ascii	"sgp30_measure_co2_eq\000"
	.4byte	0x4cd
	.ascii	"sgp30_measure_tvoc_blocking_read\000"
	.4byte	0x506
	.ascii	"sgp30_read_tvoc\000"
	.4byte	0x53f
	.ascii	"sgp30_measure_tvoc\000"
	.4byte	0x555
	.ascii	"sgp30_measure_iaq_blocking_read\000"
	.4byte	0x59d
	.ascii	"sgp30_read_iaq\000"
	.4byte	0x5f4
	.ascii	"sgp30_measure_iaq\000"
	.4byte	0x60a
	.ascii	"sgp30_measure_test\000"
	.4byte	0x652
	.ascii	"sgp30_check_featureset\000"
	.4byte	0
	.section	.debug_pubtypes,"",%progbits
	.4byte	0xf0
	.2byte	0x2
	.4byte	.Ldebug_info0
	.4byte	0x6a6
	.4byte	0x29
	.ascii	"int\000"
	.4byte	0x30
	.ascii	"long int\000"
	.4byte	0x37
	.ascii	"char\000"
	.4byte	0x3e
	.ascii	"unsigned int\000"
	.4byte	0x45
	.ascii	"unsigned char\000"
	.4byte	0x4c
	.ascii	"short unsigned int\000"
	.4byte	0x53
	.ascii	"long long int\000"
	.4byte	0x5a
	.ascii	"signed char\000"
	.4byte	0x61
	.ascii	"uint8_t\000"
	.4byte	0x7e
	.ascii	"short int\000"
	.4byte	0x72
	.ascii	"int16_t\000"
	.4byte	0x85
	.ascii	"uint16_t\000"
	.4byte	0x91
	.ascii	"uint32_t\000"
	.4byte	0xa9
	.ascii	"long long unsigned int\000"
	.4byte	0x9d
	.ascii	"uint64_t\000"
	.4byte	0
	.section	.debug_aranges,"",%progbits
	.4byte	0xdc
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	.LFB0
	.4byte	.LFE0-.LFB0
	.4byte	.LFB1
	.4byte	.LFE1-.LFB1
	.4byte	.LFB2
	.4byte	.LFE2-.LFB2
	.4byte	.LFB3
	.4byte	.LFE3-.LFB3
	.4byte	.LFB4
	.4byte	.LFE4-.LFB4
	.4byte	.LFB5
	.4byte	.LFE5-.LFB5
	.4byte	.LFB6
	.4byte	.LFE6-.LFB6
	.4byte	.LFB7
	.4byte	.LFE7-.LFB7
	.4byte	.LFB8
	.4byte	.LFE8-.LFB8
	.4byte	.LFB9
	.4byte	.LFE9-.LFB9
	.4byte	.LFB10
	.4byte	.LFE10-.LFB10
	.4byte	.LFB11
	.4byte	.LFE11-.LFB11
	.4byte	.LFB12
	.4byte	.LFE12-.LFB12
	.4byte	.LFB13
	.4byte	.LFE13-.LFB13
	.4byte	.LFB14
	.4byte	.LFE14-.LFB14
	.4byte	.LFB15
	.4byte	.LFE15-.LFB15
	.4byte	.LFB16
	.4byte	.LFE16-.LFB16
	.4byte	.LFB17
	.4byte	.LFE17-.LFB17
	.4byte	.LFB18
	.4byte	.LFE18-.LFB18
	.4byte	.LFB19
	.4byte	.LFE19-.LFB19
	.4byte	.LFB20
	.4byte	.LFE20-.LFB20
	.4byte	.LFB21
	.4byte	.LFE21-.LFB21
	.4byte	.LFB22
	.4byte	.LFE22-.LFB22
	.4byte	.LFB23
	.4byte	.LFE23-.LFB23
	.4byte	.LFB24
	.4byte	.LFE24-.LFB24
	.4byte	0
	.4byte	0
	.section	.debug_ranges,"",%progbits
.Ldebug_ranges0:
	.4byte	.LFB0
	.4byte	.LFE0
	.4byte	.LFB1
	.4byte	.LFE1
	.4byte	.LFB2
	.4byte	.LFE2
	.4byte	.LFB3
	.4byte	.LFE3
	.4byte	.LFB4
	.4byte	.LFE4
	.4byte	.LFB5
	.4byte	.LFE5
	.4byte	.LFB6
	.4byte	.LFE6
	.4byte	.LFB7
	.4byte	.LFE7
	.4byte	.LFB8
	.4byte	.LFE8
	.4byte	.LFB9
	.4byte	.LFE9
	.4byte	.LFB10
	.4byte	.LFE10
	.4byte	.LFB11
	.4byte	.LFE11
	.4byte	.LFB12
	.4byte	.LFE12
	.4byte	.LFB13
	.4byte	.LFE13
	.4byte	.LFB14
	.4byte	.LFE14
	.4byte	.LFB15
	.4byte	.LFE15
	.4byte	.LFB16
	.4byte	.LFE16
	.4byte	.LFB17
	.4byte	.LFE17
	.4byte	.LFB18
	.4byte	.LFE18
	.4byte	.LFB19
	.4byte	.LFE19
	.4byte	.LFB20
	.4byte	.LFE20
	.4byte	.LFB21
	.4byte	.LFE21
	.4byte	.LFB22
	.4byte	.LFE22
	.4byte	.LFB23
	.4byte	.LFE23
	.4byte	.LFB24
	.4byte	.LFE24
	.4byte	0
	.4byte	0
	.section	.debug_macro,"",%progbits
.Ldebug_macro0:
	.2byte	0x4
	.byte	0x2
	.4byte	.Ldebug_line0
	.byte	0x7
	.4byte	.Ldebug_macro2
	.byte	0x3
	.uleb128 0
	.uleb128 0x1
	.file 3 "C:\\nrf_sdk\\nRF5_SDK_17.1.0_ddde560\\examples\\My Projects\\Progetto_WearableAirMonitoring\\sensor\\sgp30.h"
	.byte	0x3
	.uleb128 0x20
	.uleb128 0x3
	.byte	0x5
	.uleb128 0x21
	.4byte	.LASF473
	.file 4 "C:\\nrf_sdk\\nRF5_SDK_17.1.0_ddde560\\examples\\My Projects\\Progetto_WearableAirMonitoring\\sensor\\sensirion_common.h"
	.byte	0x3
	.uleb128 0x23
	.uleb128 0x4
	.byte	0x5
	.uleb128 0x21
	.4byte	.LASF474
	.file 5 "C:\\nrf_sdk\\nRF5_SDK_17.1.0_ddde560\\examples\\My Projects\\Progetto_WearableAirMonitoring\\sensor\\sensirion_config.h"
	.byte	0x3
	.uleb128 0x23
	.uleb128 0x5
	.byte	0x5
	.uleb128 0x21
	.4byte	.LASF475
	.file 6 "C:/Program Files/SEGGER/SEGGER Embedded Studio for ARM 5.70a/include/stdlib.h"
	.byte	0x3
	.uleb128 0x27
	.uleb128 0x6
	.byte	0x5
	.uleb128 0x27
	.4byte	.LASF476
	.file 7 "C:/Program Files/SEGGER/SEGGER Embedded Studio for ARM 5.70a/include/__crossworks.h"
	.byte	0x3
	.uleb128 0x29
	.uleb128 0x7
	.byte	0x7
	.4byte	.Ldebug_macro3
	.byte	0x4
	.byte	0x7
	.4byte	.Ldebug_macro4
	.byte	0x4
	.byte	0x3
	.uleb128 0x33
	.uleb128 0x2
	.byte	0x7
	.4byte	.Ldebug_macro5
	.byte	0x4
	.file 8 "C:/Program Files/SEGGER/SEGGER Embedded Studio for ARM 5.70a/include/stdbool.h"
	.byte	0x3
	.uleb128 0x4b
	.uleb128 0x8
	.byte	0x7
	.4byte	.Ldebug_macro6
	.byte	0x4
	.byte	0x4
	.byte	0x7
	.4byte	.Ldebug_macro7
	.byte	0x4
	.file 9 "C:\\nrf_sdk\\nRF5_SDK_17.1.0_ddde560\\examples\\My Projects\\Progetto_WearableAirMonitoring\\sensor\\sensirion_i2c.h"
	.byte	0x3
	.uleb128 0x24
	.uleb128 0x9
	.byte	0x7
	.4byte	.Ldebug_macro8
	.byte	0x4
	.file 10 "C:\\nrf_sdk\\nRF5_SDK_17.1.0_ddde560\\examples\\My Projects\\Progetto_WearableAirMonitoring\\sensor\\sgp_git_version.h"
	.byte	0x3
	.uleb128 0x25
	.uleb128 0xa
	.byte	0x5
	.uleb128 0x21
	.4byte	.LASF585
	.byte	0x4
	.byte	0x7
	.4byte	.Ldebug_macro9
	.byte	0x4
	.file 11 "C:\\nrf_sdk\\nRF5_SDK_17.1.0_ddde560\\examples\\My Projects\\Progetto_WearableAirMonitoring\\sensor\\sensirion_i2c_hal.h"
	.byte	0x3
	.uleb128 0x24
	.uleb128 0xb
	.byte	0x5
	.uleb128 0x21
	.4byte	.LASF590
	.byte	0x4
	.byte	0x5
	.uleb128 0x27
	.4byte	.LASF591
	.byte	0x5
	.uleb128 0x2b
	.4byte	.LASF592
	.byte	0x5
	.uleb128 0x2c
	.4byte	.LASF593
	.byte	0x5
	.uleb128 0x2d
	.4byte	.LASF594
	.byte	0x5
	.uleb128 0x30
	.4byte	.LASF595
	.byte	0x5
	.uleb128 0x31
	.4byte	.LASF596
	.byte	0x5
	.uleb128 0x32
	.4byte	.LASF597
	.byte	0x5
	.uleb128 0x35
	.4byte	.LASF598
	.byte	0x5
	.uleb128 0x36
	.4byte	.LASF599
	.byte	0x5
	.uleb128 0x37
	.4byte	.LASF600
	.byte	0x5
	.uleb128 0x38
	.4byte	.LASF601
	.byte	0x5
	.uleb128 0x3b
	.4byte	.LASF602
	.byte	0x5
	.uleb128 0x3c
	.4byte	.LASF603
	.byte	0x5
	.uleb128 0x3f
	.4byte	.LASF604
	.byte	0x5
	.uleb128 0x40
	.4byte	.LASF605
	.byte	0x5
	.uleb128 0x41
	.4byte	.LASF606
	.byte	0x5
	.uleb128 0x44
	.4byte	.LASF607
	.byte	0x5
	.uleb128 0x45
	.4byte	.LASF608
	.byte	0x5
	.uleb128 0x46
	.4byte	.LASF609
	.byte	0x5
	.uleb128 0x49
	.4byte	.LASF610
	.byte	0x5
	.uleb128 0x4a
	.4byte	.LASF611
	.byte	0x5
	.uleb128 0x4d
	.4byte	.LASF612
	.byte	0x5
	.uleb128 0x4e
	.4byte	.LASF613
	.byte	0x5
	.uleb128 0x4f
	.4byte	.LASF614
	.byte	0x5
	.uleb128 0x52
	.4byte	.LASF615
	.byte	0x5
	.uleb128 0x53
	.4byte	.LASF616
	.byte	0x5
	.uleb128 0x56
	.4byte	.LASF617
	.byte	0x5
	.uleb128 0x57
	.4byte	.LASF618
	.byte	0x5
	.uleb128 0x58
	.4byte	.LASF619
	.byte	0x5
	.uleb128 0x5b
	.4byte	.LASF620
	.byte	0x5
	.uleb128 0x5c
	.4byte	.LASF621
	.byte	0x4
	.byte	0
	.section	.debug_macro,"G",%progbits,wm4.0.1f861b170710a3d369a01608067e0acf,comdat
.Ldebug_macro2:
	.2byte	0x4
	.byte	0
	.byte	0x5
	.uleb128 0
	.4byte	.LASF0
	.byte	0x5
	.uleb128 0
	.4byte	.LASF1
	.byte	0x5
	.uleb128 0
	.4byte	.LASF2
	.byte	0x5
	.uleb128 0
	.4byte	.LASF3
	.byte	0x5
	.uleb128 0
	.4byte	.LASF4
	.byte	0x5
	.uleb128 0
	.4byte	.LASF5
	.byte	0x5
	.uleb128 0
	.4byte	.LASF6
	.byte	0x5
	.uleb128 0
	.4byte	.LASF7
	.byte	0x5
	.uleb128 0
	.4byte	.LASF8
	.byte	0x5
	.uleb128 0
	.4byte	.LASF9
	.byte	0x5
	.uleb128 0
	.4byte	.LASF10
	.byte	0x5
	.uleb128 0
	.4byte	.LASF11
	.byte	0x5
	.uleb128 0
	.4byte	.LASF12
	.byte	0x5
	.uleb128 0
	.4byte	.LASF13
	.byte	0x5
	.uleb128 0
	.4byte	.LASF14
	.byte	0x5
	.uleb128 0
	.4byte	.LASF15
	.byte	0x5
	.uleb128 0
	.4byte	.LASF16
	.byte	0x5
	.uleb128 0
	.4byte	.LASF17
	.byte	0x5
	.uleb128 0
	.4byte	.LASF18
	.byte	0x5
	.uleb128 0
	.4byte	.LASF19
	.byte	0x5
	.uleb128 0
	.4byte	.LASF20
	.byte	0x5
	.uleb128 0
	.4byte	.LASF21
	.byte	0x5
	.uleb128 0
	.4byte	.LASF22
	.byte	0x5
	.uleb128 0
	.4byte	.LASF23
	.byte	0x5
	.uleb128 0
	.4byte	.LASF24
	.byte	0x5
	.uleb128 0
	.4byte	.LASF25
	.byte	0x5
	.uleb128 0
	.4byte	.LASF26
	.byte	0x5
	.uleb128 0
	.4byte	.LASF27
	.byte	0x5
	.uleb128 0
	.4byte	.LASF28
	.byte	0x5
	.uleb128 0
	.4byte	.LASF29
	.byte	0x5
	.uleb128 0
	.4byte	.LASF30
	.byte	0x5
	.uleb128 0
	.4byte	.LASF31
	.byte	0x5
	.uleb128 0
	.4byte	.LASF32
	.byte	0x5
	.uleb128 0
	.4byte	.LASF33
	.byte	0x5
	.uleb128 0
	.4byte	.LASF34
	.byte	0x5
	.uleb128 0
	.4byte	.LASF35
	.byte	0x5
	.uleb128 0
	.4byte	.LASF36
	.byte	0x5
	.uleb128 0
	.4byte	.LASF37
	.byte	0x5
	.uleb128 0
	.4byte	.LASF38
	.byte	0x5
	.uleb128 0
	.4byte	.LASF39
	.byte	0x5
	.uleb128 0
	.4byte	.LASF40
	.byte	0x5
	.uleb128 0
	.4byte	.LASF41
	.byte	0x5
	.uleb128 0
	.4byte	.LASF42
	.byte	0x5
	.uleb128 0
	.4byte	.LASF43
	.byte	0x5
	.uleb128 0
	.4byte	.LASF44
	.byte	0x5
	.uleb128 0
	.4byte	.LASF45
	.byte	0x5
	.uleb128 0
	.4byte	.LASF46
	.byte	0x5
	.uleb128 0
	.4byte	.LASF47
	.byte	0x5
	.uleb128 0
	.4byte	.LASF48
	.byte	0x5
	.uleb128 0
	.4byte	.LASF49
	.byte	0x5
	.uleb128 0
	.4byte	.LASF50
	.byte	0x5
	.uleb128 0
	.4byte	.LASF51
	.byte	0x5
	.uleb128 0
	.4byte	.LASF52
	.byte	0x5
	.uleb128 0
	.4byte	.LASF53
	.byte	0x5
	.uleb128 0
	.4byte	.LASF54
	.byte	0x5
	.uleb128 0
	.4byte	.LASF55
	.byte	0x5
	.uleb128 0
	.4byte	.LASF56
	.byte	0x5
	.uleb128 0
	.4byte	.LASF57
	.byte	0x5
	.uleb128 0
	.4byte	.LASF58
	.byte	0x5
	.uleb128 0
	.4byte	.LASF59
	.byte	0x5
	.uleb128 0
	.4byte	.LASF60
	.byte	0x5
	.uleb128 0
	.4byte	.LASF61
	.byte	0x5
	.uleb128 0
	.4byte	.LASF62
	.byte	0x5
	.uleb128 0
	.4byte	.LASF63
	.byte	0x5
	.uleb128 0
	.4byte	.LASF64
	.byte	0x5
	.uleb128 0
	.4byte	.LASF65
	.byte	0x5
	.uleb128 0
	.4byte	.LASF66
	.byte	0x5
	.uleb128 0
	.4byte	.LASF67
	.byte	0x5
	.uleb128 0
	.4byte	.LASF68
	.byte	0x5
	.uleb128 0
	.4byte	.LASF69
	.byte	0x5
	.uleb128 0
	.4byte	.LASF70
	.byte	0x5
	.uleb128 0
	.4byte	.LASF71
	.byte	0x5
	.uleb128 0
	.4byte	.LASF72
	.byte	0x5
	.uleb128 0
	.4byte	.LASF73
	.byte	0x5
	.uleb128 0
	.4byte	.LASF74
	.byte	0x5
	.uleb128 0
	.4byte	.LASF75
	.byte	0x5
	.uleb128 0
	.4byte	.LASF76
	.byte	0x5
	.uleb128 0
	.4byte	.LASF77
	.byte	0x5
	.uleb128 0
	.4byte	.LASF78
	.byte	0x5
	.uleb128 0
	.4byte	.LASF79
	.byte	0x5
	.uleb128 0
	.4byte	.LASF80
	.byte	0x5
	.uleb128 0
	.4byte	.LASF81
	.byte	0x5
	.uleb128 0
	.4byte	.LASF82
	.byte	0x5
	.uleb128 0
	.4byte	.LASF83
	.byte	0x5
	.uleb128 0
	.4byte	.LASF84
	.byte	0x5
	.uleb128 0
	.4byte	.LASF85
	.byte	0x5
	.uleb128 0
	.4byte	.LASF86
	.byte	0x5
	.uleb128 0
	.4byte	.LASF87
	.byte	0x5
	.uleb128 0
	.4byte	.LASF88
	.byte	0x5
	.uleb128 0
	.4byte	.LASF89
	.byte	0x5
	.uleb128 0
	.4byte	.LASF90
	.byte	0x5
	.uleb128 0
	.4byte	.LASF91
	.byte	0x5
	.uleb128 0
	.4byte	.LASF92
	.byte	0x5
	.uleb128 0
	.4byte	.LASF93
	.byte	0x5
	.uleb128 0
	.4byte	.LASF94
	.byte	0x5
	.uleb128 0
	.4byte	.LASF95
	.byte	0x5
	.uleb128 0
	.4byte	.LASF96
	.byte	0x5
	.uleb128 0
	.4byte	.LASF97
	.byte	0x5
	.uleb128 0
	.4byte	.LASF98
	.byte	0x5
	.uleb128 0
	.4byte	.LASF99
	.byte	0x5
	.uleb128 0
	.4byte	.LASF100
	.byte	0x5
	.uleb128 0
	.4byte	.LASF101
	.byte	0x5
	.uleb128 0
	.4byte	.LASF102
	.byte	0x5
	.uleb128 0
	.4byte	.LASF103
	.byte	0x5
	.uleb128 0
	.4byte	.LASF104
	.byte	0x5
	.uleb128 0
	.4byte	.LASF105
	.byte	0x5
	.uleb128 0
	.4byte	.LASF106
	.byte	0x5
	.uleb128 0
	.4byte	.LASF107
	.byte	0x5
	.uleb128 0
	.4byte	.LASF108
	.byte	0x5
	.uleb128 0
	.4byte	.LASF109
	.byte	0x5
	.uleb128 0
	.4byte	.LASF110
	.byte	0x5
	.uleb128 0
	.4byte	.LASF111
	.byte	0x5
	.uleb128 0
	.4byte	.LASF112
	.byte	0x5
	.uleb128 0
	.4byte	.LASF113
	.byte	0x5
	.uleb128 0
	.4byte	.LASF114
	.byte	0x5
	.uleb128 0
	.4byte	.LASF115
	.byte	0x5
	.uleb128 0
	.4byte	.LASF116
	.byte	0x5
	.uleb128 0
	.4byte	.LASF117
	.byte	0x5
	.uleb128 0
	.4byte	.LASF118
	.byte	0x5
	.uleb128 0
	.4byte	.LASF119
	.byte	0x5
	.uleb128 0
	.4byte	.LASF120
	.byte	0x5
	.uleb128 0
	.4byte	.LASF121
	.byte	0x5
	.uleb128 0
	.4byte	.LASF122
	.byte	0x5
	.uleb128 0
	.4byte	.LASF123
	.byte	0x5
	.uleb128 0
	.4byte	.LASF124
	.byte	0x5
	.uleb128 0
	.4byte	.LASF125
	.byte	0x5
	.uleb128 0
	.4byte	.LASF126
	.byte	0x5
	.uleb128 0
	.4byte	.LASF127
	.byte	0x5
	.uleb128 0
	.4byte	.LASF128
	.byte	0x5
	.uleb128 0
	.4byte	.LASF129
	.byte	0x5
	.uleb128 0
	.4byte	.LASF130
	.byte	0x5
	.uleb128 0
	.4byte	.LASF131
	.byte	0x5
	.uleb128 0
	.4byte	.LASF132
	.byte	0x5
	.uleb128 0
	.4byte	.LASF133
	.byte	0x5
	.uleb128 0
	.4byte	.LASF134
	.byte	0x5
	.uleb128 0
	.4byte	.LASF135
	.byte	0x5
	.uleb128 0
	.4byte	.LASF136
	.byte	0x5
	.uleb128 0
	.4byte	.LASF137
	.byte	0x5
	.uleb128 0
	.4byte	.LASF138
	.byte	0x5
	.uleb128 0
	.4byte	.LASF139
	.byte	0x5
	.uleb128 0
	.4byte	.LASF140
	.byte	0x5
	.uleb128 0
	.4byte	.LASF141
	.byte	0x5
	.uleb128 0
	.4byte	.LASF142
	.byte	0x5
	.uleb128 0
	.4byte	.LASF143
	.byte	0x5
	.uleb128 0
	.4byte	.LASF144
	.byte	0x5
	.uleb128 0
	.4byte	.LASF145
	.byte	0x5
	.uleb128 0
	.4byte	.LASF146
	.byte	0x5
	.uleb128 0
	.4byte	.LASF147
	.byte	0x5
	.uleb128 0
	.4byte	.LASF148
	.byte	0x5
	.uleb128 0
	.4byte	.LASF149
	.byte	0x5
	.uleb128 0
	.4byte	.LASF150
	.byte	0x5
	.uleb128 0
	.4byte	.LASF151
	.byte	0x5
	.uleb128 0
	.4byte	.LASF152
	.byte	0x5
	.uleb128 0
	.4byte	.LASF153
	.byte	0x5
	.uleb128 0
	.4byte	.LASF154
	.byte	0x5
	.uleb128 0
	.4byte	.LASF155
	.byte	0x5
	.uleb128 0
	.4byte	.LASF156
	.byte	0x5
	.uleb128 0
	.4byte	.LASF157
	.byte	0x5
	.uleb128 0
	.4byte	.LASF158
	.byte	0x5
	.uleb128 0
	.4byte	.LASF159
	.byte	0x5
	.uleb128 0
	.4byte	.LASF160
	.byte	0x5
	.uleb128 0
	.4byte	.LASF161
	.byte	0x5
	.uleb128 0
	.4byte	.LASF162
	.byte	0x5
	.uleb128 0
	.4byte	.LASF163
	.byte	0x5
	.uleb128 0
	.4byte	.LASF164
	.byte	0x5
	.uleb128 0
	.4byte	.LASF165
	.byte	0x5
	.uleb128 0
	.4byte	.LASF166
	.byte	0x5
	.uleb128 0
	.4byte	.LASF167
	.byte	0x5
	.uleb128 0
	.4byte	.LASF168
	.byte	0x5
	.uleb128 0
	.4byte	.LASF169
	.byte	0x5
	.uleb128 0
	.4byte	.LASF170
	.byte	0x5
	.uleb128 0
	.4byte	.LASF171
	.byte	0x5
	.uleb128 0
	.4byte	.LASF172
	.byte	0x5
	.uleb128 0
	.4byte	.LASF173
	.byte	0x5
	.uleb128 0
	.4byte	.LASF174
	.byte	0x5
	.uleb128 0
	.4byte	.LASF175
	.byte	0x5
	.uleb128 0
	.4byte	.LASF176
	.byte	0x5
	.uleb128 0
	.4byte	.LASF177
	.byte	0x5
	.uleb128 0
	.4byte	.LASF178
	.byte	0x5
	.uleb128 0
	.4byte	.LASF179
	.byte	0x5
	.uleb128 0
	.4byte	.LASF180
	.byte	0x5
	.uleb128 0
	.4byte	.LASF181
	.byte	0x5
	.uleb128 0
	.4byte	.LASF182
	.byte	0x5
	.uleb128 0
	.4byte	.LASF183
	.byte	0x5
	.uleb128 0
	.4byte	.LASF184
	.byte	0x5
	.uleb128 0
	.4byte	.LASF185
	.byte	0x5
	.uleb128 0
	.4byte	.LASF186
	.byte	0x5
	.uleb128 0
	.4byte	.LASF187
	.byte	0x5
	.uleb128 0
	.4byte	.LASF188
	.byte	0x5
	.uleb128 0
	.4byte	.LASF189
	.byte	0x5
	.uleb128 0
	.4byte	.LASF190
	.byte	0x5
	.uleb128 0
	.4byte	.LASF191
	.byte	0x5
	.uleb128 0
	.4byte	.LASF192
	.byte	0x5
	.uleb128 0
	.4byte	.LASF193
	.byte	0x5
	.uleb128 0
	.4byte	.LASF194
	.byte	0x5
	.uleb128 0
	.4byte	.LASF195
	.byte	0x5
	.uleb128 0
	.4byte	.LASF196
	.byte	0x5
	.uleb128 0
	.4byte	.LASF197
	.byte	0x5
	.uleb128 0
	.4byte	.LASF198
	.byte	0x5
	.uleb128 0
	.4byte	.LASF199
	.byte	0x5
	.uleb128 0
	.4byte	.LASF200
	.byte	0x5
	.uleb128 0
	.4byte	.LASF201
	.byte	0x5
	.uleb128 0
	.4byte	.LASF202
	.byte	0x5
	.uleb128 0
	.4byte	.LASF203
	.byte	0x5
	.uleb128 0
	.4byte	.LASF204
	.byte	0x5
	.uleb128 0
	.4byte	.LASF205
	.byte	0x5
	.uleb128 0
	.4byte	.LASF206
	.byte	0x5
	.uleb128 0
	.4byte	.LASF207
	.byte	0x5
	.uleb128 0
	.4byte	.LASF208
	.byte	0x5
	.uleb128 0
	.4byte	.LASF209
	.byte	0x5
	.uleb128 0
	.4byte	.LASF210
	.byte	0x5
	.uleb128 0
	.4byte	.LASF211
	.byte	0x5
	.uleb128 0
	.4byte	.LASF212
	.byte	0x5
	.uleb128 0
	.4byte	.LASF213
	.byte	0x5
	.uleb128 0
	.4byte	.LASF214
	.byte	0x5
	.uleb128 0
	.4byte	.LASF215
	.byte	0x5
	.uleb128 0
	.4byte	.LASF216
	.byte	0x5
	.uleb128 0
	.4byte	.LASF217
	.byte	0x5
	.uleb128 0
	.4byte	.LASF218
	.byte	0x5
	.uleb128 0
	.4byte	.LASF219
	.byte	0x5
	.uleb128 0
	.4byte	.LASF220
	.byte	0x5
	.uleb128 0
	.4byte	.LASF221
	.byte	0x5
	.uleb128 0
	.4byte	.LASF222
	.byte	0x5
	.uleb128 0
	.4byte	.LASF223
	.byte	0x5
	.uleb128 0
	.4byte	.LASF224
	.byte	0x5
	.uleb128 0
	.4byte	.LASF225
	.byte	0x5
	.uleb128 0
	.4byte	.LASF226
	.byte	0x5
	.uleb128 0
	.4byte	.LASF227
	.byte	0x5
	.uleb128 0
	.4byte	.LASF228
	.byte	0x5
	.uleb128 0
	.4byte	.LASF229
	.byte	0x5
	.uleb128 0
	.4byte	.LASF230
	.byte	0x5
	.uleb128 0
	.4byte	.LASF231
	.byte	0x5
	.uleb128 0
	.4byte	.LASF232
	.byte	0x5
	.uleb128 0
	.4byte	.LASF233
	.byte	0x5
	.uleb128 0
	.4byte	.LASF234
	.byte	0x5
	.uleb128 0
	.4byte	.LASF235
	.byte	0x5
	.uleb128 0
	.4byte	.LASF236
	.byte	0x5
	.uleb128 0
	.4byte	.LASF237
	.byte	0x5
	.uleb128 0
	.4byte	.LASF238
	.byte	0x5
	.uleb128 0
	.4byte	.LASF239
	.byte	0x5
	.uleb128 0
	.4byte	.LASF240
	.byte	0x5
	.uleb128 0
	.4byte	.LASF241
	.byte	0x5
	.uleb128 0
	.4byte	.LASF242
	.byte	0x5
	.uleb128 0
	.4byte	.LASF243
	.byte	0x5
	.uleb128 0
	.4byte	.LASF244
	.byte	0x5
	.uleb128 0
	.4byte	.LASF245
	.byte	0x5
	.uleb128 0
	.4byte	.LASF246
	.byte	0x5
	.uleb128 0
	.4byte	.LASF247
	.byte	0x5
	.uleb128 0
	.4byte	.LASF248
	.byte	0x5
	.uleb128 0
	.4byte	.LASF249
	.byte	0x5
	.uleb128 0
	.4byte	.LASF250
	.byte	0x5
	.uleb128 0
	.4byte	.LASF251
	.byte	0x5
	.uleb128 0
	.4byte	.LASF252
	.byte	0x5
	.uleb128 0
	.4byte	.LASF253
	.byte	0x5
	.uleb128 0
	.4byte	.LASF254
	.byte	0x5
	.uleb128 0
	.4byte	.LASF255
	.byte	0x5
	.uleb128 0
	.4byte	.LASF256
	.byte	0x5
	.uleb128 0
	.4byte	.LASF257
	.byte	0x5
	.uleb128 0
	.4byte	.LASF258
	.byte	0x5
	.uleb128 0
	.4byte	.LASF259
	.byte	0x5
	.uleb128 0
	.4byte	.LASF260
	.byte	0x5
	.uleb128 0
	.4byte	.LASF261
	.byte	0x5
	.uleb128 0
	.4byte	.LASF262
	.byte	0x5
	.uleb128 0
	.4byte	.LASF263
	.byte	0x5
	.uleb128 0
	.4byte	.LASF264
	.byte	0x5
	.uleb128 0
	.4byte	.LASF265
	.byte	0x5
	.uleb128 0
	.4byte	.LASF266
	.byte	0x5
	.uleb128 0
	.4byte	.LASF267
	.byte	0x5
	.uleb128 0
	.4byte	.LASF268
	.byte	0x5
	.uleb128 0
	.4byte	.LASF269
	.byte	0x5
	.uleb128 0
	.4byte	.LASF270
	.byte	0x5
	.uleb128 0
	.4byte	.LASF271
	.byte	0x5
	.uleb128 0
	.4byte	.LASF272
	.byte	0x5
	.uleb128 0
	.4byte	.LASF273
	.byte	0x5
	.uleb128 0
	.4byte	.LASF274
	.byte	0x5
	.uleb128 0
	.4byte	.LASF275
	.byte	0x5
	.uleb128 0
	.4byte	.LASF276
	.byte	0x5
	.uleb128 0
	.4byte	.LASF277
	.byte	0x5
	.uleb128 0
	.4byte	.LASF278
	.byte	0x5
	.uleb128 0
	.4byte	.LASF279
	.byte	0x5
	.uleb128 0
	.4byte	.LASF280
	.byte	0x5
	.uleb128 0
	.4byte	.LASF281
	.byte	0x5
	.uleb128 0
	.4byte	.LASF282
	.byte	0x5
	.uleb128 0
	.4byte	.LASF283
	.byte	0x5
	.uleb128 0
	.4byte	.LASF284
	.byte	0x5
	.uleb128 0
	.4byte	.LASF285
	.byte	0x5
	.uleb128 0
	.4byte	.LASF286
	.byte	0x5
	.uleb128 0
	.4byte	.LASF287
	.byte	0x5
	.uleb128 0
	.4byte	.LASF288
	.byte	0x5
	.uleb128 0
	.4byte	.LASF289
	.byte	0x5
	.uleb128 0
	.4byte	.LASF290
	.byte	0x5
	.uleb128 0
	.4byte	.LASF291
	.byte	0x5
	.uleb128 0
	.4byte	.LASF292
	.byte	0x5
	.uleb128 0
	.4byte	.LASF293
	.byte	0x5
	.uleb128 0
	.4byte	.LASF294
	.byte	0x5
	.uleb128 0
	.4byte	.LASF295
	.byte	0x5
	.uleb128 0
	.4byte	.LASF296
	.byte	0x5
	.uleb128 0
	.4byte	.LASF297
	.byte	0x5
	.uleb128 0
	.4byte	.LASF298
	.byte	0x5
	.uleb128 0
	.4byte	.LASF299
	.byte	0x5
	.uleb128 0
	.4byte	.LASF300
	.byte	0x5
	.uleb128 0
	.4byte	.LASF301
	.byte	0x5
	.uleb128 0
	.4byte	.LASF302
	.byte	0x5
	.uleb128 0
	.4byte	.LASF303
	.byte	0x5
	.uleb128 0
	.4byte	.LASF304
	.byte	0x5
	.uleb128 0
	.4byte	.LASF305
	.byte	0x5
	.uleb128 0
	.4byte	.LASF306
	.byte	0x5
	.uleb128 0
	.4byte	.LASF307
	.byte	0x5
	.uleb128 0
	.4byte	.LASF308
	.byte	0x5
	.uleb128 0
	.4byte	.LASF309
	.byte	0x5
	.uleb128 0
	.4byte	.LASF310
	.byte	0x5
	.uleb128 0
	.4byte	.LASF311
	.byte	0x5
	.uleb128 0
	.4byte	.LASF312
	.byte	0x5
	.uleb128 0
	.4byte	.LASF313
	.byte	0x5
	.uleb128 0
	.4byte	.LASF314
	.byte	0x5
	.uleb128 0
	.4byte	.LASF315
	.byte	0x5
	.uleb128 0
	.4byte	.LASF316
	.byte	0x5
	.uleb128 0
	.4byte	.LASF317
	.byte	0x5
	.uleb128 0
	.4byte	.LASF318
	.byte	0x5
	.uleb128 0
	.4byte	.LASF319
	.byte	0x5
	.uleb128 0
	.4byte	.LASF320
	.byte	0x5
	.uleb128 0
	.4byte	.LASF321
	.byte	0x5
	.uleb128 0
	.4byte	.LASF322
	.byte	0x5
	.uleb128 0
	.4byte	.LASF323
	.byte	0x5
	.uleb128 0
	.4byte	.LASF324
	.byte	0x5
	.uleb128 0
	.4byte	.LASF325
	.byte	0x5
	.uleb128 0
	.4byte	.LASF326
	.byte	0x5
	.uleb128 0
	.4byte	.LASF327
	.byte	0x5
	.uleb128 0
	.4byte	.LASF328
	.byte	0x5
	.uleb128 0
	.4byte	.LASF329
	.byte	0x5
	.uleb128 0
	.4byte	.LASF330
	.byte	0x5
	.uleb128 0
	.4byte	.LASF331
	.byte	0x5
	.uleb128 0
	.4byte	.LASF332
	.byte	0x5
	.uleb128 0
	.4byte	.LASF333
	.byte	0x5
	.uleb128 0
	.4byte	.LASF334
	.byte	0x5
	.uleb128 0
	.4byte	.LASF335
	.byte	0x5
	.uleb128 0
	.4byte	.LASF336
	.byte	0x5
	.uleb128 0
	.4byte	.LASF337
	.byte	0x5
	.uleb128 0
	.4byte	.LASF338
	.byte	0x5
	.uleb128 0
	.4byte	.LASF339
	.byte	0x5
	.uleb128 0
	.4byte	.LASF340
	.byte	0x5
	.uleb128 0
	.4byte	.LASF341
	.byte	0x5
	.uleb128 0
	.4byte	.LASF342
	.byte	0x5
	.uleb128 0
	.4byte	.LASF343
	.byte	0x5
	.uleb128 0
	.4byte	.LASF344
	.byte	0x5
	.uleb128 0
	.4byte	.LASF345
	.byte	0x5
	.uleb128 0
	.4byte	.LASF346
	.byte	0x5
	.uleb128 0
	.4byte	.LASF347
	.byte	0x5
	.uleb128 0
	.4byte	.LASF348
	.byte	0x5
	.uleb128 0
	.4byte	.LASF349
	.byte	0x5
	.uleb128 0
	.4byte	.LASF350
	.byte	0x5
	.uleb128 0
	.4byte	.LASF351
	.byte	0x5
	.uleb128 0
	.4byte	.LASF352
	.byte	0x5
	.uleb128 0
	.4byte	.LASF353
	.byte	0x5
	.uleb128 0
	.4byte	.LASF354
	.byte	0x5
	.uleb128 0
	.4byte	.LASF355
	.byte	0x5
	.uleb128 0
	.4byte	.LASF356
	.byte	0x5
	.uleb128 0
	.4byte	.LASF357
	.byte	0x5
	.uleb128 0
	.4byte	.LASF358
	.byte	0x5
	.uleb128 0
	.4byte	.LASF359
	.byte	0x5
	.uleb128 0
	.4byte	.LASF360
	.byte	0x5
	.uleb128 0
	.4byte	.LASF361
	.byte	0x5
	.uleb128 0
	.4byte	.LASF362
	.byte	0x5
	.uleb128 0
	.4byte	.LASF363
	.byte	0x5
	.uleb128 0
	.4byte	.LASF364
	.byte	0x5
	.uleb128 0
	.4byte	.LASF365
	.byte	0x5
	.uleb128 0
	.4byte	.LASF366
	.byte	0x5
	.uleb128 0
	.4byte	.LASF367
	.byte	0x5
	.uleb128 0
	.4byte	.LASF368
	.byte	0x5
	.uleb128 0
	.4byte	.LASF369
	.byte	0x5
	.uleb128 0
	.4byte	.LASF370
	.byte	0x5
	.uleb128 0
	.4byte	.LASF371
	.byte	0x5
	.uleb128 0
	.4byte	.LASF372
	.byte	0x5
	.uleb128 0
	.4byte	.LASF373
	.byte	0x5
	.uleb128 0
	.4byte	.LASF374
	.byte	0x5
	.uleb128 0
	.4byte	.LASF375
	.byte	0x5
	.uleb128 0
	.4byte	.LASF376
	.byte	0x5
	.uleb128 0
	.4byte	.LASF377
	.byte	0x5
	.uleb128 0
	.4byte	.LASF378
	.byte	0x5
	.uleb128 0
	.4byte	.LASF379
	.byte	0x5
	.uleb128 0
	.4byte	.LASF380
	.byte	0x5
	.uleb128 0
	.4byte	.LASF381
	.byte	0x5
	.uleb128 0
	.4byte	.LASF382
	.byte	0x5
	.uleb128 0
	.4byte	.LASF383
	.byte	0x5
	.uleb128 0
	.4byte	.LASF384
	.byte	0x5
	.uleb128 0
	.4byte	.LASF385
	.byte	0x5
	.uleb128 0
	.4byte	.LASF386
	.byte	0x5
	.uleb128 0
	.4byte	.LASF387
	.byte	0x5
	.uleb128 0
	.4byte	.LASF388
	.byte	0x5
	.uleb128 0
	.4byte	.LASF389
	.byte	0x5
	.uleb128 0
	.4byte	.LASF390
	.byte	0x5
	.uleb128 0
	.4byte	.LASF391
	.byte	0x5
	.uleb128 0
	.4byte	.LASF392
	.byte	0x5
	.uleb128 0
	.4byte	.LASF393
	.byte	0x5
	.uleb128 0
	.4byte	.LASF394
	.byte	0x5
	.uleb128 0
	.4byte	.LASF395
	.byte	0x6
	.uleb128 0
	.4byte	.LASF396
	.byte	0x5
	.uleb128 0
	.4byte	.LASF397
	.byte	0x6
	.uleb128 0
	.4byte	.LASF398
	.byte	0x6
	.uleb128 0
	.4byte	.LASF399
	.byte	0x6
	.uleb128 0
	.4byte	.LASF400
	.byte	0x6
	.uleb128 0
	.4byte	.LASF401
	.byte	0x5
	.uleb128 0
	.4byte	.LASF402
	.byte	0x6
	.uleb128 0
	.4byte	.LASF403
	.byte	0x6
	.uleb128 0
	.4byte	.LASF404
	.byte	0x6
	.uleb128 0
	.4byte	.LASF405
	.byte	0x5
	.uleb128 0
	.4byte	.LASF406
	.byte	0x5
	.uleb128 0
	.4byte	.LASF407
	.byte	0x6
	.uleb128 0
	.4byte	.LASF408
	.byte	0x5
	.uleb128 0
	.4byte	.LASF409
	.byte	0x5
	.uleb128 0
	.4byte	.LASF410
	.byte	0x5
	.uleb128 0
	.4byte	.LASF411
	.byte	0x6
	.uleb128 0
	.4byte	.LASF412
	.byte	0x5
	.uleb128 0
	.4byte	.LASF413
	.byte	0x5
	.uleb128 0
	.4byte	.LASF414
	.byte	0x6
	.uleb128 0
	.4byte	.LASF415
	.byte	0x5
	.uleb128 0
	.4byte	.LASF416
	.byte	0x5
	.uleb128 0
	.4byte	.LASF417
	.byte	0x5
	.uleb128 0
	.4byte	.LASF418
	.byte	0x5
	.uleb128 0
	.4byte	.LASF419
	.byte	0x5
	.uleb128 0
	.4byte	.LASF420
	.byte	0x5
	.uleb128 0
	.4byte	.LASF421
	.byte	0x6
	.uleb128 0
	.4byte	.LASF422
	.byte	0x5
	.uleb128 0
	.4byte	.LASF423
	.byte	0x5
	.uleb128 0
	.4byte	.LASF424
	.byte	0x5
	.uleb128 0
	.4byte	.LASF425
	.byte	0x6
	.uleb128 0
	.4byte	.LASF426
	.byte	0x5
	.uleb128 0
	.4byte	.LASF427
	.byte	0x5
	.uleb128 0
	.4byte	.LASF428
	.byte	0x6
	.uleb128 0
	.4byte	.LASF429
	.byte	0x5
	.uleb128 0
	.4byte	.LASF430
	.byte	0x6
	.uleb128 0
	.4byte	.LASF431
	.byte	0x6
	.uleb128 0
	.4byte	.LASF432
	.byte	0x6
	.uleb128 0
	.4byte	.LASF433
	.byte	0x5
	.uleb128 0
	.4byte	.LASF434
	.byte	0x6
	.uleb128 0
	.4byte	.LASF435
	.byte	0x6
	.uleb128 0
	.4byte	.LASF436
	.byte	0x6
	.uleb128 0
	.4byte	.LASF437
	.byte	0x5
	.uleb128 0
	.4byte	.LASF438
	.byte	0x5
	.uleb128 0
	.4byte	.LASF439
	.byte	0x5
	.uleb128 0
	.4byte	.LASF440
	.byte	0x5
	.uleb128 0
	.4byte	.LASF441
	.byte	0x6
	.uleb128 0
	.4byte	.LASF442
	.byte	0x5
	.uleb128 0
	.4byte	.LASF443
	.byte	0x5
	.uleb128 0
	.4byte	.LASF444
	.byte	0x5
	.uleb128 0
	.4byte	.LASF445
	.byte	0x6
	.uleb128 0
	.4byte	.LASF446
	.byte	0x5
	.uleb128 0
	.4byte	.LASF447
	.byte	0x6
	.uleb128 0
	.4byte	.LASF448
	.byte	0x6
	.uleb128 0
	.4byte	.LASF449
	.byte	0x6
	.uleb128 0
	.4byte	.LASF450
	.byte	0x6
	.uleb128 0
	.4byte	.LASF451
	.byte	0x6
	.uleb128 0
	.4byte	.LASF452
	.byte	0x6
	.uleb128 0
	.4byte	.LASF453
	.byte	0x5
	.uleb128 0
	.4byte	.LASF454
	.byte	0x5
	.uleb128 0
	.4byte	.LASF455
	.byte	0x5
	.uleb128 0
	.4byte	.LASF456
	.byte	0x5
	.uleb128 0
	.4byte	.LASF439
	.byte	0x5
	.uleb128 0
	.4byte	.LASF457
	.byte	0x5
	.uleb128 0
	.4byte	.LASF458
	.byte	0x5
	.uleb128 0
	.4byte	.LASF459
	.byte	0x5
	.uleb128 0
	.4byte	.LASF460
	.byte	0x5
	.uleb128 0
	.4byte	.LASF461
	.byte	0x5
	.uleb128 0
	.4byte	.LASF462
	.byte	0x5
	.uleb128 0
	.4byte	.LASF463
	.byte	0x5
	.uleb128 0
	.4byte	.LASF464
	.byte	0x5
	.uleb128 0
	.4byte	.LASF465
	.byte	0x5
	.uleb128 0
	.4byte	.LASF466
	.byte	0x5
	.uleb128 0
	.4byte	.LASF467
	.byte	0x5
	.uleb128 0
	.4byte	.LASF468
	.byte	0x5
	.uleb128 0
	.4byte	.LASF469
	.byte	0x5
	.uleb128 0
	.4byte	.LASF470
	.byte	0x5
	.uleb128 0
	.4byte	.LASF471
	.byte	0x5
	.uleb128 0
	.4byte	.LASF472
	.byte	0
	.section	.debug_macro,"G",%progbits,wm4.__crossworks.h.39.ff21eb83ebfc80fb95245a821dd1e413,comdat
.Ldebug_macro3:
	.2byte	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x27
	.4byte	.LASF477
	.byte	0x5
	.uleb128 0x3b
	.4byte	.LASF478
	.byte	0x6
	.uleb128 0x3d
	.4byte	.LASF479
	.byte	0x5
	.uleb128 0x3f
	.4byte	.LASF480
	.byte	0x5
	.uleb128 0x43
	.4byte	.LASF481
	.byte	0x5
	.uleb128 0x45
	.4byte	.LASF482
	.byte	0x5
	.uleb128 0x56
	.4byte	.LASF483
	.byte	0x5
	.uleb128 0x5d
	.4byte	.LASF478
	.byte	0x5
	.uleb128 0x63
	.4byte	.LASF484
	.byte	0x5
	.uleb128 0x64
	.4byte	.LASF485
	.byte	0x5
	.uleb128 0x65
	.4byte	.LASF486
	.byte	0x5
	.uleb128 0x66
	.4byte	.LASF487
	.byte	0x5
	.uleb128 0x67
	.4byte	.LASF488
	.byte	0x5
	.uleb128 0x68
	.4byte	.LASF489
	.byte	0x5
	.uleb128 0x69
	.4byte	.LASF490
	.byte	0x5
	.uleb128 0x6a
	.4byte	.LASF491
	.byte	0x5
	.uleb128 0x6d
	.4byte	.LASF492
	.byte	0x5
	.uleb128 0x6e
	.4byte	.LASF493
	.byte	0x5
	.uleb128 0x6f
	.4byte	.LASF494
	.byte	0x5
	.uleb128 0x70
	.4byte	.LASF495
	.byte	0x5
	.uleb128 0x73
	.4byte	.LASF496
	.byte	0x5
	.uleb128 0xd8
	.4byte	.LASF497
	.byte	0
	.section	.debug_macro,"G",%progbits,wm4.stdlib.h.48.46499b9a2c5c0782586f14a39a906a6b,comdat
.Ldebug_macro4:
	.2byte	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x30
	.4byte	.LASF498
	.byte	0x5
	.uleb128 0x35
	.4byte	.LASF499
	.byte	0x5
	.uleb128 0x3a
	.4byte	.LASF500
	.byte	0x5
	.uleb128 0x42
	.4byte	.LASF501
	.byte	0x5
	.uleb128 0x49
	.4byte	.LASF502
	.byte	0x5
	.uleb128 0x51
	.4byte	.LASF503
	.byte	0x5
	.uleb128 0x5b
	.4byte	.LASF504
	.byte	0
	.section	.debug_macro,"G",%progbits,wm4.stdint.h.39.fe42d6eb18d369206696c6985313e641,comdat
.Ldebug_macro5:
	.2byte	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x27
	.4byte	.LASF505
	.byte	0x5
	.uleb128 0x79
	.4byte	.LASF506
	.byte	0x5
	.uleb128 0x7b
	.4byte	.LASF507
	.byte	0x5
	.uleb128 0x7c
	.4byte	.LASF508
	.byte	0x5
	.uleb128 0x7e
	.4byte	.LASF509
	.byte	0x5
	.uleb128 0x80
	.4byte	.LASF510
	.byte	0x5
	.uleb128 0x81
	.4byte	.LASF511
	.byte	0x5
	.uleb128 0x83
	.4byte	.LASF512
	.byte	0x5
	.uleb128 0x84
	.4byte	.LASF513
	.byte	0x5
	.uleb128 0x85
	.4byte	.LASF514
	.byte	0x5
	.uleb128 0x87
	.4byte	.LASF515
	.byte	0x5
	.uleb128 0x88
	.4byte	.LASF516
	.byte	0x5
	.uleb128 0x89
	.4byte	.LASF517
	.byte	0x5
	.uleb128 0x8b
	.4byte	.LASF518
	.byte	0x5
	.uleb128 0x8c
	.4byte	.LASF519
	.byte	0x5
	.uleb128 0x8d
	.4byte	.LASF520
	.byte	0x5
	.uleb128 0x90
	.4byte	.LASF521
	.byte	0x5
	.uleb128 0x91
	.4byte	.LASF522
	.byte	0x5
	.uleb128 0x92
	.4byte	.LASF523
	.byte	0x5
	.uleb128 0x93
	.4byte	.LASF524
	.byte	0x5
	.uleb128 0x94
	.4byte	.LASF525
	.byte	0x5
	.uleb128 0x95
	.4byte	.LASF526
	.byte	0x5
	.uleb128 0x96
	.4byte	.LASF527
	.byte	0x5
	.uleb128 0x97
	.4byte	.LASF528
	.byte	0x5
	.uleb128 0x98
	.4byte	.LASF529
	.byte	0x5
	.uleb128 0x99
	.4byte	.LASF530
	.byte	0x5
	.uleb128 0x9a
	.4byte	.LASF531
	.byte	0x5
	.uleb128 0x9b
	.4byte	.LASF532
	.byte	0x5
	.uleb128 0x9d
	.4byte	.LASF533
	.byte	0x5
	.uleb128 0x9e
	.4byte	.LASF534
	.byte	0x5
	.uleb128 0x9f
	.4byte	.LASF535
	.byte	0x5
	.uleb128 0xa0
	.4byte	.LASF536
	.byte	0x5
	.uleb128 0xa1
	.4byte	.LASF537
	.byte	0x5
	.uleb128 0xa2
	.4byte	.LASF538
	.byte	0x5
	.uleb128 0xa3
	.4byte	.LASF539
	.byte	0x5
	.uleb128 0xa4
	.4byte	.LASF540
	.byte	0x5
	.uleb128 0xa5
	.4byte	.LASF541
	.byte	0x5
	.uleb128 0xa6
	.4byte	.LASF542
	.byte	0x5
	.uleb128 0xa7
	.4byte	.LASF543
	.byte	0x5
	.uleb128 0xa8
	.4byte	.LASF544
	.byte	0x5
	.uleb128 0xad
	.4byte	.LASF545
	.byte	0x5
	.uleb128 0xae
	.4byte	.LASF546
	.byte	0x5
	.uleb128 0xaf
	.4byte	.LASF547
	.byte	0x5
	.uleb128 0xb1
	.4byte	.LASF548
	.byte	0x5
	.uleb128 0xb2
	.4byte	.LASF549
	.byte	0x5
	.uleb128 0xb3
	.4byte	.LASF550
	.byte	0x5
	.uleb128 0xc3
	.4byte	.LASF551
	.byte	0x5
	.uleb128 0xc4
	.4byte	.LASF552
	.byte	0x5
	.uleb128 0xc5
	.4byte	.LASF553
	.byte	0x5
	.uleb128 0xc6
	.4byte	.LASF554
	.byte	0x5
	.uleb128 0xc7
	.4byte	.LASF555
	.byte	0x5
	.uleb128 0xc8
	.4byte	.LASF556
	.byte	0x5
	.uleb128 0xc9
	.4byte	.LASF557
	.byte	0x5
	.uleb128 0xca
	.4byte	.LASF558
	.byte	0x5
	.uleb128 0xcc
	.4byte	.LASF559
	.byte	0x5
	.uleb128 0xcd
	.4byte	.LASF560
	.byte	0x5
	.uleb128 0xd7
	.4byte	.LASF561
	.byte	0x5
	.uleb128 0xd8
	.4byte	.LASF562
	.byte	0x5
	.uleb128 0xe3
	.4byte	.LASF563
	.byte	0x5
	.uleb128 0xe4
	.4byte	.LASF564
	.byte	0
	.section	.debug_macro,"G",%progbits,wm4.stdbool.h.39.3758cb47b714dfcbf7837a03b10a6ad6,comdat
.Ldebug_macro6:
	.2byte	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x27
	.4byte	.LASF565
	.byte	0x5
	.uleb128 0x2b
	.4byte	.LASF566
	.byte	0x5
	.uleb128 0x2f
	.4byte	.LASF567
	.byte	0x5
	.uleb128 0x30
	.4byte	.LASF568
	.byte	0x5
	.uleb128 0x32
	.4byte	.LASF569
	.byte	0
	.section	.debug_macro,"G",%progbits,wm4.sensirion_common.h.41.43ccc8be77c3e6633975b413ab3f9e5b,comdat
.Ldebug_macro7:
	.2byte	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x29
	.4byte	.LASF570
	.byte	0x5
	.uleb128 0x2a
	.4byte	.LASF571
	.byte	0x5
	.uleb128 0x2d
	.4byte	.LASF572
	.byte	0x5
	.uleb128 0x30
	.4byte	.LASF573
	.byte	0x5
	.uleb128 0x31
	.4byte	.LASF574
	.byte	0x5
	.uleb128 0x32
	.4byte	.LASF575
	.byte	0x5
	.uleb128 0x33
	.4byte	.LASF576
	.byte	0
	.section	.debug_macro,"G",%progbits,wm4.sensirion_i2c.h.33.3e6706c398696b4ca211e48a502e08b9,comdat
.Ldebug_macro8:
	.2byte	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x21
	.4byte	.LASF577
	.byte	0x5
	.uleb128 0x29
	.4byte	.LASF578
	.byte	0x5
	.uleb128 0x2a
	.4byte	.LASF579
	.byte	0x5
	.uleb128 0x2b
	.4byte	.LASF580
	.byte	0x5
	.uleb128 0x2c
	.4byte	.LASF581
	.byte	0x5
	.uleb128 0x2e
	.4byte	.LASF582
	.byte	0x5
	.uleb128 0x2f
	.4byte	.LASF583
	.byte	0x5
	.uleb128 0x30
	.4byte	.LASF584
	.byte	0x5
	.uleb128 0x32
	.4byte	.LASF573
	.byte	0x5
	.uleb128 0x33
	.4byte	.LASF574
	.byte	0x5
	.uleb128 0x34
	.4byte	.LASF575
	.byte	0x5
	.uleb128 0x35
	.4byte	.LASF576
	.byte	0
	.section	.debug_macro,"G",%progbits,wm4.sgp30.h.39.049d8d074f8f98efffaba6dd79710c19,comdat
.Ldebug_macro9:
	.2byte	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x27
	.4byte	.LASF586
	.byte	0x5
	.uleb128 0x28
	.4byte	.LASF587
	.byte	0x5
	.uleb128 0x2a
	.4byte	.LASF588
	.byte	0x5
	.uleb128 0x2b
	.4byte	.LASF589
	.byte	0
	.section	.debug_line,"",%progbits
.Ldebug_line0:
	.section	.debug_str,"MS",%progbits,1
.LASF169:
	.ascii	"__DBL_NORM_MAX__ ((double)1.1)\000"
.LASF93:
	.ascii	"__SIG_ATOMIC_MAX__ 0x7fffffff\000"
.LASF237:
	.ascii	"__FLT64_HAS_QUIET_NAN__ 1\000"
.LASF424:
	.ascii	"__ARMEL__ 1\000"
.LASF382:
	.ascii	"__GCC_ATOMIC_SHORT_LOCK_FREE 2\000"
.LASF195:
	.ascii	"__FLT16_MIN_10_EXP__ (-4)\000"
.LASF220:
	.ascii	"__FLT32_HAS_INFINITY__ 1\000"
.LASF518:
	.ascii	"INTMAX_MIN (-9223372036854775807LL-1)\000"
.LASF61:
	.ascii	"__UINT_FAST8_TYPE__ unsigned int\000"
.LASF227:
	.ascii	"__FLT64_MAX_EXP__ 1024\000"
.LASF332:
	.ascii	"__ULLACCUM_EPSILON__ 0x1P-32ULLK\000"
.LASF473:
	.ascii	"SGP30_H \000"
.LASF420:
	.ascii	"__thumb2__ 1\000"
.LASF242:
	.ascii	"__FLT32X_MAX_EXP__ 1024\000"
.LASF127:
	.ascii	"__INT_FAST16_WIDTH__ 32\000"
.LASF63:
	.ascii	"__UINT_FAST32_TYPE__ unsigned int\000"
.LASF553:
	.ascii	"INT16_C(x) (x)\000"
.LASF576:
	.ascii	"SENSIRION_MAX_BUFFER_WORDS 32\000"
.LASF467:
	.ascii	"FLOAT_ABI_HARD 1\000"
.LASF322:
	.ascii	"__ULACCUM_EPSILON__ 0x1P-32ULK\000"
.LASF496:
	.ascii	"__RAL_WCHAR_T __WCHAR_TYPE__\000"
.LASF214:
	.ascii	"__FLT32_MAX__ 1.1\000"
.LASF459:
	.ascii	"__HEAP_SIZE__ 8192\000"
.LASF207:
	.ascii	"__FLT32_MANT_DIG__ 24\000"
.LASF623:
	.ascii	"char\000"
.LASF117:
	.ascii	"__UINT8_C(c) c\000"
.LASF435:
	.ascii	"__ARM_NEON__\000"
.LASF391:
	.ascii	"__SIZEOF_WINT_T__ 4\000"
.LASF334:
	.ascii	"__QQ_IBIT__ 0\000"
.LASF350:
	.ascii	"__UDQ_IBIT__ 0\000"
.LASF244:
	.ascii	"__FLT32X_DECIMAL_DIG__ 17\000"
.LASF163:
	.ascii	"__DBL_MIN_EXP__ (-1021)\000"
.LASF83:
	.ascii	"__LONG_LONG_WIDTH__ 64\000"
.LASF379:
	.ascii	"__GCC_ATOMIC_CHAR16_T_LOCK_FREE 2\000"
.LASF449:
	.ascii	"__ARM_FEATURE_CDE_COPROC\000"
.LASF411:
	.ascii	"__ARM_SIZEOF_WCHAR_T 4\000"
.LASF613:
	.ascii	"SGP30_CMD_RAW_MEASURE_DURATION_US 25000\000"
.LASF401:
	.ascii	"__ARM_FEATURE_COMPLEX\000"
.LASF284:
	.ascii	"__LLFRACT_IBIT__ 0\000"
.LASF609:
	.ascii	"SGP30_CMD_GET_IAQ_BASELINE_WORDS 2\000"
.LASF439:
	.ascii	"__ARM_ARCH_7EM__ 1\000"
.LASF260:
	.ascii	"__USFRACT_MIN__ 0.0UHR\000"
.LASF76:
	.ascii	"__WINT_MIN__ 0U\000"
.LASF6:
	.ascii	"__GNUC_MINOR__ 3\000"
.LASF155:
	.ascii	"__FLT_EPSILON__ 1.1\000"
.LASF658:
	.ascii	"ethanol_raw_signal\000"
.LASF445:
	.ascii	"__ARM_ASM_SYNTAX_UNIFIED__ 1\000"
.LASF531:
	.ascii	"UINT_LEAST32_MAX UINT32_MAX\000"
.LASF624:
	.ascii	"unsigned int\000"
.LASF396:
	.ascii	"__ARM_FEATURE_CRYPTO\000"
.LASF119:
	.ascii	"__UINT16_C(c) c\000"
.LASF23:
	.ascii	"__SIZEOF_SIZE_T__ 4\000"
.LASF38:
	.ascii	"__CHAR16_TYPE__ short unsigned int\000"
.LASF22:
	.ascii	"__SIZEOF_LONG_DOUBLE__ 8\000"
.LASF152:
	.ascii	"__FLT_MAX__ 1.1\000"
.LASF124:
	.ascii	"__INT_FAST8_MAX__ 0x7fffffff\000"
.LASF27:
	.ascii	"__ORDER_BIG_ENDIAN__ 4321\000"
.LASF291:
	.ascii	"__ULLFRACT_MAX__ 0XFFFFFFFFFFFFFFFFP-64ULLR\000"
.LASF465:
	.ascii	"BSP_DEFINES_ONLY 1\000"
.LASF393:
	.ascii	"__ARM_FEATURE_DSP 1\000"
.LASF197:
	.ascii	"__FLT16_MAX_10_EXP__ 4\000"
.LASF367:
	.ascii	"__UTA_FBIT__ 64\000"
.LASF161:
	.ascii	"__DBL_MANT_DIG__ 53\000"
.LASF56:
	.ascii	"__UINT_LEAST64_TYPE__ long long unsigned int\000"
.LASF248:
	.ascii	"__FLT32X_EPSILON__ 1.1\000"
.LASF70:
	.ascii	"__INT_MAX__ 0x7fffffff\000"
.LASF12:
	.ascii	"__ATOMIC_RELEASE 3\000"
.LASF193:
	.ascii	"__FLT16_DIG__ 3\000"
.LASF373:
	.ascii	"__CHAR_UNSIGNED__ 1\000"
.LASF42:
	.ascii	"__INT16_TYPE__ short int\000"
.LASF398:
	.ascii	"__ARM_FEATURE_QRDMX\000"
.LASF177:
	.ascii	"__LDBL_DIG__ 15\000"
.LASF247:
	.ascii	"__FLT32X_MIN__ 1.1\000"
.LASF529:
	.ascii	"UINT_LEAST8_MAX UINT8_MAX\000"
.LASF324:
	.ascii	"__LLACCUM_IBIT__ 32\000"
.LASF10:
	.ascii	"__ATOMIC_SEQ_CST 5\000"
.LASF469:
	.ascii	"NO_VTOR_CONFIG 1\000"
.LASF606:
	.ascii	"SGP30_CMD_IAQ_MEASURE_WORDS 2\000"
.LASF19:
	.ascii	"__SIZEOF_SHORT__ 2\000"
.LASF187:
	.ascii	"__LDBL_EPSILON__ 1.1\000"
.LASF200:
	.ascii	"__FLT16_NORM_MAX__ 1.1\000"
.LASF49:
	.ascii	"__INT_LEAST8_TYPE__ signed char\000"
.LASF402:
	.ascii	"__ARM_32BIT_STATE 1\000"
.LASF666:
	.ascii	"sgp30_measure_co2_eq\000"
.LASF676:
	.ascii	"needed_fs\000"
.LASF29:
	.ascii	"__BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__\000"
.LASF646:
	.ascii	"sgp30_get_configured_address\000"
.LASF654:
	.ascii	"sgp30_set_iaq_baseline\000"
.LASF210:
	.ascii	"__FLT32_MIN_10_EXP__ (-37)\000"
.LASF587:
	.ascii	"SGP30_ERR_INVALID_PRODUCT_TYPE (-12)\000"
.LASF274:
	.ascii	"__LFRACT_IBIT__ 0\000"
.LASF638:
	.ascii	"sgp30_iaq_init\000"
.LASF534:
	.ascii	"INT_FAST16_MIN INT32_MIN\000"
.LASF416:
	.ascii	"__ARM_ARCH 7\000"
.LASF3:
	.ascii	"__STDC_UTF_32__ 1\000"
.LASF107:
	.ascii	"__INT_LEAST16_MAX__ 0x7fff\000"
.LASF68:
	.ascii	"__SCHAR_MAX__ 0x7f\000"
.LASF329:
	.ascii	"__ULLACCUM_IBIT__ 32\000"
.LASF408:
	.ascii	"__ARM_FEATURE_NUMERIC_MAXMIN\000"
.LASF289:
	.ascii	"__ULLFRACT_IBIT__ 0\000"
.LASF224:
	.ascii	"__FLT64_DIG__ 15\000"
.LASF527:
	.ascii	"INT_LEAST32_MAX INT32_MAX\000"
.LASF9:
	.ascii	"__ATOMIC_RELAXED 0\000"
.LASF174:
	.ascii	"__DBL_HAS_INFINITY__ 1\000"
.LASF433:
	.ascii	"__ARM_FEATURE_FP16_FML\000"
.LASF78:
	.ascii	"__SIZE_MAX__ 0xffffffffU\000"
.LASF584:
	.ascii	"CRC8_LEN 1\000"
.LASF653:
	.ascii	"tvoc_inceptive_baseline\000"
.LASF315:
	.ascii	"__LACCUM_MIN__ (-0X1P31LK-0X1P31LK)\000"
.LASF331:
	.ascii	"__ULLACCUM_MAX__ 0XFFFFFFFFFFFFFFFFP-32ULLK\000"
.LASF320:
	.ascii	"__ULACCUM_MIN__ 0.0ULK\000"
.LASF251:
	.ascii	"__FLT32X_HAS_INFINITY__ 1\000"
.LASF158:
	.ascii	"__FLT_HAS_INFINITY__ 1\000"
.LASF53:
	.ascii	"__UINT_LEAST8_TYPE__ unsigned char\000"
.LASF366:
	.ascii	"__UDA_IBIT__ 32\000"
.LASF539:
	.ascii	"INT_FAST32_MAX INT32_MAX\000"
.LASF570:
	.ascii	"NO_ERROR 0\000"
.LASF60:
	.ascii	"__INT_FAST64_TYPE__ long long int\000"
.LASF105:
	.ascii	"__INT8_C(c) c\000"
.LASF222:
	.ascii	"__FP_FAST_FMAF32 1\000"
.LASF628:
	.ascii	"signed char\000"
.LASF442:
	.ascii	"__FDPIC__\000"
.LASF249:
	.ascii	"__FLT32X_DENORM_MIN__ 1.1\000"
.LASF109:
	.ascii	"__INT_LEAST16_WIDTH__ 16\000"
.LASF543:
	.ascii	"UINT_FAST32_MAX UINT32_MAX\000"
.LASF330:
	.ascii	"__ULLACCUM_MIN__ 0.0ULLK\000"
.LASF633:
	.ascii	"uint32_t\000"
.LASF400:
	.ascii	"__ARM_FEATURE_DOTPROD\000"
.LASF436:
	.ascii	"__ARM_NEON\000"
.LASF566:
	.ascii	"bool _Bool\000"
.LASF77:
	.ascii	"__PTRDIFF_MAX__ 0x7fffffff\000"
.LASF404:
	.ascii	"__ARM_FEATURE_CMSE\000"
.LASF66:
	.ascii	"__UINTPTR_TYPE__ unsigned int\000"
.LASF673:
	.ascii	"sgp30_measure_test\000"
.LASF219:
	.ascii	"__FLT32_HAS_DENORM__ 1\000"
.LASF479:
	.ascii	"__RAL_SIZE_T\000"
.LASF374:
	.ascii	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 1\000"
.LASF555:
	.ascii	"INT32_C(x) (x ##L)\000"
.LASF541:
	.ascii	"UINT_FAST8_MAX UINT8_MAX\000"
.LASF356:
	.ascii	"__SA_IBIT__ 16\000"
.LASF286:
	.ascii	"__LLFRACT_MAX__ 0X7FFFFFFFFFFFFFFFP-63LLR\000"
.LASF663:
	.ascii	"co2_eq_ppm\000"
.LASF160:
	.ascii	"__FP_FAST_FMAF 1\000"
.LASF146:
	.ascii	"__FLT_DIG__ 6\000"
.LASF126:
	.ascii	"__INT_FAST16_MAX__ 0x7fffffff\000"
.LASF377:
	.ascii	"__GCC_ATOMIC_BOOL_LOCK_FREE 2\000"
.LASF375:
	.ascii	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 1\000"
.LASF498:
	.ascii	"__RAL_SIZE_T_DEFINED \000"
.LASF357:
	.ascii	"__DA_FBIT__ 31\000"
.LASF192:
	.ascii	"__FLT16_MANT_DIG__ 11\000"
.LASF661:
	.ascii	"sgp30_measure_raw_blocking_read\000"
.LASF302:
	.ascii	"__USACCUM_EPSILON__ 0x1P-8UHK\000"
.LASF630:
	.ascii	"int16_t\000"
.LASF221:
	.ascii	"__FLT32_HAS_QUIET_NAN__ 1\000"
.LASF118:
	.ascii	"__UINT_LEAST16_MAX__ 0xffff\000"
.LASF271:
	.ascii	"__UFRACT_MAX__ 0XFFFFP-16UR\000"
.LASF256:
	.ascii	"__SFRACT_MAX__ 0X7FP-7HR\000"
.LASF441:
	.ascii	"__ARM_EABI__ 1\000"
.LASF635:
	.ascii	"long long unsigned int\000"
.LASF99:
	.ascii	"__INT64_MAX__ 0x7fffffffffffffffLL\000"
.LASF607:
	.ascii	"SGP30_CMD_GET_IAQ_BASELINE 0x2015\000"
.LASF578:
	.ascii	"CRC_ERROR 1\000"
.LASF96:
	.ascii	"__INT8_MAX__ 0x7f\000"
.LASF282:
	.ascii	"__ULFRACT_EPSILON__ 0x1P-32ULR\000"
.LASF51:
	.ascii	"__INT_LEAST32_TYPE__ long int\000"
.LASF488:
	.ascii	"__CTYPE_PUNCT 0x10\000"
.LASF279:
	.ascii	"__ULFRACT_IBIT__ 0\000"
.LASF323:
	.ascii	"__LLACCUM_FBIT__ 31\000"
.LASF526:
	.ascii	"INT_LEAST16_MAX INT16_MAX\000"
.LASF122:
	.ascii	"__UINT_LEAST64_MAX__ 0xffffffffffffffffULL\000"
.LASF144:
	.ascii	"__FLT_RADIX__ 2\000"
.LASF130:
	.ascii	"__INT_FAST64_MAX__ 0x7fffffffffffffffLL\000"
.LASF290:
	.ascii	"__ULLFRACT_MIN__ 0.0ULLR\000"
.LASF175:
	.ascii	"__DBL_HAS_QUIET_NAN__ 1\000"
.LASF310:
	.ascii	"__UACCUM_MIN__ 0.0UK\000"
.LASF490:
	.ascii	"__CTYPE_BLANK 0x40\000"
.LASF277:
	.ascii	"__LFRACT_EPSILON__ 0x1P-31LR\000"
.LASF57:
	.ascii	"__INT_FAST8_TYPE__ int\000"
.LASF474:
	.ascii	"SENSIRION_COMMON_H \000"
.LASF619:
	.ascii	"SGP30_CMD_GET_TVOC_INCEPTIVE_BASELINE_WORDS 1\000"
.LASF236:
	.ascii	"__FLT64_HAS_INFINITY__ 1\000"
.LASF573:
	.ascii	"SENSIRION_COMMAND_SIZE 2\000"
.LASF458:
	.ascii	"__ARM_ARCH_FPV4_SP_D16__ 1\000"
.LASF218:
	.ascii	"__FLT32_DENORM_MIN__ 1.1\000"
.LASF431:
	.ascii	"__ARM_FEATURE_FP16_SCALAR_ARITHMETIC\000"
.LASF484:
	.ascii	"__CTYPE_UPPER 0x01\000"
.LASF293:
	.ascii	"__SACCUM_FBIT__ 7\000"
.LASF34:
	.ascii	"__WCHAR_TYPE__ unsigned int\000"
.LASF216:
	.ascii	"__FLT32_MIN__ 1.1\000"
.LASF413:
	.ascii	"__ARM_ARCH_PROFILE 77\000"
.LASF656:
	.ascii	"sgp30_get_iaq_baseline\000"
.LASF456:
	.ascii	"__SIZEOF_WCHAR_T 4\000"
.LASF265:
	.ascii	"__FRACT_MIN__ (-0.5R-0.5R)\000"
.LASF481:
	.ascii	"__RAL_SIZE_MAX 4294967295UL\000"
.LASF383:
	.ascii	"__GCC_ATOMIC_INT_LOCK_FREE 2\000"
.LASF88:
	.ascii	"__INTMAX_MAX__ 0x7fffffffffffffffLL\000"
.LASF562:
	.ascii	"WCHAR_MAX __WCHAR_MAX__\000"
.LASF312:
	.ascii	"__UACCUM_EPSILON__ 0x1P-16UK\000"
.LASF513:
	.ascii	"INT32_MAX 2147483647L\000"
.LASF202:
	.ascii	"__FLT16_EPSILON__ 1.1\000"
.LASF304:
	.ascii	"__ACCUM_IBIT__ 16\000"
.LASF115:
	.ascii	"__INT_LEAST64_WIDTH__ 64\000"
.LASF464:
	.ascii	"BOARD_PCA10040 1\000"
.LASF652:
	.ascii	"sgp30_get_tvoc_inceptive_baseline\000"
.LASF228:
	.ascii	"__FLT64_MAX_10_EXP__ 308\000"
.LASF294:
	.ascii	"__SACCUM_IBIT__ 8\000"
.LASF392:
	.ascii	"__SIZEOF_PTRDIFF_T__ 4\000"
.LASF389:
	.ascii	"__PRAGMA_REDEFINE_EXTNAME 1\000"
.LASF510:
	.ascii	"INT16_MIN (-32767-1)\000"
.LASF670:
	.ascii	"sgp30_measure_iaq_blocking_read\000"
.LASF364:
	.ascii	"__USA_IBIT__ 16\000"
.LASF278:
	.ascii	"__ULFRACT_FBIT__ 32\000"
.LASF443:
	.ascii	"__ARM_ARCH_EXT_IDIV__ 1\000"
.LASF672:
	.ascii	"sgp30_measure_iaq\000"
.LASF494:
	.ascii	"__CTYPE_GRAPH (__CTYPE_PUNCT | __CTYPE_UPPER | __CT"
	.ascii	"YPE_LOWER | __CTYPE_DIGIT)\000"
.LASF662:
	.ascii	"sgp30_measure_co2_eq_blocking_read\000"
.LASF478:
	.ascii	"__THREAD __thread\000"
.LASF301:
	.ascii	"__USACCUM_MAX__ 0XFFFFP-8UHK\000"
.LASF121:
	.ascii	"__UINT32_C(c) c ## UL\000"
.LASF645:
	.ascii	"sgp30_init\000"
.LASF581:
	.ascii	"BYTE_NUM_ERROR 4\000"
.LASF309:
	.ascii	"__UACCUM_IBIT__ 16\000"
.LASF263:
	.ascii	"__FRACT_FBIT__ 15\000"
.LASF421:
	.ascii	"__THUMBEL__ 1\000"
.LASF186:
	.ascii	"__LDBL_MIN__ 1.1\000"
.LASF358:
	.ascii	"__DA_IBIT__ 32\000"
.LASF25:
	.ascii	"__BIGGEST_ALIGNMENT__ 8\000"
.LASF314:
	.ascii	"__LACCUM_IBIT__ 32\000"
.LASF261:
	.ascii	"__USFRACT_MAX__ 0XFFP-8UHR\000"
.LASF132:
	.ascii	"__UINT_FAST8_MAX__ 0xffffffffU\000"
.LASF26:
	.ascii	"__ORDER_LITTLE_ENDIAN__ 1234\000"
.LASF388:
	.ascii	"__HAVE_SPECULATION_SAFE_VALUE 1\000"
.LASF325:
	.ascii	"__LLACCUM_MIN__ (-0X1P31LLK-0X1P31LLK)\000"
.LASF538:
	.ascii	"INT_FAST16_MAX INT32_MAX\000"
.LASF475:
	.ascii	"SENSIRION_CONFIG_H \000"
.LASF355:
	.ascii	"__SA_FBIT__ 15\000"
.LASF226:
	.ascii	"__FLT64_MIN_10_EXP__ (-307)\000"
.LASF605:
	.ascii	"SGP30_CMD_IAQ_MEASURE_DURATION_US 12000\000"
.LASF667:
	.ascii	"sgp30_measure_tvoc_blocking_read\000"
.LASF432:
	.ascii	"__ARM_FEATURE_FP16_VECTOR_ARITHMETIC\000"
.LASF519:
	.ascii	"INTMAX_MAX 9223372036854775807LL\000"
.LASF297:
	.ascii	"__SACCUM_EPSILON__ 0x1P-7HK\000"
.LASF58:
	.ascii	"__INT_FAST16_TYPE__ int\000"
.LASF194:
	.ascii	"__FLT16_MIN_EXP__ (-13)\000"
.LASF213:
	.ascii	"__FLT32_DECIMAL_DIG__ 9\000"
.LASF46:
	.ascii	"__UINT16_TYPE__ short unsigned int\000"
.LASF590:
	.ascii	"SENSIRION_I2C_HAL_H \000"
.LASF466:
	.ascii	"CONFIG_GPIO_AS_PINRESET 1\000"
.LASF84:
	.ascii	"__WCHAR_WIDTH__ 32\000"
.LASF371:
	.ascii	"__GNUC_STDC_INLINE__ 1\000"
.LASF346:
	.ascii	"__UHQ_IBIT__ 0\000"
.LASF268:
	.ascii	"__UFRACT_FBIT__ 16\000"
.LASF554:
	.ascii	"UINT16_C(x) (x ##U)\000"
.LASF33:
	.ascii	"__PTRDIFF_TYPE__ int\000"
.LASF72:
	.ascii	"__LONG_LONG_MAX__ 0x7fffffffffffffffLL\000"
.LASF491:
	.ascii	"__CTYPE_XDIGIT 0x80\000"
.LASF54:
	.ascii	"__UINT_LEAST16_TYPE__ short unsigned int\000"
.LASF150:
	.ascii	"__FLT_MAX_10_EXP__ 38\000"
.LASF618:
	.ascii	"SGP30_CMD_GET_TVOC_INCEPTIVE_BASELINE_DURATION_US 1"
	.ascii	"0000\000"
.LASF326:
	.ascii	"__LLACCUM_MAX__ 0X7FFFFFFFFFFFFFFFP-31LLK\000"
.LASF463:
	.ascii	"DEBUG_NRF 1\000"
.LASF196:
	.ascii	"__FLT16_MAX_EXP__ 16\000"
.LASF639:
	.ascii	"sgp30_get_serial_id\000"
.LASF327:
	.ascii	"__LLACCUM_EPSILON__ 0x1P-31LLK\000"
.LASF678:
	.ascii	"GNU C99 10.3.1 20210824 (release) -fmessage-length="
	.ascii	"0 -std=gnu99 -mcpu=cortex-m4 -mlittle-endian -mfloa"
	.ascii	"t-abi=hard -mfpu=fpv4-sp-d16 -mthumb -mtp=soft -mfp"
	.ascii	"16-format=ieee -munaligned-access -gdwarf-4 -g3 -gp"
	.ascii	"ubnames -fomit-frame-pointer -fno-dwarf2-cfi-asm -f"
	.ascii	"function-sections -fdata-sections -fshort-enums -fn"
	.ascii	"o-common\000"
.LASF238:
	.ascii	"__FLT32X_MANT_DIG__ 53\000"
.LASF680:
	.ascii	"C:\\nrf_sdk\\nRF5_SDK_17.1.0_ddde560\\examples\\My "
	.ascii	"Projects\\Progetto_WearableAirMonitoring\\pca10040\\"
	.ascii	"blank\\ses\000"
.LASF616:
	.ascii	"SGP30_CMD_SET_ABSOLUTE_HUMIDITY_DURATION_US 10000\000"
.LASF446:
	.ascii	"__ARM_FEATURE_COPROC\000"
.LASF298:
	.ascii	"__USACCUM_FBIT__ 8\000"
.LASF145:
	.ascii	"__FLT_MANT_DIG__ 24\000"
.LASF415:
	.ascii	"__ARM_ARCH\000"
.LASF229:
	.ascii	"__FLT64_DECIMAL_DIG__ 17\000"
.LASF369:
	.ascii	"__REGISTER_PREFIX__ \000"
.LASF659:
	.ascii	"h2_raw_signal\000"
.LASF209:
	.ascii	"__FLT32_MIN_EXP__ (-125)\000"
.LASF504:
	.ascii	"MB_CUR_MAX __RAL_mb_max(&__RAL_global_locale)\000"
.LASF91:
	.ascii	"__UINTMAX_C(c) c ## ULL\000"
.LASF133:
	.ascii	"__UINT_FAST16_MAX__ 0xffffffffU\000"
.LASF62:
	.ascii	"__UINT_FAST16_TYPE__ unsigned int\000"
.LASF487:
	.ascii	"__CTYPE_SPACE 0x08\000"
.LASF164:
	.ascii	"__DBL_MIN_10_EXP__ (-307)\000"
.LASF299:
	.ascii	"__USACCUM_IBIT__ 8\000"
.LASF269:
	.ascii	"__UFRACT_IBIT__ 0\000"
.LASF67:
	.ascii	"__GXX_ABI_VERSION 1014\000"
.LASF591:
	.ascii	"SGP30_PRODUCT_TYPE 0\000"
.LASF440:
	.ascii	"__ARM_PCS_VFP 1\000"
.LASF208:
	.ascii	"__FLT32_DIG__ 6\000"
.LASF532:
	.ascii	"UINT_LEAST64_MAX UINT64_MAX\000"
.LASF505:
	.ascii	"__stdint_H \000"
.LASF235:
	.ascii	"__FLT64_HAS_DENORM__ 1\000"
.LASF141:
	.ascii	"__FLT_EVAL_METHOD__ 0\000"
.LASF250:
	.ascii	"__FLT32X_HAS_DENORM__ 1\000"
.LASF407:
	.ascii	"__ARM_FEATURE_CLZ 1\000"
.LASF113:
	.ascii	"__INT_LEAST64_MAX__ 0x7fffffffffffffffLL\000"
.LASF234:
	.ascii	"__FLT64_DENORM_MIN__ 1.1\000"
.LASF523:
	.ascii	"INT_LEAST32_MIN INT32_MIN\000"
.LASF381:
	.ascii	"__GCC_ATOMIC_WCHAR_T_LOCK_FREE 2\000"
.LASF319:
	.ascii	"__ULACCUM_IBIT__ 32\000"
.LASF617:
	.ascii	"SGP30_CMD_GET_TVOC_INCEPTIVE_BASELINE 0x20b3\000"
.LASF430:
	.ascii	"__ARM_FP16_ARGS 1\000"
.LASF283:
	.ascii	"__LLFRACT_FBIT__ 63\000"
.LASF280:
	.ascii	"__ULFRACT_MIN__ 0.0ULR\000"
.LASF106:
	.ascii	"__INT_LEAST8_WIDTH__ 8\000"
.LASF363:
	.ascii	"__USA_FBIT__ 16\000"
.LASF100:
	.ascii	"__UINT8_MAX__ 0xff\000"
.LASF438:
	.ascii	"__THUMB_INTERWORK__ 1\000"
.LASF556:
	.ascii	"UINT32_C(x) (x ##UL)\000"
.LASF101:
	.ascii	"__UINT16_MAX__ 0xffff\000"
.LASF462:
	.ascii	"DEBUG 1\000"
.LASF154:
	.ascii	"__FLT_MIN__ 1.1\000"
.LASF506:
	.ascii	"UINT8_MAX 255\000"
.LASF308:
	.ascii	"__UACCUM_FBIT__ 16\000"
.LASF629:
	.ascii	"uint8_t\000"
.LASF546:
	.ascii	"PTRDIFF_MAX INT32_MAX\000"
.LASF92:
	.ascii	"__INTMAX_WIDTH__ 64\000"
.LASF448:
	.ascii	"__ARM_FEATURE_CDE\000"
.LASF139:
	.ascii	"__GCC_IEC_559 0\000"
.LASF595:
	.ascii	"SGP30_CMD_GET_FEATURESET 0x202f\000"
.LASF457:
	.ascii	"__SES_ARM 1\000"
.LASF643:
	.ascii	"feature_set_version\000"
.LASF50:
	.ascii	"__INT_LEAST16_TYPE__ short int\000"
.LASF211:
	.ascii	"__FLT32_MAX_EXP__ 128\000"
.LASF273:
	.ascii	"__LFRACT_FBIT__ 31\000"
.LASF574:
	.ascii	"SENSIRION_WORD_SIZE 2\000"
.LASF594:
	.ascii	"SGP30_CMD_GET_SERIAL_ID_WORDS 3\000"
.LASF461:
	.ascii	"__GNU_LINKER 1\000"
.LASF162:
	.ascii	"__DBL_DIG__ 15\000"
.LASF665:
	.ascii	"sgp30_read_co2_eq\000"
.LASF104:
	.ascii	"__INT_LEAST8_MAX__ 0x7f\000"
.LASF422:
	.ascii	"__ARM_ARCH_ISA_THUMB\000"
.LASF313:
	.ascii	"__LACCUM_FBIT__ 31\000"
.LASF352:
	.ascii	"__UTQ_IBIT__ 0\000"
.LASF272:
	.ascii	"__UFRACT_EPSILON__ 0x1P-16UR\000"
.LASF580:
	.ascii	"I2C_NACK_ERROR 3\000"
.LASF172:
	.ascii	"__DBL_DENORM_MIN__ ((double)1.1)\000"
.LASF384:
	.ascii	"__GCC_ATOMIC_LONG_LOCK_FREE 2\000"
.LASF239:
	.ascii	"__FLT32X_DIG__ 15\000"
.LASF307:
	.ascii	"__ACCUM_EPSILON__ 0x1P-15K\000"
.LASF520:
	.ascii	"UINTMAX_MAX 18446744073709551615ULL\000"
.LASF349:
	.ascii	"__UDQ_FBIT__ 64\000"
.LASF185:
	.ascii	"__LDBL_NORM_MAX__ 1.1\000"
.LASF423:
	.ascii	"__ARM_ARCH_ISA_THUMB 2\000"
.LASF500:
	.ascii	"NULL 0\000"
.LASF351:
	.ascii	"__UTQ_FBIT__ 128\000"
.LASF153:
	.ascii	"__FLT_NORM_MAX__ 1.1\000"
.LASF627:
	.ascii	"long long int\000"
.LASF24:
	.ascii	"__CHAR_BIT__ 8\000"
.LASF426:
	.ascii	"__ARM_FP\000"
.LASF137:
	.ascii	"__INTPTR_WIDTH__ 32\000"
.LASF303:
	.ascii	"__ACCUM_FBIT__ 15\000"
.LASF15:
	.ascii	"__FINITE_MATH_ONLY__ 0\000"
.LASF296:
	.ascii	"__SACCUM_MAX__ 0X7FFFP-7HK\000"
.LASF414:
	.ascii	"__arm__ 1\000"
.LASF677:
	.ascii	"fs_version\000"
.LASF583:
	.ascii	"CRC8_INIT 0xFF\000"
.LASF176:
	.ascii	"__LDBL_MANT_DIG__ 53\000"
.LASF342:
	.ascii	"__TQ_IBIT__ 0\000"
.LASF361:
	.ascii	"__UHA_FBIT__ 8\000"
.LASF522:
	.ascii	"INT_LEAST16_MIN INT16_MIN\000"
.LASF418:
	.ascii	"__GCC_ASM_FLAG_OUTPUTS__ 1\000"
.LASF386:
	.ascii	"__GCC_ATOMIC_TEST_AND_SET_TRUEVAL 1\000"
.LASF372:
	.ascii	"__NO_INLINE__ 1\000"
.LASF589:
	.ascii	"STATUS_FAIL (-1)\000"
.LASF455:
	.ascii	"__ELF__ 1\000"
.LASF412:
	.ascii	"__ARM_ARCH_PROFILE\000"
.LASF397:
	.ascii	"__ARM_FEATURE_UNALIGNED 1\000"
.LASF321:
	.ascii	"__ULACCUM_MAX__ 0XFFFFFFFFFFFFFFFFP-32ULK\000"
.LASF108:
	.ascii	"__INT16_C(c) c\000"
.LASF394:
	.ascii	"__ARM_FEATURE_QBIT 1\000"
.LASF674:
	.ascii	"test_result\000"
.LASF103:
	.ascii	"__UINT64_MAX__ 0xffffffffffffffffULL\000"
.LASF316:
	.ascii	"__LACCUM_MAX__ 0X7FFFFFFFFFFFFFFFP-31LK\000"
.LASF128:
	.ascii	"__INT_FAST32_MAX__ 0x7fffffff\000"
.LASF171:
	.ascii	"__DBL_EPSILON__ ((double)1.1)\000"
.LASF11:
	.ascii	"__ATOMIC_ACQUIRE 2\000"
.LASF657:
	.ascii	"sgp30_read_raw\000"
.LASF205:
	.ascii	"__FLT16_HAS_INFINITY__ 1\000"
.LASF447:
	.ascii	"__ARM_FEATURE_COPROC 15\000"
.LASF647:
	.ascii	"sgp30_set_absolute_humidity\000"
.LASF492:
	.ascii	"__CTYPE_ALPHA (__CTYPE_UPPER | __CTYPE_LOWER)\000"
.LASF17:
	.ascii	"__SIZEOF_LONG__ 4\000"
.LASF545:
	.ascii	"PTRDIFF_MIN INT32_MIN\000"
.LASF165:
	.ascii	"__DBL_MAX_EXP__ 1024\000"
.LASF14:
	.ascii	"__ATOMIC_CONSUME 1\000"
.LASF597:
	.ascii	"SGP30_CMD_GET_FEATURESET_WORDS 1\000"
.LASF129:
	.ascii	"__INT_FAST32_WIDTH__ 32\000"
.LASF453:
	.ascii	"__ARM_BF16_FORMAT_ALTERNATIVE\000"
.LASF35:
	.ascii	"__WINT_TYPE__ unsigned int\000"
.LASF571:
	.ascii	"NOT_IMPLEMENTED_ERROR 31\000"
.LASF71:
	.ascii	"__LONG_MAX__ 0x7fffffffL\000"
.LASF97:
	.ascii	"__INT16_MAX__ 0x7fff\000"
.LASF636:
	.ascii	"SGP30_I2C_ADDRESS\000"
.LASF79:
	.ascii	"__SCHAR_WIDTH__ 8\000"
.LASF305:
	.ascii	"__ACCUM_MIN__ (-0X1P15K-0X1P15K)\000"
.LASF544:
	.ascii	"UINT_FAST64_MAX UINT64_MAX\000"
.LASF21:
	.ascii	"__SIZEOF_DOUBLE__ 8\000"
.LASF637:
	.ascii	"sgp30_probe\000"
.LASF7:
	.ascii	"__GNUC_PATCHLEVEL__ 1\000"
.LASF563:
	.ascii	"WINT_MIN (-2147483647L-1)\000"
.LASF454:
	.ascii	"__GXX_TYPEINFO_EQUALITY_INLINE 0\000"
.LASF198:
	.ascii	"__FLT16_DECIMAL_DIG__ 5\000"
.LASF588:
	.ascii	"STATUS_OK 0\000"
.LASF266:
	.ascii	"__FRACT_MAX__ 0X7FFFP-15R\000"
.LASF44:
	.ascii	"__INT64_TYPE__ long long int\000"
.LASF318:
	.ascii	"__ULACCUM_FBIT__ 32\000"
.LASF270:
	.ascii	"__UFRACT_MIN__ 0.0UR\000"
.LASF437:
	.ascii	"__ARM_NEON_FP\000"
.LASF428:
	.ascii	"__ARM_FP16_FORMAT_IEEE 1\000"
.LASF2:
	.ascii	"__STDC_UTF_16__ 1\000"
.LASF264:
	.ascii	"__FRACT_IBIT__ 0\000"
.LASF476:
	.ascii	"__stdlib_H \000"
.LASF359:
	.ascii	"__TA_FBIT__ 63\000"
.LASF598:
	.ascii	"SGP30_CMD_MEASURE_TEST 0x2032\000"
.LASF190:
	.ascii	"__LDBL_HAS_INFINITY__ 1\000"
.LASF140:
	.ascii	"__GCC_IEC_559_COMPLEX 0\000"
.LASF102:
	.ascii	"__UINT32_MAX__ 0xffffffffUL\000"
.LASF199:
	.ascii	"__FLT16_MAX__ 1.1\000"
.LASF215:
	.ascii	"__FLT32_NORM_MAX__ 1.1\000"
.LASF178:
	.ascii	"__LDBL_MIN_EXP__ (-1021)\000"
.LASF508:
	.ascii	"INT8_MIN (-128)\000"
.LASF288:
	.ascii	"__ULLFRACT_FBIT__ 64\000"
.LASF390:
	.ascii	"__SIZEOF_WCHAR_T__ 4\000"
.LASF460:
	.ascii	"__SES_VERSION 57001\000"
.LASF30:
	.ascii	"__FLOAT_WORD_ORDER__ __ORDER_LITTLE_ENDIAN__\000"
.LASF306:
	.ascii	"__ACCUM_MAX__ 0X7FFFFFFFP-15K\000"
.LASF87:
	.ascii	"__SIZE_WIDTH__ 32\000"
.LASF395:
	.ascii	"__ARM_FEATURE_SAT 1\000"
.LASF495:
	.ascii	"__CTYPE_PRINT (__CTYPE_BLANK | __CTYPE_PUNCT | __CT"
	.ascii	"YPE_UPPER | __CTYPE_LOWER | __CTYPE_DIGIT)\000"
.LASF94:
	.ascii	"__SIG_ATOMIC_MIN__ (-__SIG_ATOMIC_MAX__ - 1)\000"
.LASF287:
	.ascii	"__LLFRACT_EPSILON__ 0x1P-63LLR\000"
.LASF558:
	.ascii	"UINT64_C(x) (x ##ULL)\000"
.LASF471:
	.ascii	"NRF52832_XXAA 1\000"
.LASF82:
	.ascii	"__LONG_WIDTH__ 32\000"
.LASF253:
	.ascii	"__SFRACT_FBIT__ 7\000"
.LASF39:
	.ascii	"__CHAR32_TYPE__ long unsigned int\000"
.LASF254:
	.ascii	"__SFRACT_IBIT__ 0\000"
.LASF517:
	.ascii	"UINT64_MAX 18446744073709551615ULL\000"
.LASF577:
	.ascii	"SENSIRION_I2C_H \000"
.LASF336:
	.ascii	"__HQ_IBIT__ 0\000"
.LASF603:
	.ascii	"SGP30_CMD_IAQ_INIT_DURATION_US 10000\000"
.LASF632:
	.ascii	"uint16_t\000"
.LASF370:
	.ascii	"__USER_LABEL_PREFIX__ \000"
.LASF204:
	.ascii	"__FLT16_HAS_DENORM__ 1\000"
.LASF648:
	.ascii	"absolute_humidity\000"
.LASF55:
	.ascii	"__UINT_LEAST32_TYPE__ long unsigned int\000"
.LASF339:
	.ascii	"__DQ_FBIT__ 63\000"
.LASF255:
	.ascii	"__SFRACT_MIN__ (-0.5HR-0.5HR)\000"
.LASF406:
	.ascii	"__ARM_FEATURE_LDREX 7\000"
.LASF95:
	.ascii	"__SIG_ATOMIC_WIDTH__ 32\000"
.LASF489:
	.ascii	"__CTYPE_CNTRL 0x20\000"
.LASF452:
	.ascii	"__ARM_FEATURE_BF16_VECTOR_ARITHMETIC\000"
.LASF69:
	.ascii	"__SHRT_MAX__ 0x7fff\000"
.LASF608:
	.ascii	"SGP30_CMD_GET_IAQ_BASELINE_DURATION_US 10000\000"
.LASF28:
	.ascii	"__ORDER_PDP_ENDIAN__ 3412\000"
.LASF614:
	.ascii	"SGP30_CMD_RAW_MEASURE_WORDS 2\000"
.LASF338:
	.ascii	"__SQ_IBIT__ 0\000"
.LASF5:
	.ascii	"__GNUC__ 10\000"
.LASF524:
	.ascii	"INT_LEAST64_MIN INT64_MIN\000"
.LASF151:
	.ascii	"__FLT_DECIMAL_DIG__ 9\000"
.LASF599:
	.ascii	"SGP30_CMD_MEASURE_TEST_DURATION_US 220000\000"
.LASF98:
	.ascii	"__INT32_MAX__ 0x7fffffffL\000"
.LASF85:
	.ascii	"__WINT_WIDTH__ 32\000"
.LASF542:
	.ascii	"UINT_FAST16_MAX UINT32_MAX\000"
.LASF551:
	.ascii	"INT8_C(x) (x)\000"
.LASF569:
	.ascii	"__bool_true_false_are_defined 1\000"
.LASF343:
	.ascii	"__UQQ_FBIT__ 8\000"
.LASF348:
	.ascii	"__USQ_IBIT__ 0\000"
.LASF16:
	.ascii	"__SIZEOF_INT__ 4\000"
.LASF669:
	.ascii	"sgp30_measure_tvoc\000"
.LASF586:
	.ascii	"SGP30_ERR_UNSUPPORTED_FEATURE_SET (-10)\000"
.LASF410:
	.ascii	"__ARM_SIZEOF_MINIMAL_ENUM 1\000"
.LASF536:
	.ascii	"INT_FAST64_MIN INT64_MIN\000"
.LASF631:
	.ascii	"short int\000"
.LASF311:
	.ascii	"__UACCUM_MAX__ 0XFFFFFFFFP-16UK\000"
.LASF615:
	.ascii	"SGP30_CMD_SET_ABSOLUTE_HUMIDITY 0x2061\000"
.LASF564:
	.ascii	"WINT_MAX 2147483647L\000"
.LASF604:
	.ascii	"SGP30_CMD_IAQ_MEASURE 0x2008\000"
.LASF649:
	.ascii	"ah_scaled\000"
.LASF345:
	.ascii	"__UHQ_FBIT__ 16\000"
.LASF43:
	.ascii	"__INT32_TYPE__ long int\000"
.LASF241:
	.ascii	"__FLT32X_MIN_10_EXP__ (-307)\000"
.LASF451:
	.ascii	"__ARM_FEATURE_BF16_SCALAR_ARITHMETIC\000"
.LASF622:
	.ascii	"long int\000"
.LASF444:
	.ascii	"__ARM_FEATURE_IDIV 1\000"
.LASF180:
	.ascii	"__LDBL_MAX_EXP__ 1024\000"
.LASF337:
	.ascii	"__SQ_FBIT__ 31\000"
.LASF582:
	.ascii	"CRC8_POLYNOMIAL 0x31\000"
.LASF275:
	.ascii	"__LFRACT_MIN__ (-0.5LR-0.5LR)\000"
.LASF548:
	.ascii	"INTPTR_MIN INT32_MIN\000"
.LASF74:
	.ascii	"__WCHAR_MIN__ 0U\000"
.LASF620:
	.ascii	"SGP30_CMD_SET_TVOC_BASELINE 0x2077\000"
.LASF507:
	.ascii	"INT8_MAX 127\000"
.LASF483:
	.ascii	"__CODE \000"
.LASF120:
	.ascii	"__UINT_LEAST32_MAX__ 0xffffffffUL\000"
.LASF557:
	.ascii	"INT64_C(x) (x ##LL)\000"
.LASF533:
	.ascii	"INT_FAST8_MIN INT8_MIN\000"
.LASF419:
	.ascii	"__thumb__ 1\000"
.LASF191:
	.ascii	"__LDBL_HAS_QUIET_NAN__ 1\000"
.LASF41:
	.ascii	"__INT8_TYPE__ signed char\000"
.LASF75:
	.ascii	"__WINT_MAX__ 0xffffffffU\000"
.LASF596:
	.ascii	"SGP30_CMD_GET_FEATURESET_DURATION_US 10000\000"
.LASF183:
	.ascii	"__LDBL_DECIMAL_DIG__ 17\000"
.LASF341:
	.ascii	"__TQ_FBIT__ 127\000"
.LASF634:
	.ascii	"uint64_t\000"
.LASF262:
	.ascii	"__USFRACT_EPSILON__ 0x1P-8UHR\000"
.LASF575:
	.ascii	"SENSIRION_NUM_WORDS(x) (sizeof(x) / SENSIRION_WORD_"
	.ascii	"SIZE)\000"
.LASF516:
	.ascii	"INT64_MAX 9223372036854775807LL\000"
.LASF135:
	.ascii	"__UINT_FAST64_MAX__ 0xffffffffffffffffULL\000"
.LASF134:
	.ascii	"__UINT_FAST32_MAX__ 0xffffffffU\000"
.LASF681:
	.ascii	"sgp30_check_featureset\000"
.LASF258:
	.ascii	"__USFRACT_FBIT__ 8\000"
.LASF114:
	.ascii	"__INT64_C(c) c ## LL\000"
.LASF335:
	.ascii	"__HQ_FBIT__ 15\000"
.LASF230:
	.ascii	"__FLT64_MAX__ 1.1\000"
.LASF362:
	.ascii	"__UHA_IBIT__ 8\000"
.LASF592:
	.ascii	"SGP30_CMD_GET_SERIAL_ID 0x3682\000"
.LASF409:
	.ascii	"__ARM_FEATURE_SIMD32 1\000"
.LASF73:
	.ascii	"__WCHAR_MAX__ 0xffffffffU\000"
.LASF18:
	.ascii	"__SIZEOF_LONG_LONG__ 8\000"
.LASF509:
	.ascii	"UINT16_MAX 65535\000"
.LASF45:
	.ascii	"__UINT8_TYPE__ unsigned char\000"
.LASF80:
	.ascii	"__SHRT_WIDTH__ 16\000"
.LASF540:
	.ascii	"INT_FAST64_MAX INT64_MAX\000"
.LASF525:
	.ascii	"INT_LEAST8_MAX INT8_MAX\000"
.LASF515:
	.ascii	"INT64_MIN (-9223372036854775807LL-1)\000"
.LASF52:
	.ascii	"__INT_LEAST64_TYPE__ long long int\000"
.LASF549:
	.ascii	"INTPTR_MAX INT32_MAX\000"
.LASF501:
	.ascii	"EXIT_SUCCESS 0\000"
.LASF47:
	.ascii	"__UINT32_TYPE__ long unsigned int\000"
.LASF179:
	.ascii	"__LDBL_MIN_10_EXP__ (-307)\000"
.LASF482:
	.ascii	"__RAL_PTRDIFF_T int\000"
.LASF245:
	.ascii	"__FLT32X_MAX__ 1.1\000"
.LASF31:
	.ascii	"__SIZEOF_POINTER__ 4\000"
.LASF425:
	.ascii	"__VFP_FP__ 1\000"
.LASF281:
	.ascii	"__ULFRACT_MAX__ 0XFFFFFFFFP-32ULR\000"
.LASF353:
	.ascii	"__HA_FBIT__ 7\000"
.LASF86:
	.ascii	"__PTRDIFF_WIDTH__ 32\000"
.LASF485:
	.ascii	"__CTYPE_LOWER 0x02\000"
.LASF579:
	.ascii	"I2C_BUS_ERROR 2\000"
.LASF295:
	.ascii	"__SACCUM_MIN__ (-0X1P7HK-0X1P7HK)\000"
.LASF81:
	.ascii	"__INT_WIDTH__ 32\000"
.LASF387:
	.ascii	"__GCC_ATOMIC_POINTER_LOCK_FREE 2\000"
.LASF123:
	.ascii	"__UINT64_C(c) c ## ULL\000"
.LASF317:
	.ascii	"__LACCUM_EPSILON__ 0x1P-31LK\000"
.LASF550:
	.ascii	"UINTPTR_MAX UINT32_MAX\000"
.LASF257:
	.ascii	"__SFRACT_EPSILON__ 0x1P-7HR\000"
.LASF399:
	.ascii	"__ARM_FEATURE_CRC32\000"
.LASF344:
	.ascii	"__UQQ_IBIT__ 0\000"
.LASF347:
	.ascii	"__USQ_FBIT__ 32\000"
.LASF354:
	.ascii	"__HA_IBIT__ 8\000"
.LASF380:
	.ascii	"__GCC_ATOMIC_CHAR32_T_LOCK_FREE 2\000"
.LASF1:
	.ascii	"__STDC_VERSION__ 199901L\000"
.LASF664:
	.ascii	"tvoc_ppb\000"
.LASF156:
	.ascii	"__FLT_DENORM_MIN__ 1.1\000"
.LASF267:
	.ascii	"__FRACT_EPSILON__ 0x1P-15R\000"
.LASF4:
	.ascii	"__STDC_HOSTED__ 1\000"
.LASF203:
	.ascii	"__FLT16_DENORM_MIN__ 1.1\000"
.LASF136:
	.ascii	"__INTPTR_MAX__ 0x7fffffff\000"
.LASF170:
	.ascii	"__DBL_MIN__ ((double)1.1)\000"
.LASF611:
	.ascii	"SGP30_CMD_SET_IAQ_BASELINE_DURATION_US 10000\000"
.LASF206:
	.ascii	"__FLT16_HAS_QUIET_NAN__ 1\000"
.LASF246:
	.ascii	"__FLT32X_NORM_MAX__ 1.1\000"
.LASF468:
	.ascii	"INITIALIZE_USER_SECTIONS 1\000"
.LASF503:
	.ascii	"RAND_MAX 32767\000"
.LASF511:
	.ascii	"INT16_MAX 32767\000"
.LASF530:
	.ascii	"UINT_LEAST16_MAX UINT16_MAX\000"
.LASF521:
	.ascii	"INT_LEAST8_MIN INT8_MIN\000"
.LASF385:
	.ascii	"__GCC_ATOMIC_LLONG_LOCK_FREE 1\000"
.LASF376:
	.ascii	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 1\000"
.LASF149:
	.ascii	"__FLT_MAX_EXP__ 128\000"
.LASF13:
	.ascii	"__ATOMIC_ACQ_REL 4\000"
.LASF64:
	.ascii	"__UINT_FAST64_TYPE__ long long unsigned int\000"
.LASF625:
	.ascii	"unsigned char\000"
.LASF37:
	.ascii	"__UINTMAX_TYPE__ long long unsigned int\000"
.LASF610:
	.ascii	"SGP30_CMD_SET_IAQ_BASELINE 0x201e\000"
.LASF480:
	.ascii	"__RAL_SIZE_T unsigned\000"
.LASF593:
	.ascii	"SGP30_CMD_GET_SERIAL_ID_DURATION_US 500\000"
.LASF512:
	.ascii	"UINT32_MAX 4294967295UL\000"
.LASF65:
	.ascii	"__INTPTR_TYPE__ int\000"
.LASF679:
	.ascii	"C:\\nrf_sdk\\nRF5_SDK_17.1.0_ddde560\\examples\\My "
	.ascii	"Projects\\Progetto_WearableAirMonitoring\\sensor\\s"
	.ascii	"gp30.c\000"
.LASF143:
	.ascii	"__DEC_EVAL_METHOD__ 2\000"
.LASF217:
	.ascii	"__FLT32_EPSILON__ 1.1\000"
.LASF470:
	.ascii	"NRF52 1\000"
.LASF259:
	.ascii	"__USFRACT_IBIT__ 0\000"
.LASF112:
	.ascii	"__INT_LEAST32_WIDTH__ 32\000"
.LASF621:
	.ascii	"SGP30_CMD_SET_TVOC_BASELINE_DURATION_US 10000\000"
.LASF502:
	.ascii	"EXIT_FAILURE 1\000"
.LASF650:
	.ascii	"sgp30_set_tvoc_baseline\000"
.LASF477:
	.ascii	"__crossworks_H \000"
.LASF535:
	.ascii	"INT_FAST32_MIN INT32_MIN\000"
.LASF188:
	.ascii	"__LDBL_DENORM_MIN__ 1.1\000"
.LASF340:
	.ascii	"__DQ_IBIT__ 0\000"
.LASF655:
	.ascii	"baseline\000"
.LASF644:
	.ascii	"product_type\000"
.LASF32:
	.ascii	"__SIZE_TYPE__ unsigned int\000"
.LASF561:
	.ascii	"WCHAR_MIN __WCHAR_MIN__\000"
.LASF328:
	.ascii	"__ULLACCUM_FBIT__ 32\000"
.LASF552:
	.ascii	"UINT8_C(x) (x ##U)\000"
.LASF560:
	.ascii	"UINTMAX_C(x) (x ##ULL)\000"
.LASF225:
	.ascii	"__FLT64_MIN_EXP__ (-1021)\000"
.LASF640:
	.ascii	"words\000"
.LASF8:
	.ascii	"__VERSION__ \"10.3.1 20210824 (release)\"\000"
.LASF493:
	.ascii	"__CTYPE_ALNUM (__CTYPE_UPPER | __CTYPE_LOWER | __CT"
	.ascii	"YPE_DIGIT)\000"
.LASF368:
	.ascii	"__UTA_IBIT__ 64\000"
.LASF499:
	.ascii	"__RAL_WCHAR_T_DEFINED \000"
.LASF559:
	.ascii	"INTMAX_C(x) (x ##LL)\000"
.LASF148:
	.ascii	"__FLT_MIN_10_EXP__ (-37)\000"
.LASF240:
	.ascii	"__FLT32X_MIN_EXP__ (-1021)\000"
.LASF612:
	.ascii	"SGP30_CMD_RAW_MEASURE 0x2050\000"
.LASF142:
	.ascii	"__FLT_EVAL_METHOD_TS_18661_3__ 0\000"
.LASF660:
	.ascii	"sgp30_measure_raw\000"
.LASF168:
	.ascii	"__DBL_MAX__ ((double)1.1)\000"
.LASF59:
	.ascii	"__INT_FAST32_TYPE__ int\000"
.LASF159:
	.ascii	"__FLT_HAS_QUIET_NAN__ 1\000"
.LASF116:
	.ascii	"__UINT_LEAST8_MAX__ 0xff\000"
.LASF572:
	.ascii	"ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))\000"
.LASF36:
	.ascii	"__INTMAX_TYPE__ long long int\000"
.LASF565:
	.ascii	"__stdbool_h \000"
.LASF89:
	.ascii	"__INTMAX_C(c) c ## LL\000"
.LASF403:
	.ascii	"__ARM_FEATURE_MVE\000"
.LASF417:
	.ascii	"__APCS_32__ 1\000"
.LASF233:
	.ascii	"__FLT64_EPSILON__ 1.1\000"
.LASF537:
	.ascii	"INT_FAST8_MAX INT8_MAX\000"
.LASF48:
	.ascii	"__UINT64_TYPE__ long long unsigned int\000"
.LASF600:
	.ascii	"SGP30_CMD_MEASURE_TEST_WORDS 1\000"
.LASF252:
	.ascii	"__FLT32X_HAS_QUIET_NAN__ 1\000"
.LASF166:
	.ascii	"__DBL_MAX_10_EXP__ 308\000"
.LASF231:
	.ascii	"__FLT64_NORM_MAX__ 1.1\000"
.LASF626:
	.ascii	"short unsigned int\000"
.LASF378:
	.ascii	"__GCC_ATOMIC_CHAR_LOCK_FREE 2\000"
.LASF360:
	.ascii	"__TA_IBIT__ 64\000"
.LASF20:
	.ascii	"__SIZEOF_FLOAT__ 4\000"
.LASF651:
	.ascii	"tvoc_baseline\000"
.LASF300:
	.ascii	"__USACCUM_MIN__ 0.0UHK\000"
.LASF125:
	.ascii	"__INT_FAST8_WIDTH__ 32\000"
.LASF147:
	.ascii	"__FLT_MIN_EXP__ (-125)\000"
.LASF0:
	.ascii	"__STDC__ 1\000"
.LASF450:
	.ascii	"__ARM_FEATURE_MATMUL_INT8\000"
.LASF675:
	.ascii	"measure_test_word_buf\000"
.LASF182:
	.ascii	"__DECIMAL_DIG__ 17\000"
.LASF427:
	.ascii	"__ARM_FP 4\000"
.LASF111:
	.ascii	"__INT32_C(c) c ## L\000"
.LASF568:
	.ascii	"false 0\000"
.LASF567:
	.ascii	"true 1\000"
.LASF429:
	.ascii	"__ARM_FP16_FORMAT_ALTERNATIVE\000"
.LASF601:
	.ascii	"SGP30_CMD_MEASURE_TEST_OK 0xd400\000"
.LASF181:
	.ascii	"__LDBL_MAX_10_EXP__ 308\000"
.LASF243:
	.ascii	"__FLT32X_MAX_10_EXP__ 308\000"
.LASF138:
	.ascii	"__UINTPTR_MAX__ 0xffffffffU\000"
.LASF173:
	.ascii	"__DBL_HAS_DENORM__ 1\000"
.LASF201:
	.ascii	"__FLT16_MIN__ 1.1\000"
.LASF602:
	.ascii	"SGP30_CMD_IAQ_INIT 0x2003\000"
.LASF668:
	.ascii	"sgp30_read_tvoc\000"
.LASF671:
	.ascii	"sgp30_read_iaq\000"
.LASF212:
	.ascii	"__FLT32_MAX_10_EXP__ 38\000"
.LASF333:
	.ascii	"__QQ_FBIT__ 7\000"
.LASF276:
	.ascii	"__LFRACT_MAX__ 0X7FFFFFFFP-31LR\000"
.LASF365:
	.ascii	"__UDA_FBIT__ 32\000"
.LASF642:
	.ascii	"serial_id\000"
.LASF514:
	.ascii	"INT32_MIN (-2147483647L-1)\000"
.LASF585:
	.ascii	"SGP_GIT_VERSION_H \000"
.LASF110:
	.ascii	"__INT_LEAST32_MAX__ 0x7fffffffL\000"
.LASF184:
	.ascii	"__LDBL_MAX__ 1.1\000"
.LASF528:
	.ascii	"INT_LEAST64_MAX INT64_MAX\000"
.LASF486:
	.ascii	"__CTYPE_DIGIT 0x04\000"
.LASF90:
	.ascii	"__UINTMAX_MAX__ 0xffffffffffffffffULL\000"
.LASF40:
	.ascii	"__SIG_ATOMIC_TYPE__ int\000"
.LASF497:
	.ascii	"__MAX_CATEGORY 5\000"
.LASF547:
	.ascii	"SIZE_MAX INT32_MAX\000"
.LASF285:
	.ascii	"__LLFRACT_MIN__ (-0.5LLR-0.5LLR)\000"
.LASF232:
	.ascii	"__FLT64_MIN__ 1.1\000"
.LASF434:
	.ascii	"__ARM_FEATURE_FMA 1\000"
.LASF292:
	.ascii	"__ULLFRACT_EPSILON__ 0x1P-64ULLR\000"
.LASF189:
	.ascii	"__LDBL_HAS_DENORM__ 1\000"
.LASF641:
	.ascii	"sgp30_get_feature_set_version\000"
.LASF405:
	.ascii	"__ARM_FEATURE_LDREX\000"
.LASF223:
	.ascii	"__FLT64_MANT_DIG__ 53\000"
.LASF472:
	.ascii	"NRF52_PAN_74 1\000"
.LASF157:
	.ascii	"__FLT_HAS_DENORM__ 1\000"
.LASF131:
	.ascii	"__INT_FAST64_WIDTH__ 64\000"
.LASF167:
	.ascii	"__DBL_DECIMAL_DIG__ 17\000"
	.ident	"GCC: (based on arm-10.3-2021.10 GCC) 10.3.1 20210824 (release)"
