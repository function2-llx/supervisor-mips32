
kernel.elf:     file format elf32-tradlittlemips


Disassembly of section .text.init:

80000000 <INITLOCATE>:
    .set noat
    .p2align 2
    .section .text.init
    .global INITLOCATE
INITLOCATE:                         // 定位启动程序
    lui k0, %hi(START)
80000000:	00 80 1a 3c ac 12 5a 27 08 00 40 03 00 00 00 00     ...<..Z'..@.....

Disassembly of section .text.ebase:

80001000 <TLBREFILL>:
    mtc0 k1, CP0_ENTRYLO1
    nop
    tlbwr
    eret
#endif
    nop
80001000:	00000000 	nop

Disassembly of section .text.ebase180:

80001180 <EHANDLERLOCATE>:
    lui k0, %hi(EXCEPTIONHANDLER)
80001180:	3c1a8000 	lui	k0,0x8000
    addiu k0, %lo(EXCEPTIONHANDLER)
80001184:	275a16b0 	addiu	k0,k0,5808
    jr k0
80001188:	03400008 	jr	k0
    nop
8000118c:	00000000 	nop

Disassembly of section .text:

80001190 <WRITESERIAL>:
    .global READSERIAL
    .global READSERIALWORD

WRITESERIAL:                        // 写串口：将a0的低八位写入串口
#ifdef MACH_FPGA
    lui t1, %hi(SerialStat)
80001190:	3c09bfd0                                ...<

80001194 <.TESTW>:
.TESTW:
    lb t0, %lo(SerialStat)(t1)      // 查看串口状态
80001194:	812803fc 	lb	t0,1020(t1)
    andi t0, t0, 0x0001             // 截取写状态位
80001198:	31080001 	andi	t0,t0,0x1
    bne t0, zero, .WSERIAL          // 状态位非零可写进入写
8000119c:	15000003 	bnez	t0,800011ac <.WSERIAL>
    nop
800011a0:	00000000 	nop
    j .TESTW                        // 检测验证，忙等待
800011a4:	08000465 	j	80001194 <.TESTW>
    nop
800011a8:	00000000 	nop

800011ac <.WSERIAL>:
.WSERIAL:
    lui t1, %hi(SerialData)
800011ac:	3c09bfd0 	lui	t1,0xbfd0
    sb a0, %lo(SerialData)(t1)      // 写入
800011b0:	a12403f8 	sb	a0,1016(t1)
    jr ra
800011b4:	03e00008 	jr	ra
    nop
800011b8:	00000000 	nop

800011bc <READSERIAL>:
    nop
#endif

READSERIAL:                         // 读串口：将读到的数据写入v0低八位
#ifdef MACH_FPGA
    lui t1, %hi(SerialStat)
800011bc:	3c09bfd0                                ...<

800011c0 <.TESTR>:
.TESTR:
    lb t0, %lo(SerialStat)(t1)      // 查看串口状态
800011c0:	812803fc 	lb	t0,1020(t1)
    andi t0, t0, 0x0002             // 截取读状态位
800011c4:	31080002 	andi	t0,t0,0x2
    bne t0, zero, .RSERIAL          // 状态位非零可读进入读
800011c8:	15000003 	bnez	t0,800011d8 <.RSERIAL>
    nop
800011cc:	00000000 	nop
#ifdef ENABLE_INT
    ori v0, zero, SYS_wait          // 取得wait调用号
    syscall SYSCALL_BASE            // 睡眠等待
#endif
    j .TESTR                        // 检测验证
800011d0:	08000470 	j	800011c0 <.TESTR>
    nop
800011d4:	00000000 	nop

800011d8 <.RSERIAL>:
.RSERIAL:
    lui t1, %hi(SerialData)
800011d8:	3c09bfd0 	lui	t1,0xbfd0
    lb v0, %lo(SerialData)(t1)      // 读出
800011dc:	812203f8 	lb	v0,1016(t1)
    jr ra
800011e0:	03e00008 	jr	ra
    nop
800011e4:	00000000 	nop

800011e8 <READSERIALWORD>:
    jr ra
    nop
#endif //ifdef MACH_FPGA

READSERIALWORD:
    addiu sp, sp, -0x14             // 保存ra,s0
800011e8:	27bdffec afbf0000 afb00004 afb10008     ...'............
    sw ra, 0x0(sp)
    sw s0, 0x4(sp)
    sw s1, 0x8(sp)
    sw s2, 0xC(sp)
800011f8:	afb2000c afb30010 0c00046f 00000000     ........o.......
    sw s3, 0x10(sp)

    jal READSERIAL                  // 读串口获得八个比特
    nop
    or s0, zero, v0                 // 结果存入s0
80001208:	00028025 0c00046f 00000000 00028825     %...o.......%...
    jal READSERIAL                  // 读串口获得八个比特
    nop
    or s1, zero, v0                 // 结果存入s1
    jal READSERIAL                  // 读串口获得八个比特
80001218:	0c00046f 00000000 00029025 0c00046f     o.......%...o...
    nop
    or s2, zero, v0                 // 结果存入s2
    jal READSERIAL                  // 读串口获得八个比特
    nop
80001228:	00000000 00029825 321000ff 327300ff     ....%......2..s2
    or s3, zero, v0                 // 结果存入s3

    andi s0, s0, 0x00FF             // 截取低八位
    andi s3, s3, 0x00FF
    andi s2, s2, 0x00FF
80001238:	325200ff 323100ff 00131025 00021200     ..R2..12%.......
    andi s1, s1, 0x00FF
    or v0, zero, s3                 // 存高八位
    sll v0, v0, 8                   // 左移
    or v0, v0, s2                   // 存八位
80001248:	00521025 00021200 00511025 00021200     %.R.....%.Q.....
    sll v0, v0, 8                   // 左移
    or v0, v0, s1                   // 存八位
    sll v0, v0, 8                   // 左移
    or v0, v0, s0                   // 存低八位
80001258:	00501025 8fbf0000 8fb00004 8fb10008     %.P.............

    lw ra, 0x0(sp)                  // 恢复ra,s0
    lw s0, 0x4(sp)
    lw s1, 0x8(sp)
    lw s2, 0xC(sp)
80001268:	8fb2000c 8fb30010 27bd0014 03e00008     ...........'....
	...

80001280 <monitor_version>:
80001280:	494e4f4d 	0x494e4f4d
80001284:	20524f54 	addi	s2,v0,20308
80001288:	20726f66 	addi	s2,v1,28518
8000128c:	5350494d 	beql	k0,s0,800137c4 <UTEST_4MDCT+0x11710>
80001290:	2d203233 	sltiu	zero,t1,12851
80001294:	696e6920 	0x696e6920
80001298:	6c616974 	0x6c616974
8000129c:	64657a69 	0x64657a69
800012a0:	0000002e 	0x2e
800012a4:	807f0000 	lb	ra,0(v1)
800012a8:	807f0090 	lb	ra,144(v1)

800012ac <START>:
    .word   _sbss
    /* end address for the .bss section. defined in linker script */
    .word   _ebss
    .global START
START:                              // kernel init
    lui k0, %hi(_sbss)
800012ac:	3c1a807f 275a0000 3c1b807f 277b0090     ...<..Z'...<..{'

800012bc <bss_init>:
    addiu k0, %lo(_sbss)
    lui k1, %hi(_ebss)
    addiu k1, %lo(_ebss)
bss_init:
    beq k0, k1, bss_init_done
800012bc:	135b0005 	beq	k0,k1,800012d4 <bss_init_done>
    nop
800012c0:	00000000 	nop
    sw  zero, 0(k0)
800012c4:	af400000 	sw	zero,0(k0)
    addiu k0, k0, 4
800012c8:	275a0004 	addiu	k0,k0,4
    b   bss_init
800012cc:	1000fffb 	b	800012bc <bss_init>
    nop
800012d0:	00000000 	nop

800012d4 <bss_init_done>:
    lui t1, %hi(CAUSEF_IV)
    xor t1, t1, t0
    and t0, t0, t1                  // Cause IV位置零
    mtc0 t0, CP0_CAUSE              // 关闭中断特殊入口
#endif
    lui sp, %hi(KERNEL_STACK_INIT)  // 设置内核栈
800012d4:	3c1d8080 	lui	sp,0x8080
    addiu sp, %lo(KERNEL_STACK_INIT)
800012d8:	27bd0000 	addiu	sp,sp,0
    or fp, sp, zero
800012dc:	03a0f025 	move	s8,sp
    lui t0, %hi(USER_STACK_INIT)    // 设置用户栈
800012e0:	3c08807f 	lui	t0,0x807f
    addiu t0, %lo(USER_STACK_INIT)
800012e4:	25080000 	addiu	t0,t0,0
    lui t1, %hi(uregs_sp)           // 写入用户空间备份
800012e8:	3c09807f 	lui	t1,0x807f
    sw t0, %lo(uregs_sp)(t1)
800012ec:	ad280070 	sw	t0,112(t1)
    lui t1, %hi(uregs_fp)
800012f0:	3c09807f 	lui	t1,0x807f
    sw t0, %lo(uregs_fp)(t1)
800012f4:	ad280074 	sw	t0,116(t1)
    sb t1, %lo(COM_LCR)(t0)         // :62
    sb zero, %lo(COM_MCR)(t0)       // :65
    ori t1, zero, %lo(COM_IER_RDI)
    sb t1, %lo(COM_IER)(t0)         // :67
#else
    lui t0, %hi(SerialStat)
800012f8:	3c08bfd0 	lui	t0,0xbfd0
    ori t1, zero, 0x10
800012fc:	34090010 	li	t1,0x10
    sb t1, %lo(SerialStat)(t0)      // 串口可读中断
80001300:	a10903fc 	sb	t1,1020(t0)
    ori t0, t0, STATUSF_IP4         // hardware interrupt source #2, irq #4
    mtc0 t0, CP0_STATUS
#endif


    ori t0, zero, TF_SIZE / 4       // 计数器
80001304:	34080020 	li	t0,0x20
.LC0:
    addiu t0, t0, -1                // 滚动计数器
80001308:	2508ffff 	addiu	t0,t0,-1
    addiu sp, sp, -4                // 移动栈指针
8000130c:	27bdfffc 	addiu	sp,sp,-4
    sw zero, 0(sp)                  // 初始化栈空间
80001310:	afa00000 	sw	zero,0(sp)
    bne t0, zero, .LC0              // 初始化循环
80001314:	1500fffc 	bnez	t0,80001308 <bss_init_done+0x34>
    nop
80001318:	00000000 	nop
    lui t0, %hi(TCBT)
8000131c:	3c08807f 	lui	t0,0x807f
    addiu t0, %lo(TCBT)           // 载入TCBT地址
80001320:	25080080 	addiu	t0,t0,128
    sw sp, 0(t0)                    // thread0(idle)的中断帧地址设置
80001324:	ad1d0000 	sw	sp,0(t0)
    sw t1, TF_STATUS(sp)            // 写中断帧STATUS; idle线程打开串口硬件中断响应
    lui t3, %hi(IDLELOOP)
    addiu t3, %lo(IDLELOOP)       // 取得idle线程入口
    sw t3, TF_EPC(sp)               // 写中断帧EPC
#endif
    or t6, sp, zero                 // t6保存idle中断帧位置
80001328:	03a07025 	move	t6,sp

    ori t0, zero, TF_SIZE / 4       // 计数器
8000132c:	34080020 	li	t0,0x20
.LC1:
    addiu t0, t0, -1                // 滚动计数器
80001330:	2508ffff 	addiu	t0,t0,-1
    addiu sp, sp, -4                // 移动栈指针
80001334:	27bdfffc 	addiu	sp,sp,-4
    sw zero, 0(sp)                  // 初始化栈空间
80001338:	afa00000 	sw	zero,0(sp)
    bne t0, zero, .LC1              // 初始化循环
8000133c:	1500fffc 	bnez	t0,80001330 <bss_init_done+0x5c>
    nop
80001340:	00000000 	nop
    lui t0, %hi(TCBT)
80001344:	3c08807f 	lui	t0,0x807f
    addiu t0, %lo(TCBT)           // 载入TCBT地址
80001348:	25080080 	addiu	t0,t0,128
    sw sp, 4(t0)                    // thread1(shell/user)的中断帧地址设置
8000134c:	ad1d0004 	sw	sp,4(t0)
    sw sp, TF_sp(t6)                // 设置idle线程栈指针(调试用?)
80001350:	addd007c 	sw	sp,124(t6)

    lui t2, %hi(TCBT + 4)
80001354:	3c0a807f 	lui	t2,0x807f
    addiu t2, %lo(TCBT + 4)
80001358:	254a0084 	addiu	t2,t2,132
    lw t2, 0(t2)                    // 取得thread1的TCB地址
8000135c:	8d4a0000 	lw	t2,0(t2)
    lui t1, %hi(current)
80001360:	3c09807f 	lui	t1,0x807f
    sw t2, %lo(current)(t1)         // 设置当前线程为thread1
80001364:	ad2a0088 	sw	t2,136(t1)
    and t0, t0, t1                  // 主线程屏蔽串口硬件中断
    mtc0 t0, CP0_STATUS             // 启动完成，恢复中断机制
    nop
#endif

    j WELCOME                       // 进入主线程
80001368:	080004dc 	j	80001370 <WELCOME>
    nop
8000136c:	00000000 	nop

80001370 <WELCOME>:



WELCOME:
    lui s0, %hi(monitor_version)    // 装入启动信息
80001370:	3c108000 	lui	s0,0x8000
    addiu s0, %lo(monitor_version)
80001374:	26101280 	addiu	s0,s0,4736
    lb a0, 0(s0)
80001378:	82040000 	lb	a0,0(s0)
.Loop0:
    addiu s0, s0, 0x1
8000137c:	26100001 	addiu	s0,s0,1
    jal WRITESERIAL                 // 调用串口写函数
80001380:	0c000464 	jal	80001190 <WRITESERIAL>
    nop
80001384:	00000000 	nop
    lb a0, 0(s0)
80001388:	82040000 	lb	a0,0(s0)
    bne a0, zero, .Loop0            // 打印循环至0结束符
8000138c:	1480fffb 	bnez	a0,8000137c <WELCOME+0xc>
    nop
80001390:	00000000 	nop
    j SHELL                         // 开始交互
80001394:	080004f4 	j	800013d0 <SHELL>
    nop
80001398:	00000000 	nop

8000139c <IDLELOOP>:
	...
    nop
    nop
    nop
    nop
    nop
    j IDLELOOP
800013c4:	080004e7 	j	8000139c <IDLELOOP>
    nop
800013c8:	00000000 	nop
800013cc:	00000000 	nop

800013d0 <SHELL>:
     * 
     *  用户空间寄存器：$1-$30依次保存在0x807F0000连续120字节
     *  用户程序入口临时存储：0x807F0078
     */
SHELL:
    jal READSERIAL                  // 读操作符
800013d0:	0c00046f 00000000 34080052 10480026     o.......R..4&.H.
    nop

    ori t0, zero, SH_OP_R
    beq v0, t0, .OP_R
    nop
800013e0:	00000000 34080044 10480034 00000000     ....D..44.H.....
    ori t0, zero, SH_OP_D
    beq v0, t0, .OP_D
    nop
    ori t0, zero, SH_OP_A
800013f0:	34080041 10480046 00000000 34080047     A..4F.H.....G..4
    beq v0, t0, .OP_A
    nop
    ori t0, zero, SH_OP_G
    beq v0, t0, .OP_G
80001400:	10480059 00000000 34080054 10480003     Y.H.....T..4..H.
    nop
    ori t0, zero, SH_OP_T
    beq v0, t0, .OP_T
    nop
80001410:	00000000 080005aa 00000000              ............

8000141c <.OP_T>:
    j .DONE                         // 错误的操作符，默认忽略
    nop

.OP_T:                              // 操作 - 打印TLB项
    jal READSERIALWORD              // 取num(index)
8000141c:	0c00047a 	jal	800011e8 <READSERIALWORD>
    nop
80001420:	00000000 	nop
    addiu sp, sp, -0x18
80001424:	27bdffe8 	addiu	sp,sp,-24
    sw s0, 0x0(sp)
80001428:	afb00000 	sw	s0,0(sp)
    sw s1, 0x4(sp)
8000142c:	afb10004 	sw	s1,4(sp)
    mfc0 s0, CP0_ENTRYLO1           // 取ENTRYLO1
    sw s0, 0x14(sp)
    mtc0 s1, CP0_ENTRYHI            // 写回ASID
    nop
#else
    addiu s0, zero, -1              // 不支持TLB则返回全1
80001430:	2410ffff 	li	s0,-1
    sw s0, 0xC(sp)
80001434:	afb0000c 	sw	s0,12(sp)
    sw s0, 0x10(sp)
80001438:	afb00010 	sw	s0,16(sp)
    sw s0, 0x14(sp)
8000143c:	afb00014 	sw	s0,20(sp)
#endif

    ori s1, zero, 0xC               // 打印12字节
80001440:	3411000c 	li	s1,0xc
    addiu s0, sp, 0xC               // ENTRYHI位置
80001444:	27b0000c 	addiu	s0,sp,12
.LC3:
    lb a0, 0x0(s0)                  // 读一字节
80001448:	82040000 	lb	a0,0(s0)
    addiu s1, s1, -1                // 滚动计数器
8000144c:	2631ffff 	addiu	s1,s1,-1
    jal WRITESERIAL                 // 打印
80001450:	0c000464 	jal	80001190 <WRITESERIAL>
    nop
80001454:	00000000 	nop
    addiu s0, s0, 1                 // 移动打印指针
80001458:	26100001 	addiu	s0,s0,1
    bne s1, zero, .LC3              // 打印循环
8000145c:	1620fffa 	bnez	s1,80001448 <.OP_T+0x2c>
    nop
80001460:	00000000 	nop

    lw s0, 0x0(sp)
80001464:	8fb00000 	lw	s0,0(sp)
    lw s1, 0x4(sp)
80001468:	8fb10004 	lw	s1,4(sp)
    addiu sp, sp, 0x18
8000146c:	27bd0018 	addiu	sp,sp,24

    j .DONE
80001470:	080005aa 	j	800016a8 <.DONE>
    nop
80001474:	00000000 	nop

80001478 <.OP_R>:

.OP_R:                              // 操作 - 打印用户空间寄存器
    addiu sp, sp, -8                // 保存s0,s1
80001478:	27bdfff8 	addiu	sp,sp,-8
    sw s0, 0(sp)
8000147c:	afb00000 	sw	s0,0(sp)
    sw s1, 4(sp)
80001480:	afb10004 	sw	s1,4(sp)

    lui s0, %hi(uregs)
80001484:	3c10807f 	lui	s0,0x807f
    ori s1, zero, 120               // 计数器，打印120字节
80001488:	34110078 	li	s1,0x78
.LC0:
    lb a0, %lo(uregs)(s0)           // 读取字节
8000148c:	82040000 	lb	a0,0(s0)
    addiu s1, s1, -1                // 滚动计数器
80001490:	2631ffff 	addiu	s1,s1,-1
    jal WRITESERIAL                 // 写入串口
80001494:	0c000464 	jal	80001190 <WRITESERIAL>
    nop
80001498:	00000000 	nop
    addiu s0, s0, 0x1               // 移动打印指针
8000149c:	26100001 	addiu	s0,s0,1
    bne s1, zero, .LC0              // 打印循环
800014a0:	1620fffa 	bnez	s1,8000148c <.OP_R+0x14>
    nop
800014a4:	00000000 	nop

    lw s0, 0(sp)                    // 恢复s0,s1
800014a8:	8fb00000 	lw	s0,0(sp)
    lw s1, 4(sp)
800014ac:	8fb10004 	lw	s1,4(sp)
    addiu sp, sp, 8
800014b0:	27bd0008 	addiu	sp,sp,8
    j .DONE
800014b4:	080005aa 	j	800016a8 <.DONE>
    nop
800014b8:	00000000 	nop

800014bc <.OP_D>:

.OP_D:                              // 操作 - 打印内存num字节
    addiu sp, sp, -8                // 保存s0,s1
800014bc:	27bdfff8 	addiu	sp,sp,-8
    sw s0, 0(sp)
800014c0:	afb00000 	sw	s0,0(sp)
    sw s1, 4(sp)
800014c4:	afb10004 	sw	s1,4(sp)

    jal READSERIALWORD
800014c8:	0c00047a 	jal	800011e8 <READSERIALWORD>
    nop
800014cc:	00000000 	nop
    or s0, v0, zero                 // 获得addr
800014d0:	00408025 	move	s0,v0
    jal READSERIALWORD
800014d4:	0c00047a 	jal	800011e8 <READSERIALWORD>
    nop
800014d8:	00000000 	nop
    or s1, v0, zero                 // 获得num
800014dc:	00408825 	move	s1,v0

.LC1:
    lb a0, 0(s0)                    // 读取字节
800014e0:	82040000 	lb	a0,0(s0)
    addiu s1, s1, -1                // 滚动计数器
800014e4:	2631ffff 	addiu	s1,s1,-1
    jal WRITESERIAL                 // 写入串口
800014e8:	0c000464 	jal	80001190 <WRITESERIAL>
    nop
800014ec:	00000000 	nop
    addiu s0, s0, 0x1               // 移动打印指针
800014f0:	26100001 	addiu	s0,s0,1
    bne s1, zero, .LC1              // 打印循环
800014f4:	1620fffa 	bnez	s1,800014e0 <.OP_D+0x24>
    nop
800014f8:	00000000 	nop

    lw s0, 0(sp)                    // 恢复s0,s1
800014fc:	8fb00000 	lw	s0,0(sp)
    lw s1, 4(sp)
80001500:	8fb10004 	lw	s1,4(sp)
    addiu sp, sp, 8
80001504:	27bd0008 	addiu	sp,sp,8
    j .DONE
80001508:	080005aa 	j	800016a8 <.DONE>
    nop
8000150c:	00000000 	nop

80001510 <.OP_A>:

.OP_A:                              // 操作 - 写入内存num字节，num为4的倍数
    addiu sp, sp, -8                // 保存s0,s1
80001510:	27bdfff8 	addiu	sp,sp,-8
    sw s0, 0(sp)
80001514:	afb00000 	sw	s0,0(sp)
    sw s1, 4(sp)
80001518:	afb10004 	sw	s1,4(sp)

    jal READSERIALWORD
8000151c:	0c00047a 	jal	800011e8 <READSERIALWORD>
    nop
80001520:	00000000 	nop
    or s0, v0, zero                 // 获得addr
80001524:	00408025 	move	s0,v0
    jal READSERIALWORD
80001528:	0c00047a 	jal	800011e8 <READSERIALWORD>
    nop
8000152c:	00000000 	nop
    or s1, v0, zero                 // 获得num
80001530:	00408825 	move	s1,v0
    srl s1, s1, 2                   // num除4，获得字数
80001534:	00118882 	srl	s1,s1,0x2
.LC2:                               // 每次写入一字
    jal READSERIALWORD              // 从串口读入一字
80001538:	0c00047a 	jal	800011e8 <READSERIALWORD>
    nop
8000153c:	00000000 	nop
    sw v0, 0(s0)                    // 写内存一字
80001540:	ae020000 	sw	v0,0(s0)
    addiu s1, s1, -1                // 滚动计数器
80001544:	2631ffff 	addiu	s1,s1,-1
    addiu s0, s0, 4                 // 移动写指针
80001548:	26100004 	addiu	s0,s0,4
    bne s1, zero, .LC2              // 写循环
8000154c:	1620fffa 	bnez	s1,80001538 <.OP_A+0x28>
    nop
80001550:	00000000 	nop

    lw s0, 0(sp)                    // 恢复s0,s1
80001554:	8fb00000 	lw	s0,0(sp)
    lw s1, 4(sp)
80001558:	8fb10004 	lw	s1,4(sp)
    addiu sp, sp, 8
8000155c:	27bd0008 	addiu	sp,sp,8
    j .DONE
80001560:	080005aa 	j	800016a8 <.DONE>
    nop
80001564:	00000000 	nop

80001568 <.OP_G>:

.OP_G:
    jal READSERIALWORD              // 获取addr
80001568:	0c00047a 	jal	800011e8 <READSERIALWORD>
    nop
8000156c:	00000000 	nop

    ori a0, zero, TIMERSET          // 写TIMERSET(0x06)信号
80001570:	34040006 	li	a0,0x6
    jal WRITESERIAL                 // 告诉终端用户程序开始运行
80001574:	0c000464 	jal	80001190 <WRITESERIAL>
    nop
80001578:	00000000 	nop

#ifdef ENABLE_INT
    mtc0 v0, CP0_EPC                // 用户程序入口写入EPC
#else
    or k0, v0, zero
8000157c:	0040d025 	move	k0,v0
#endif

    lui ra, %hi(uregs)              // 定位用户空间寄存器备份地址
80001580:	3c1f807f 	lui	ra,0x807f
    addiu ra, %lo(uregs)
80001584:	27ff0000 	addiu	ra,ra,0
    sw v0, PUTREG(31)(ra)           // 保存用户程序入口
80001588:	afe20078 	sw	v0,120(ra)
    sw sp, PUTREG(32)(ra)           // 保存栈指针
8000158c:	affd007c 	sw	sp,124(ra)

    lw $1,  PUTREG(1)(ra)           // 装入$1-$30
80001590:	8fe10000 	lw	at,0(ra)
    lw $2,  PUTREG(2)(ra)
80001594:	8fe20004 	lw	v0,4(ra)
    lw $3,  PUTREG(3)(ra)
80001598:	8fe30008 	lw	v1,8(ra)
    lw $4,  PUTREG(4)(ra)
8000159c:	8fe4000c 	lw	a0,12(ra)
    lw $5,  PUTREG(5)(ra)
800015a0:	8fe50010 	lw	a1,16(ra)
    lw $6,  PUTREG(6)(ra)
800015a4:	8fe60014 	lw	a2,20(ra)
    lw $7,  PUTREG(7)(ra)
800015a8:	8fe70018 	lw	a3,24(ra)
    lw $8,  PUTREG(8)(ra)
800015ac:	8fe8001c 	lw	t0,28(ra)
    lw $9,  PUTREG(9)(ra)
800015b0:	8fe90020 	lw	t1,32(ra)
    lw $10, PUTREG(10)(ra)
800015b4:	8fea0024 	lw	t2,36(ra)
    lw $11, PUTREG(11)(ra)
800015b8:	8feb0028 	lw	t3,40(ra)
    lw $12, PUTREG(12)(ra)
800015bc:	8fec002c 	lw	t4,44(ra)
    lw $13, PUTREG(13)(ra)
800015c0:	8fed0030 	lw	t5,48(ra)
    lw $14, PUTREG(14)(ra)
800015c4:	8fee0034 	lw	t6,52(ra)
    lw $15, PUTREG(15)(ra)
800015c8:	8fef0038 	lw	t7,56(ra)
    lw $16, PUTREG(16)(ra)
800015cc:	8ff0003c 	lw	s0,60(ra)
    lw $17, PUTREG(17)(ra)
800015d0:	8ff10040 	lw	s1,64(ra)
    lw $18, PUTREG(18)(ra)
800015d4:	8ff20044 	lw	s2,68(ra)
    lw $19, PUTREG(19)(ra)
800015d8:	8ff30048 	lw	s3,72(ra)
    lw $20, PUTREG(20)(ra)
800015dc:	8ff4004c 	lw	s4,76(ra)
    lw $21, PUTREG(21)(ra)
800015e0:	8ff50050 	lw	s5,80(ra)
    lw $22, PUTREG(22)(ra)
800015e4:	8ff60054 	lw	s6,84(ra)
    lw $23, PUTREG(23)(ra)
800015e8:	8ff70058 	lw	s7,88(ra)
    lw $24, PUTREG(24)(ra)
800015ec:	8ff8005c 	lw	t8,92(ra)
    lw $25, PUTREG(25)(ra)
800015f0:	8ff90060 	lw	t9,96(ra)
    //lw $26, PUTREG(26)(ra)
    //lw $27, PUTREG(27)(ra)
    lw $28, PUTREG(28)(ra)
800015f4:	8ffc006c 	lw	gp,108(ra)
    lw $29, PUTREG(29)(ra)
800015f8:	8ffd0070 	lw	sp,112(ra)
    lw $30, PUTREG(30)(ra)
800015fc:	8ffe0074 	lw	s8,116(ra)

    lui ra, %hi(.USERRET2)          // ra写入返回地址
80001600:	3c1f8000 	lui	ra,0x8000
    addiu ra, %lo(.USERRET2)
80001604:	27ff1614 	addiu	ra,ra,5652
    nop
80001608:	00000000 	nop
#ifdef ENABLE_INT
    eret                            // 进入用户程序
#else
    jr k0
8000160c:	03400008 	jr	k0
    nop
80001610:	00000000 	nop

80001614 <.USERRET2>:
#endif
.USERRET2:
    nop
80001614:	00000000 	nop

    lui ra, %hi(uregs)              // 定位用户空间寄存器备份地址
80001618:	3c1f807f 	lui	ra,0x807f
    addiu ra, %lo(uregs)
8000161c:	27ff0000 	addiu	ra,ra,0

    sw $1,  PUTREG(1)(ra)           // 备份$1-$30
80001620:	afe10000 	sw	at,0(ra)
    sw $2,  PUTREG(2)(ra)
80001624:	afe20004 	sw	v0,4(ra)
    sw $3,  PUTREG(3)(ra)
80001628:	afe30008 	sw	v1,8(ra)
    sw $4,  PUTREG(4)(ra)
8000162c:	afe4000c 	sw	a0,12(ra)
    sw $5,  PUTREG(5)(ra)
80001630:	afe50010 	sw	a1,16(ra)
    sw $6,  PUTREG(6)(ra)
80001634:	afe60014 	sw	a2,20(ra)
    sw $7,  PUTREG(7)(ra)
80001638:	afe70018 	sw	a3,24(ra)
    sw $8,  PUTREG(8)(ra)
8000163c:	afe8001c 	sw	t0,28(ra)
    sw $9,  PUTREG(9)(ra)
80001640:	afe90020 	sw	t1,32(ra)
    sw $10, PUTREG(10)(ra)
80001644:	afea0024 	sw	t2,36(ra)
    sw $11, PUTREG(11)(ra)
80001648:	afeb0028 	sw	t3,40(ra)
    sw $12, PUTREG(12)(ra)
8000164c:	afec002c 	sw	t4,44(ra)
    sw $13, PUTREG(13)(ra)
80001650:	afed0030 	sw	t5,48(ra)
    sw $14, PUTREG(14)(ra)
80001654:	afee0034 	sw	t6,52(ra)
    sw $15, PUTREG(15)(ra)
80001658:	afef0038 	sw	t7,56(ra)
    sw $16, PUTREG(16)(ra)
8000165c:	aff0003c 	sw	s0,60(ra)
    sw $17, PUTREG(17)(ra)
80001660:	aff10040 	sw	s1,64(ra)
    sw $18, PUTREG(18)(ra)
80001664:	aff20044 	sw	s2,68(ra)
    sw $19, PUTREG(19)(ra)
80001668:	aff30048 	sw	s3,72(ra)
    sw $20, PUTREG(20)(ra)
8000166c:	aff4004c 	sw	s4,76(ra)
    sw $21, PUTREG(21)(ra)
80001670:	aff50050 	sw	s5,80(ra)
    sw $22, PUTREG(22)(ra)
80001674:	aff60054 	sw	s6,84(ra)
    sw $23, PUTREG(23)(ra)
80001678:	aff70058 	sw	s7,88(ra)
    sw $24, PUTREG(24)(ra)
8000167c:	aff8005c 	sw	t8,92(ra)
    sw $25, PUTREG(25)(ra)
80001680:	aff90060 	sw	t9,96(ra)
    //sw $26, PUTREG(26)(ra)
    //sw $27, PUTREG(27)(ra)
    sw $28, PUTREG(28)(ra)
80001684:	affc006c 	sw	gp,108(ra)
    sw $29, PUTREG(29)(ra)
80001688:	affd0070 	sw	sp,112(ra)
    sw $30, PUTREG(30)(ra)
8000168c:	affe0074 	sw	s8,116(ra)

    lw sp, PUTREG(32)(ra)
80001690:	8ffd007c 	lw	sp,124(ra)
    ori a0, zero, TIMETOKEN         // 发送TIMETOKEN(0x07)信号
80001694:	34040007 	li	a0,0x7
    jal WRITESERIAL                 // 告诉终端用户程序结束运行
80001698:	0c000464 	jal	80001190 <WRITESERIAL>
    nop
8000169c:	00000000 	nop

    j .DONE
800016a0:	080005aa 	j	800016a8 <.DONE>
    nop
800016a4:	00000000 	nop

800016a8 <.DONE>:

.DONE:
    j SHELL                         // 交互循环
800016a8:	080004f4 	j	800013d0 <SHELL>
    nop
800016ac:	00000000 	nop

800016b0 <EXCEPTIONHANDLER>:
FATAL:
EXCEPTIONHANDLER:
RETURNFRMTRAP:
WAKEUPSHELL:
SYSCALL:
    b   FATAL                       // 不支持异常时，这些入口都不应该进入，如果进入就永远等待，用于调试
800016b0:	1000ffff 00000000 00000000 00000000     ................

800016c0 <SCHEDULE>:
    or sp, t2, zero                 // 调换中断帧指针
    sw sp, %lo(current)(t4)         // 设置current为调度线程
    j RETURNFRMTRAP                 // 退出中断，加载调度线程中断帧，完成线程切换
    nop
#else
    b SCHEDULE                      // Infinity loop for debug
800016c0:	1000ffff 00000000 00000000 00000000     ................
	...

80002000 <UTEST_SIMPLE>:
    .set noat
    .section .text.utest
    .p2align 2

UTEST_SIMPLE:
    addiu v0, v0, 0x1
80002000:	24420001 	addiu	v0,v0,1
    jr ra
80002004:	03e00008 	jr	ra
    nop
80002008:	00000000 	nop

8000200c <UTEST_1PTB>:
     *  这段程序一般没有数据冲突和结构冲突，可作为性能标定。
     *  若执行延迟槽，执行这段程序需至少384M指令，384M/time可算得频率。
     *  不执行延迟槽，执行这段程序需至少320M指令，320M/time可算得频率。
     */
UTEST_1PTB:
    lui t0, %hi(TESTLOOP64)         // 装入64M
8000200c:	3c080400 	lui	t0,0x400
	...
    nop
    nop
    nop
.LC0:
    addiu t0, t0, -1                // 滚动计数器
8000201c:	2508ffff 	addiu	t0,t0,-1
    ori t1, zero, 0
80002020:	34090000 	li	t1,0x0
    ori t2, zero, 1
80002024:	340a0001 	li	t2,0x1
    ori t3, zero, 2
80002028:	340b0002 	li	t3,0x2
    bne t0, zero, .LC0
8000202c:	1500fffb 	bnez	t0,8000201c <UTEST_1PTB+0x10>
    nop
80002030:	00000000 	nop
    nop
80002034:	00000000 	nop
    jr ra
80002038:	03e00008 	jr	ra
    nop
8000203c:	00000000 	nop

80002040 <UTEST_2DCT>:
     *  这段程序含有大量数据冲突，可测试数据冲突对效率的影响。
     *  执行延迟槽，执行这段程序需至少192M指令。
     *  不执行延迟槽，执行这段程序需至少176M指令。
     */
UTEST_2DCT:
    lui t0, %hi(TESTLOOP16)         // 装入16M
80002040:	3c080100 	lui	t0,0x100
    ori t1, zero, 1
80002044:	34090001 	li	t1,0x1
    ori t2, zero, 2
80002048:	340a0002 	li	t2,0x2
    ori t3, zero, 3
8000204c:	340b0003 	li	t3,0x3
.LC1:
    xor t2, t2, t1                  // 交换t1,t2
80002050:	01495026 	xor	t2,t2,t1
    xor t1, t1, t2
80002054:	012a4826 	xor	t1,t1,t2
    xor t2, t2, t1
80002058:	01495026 	xor	t2,t2,t1
    xor t3, t3, t2                  // 交换t2,t3
8000205c:	016a5826 	xor	t3,t3,t2
    xor t2, t2, t3
80002060:	014b5026 	xor	t2,t2,t3
    xor t3, t3, t2
80002064:	016a5826 	xor	t3,t3,t2
    xor t1, t1, t3                  // 交换t3,t1
80002068:	012b4826 	xor	t1,t1,t3
    xor t3, t3, t1
8000206c:	01695826 	xor	t3,t3,t1
    xor t1, t1, t3
80002070:	012b4826 	xor	t1,t1,t3
    addiu t0, t0, -1
80002074:	2508ffff 	addiu	t0,t0,-1
    bne t0, zero, .LC1
80002078:	1500fff5 	bnez	t0,80002050 <UTEST_2DCT+0x10>
    nop
8000207c:	00000000 	nop
    jr ra
80002080:	03e00008 	jr	ra
    nop
80002084:	00000000 	nop

80002088 <UTEST_3CCT>:
     *  这段程序有大量控制冲突。
     *  无延迟槽执行需要至少256M指令；
     *  有延迟槽需要224M指令。
     */
UTEST_3CCT:
    lui t0, %hi(TESTLOOP64)         // 装入64M
80002088:	3c080400 	lui	t0,0x400
.LC2_0:
    bne t0, zero, .LC2_1
8000208c:	15000003 	bnez	t0,8000209c <UTEST_3CCT+0x14>
    nop
80002090:	00000000 	nop
    jr ra
80002094:	03e00008 	jr	ra
    nop
80002098:	00000000 	nop
.LC2_1:
    j .LC2_2
8000209c:	08000829 	j	800020a4 <UTEST_3CCT+0x1c>
    nop
800020a0:	00000000 	nop
.LC2_2:
    addiu t0, t0, -1
800020a4:	2508ffff 	addiu	t0,t0,-1
    j .LC2_0
800020a8:	08000823 	j	8000208c <UTEST_3CCT+0x4>
    addiu t0, t0, -1
800020ac:	2508ffff 	addiu	t0,t0,-1
    nop
800020b0:	00000000 	nop

800020b4 <UTEST_4MDCT>:
     *  这段程序反复对内存进行有数据冲突的读写。
     *  不执行延迟槽需要至少192M指令。
     *  执行延迟槽，需要至少224M指令。
     */
UTEST_4MDCT:
    lui t0, %hi(TESTLOOP32)          // 装入32M
800020b4:	3c080200 	lui	t0,0x200
    addiu sp, sp, -4
800020b8:	27bdfffc 	addiu	sp,sp,-4
.LC3:
    sw t0, 0(sp)
800020bc:	afa80000 	sw	t0,0(sp)
    lw t1, 0(sp)
800020c0:	8fa90000 	lw	t1,0(sp)
    addiu t1, t1, -1
800020c4:	2529ffff 	addiu	t1,t1,-1
    sw t1, 0(sp)
800020c8:	afa90000 	sw	t1,0(sp)
    lw t0, 0(sp)
800020cc:	8fa80000 	lw	t0,0(sp)
    bne t0, zero, .LC3
800020d0:	1500fffa 	bnez	t0,800020bc <UTEST_4MDCT+0x8>
    nop
800020d4:	00000000 	nop
    addiu sp, sp, 4
800020d8:	27bd0004 	addiu	sp,sp,4
    jr ra
800020dc:	03e00008 	jr	ra
    nop
800020e0:	00000000 	nop
