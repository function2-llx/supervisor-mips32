
kernel.elf:     file format elf32-tradlittlemips


Disassembly of section .text.init:

80000000 <INITLOCATE>:
    .set noat
    .p2align 2
    .section .text.init
    .global INITLOCATE
INITLOCATE:                         // 定位启动程序
    lui k0, %hi(START)
80000000:	00 80 1a 3c bc 12 5a 27 08 00 40 03 00 00 00 00     ...<..Z'..@.....

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
80001184:	275a176c 	addiu	k0,k0,5996
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
800011c8:	15000005 	bnez	t0,800011e0 <.RSERIAL>
    nop
800011cc:	00000000 	nop
#ifdef ENABLE_INT
    ori v0, zero, SYS_wait          // 取得wait调用号
800011d0:	34020003 	li	v0,0x3
    syscall SYSCALL_BASE            // 睡眠等待
800011d4:	0000200c 	syscall	0x80
#endif
    j .TESTR                        // 检测验证
800011d8:	08000470 	j	800011c0 <.TESTR>
    nop
800011dc:	00000000 	nop

800011e0 <.RSERIAL>:
.RSERIAL:
    lui t1, %hi(SerialData)
800011e0:	3c09bfd0 	lui	t1,0xbfd0
    lb v0, %lo(SerialData)(t1)      // 读出
800011e4:	812203f8 	lb	v0,1016(t1)
    jr ra
800011e8:	03e00008 	jr	ra
    nop
800011ec:	00000000 	nop

800011f0 <READSERIALWORD>:
    jr ra
    nop
#endif //ifdef MACH_FPGA

READSERIALWORD:
    addiu sp, sp, -0x14             // 保存ra,s0
800011f0:	27bdffec afbf0000 afb00004 afb10008     ...'............
    sw ra, 0x0(sp)
    sw s0, 0x4(sp)
    sw s1, 0x8(sp)
    sw s2, 0xC(sp)
80001200:	afb2000c afb30010 0c00046f 00000000     ........o.......
    sw s3, 0x10(sp)

    jal READSERIAL                  // 读串口获得八个比特
    nop
    or s0, zero, v0                 // 结果存入s0
80001210:	00028025 0c00046f 00000000 00028825     %...o.......%...
    jal READSERIAL                  // 读串口获得八个比特
    nop
    or s1, zero, v0                 // 结果存入s1
    jal READSERIAL                  // 读串口获得八个比特
80001220:	0c00046f 00000000 00029025 0c00046f     o.......%...o...
    nop
    or s2, zero, v0                 // 结果存入s2
    jal READSERIAL                  // 读串口获得八个比特
    nop
80001230:	00000000 00029825 321000ff 327300ff     ....%......2..s2
    or s3, zero, v0                 // 结果存入s3

    andi s0, s0, 0x00FF             // 截取低八位
    andi s3, s3, 0x00FF
    andi s2, s2, 0x00FF
80001240:	325200ff 323100ff 00131025 00021200     ..R2..12%.......
    andi s1, s1, 0x00FF
    or v0, zero, s3                 // 存高八位
    sll v0, v0, 8                   // 左移
    or v0, v0, s2                   // 存八位
80001250:	00521025 00021200 00511025 00021200     %.R.....%.Q.....
    sll v0, v0, 8                   // 左移
    or v0, v0, s1                   // 存八位
    sll v0, v0, 8                   // 左移
    or v0, v0, s0                   // 存低八位
80001260:	00501025 8fbf0000 8fb00004 8fb10008     %.P.............

    lw ra, 0x0(sp)                  // 恢复ra,s0
    lw s0, 0x4(sp)
    lw s1, 0x8(sp)
    lw s2, 0xC(sp)
80001270:	8fb2000c 8fb30010 27bd0014 03e00008     ...........'....
	...

80001290 <monitor_version>:
80001290:	494e4f4d 	0x494e4f4d
80001294:	20524f54 	addi	s2,v0,20308
80001298:	20726f66 	addi	s2,v1,28518
8000129c:	5350494d 	beql	k0,s0,800137d4 <UTEST_4MDCT+0x116fc>
800012a0:	2d203233 	sltiu	zero,t1,12851
800012a4:	696e6920 	0x696e6920
800012a8:	6c616974 	0x6c616974
800012ac:	64657a69 	0x64657a69
800012b0:	0000002e 	0x2e
800012b4:	807f0000 	lb	ra,0(v1)
800012b8:	807f0090 	lb	ra,144(v1)

800012bc <START>:
    .word   _sbss
    /* end address for the .bss section. defined in linker script */
    .word   _ebss
    .global START
START:                              // kernel init
    lui k0, %hi(_sbss)
800012bc:	3c1a807f 275a0000 3c1b807f 277b0090     ...<..Z'...<..{'

800012cc <bss_init>:
    addiu k0, %lo(_sbss)
    lui k1, %hi(_ebss)
    addiu k1, %lo(_ebss)
bss_init:
    beq k0, k1, bss_init_done
800012cc:	135b0005 	beq	k0,k1,800012e4 <bss_init_done>
    nop
800012d0:	00000000 	nop
    sw  zero, 0(k0)
800012d4:	af400000 	sw	zero,0(k0)
    addiu k0, k0, 4
800012d8:	275a0004 	addiu	k0,k0,4
    b   bss_init
800012dc:	1000fffb 	b	800012cc <bss_init>
    nop
800012e0:	00000000 	nop

800012e4 <bss_init_done>:

bss_init_done:
#ifdef ENABLE_INT
    mfc0 t0, CP0_STATUS             // 取得cp0的status Reg
800012e4:	40086000 	mfc0	t0,c0_status
    nop
800012e8:	00000000 	nop
    xori t1, t0, (ST0_IM | ST0_IE | ST0_EXL | ST0_ERL)
800012ec:	3909ff07 	xori	t1,t0,0xff07
                                    // 取消错误、异常位，使得eret正常
                                    // 见Vol3p196ERL,错误置位会让eret跳ErEPC
    and t0, t0, t1                  // status Reg 的IE位和IM位置零
800012f0:	01094024 	and	t0,t0,t1
    mtc0 t0, CP0_STATUS             // 暂停中断响应，直到启动完成
800012f4:	40886000 	mtc0	t0,c0_status
    nop
800012f8:	00000000 	nop

    mfc0 t0, CP0_STATUS
800012fc:	40086000 	mfc0	t0,c0_status
    lui t1, %hi(ST0_BEV)
80001300:	3c090040 	lui	t1,0x40
    xor t1, t0, t1
80001304:	01094826 	xor	t1,t0,t1
    and t0, t0, t1                  // status Reg 的BEV位置零
80001308:	01094024 	and	t0,t0,t1
    mtc0 t0, CP0_STATUS             // 中断处理转为正常模式
8000130c:	40886000 	mtc0	t0,c0_status
    ori t2, zero, PAGE_SIZE
80001310:	340a1000 	li	t2,0x1000
    mtc0 t2, CP0_EBASE              // 设定中断响应基址为0x8000.1000
80001314:	408a7801 	mtc0	t2,c0_ebase
    mfc0 t0, CP0_CAUSE
80001318:	40086800 	mfc0	t0,c0_cause
    lui t1, %hi(CAUSEF_IV)
8000131c:	3c090080 	lui	t1,0x80
    xor t1, t1, t0
80001320:	01284826 	xor	t1,t1,t0
    and t0, t0, t1                  // Cause IV位置零
80001324:	01094024 	and	t0,t0,t1
    mtc0 t0, CP0_CAUSE              // 关闭中断特殊入口
80001328:	40886800 	mtc0	t0,c0_cause
#endif
    lui sp, %hi(KERNEL_STACK_INIT)  // 设置内核栈
8000132c:	3c1d8080 	lui	sp,0x8080
    addiu sp, %lo(KERNEL_STACK_INIT)
80001330:	27bd0000 	addiu	sp,sp,0
    or fp, sp, zero
80001334:	03a0f025 	move	s8,sp
    lui t0, %hi(USER_STACK_INIT)    // 设置用户栈
80001338:	3c08807f 	lui	t0,0x807f
    addiu t0, %lo(USER_STACK_INIT)
8000133c:	25080000 	addiu	t0,t0,0
    lui t1, %hi(uregs_sp)           // 写入用户空间备份
80001340:	3c09807f 	lui	t1,0x807f
    sw t0, %lo(uregs_sp)(t1)
80001344:	ad280070 	sw	t0,112(t1)
    lui t1, %hi(uregs_fp)
80001348:	3c09807f 	lui	t1,0x807f
    sw t0, %lo(uregs_fp)(t1)
8000134c:	ad280074 	sw	t0,116(t1)
    sb t1, %lo(COM_LCR)(t0)         // :62
    sb zero, %lo(COM_MCR)(t0)       // :65
    ori t1, zero, %lo(COM_IER_RDI)
    sb t1, %lo(COM_IER)(t0)         // :67
#else
    lui t0, %hi(SerialStat)
80001350:	3c08bfd0 	lui	t0,0xbfd0
    ori t1, zero, 0x10
80001354:	34090010 	li	t1,0x10
    sb t1, %lo(SerialStat)(t0)      // 串口可读中断
80001358:	a10903fc 	sb	t1,1020(t0)
#endif

#ifdef ENABLE_INT
    /* enable serial interrupt */
    mfc0 t0, CP0_STATUS
8000135c:	40086000 	mfc0	t0,c0_status
    ori t0, t0, STATUSF_IP4         // hardware interrupt source #2, irq #4
80001360:	35081000 	ori	t0,t0,0x1000
    mtc0 t0, CP0_STATUS
80001364:	40886000 	mtc0	t0,c0_status
#endif


    ori t0, zero, TF_SIZE / 4       // 计数器
80001368:	34080020 	li	t0,0x20
.LC0:
    addiu t0, t0, -1                // 滚动计数器
8000136c:	2508ffff 	addiu	t0,t0,-1
    addiu sp, sp, -4                // 移动栈指针
80001370:	27bdfffc 	addiu	sp,sp,-4
    sw zero, 0(sp)                  // 初始化栈空间
80001374:	afa00000 	sw	zero,0(sp)
    bne t0, zero, .LC0              // 初始化循环
80001378:	1500fffc 	bnez	t0,8000136c <bss_init_done+0x88>
    nop
8000137c:	00000000 	nop
    lui t0, %hi(TCBT)
80001380:	3c08807f 	lui	t0,0x807f
    addiu t0, %lo(TCBT)           // 载入TCBT地址
80001384:	25080080 	addiu	t0,t0,128
    sw sp, 0(t0)                    // thread0(idle)的中断帧地址设置
80001388:	ad1d0000 	sw	sp,0(t0)
#ifdef ENABLE_INT
    mfc0 t1, CP0_STATUS             // 取STATUS
8000138c:	40096000 	mfc0	t1,c0_status
    mfc0 t2, CP0_CAUSE              // 取CAUSE
80001390:	400a6800 	mfc0	t2,c0_cause
    ori t1, t1, ST0_IE              // 使能中断
80001394:	35290001 	ori	t1,t1,0x1
    sw t2, TF_CAUSE(sp)             // 写中断帧CAUSE
80001398:	afaa0074 	sw	t2,116(sp)
    sw t1, TF_STATUS(sp)            // 写中断帧STATUS; idle线程打开串口硬件中断响应
8000139c:	afa90070 	sw	t1,112(sp)
    lui t3, %hi(IDLELOOP)
800013a0:	3c0b8000 	lui	t3,0x8000
    addiu t3, %lo(IDLELOOP)       // 取得idle线程入口
800013a4:	256b143c 	addiu	t3,t3,5180
    sw t3, TF_EPC(sp)               // 写中断帧EPC
800013a8:	afab0078 	sw	t3,120(sp)
#endif
    or t6, sp, zero                 // t6保存idle中断帧位置
800013ac:	03a07025 	move	t6,sp

    ori t0, zero, TF_SIZE / 4       // 计数器
800013b0:	34080020 	li	t0,0x20
.LC1:
    addiu t0, t0, -1                // 滚动计数器
800013b4:	2508ffff 	addiu	t0,t0,-1
    addiu sp, sp, -4                // 移动栈指针
800013b8:	27bdfffc 	addiu	sp,sp,-4
    sw zero, 0(sp)                  // 初始化栈空间
800013bc:	afa00000 	sw	zero,0(sp)
    bne t0, zero, .LC1              // 初始化循环
800013c0:	1500fffc 	bnez	t0,800013b4 <bss_init_done+0xd0>
    nop
800013c4:	00000000 	nop
    lui t0, %hi(TCBT)
800013c8:	3c08807f 	lui	t0,0x807f
    addiu t0, %lo(TCBT)           // 载入TCBT地址
800013cc:	25080080 	addiu	t0,t0,128
    sw sp, 4(t0)                    // thread1(shell/user)的中断帧地址设置
800013d0:	ad1d0004 	sw	sp,4(t0)
    sw sp, TF_sp(t6)                // 设置idle线程栈指针(调试用?)
800013d4:	addd007c 	sw	sp,124(t6)

    lui t2, %hi(TCBT + 4)
800013d8:	3c0a807f 	lui	t2,0x807f
    addiu t2, %lo(TCBT + 4)
800013dc:	254a0084 	addiu	t2,t2,132
    lw t2, 0(t2)                    // 取得thread1的TCB地址
800013e0:	8d4a0000 	lw	t2,0(t2)
    lui t1, %hi(current)
800013e4:	3c09807f 	lui	t1,0x807f
    sw t2, %lo(current)(t1)         // 设置当前线程为thread1
800013e8:	ad2a0088 	sw	t2,136(t1)
    tlbwi
    nop
#endif

#ifdef ENABLE_INT
    mfc0 t0, CP0_STATUS             // 取得cp0的status Reg
800013ec:	40086000 	mfc0	t0,c0_status
    nop
800013f0:	00000000 	nop
    ori t0, t0, ST0_IE              // status Reg 的IE位置一
800013f4:	35080001 	ori	t0,t0,0x1
    xori t1, t0, STATUSF_IP4
800013f8:	39091000 	xori	t1,t0,0x1000
    and t0, t0, t1                  // 主线程屏蔽串口硬件中断
800013fc:	01094024 	and	t0,t0,t1
    mtc0 t0, CP0_STATUS             // 启动完成，恢复中断机制
80001400:	40886000 	mtc0	t0,c0_status
    nop
80001404:	00000000 	nop
#endif

    j WELCOME                       // 进入主线程
80001408:	08000504 	j	80001410 <WELCOME>
    nop
8000140c:	00000000 	nop

80001410 <WELCOME>:



WELCOME:
    lui s0, %hi(monitor_version)    // 装入启动信息
80001410:	3c108000 	lui	s0,0x8000
    addiu s0, %lo(monitor_version)
80001414:	26101290 	addiu	s0,s0,4752
    lb a0, 0(s0)
80001418:	82040000 	lb	a0,0(s0)
.Loop0:
    addiu s0, s0, 0x1
8000141c:	26100001 	addiu	s0,s0,1
    jal WRITESERIAL                 // 调用串口写函数
80001420:	0c000464 	jal	80001190 <WRITESERIAL>
    nop
80001424:	00000000 	nop
    lb a0, 0(s0)
80001428:	82040000 	lb	a0,0(s0)
    bne a0, zero, .Loop0            // 打印循环至0结束符
8000142c:	1480fffb 	bnez	a0,8000141c <WELCOME+0xc>
    nop
80001430:	00000000 	nop
    j SHELL                         // 开始交互
80001434:	0800051c 	j	80001470 <SHELL>
    nop
80001438:	00000000 	nop

8000143c <IDLELOOP>:
	...
    nop
    nop
    nop
    nop
    nop
    j IDLELOOP
80001464:	0800050f 	j	8000143c <IDLELOOP>
    nop
80001468:	00000000 	nop
8000146c:	00000000 	nop

80001470 <SHELL>:
     * 
     *  用户空间寄存器：$1-$30依次保存在0x807F0000连续120字节
     *  用户程序入口临时存储：0x807F0078
     */
SHELL:
    jal READSERIAL                  // 读操作符
80001470:	0c00046f 00000000 34080052 10480026     o.......R..4&.H.
    nop

    ori t0, zero, SH_OP_R
    beq v0, t0, .OP_R
    nop
80001480:	00000000 34080044 10480034 00000000     ....D..44.H.....
    ori t0, zero, SH_OP_D
    beq v0, t0, .OP_D
    nop
    ori t0, zero, SH_OP_A
80001490:	34080041 10480046 00000000 34080047     A..4F.H.....G..4
    beq v0, t0, .OP_A
    nop
    ori t0, zero, SH_OP_G
    beq v0, t0, .OP_G
800014a0:	10480059 00000000 34080054 10480003     Y.H.....T..4..H.
    nop
    ori t0, zero, SH_OP_T
    beq v0, t0, .OP_T
    nop
800014b0:	00000000 080005d1 00000000              ............

800014bc <.OP_T>:
    j .DONE                         // 错误的操作符，默认忽略
    nop

.OP_T:                              // 操作 - 打印TLB项
    jal READSERIALWORD              // 取num(index)
800014bc:	0c00047c 	jal	800011f0 <READSERIALWORD>
    nop
800014c0:	00000000 	nop
    addiu sp, sp, -0x18
800014c4:	27bdffe8 	addiu	sp,sp,-24
    sw s0, 0x0(sp)
800014c8:	afb00000 	sw	s0,0(sp)
    sw s1, 0x4(sp)
800014cc:	afb10004 	sw	s1,4(sp)
    mfc0 s0, CP0_ENTRYLO1           // 取ENTRYLO1
    sw s0, 0x14(sp)
    mtc0 s1, CP0_ENTRYHI            // 写回ASID
    nop
#else
    addiu s0, zero, -1              // 不支持TLB则返回全1
800014d0:	2410ffff 	li	s0,-1
    sw s0, 0xC(sp)
800014d4:	afb0000c 	sw	s0,12(sp)
    sw s0, 0x10(sp)
800014d8:	afb00010 	sw	s0,16(sp)
    sw s0, 0x14(sp)
800014dc:	afb00014 	sw	s0,20(sp)
#endif

    ori s1, zero, 0xC               // 打印12字节
800014e0:	3411000c 	li	s1,0xc
    addiu s0, sp, 0xC               // ENTRYHI位置
800014e4:	27b0000c 	addiu	s0,sp,12
.LC3:
    lb a0, 0x0(s0)                  // 读一字节
800014e8:	82040000 	lb	a0,0(s0)
    addiu s1, s1, -1                // 滚动计数器
800014ec:	2631ffff 	addiu	s1,s1,-1
    jal WRITESERIAL                 // 打印
800014f0:	0c000464 	jal	80001190 <WRITESERIAL>
    nop
800014f4:	00000000 	nop
    addiu s0, s0, 1                 // 移动打印指针
800014f8:	26100001 	addiu	s0,s0,1
    bne s1, zero, .LC3              // 打印循环
800014fc:	1620fffa 	bnez	s1,800014e8 <.OP_T+0x2c>
    nop
80001500:	00000000 	nop

    lw s0, 0x0(sp)
80001504:	8fb00000 	lw	s0,0(sp)
    lw s1, 0x4(sp)
80001508:	8fb10004 	lw	s1,4(sp)
    addiu sp, sp, 0x18
8000150c:	27bd0018 	addiu	sp,sp,24

    j .DONE
80001510:	080005d1 	j	80001744 <.DONE>
    nop
80001514:	00000000 	nop

80001518 <.OP_R>:

.OP_R:                              // 操作 - 打印用户空间寄存器
    addiu sp, sp, -8                // 保存s0,s1
80001518:	27bdfff8 	addiu	sp,sp,-8
    sw s0, 0(sp)
8000151c:	afb00000 	sw	s0,0(sp)
    sw s1, 4(sp)
80001520:	afb10004 	sw	s1,4(sp)

    lui s0, %hi(uregs)
80001524:	3c10807f 	lui	s0,0x807f
    ori s1, zero, 120               // 计数器，打印120字节
80001528:	34110078 	li	s1,0x78
.LC0:
    lb a0, %lo(uregs)(s0)           // 读取字节
8000152c:	82040000 	lb	a0,0(s0)
    addiu s1, s1, -1                // 滚动计数器
80001530:	2631ffff 	addiu	s1,s1,-1
    jal WRITESERIAL                 // 写入串口
80001534:	0c000464 	jal	80001190 <WRITESERIAL>
    nop
80001538:	00000000 	nop
    addiu s0, s0, 0x1               // 移动打印指针
8000153c:	26100001 	addiu	s0,s0,1
    bne s1, zero, .LC0              // 打印循环
80001540:	1620fffa 	bnez	s1,8000152c <.OP_R+0x14>
    nop
80001544:	00000000 	nop

    lw s0, 0(sp)                    // 恢复s0,s1
80001548:	8fb00000 	lw	s0,0(sp)
    lw s1, 4(sp)
8000154c:	8fb10004 	lw	s1,4(sp)
    addiu sp, sp, 8
80001550:	27bd0008 	addiu	sp,sp,8
    j .DONE
80001554:	080005d1 	j	80001744 <.DONE>
    nop
80001558:	00000000 	nop

8000155c <.OP_D>:

.OP_D:                              // 操作 - 打印内存num字节
    addiu sp, sp, -8                // 保存s0,s1
8000155c:	27bdfff8 	addiu	sp,sp,-8
    sw s0, 0(sp)
80001560:	afb00000 	sw	s0,0(sp)
    sw s1, 4(sp)
80001564:	afb10004 	sw	s1,4(sp)

    jal READSERIALWORD
80001568:	0c00047c 	jal	800011f0 <READSERIALWORD>
    nop
8000156c:	00000000 	nop
    or s0, v0, zero                 // 获得addr
80001570:	00408025 	move	s0,v0
    jal READSERIALWORD
80001574:	0c00047c 	jal	800011f0 <READSERIALWORD>
    nop
80001578:	00000000 	nop
    or s1, v0, zero                 // 获得num
8000157c:	00408825 	move	s1,v0

.LC1:
    lb a0, 0(s0)                    // 读取字节
80001580:	82040000 	lb	a0,0(s0)
    addiu s1, s1, -1                // 滚动计数器
80001584:	2631ffff 	addiu	s1,s1,-1
    jal WRITESERIAL                 // 写入串口
80001588:	0c000464 	jal	80001190 <WRITESERIAL>
    nop
8000158c:	00000000 	nop
    addiu s0, s0, 0x1               // 移动打印指针
80001590:	26100001 	addiu	s0,s0,1
    bne s1, zero, .LC1              // 打印循环
80001594:	1620fffa 	bnez	s1,80001580 <.OP_D+0x24>
    nop
80001598:	00000000 	nop

    lw s0, 0(sp)                    // 恢复s0,s1
8000159c:	8fb00000 	lw	s0,0(sp)
    lw s1, 4(sp)
800015a0:	8fb10004 	lw	s1,4(sp)
    addiu sp, sp, 8
800015a4:	27bd0008 	addiu	sp,sp,8
    j .DONE
800015a8:	080005d1 	j	80001744 <.DONE>
    nop
800015ac:	00000000 	nop

800015b0 <.OP_A>:

.OP_A:                              // 操作 - 写入内存num字节，num为4的倍数
    addiu sp, sp, -8                // 保存s0,s1
800015b0:	27bdfff8 	addiu	sp,sp,-8
    sw s0, 0(sp)
800015b4:	afb00000 	sw	s0,0(sp)
    sw s1, 4(sp)
800015b8:	afb10004 	sw	s1,4(sp)

    jal READSERIALWORD
800015bc:	0c00047c 	jal	800011f0 <READSERIALWORD>
    nop
800015c0:	00000000 	nop
    or s0, v0, zero                 // 获得addr
800015c4:	00408025 	move	s0,v0
    jal READSERIALWORD
800015c8:	0c00047c 	jal	800011f0 <READSERIALWORD>
    nop
800015cc:	00000000 	nop
    or s1, v0, zero                 // 获得num
800015d0:	00408825 	move	s1,v0
    srl s1, s1, 2                   // num除4，获得字数
800015d4:	00118882 	srl	s1,s1,0x2
.LC2:                               // 每次写入一字
    jal READSERIALWORD              // 从串口读入一字
800015d8:	0c00047c 	jal	800011f0 <READSERIALWORD>
    nop
800015dc:	00000000 	nop
    sw v0, 0(s0)                    // 写内存一字
800015e0:	ae020000 	sw	v0,0(s0)
    addiu s1, s1, -1                // 滚动计数器
800015e4:	2631ffff 	addiu	s1,s1,-1
    addiu s0, s0, 4                 // 移动写指针
800015e8:	26100004 	addiu	s0,s0,4
    bne s1, zero, .LC2              // 写循环
800015ec:	1620fffa 	bnez	s1,800015d8 <.OP_A+0x28>
    nop
800015f0:	00000000 	nop

    lw s0, 0(sp)                    // 恢复s0,s1
800015f4:	8fb00000 	lw	s0,0(sp)
    lw s1, 4(sp)
800015f8:	8fb10004 	lw	s1,4(sp)
    addiu sp, sp, 8
800015fc:	27bd0008 	addiu	sp,sp,8
    j .DONE
80001600:	080005d1 	j	80001744 <.DONE>
    nop
80001604:	00000000 	nop

80001608 <.OP_G>:

.OP_G:
    jal READSERIALWORD              // 获取addr
80001608:	0c00047c 	jal	800011f0 <READSERIALWORD>
    nop
8000160c:	00000000 	nop

    ori a0, zero, TIMERSET          // 写TIMERSET(0x06)信号
80001610:	34040006 	li	a0,0x6
    jal WRITESERIAL                 // 告诉终端用户程序开始运行
80001614:	0c000464 	jal	80001190 <WRITESERIAL>
    nop
80001618:	00000000 	nop

#ifdef ENABLE_INT
    mtc0 v0, CP0_EPC                // 用户程序入口写入EPC
8000161c:	40827000 	mtc0	v0,c0_epc
#else
    or k0, v0, zero
#endif

    lui ra, %hi(uregs)              // 定位用户空间寄存器备份地址
80001620:	3c1f807f 	lui	ra,0x807f
    addiu ra, %lo(uregs)
80001624:	27ff0000 	addiu	ra,ra,0
    sw v0, PUTREG(31)(ra)           // 保存用户程序入口
80001628:	afe20078 	sw	v0,120(ra)
    sw sp, PUTREG(32)(ra)           // 保存栈指针
8000162c:	affd007c 	sw	sp,124(ra)

    lw $1,  PUTREG(1)(ra)           // 装入$1-$30
80001630:	8fe10000 	lw	at,0(ra)
    lw $2,  PUTREG(2)(ra)
80001634:	8fe20004 	lw	v0,4(ra)
    lw $3,  PUTREG(3)(ra)
80001638:	8fe30008 	lw	v1,8(ra)
    lw $4,  PUTREG(4)(ra)
8000163c:	8fe4000c 	lw	a0,12(ra)
    lw $5,  PUTREG(5)(ra)
80001640:	8fe50010 	lw	a1,16(ra)
    lw $6,  PUTREG(6)(ra)
80001644:	8fe60014 	lw	a2,20(ra)
    lw $7,  PUTREG(7)(ra)
80001648:	8fe70018 	lw	a3,24(ra)
    lw $8,  PUTREG(8)(ra)
8000164c:	8fe8001c 	lw	t0,28(ra)
    lw $9,  PUTREG(9)(ra)
80001650:	8fe90020 	lw	t1,32(ra)
    lw $10, PUTREG(10)(ra)
80001654:	8fea0024 	lw	t2,36(ra)
    lw $11, PUTREG(11)(ra)
80001658:	8feb0028 	lw	t3,40(ra)
    lw $12, PUTREG(12)(ra)
8000165c:	8fec002c 	lw	t4,44(ra)
    lw $13, PUTREG(13)(ra)
80001660:	8fed0030 	lw	t5,48(ra)
    lw $14, PUTREG(14)(ra)
80001664:	8fee0034 	lw	t6,52(ra)
    lw $15, PUTREG(15)(ra)
80001668:	8fef0038 	lw	t7,56(ra)
    lw $16, PUTREG(16)(ra)
8000166c:	8ff0003c 	lw	s0,60(ra)
    lw $17, PUTREG(17)(ra)
80001670:	8ff10040 	lw	s1,64(ra)
    lw $18, PUTREG(18)(ra)
80001674:	8ff20044 	lw	s2,68(ra)
    lw $19, PUTREG(19)(ra)
80001678:	8ff30048 	lw	s3,72(ra)
    lw $20, PUTREG(20)(ra)
8000167c:	8ff4004c 	lw	s4,76(ra)
    lw $21, PUTREG(21)(ra)
80001680:	8ff50050 	lw	s5,80(ra)
    lw $22, PUTREG(22)(ra)
80001684:	8ff60054 	lw	s6,84(ra)
    lw $23, PUTREG(23)(ra)
80001688:	8ff70058 	lw	s7,88(ra)
    lw $24, PUTREG(24)(ra)
8000168c:	8ff8005c 	lw	t8,92(ra)
    lw $25, PUTREG(25)(ra)
80001690:	8ff90060 	lw	t9,96(ra)
    //lw $26, PUTREG(26)(ra)
    //lw $27, PUTREG(27)(ra)
    lw $28, PUTREG(28)(ra)
80001694:	8ffc006c 	lw	gp,108(ra)
    lw $29, PUTREG(29)(ra)
80001698:	8ffd0070 	lw	sp,112(ra)
    lw $30, PUTREG(30)(ra)
8000169c:	8ffe0074 	lw	s8,116(ra)

    lui ra, %hi(.USERRET2)          // ra写入返回地址
800016a0:	3c1f8000 	lui	ra,0x8000
    addiu ra, %lo(.USERRET2)
800016a4:	27ff16b0 	addiu	ra,ra,5808
    nop
800016a8:	00000000 	nop
#ifdef ENABLE_INT
    eret                            // 进入用户程序
800016ac:	42000018 	eret

800016b0 <.USERRET2>:
#else
    jr k0
    nop
#endif
.USERRET2:
    nop
800016b0:	00000000 	nop

    lui ra, %hi(uregs)              // 定位用户空间寄存器备份地址
800016b4:	3c1f807f 	lui	ra,0x807f
    addiu ra, %lo(uregs)
800016b8:	27ff0000 	addiu	ra,ra,0

    sw $1,  PUTREG(1)(ra)           // 备份$1-$30
800016bc:	afe10000 	sw	at,0(ra)
    sw $2,  PUTREG(2)(ra)
800016c0:	afe20004 	sw	v0,4(ra)
    sw $3,  PUTREG(3)(ra)
800016c4:	afe30008 	sw	v1,8(ra)
    sw $4,  PUTREG(4)(ra)
800016c8:	afe4000c 	sw	a0,12(ra)
    sw $5,  PUTREG(5)(ra)
800016cc:	afe50010 	sw	a1,16(ra)
    sw $6,  PUTREG(6)(ra)
800016d0:	afe60014 	sw	a2,20(ra)
    sw $7,  PUTREG(7)(ra)
800016d4:	afe70018 	sw	a3,24(ra)
    sw $8,  PUTREG(8)(ra)
800016d8:	afe8001c 	sw	t0,28(ra)
    sw $9,  PUTREG(9)(ra)
800016dc:	afe90020 	sw	t1,32(ra)
    sw $10, PUTREG(10)(ra)
800016e0:	afea0024 	sw	t2,36(ra)
    sw $11, PUTREG(11)(ra)
800016e4:	afeb0028 	sw	t3,40(ra)
    sw $12, PUTREG(12)(ra)
800016e8:	afec002c 	sw	t4,44(ra)
    sw $13, PUTREG(13)(ra)
800016ec:	afed0030 	sw	t5,48(ra)
    sw $14, PUTREG(14)(ra)
800016f0:	afee0034 	sw	t6,52(ra)
    sw $15, PUTREG(15)(ra)
800016f4:	afef0038 	sw	t7,56(ra)
    sw $16, PUTREG(16)(ra)
800016f8:	aff0003c 	sw	s0,60(ra)
    sw $17, PUTREG(17)(ra)
800016fc:	aff10040 	sw	s1,64(ra)
    sw $18, PUTREG(18)(ra)
80001700:	aff20044 	sw	s2,68(ra)
    sw $19, PUTREG(19)(ra)
80001704:	aff30048 	sw	s3,72(ra)
    sw $20, PUTREG(20)(ra)
80001708:	aff4004c 	sw	s4,76(ra)
    sw $21, PUTREG(21)(ra)
8000170c:	aff50050 	sw	s5,80(ra)
    sw $22, PUTREG(22)(ra)
80001710:	aff60054 	sw	s6,84(ra)
    sw $23, PUTREG(23)(ra)
80001714:	aff70058 	sw	s7,88(ra)
    sw $24, PUTREG(24)(ra)
80001718:	aff8005c 	sw	t8,92(ra)
    sw $25, PUTREG(25)(ra)
8000171c:	aff90060 	sw	t9,96(ra)
    //sw $26, PUTREG(26)(ra)
    //sw $27, PUTREG(27)(ra)
    sw $28, PUTREG(28)(ra)
80001720:	affc006c 	sw	gp,108(ra)
    sw $29, PUTREG(29)(ra)
80001724:	affd0070 	sw	sp,112(ra)
    sw $30, PUTREG(30)(ra)
80001728:	affe0074 	sw	s8,116(ra)

    lw sp, PUTREG(32)(ra)
8000172c:	8ffd007c 	lw	sp,124(ra)
    ori a0, zero, TIMETOKEN         // 发送TIMETOKEN(0x07)信号
80001730:	34040007 	li	a0,0x7
    jal WRITESERIAL                 // 告诉终端用户程序结束运行
80001734:	0c000464 	jal	80001190 <WRITESERIAL>
    nop
80001738:	00000000 	nop

    j .DONE
8000173c:	080005d1 	j	80001744 <.DONE>
    nop
80001740:	00000000 	nop

80001744 <.DONE>:

.DONE:
    j SHELL                         // 交互循环
80001744:	0800051c 	j	80001470 <SHELL>
    nop
80001748:	00000000 	nop
8000174c:	00000000 	nop

80001750 <FATAL>:
    nop
#else

FATAL:                              
                                    // 严重问题，重启
    ori a0, zero, 0x80              // 错误信号
80001750:	34040080 	li	a0,0x80
    jal WRITESERIAL                 // 发送
80001754:	0c000464 	jal	80001190 <WRITESERIAL>
    nop
80001758:	00000000 	nop
    lui v0, %hi(START)              // 重启地址
8000175c:	3c028000 	lui	v0,0x8000
    addiu v0, %lo(START)
80001760:	244212bc 	addiu	v0,v0,4796
    jr v0
80001764:	00400008 	jr	v0
    nop
80001768:	00000000 	nop

8000176c <EXCEPTIONHANDLER>:


EXCEPTIONHANDLER:
    mfc0 k0, CP0_STATUS             // 处理一般中断
8000176c:	401a6000 00000000 3b5b0001 037ad024     .`.@......[;$.z.
    nop
    xori k1, k0, ST0_IE
    and k0, k1, k0                  // IE置零
    mtc0 k0, CP0_STATUS             // 禁止嵌套中断
8000177c:	409a6000 3c1a807f 8f5a0088 af5d007c     .`.@...<..Z.|.].
                                    // 一般由异常级别位自动禁止中断
    lui k0, %hi(current)
    lw k0, %lo(current)(k0)         // k0 = 取得current的中断帧存储地址

    sw sp, TF_sp(k0)                // 保存中断帧
    or sp, k0, zero
8000178c:	0340e825 afa10000 afa20004 afa30008     %.@.............
    sw AT, TF_AT(sp)
    sw v0, TF_v0(sp)
    sw v1, TF_v1(sp)
    sw a0, TF_a0(sp)
8000179c:	afa4000c afa50010 afa60014 afa70018     ................
    sw a1, TF_a1(sp)
    sw a2, TF_a2(sp)
    sw a3, TF_a3(sp)
    sw t0, TF_t0(sp)
800017ac:	afa8001c afa90020 afaa0024 afab0028     .... ...$...(...
    sw t1, TF_t1(sp)
    sw t2, TF_t2(sp)
    sw t3, TF_t3(sp)
    sw t4, TF_t4(sp)
800017bc:	afac002c afad0030 afae0034 afaf0038     ,...0...4...8...
    sw t5, TF_t5(sp)
    sw t6, TF_t6(sp)
    sw t7, TF_t7(sp)
    sw t8, TF_t8(sp)
800017cc:	afb8003c afb90040 afb00044 afb10048     <...@...D...H...
    sw t9, TF_t9(sp)
    sw s0, TF_s0(sp)
    sw s1, TF_s1(sp)
    sw s2, TF_s2(sp)
800017dc:	afb2004c afb30050 afb40054 afb50058     L...P...T...X...
    sw s3, TF_s3(sp)
    sw s4, TF_s4(sp)
    sw s5, TF_s5(sp)
    sw s6, TF_s6(sp)
800017ec:	afb6005c afb70060 afbc0064 afbe0068     \...`...d...h...
    sw s7, TF_s7(sp)
    sw gp, TF_gp(sp)
    sw fp, TF_fp(sp)
    sw ra, TF_ra(sp)
800017fc:	afbf006c 401a6000 401b6800 afba0070     l....`.@.h.@p...
    mfc0 k0, CP0_STATUS
    mfc0 k1, CP0_CAUSE
    sw k0, TF_STATUS(sp)
    mfc0 k0, CP0_EPC
8000180c:	401a7000 afbb0074 afba0078 401a6800     .p.@t...x....h.@
    sw k1, TF_CAUSE(sp)
    sw k0, TF_EPC(sp)


    mfc0 k0, CP0_CAUSE
    nop
8000181c:	00000000 335b00ff 001bd882 341a0000     ......[3.......4
    andi k1, k0, 0x00FF             // 截取CP0_CAUSE 的ExcCode
    srl k1, k1, 2
    ori k0, zero, EX_IRQ            // 硬件中断
    beq k1, k0, WAKEUPSHELL         // 让主线程控制
8000182c:	137a002c 00000000 341a0008 137a0032     ,.z........42.z.
    nop
    ori k0, zero, EX_SYS            // 系统调用
    beq k1, k0, SYSCALL             // 内核处理
    nop
8000183c:	00000000 080005d4 00000000              ............

80001848 <RETURNFRMTRAP>:
    j FATAL                         // 无法处理的中断，出现严重错误
    nop


RETURNFRMTRAP:
    lw k0, TF_STATUS(sp)
80001848:	8fba0070 375a0001 3b5b0004 035bd024     p.....Z7..[;$.[.
    ori k0, k0, ST0_IE              // 使能中断。通常eret自动取消EXL位。
    xori k1, k0, ST0_ERL
    and k0, k0, k1                  // 清除错误位(防止eret出错)
    lw k1, TF_EPC(sp)
80001858:	8fbb0078 409a6000 409b7000 8fa10000     x....`.@.p.@....
    mtc0 k0, CP0_STATUS
    mtc0 k1, CP0_EPC
    lw AT, TF_AT(sp)                // 从中断帧中恢复k0,k1以外寄存器，上下文
    lw v0, TF_v0(sp)
80001868:	8fa20004 8fa30008 8fa4000c 8fa50010     ................
    lw v1, TF_v1(sp)
    lw a0, TF_a0(sp)
    lw a1, TF_a1(sp)
    lw a2, TF_a2(sp)
80001878:	8fa60014 8fa70018 8fa8001c 8fa90020     ............ ...
    lw a3, TF_a3(sp)
    lw t0, TF_t0(sp)
    lw t1, TF_t1(sp)
    lw t2, TF_t2(sp)
80001888:	8faa0024 8fab0028 8fac002c 8fad0030     $...(...,...0...
    lw t3, TF_t3(sp)
    lw t4, TF_t4(sp)
    lw t5, TF_t5(sp)
    lw t6, TF_t6(sp)
80001898:	8fae0034 8faf0038 8fb8003c 8fb90040     4...8...<...@...
    lw t7, TF_t7(sp)
    lw t8, TF_t8(sp)
    lw t9, TF_t9(sp)
    lw s0, TF_s0(sp)
800018a8:	8fb00044 8fb10048 8fb2004c 8fb30050     D...H...L...P...
    lw s1, TF_s1(sp)
    lw s2, TF_s2(sp)
    lw s3, TF_s3(sp)
    lw s4, TF_s4(sp)
800018b8:	8fb40054 8fb50058 8fb6005c 8fb70060     T...X...\...`...
    lw s5, TF_s5(sp)
    lw s6, TF_s6(sp)
    lw s7, TF_s7(sp)
    lw gp, TF_gp(sp)
800018c8:	8fbc0064 8fbe0068 8fbf006c 8fbd007c     d...h...l...|...
    lw fp, TF_fp(sp)
    lw ra, TF_ra(sp)

    lw sp, TF_sp(sp)                // 从中断帧中恢复
    eret
800018d8:	42000018 00000000                       ...B....

800018e0 <WAKEUPSHELL>:
    nop



WAKEUPSHELL:
    lui t1, %hi(current)
800018e0:	3c09807f 	lui	t1,0x807f
    lw t1, %lo(current)(t1)         // 取得当前线程TCB地址
800018e4:	8d290088 	lw	t1,136(t1)
    lui t0, %hi(TCBT)
800018e8:	3c08807f 	lui	t0,0x807f
    lw t0, %lo(TCBT)(t0)            // 取得idle线程TCB地址
800018ec:	8d080080 	lw	t0,128(t0)
    nop
800018f0:	00000000 	nop
    bne t0, t1, RETURNFRMTRAP       // 若当前是shell/user线程无需调度
800018f4:	1509ffd4 	bne	t0,t1,80001848 <RETURNFRMTRAP>
    nop
800018f8:	00000000 	nop
    j SCHEDULE                      // 进行调度使主线程获得控制权
800018fc:	08000654 	j	80001950 <SCHEDULE>
    nop
80001900:	00000000 	nop

80001904 <SYSCALL>:

SYSCALL:
    lw k0, TF_EPC(sp)               // SYSCALL需对EPC特别处理
80001904:	8fba0078 	lw	k0,120(sp)
    addiu k0, k0, 0x4               // EPC+4,退出中断后执行SYSCALL的下一条语句
80001908:	275a0004 	addiu	k0,k0,4
    sw k0, TF_EPC(sp)
8000190c:	afba0078 	sw	k0,120(sp)
    ori t0, zero, SYS_wait          // 取得wait调用号
80001910:	34080003 	li	t0,0x3
    beq v0, t0, .syscall_wait       // syscall wait
80001914:	10480006 	beq	v0,t0,80001930 <.syscall_wait>
    nop
80001918:	00000000 	nop
    ori t0, zero, SYS_putc          // 取得putc调用号
8000191c:	3408001e 	li	t0,0x1e
    beq v0, t0, .syscall_putc       // syscall putc
80001920:	10480005 	beq	v0,t0,80001938 <.syscall_putc>
    nop
80001924:	00000000 	nop

    // 系统调用扩展

    j RETURNFRMTRAP                 // 其他系统调用忽略
80001928:	08000612 	j	80001848 <RETURNFRMTRAP>
    nop
8000192c:	00000000 	nop

80001930 <.syscall_wait>:

.syscall_wait:
    j SCHEDULE                      // 调度转交控制权
80001930:	08000654 	j	80001950 <SCHEDULE>
    nop
80001934:	00000000 	nop

80001938 <.syscall_putc>:

.syscall_putc:
    jal WRITESERIAL                 // 写串口采用忙等待，不产生嵌套中断
80001938:	0c000464 	jal	80001190 <WRITESERIAL>
    nop
8000193c:	00000000 	nop
    j RETURNFRMTRAP
80001940:	08000612 	j	80001848 <RETURNFRMTRAP>
    nop
80001944:	00000000 	nop
	...

80001950 <SCHEDULE>:

/* 本文件仅在启用异常处理时有用 */

SCHEDULE:                           
#ifdef ENABLE_INT                             
    lui t1, %hi(TCBT)               // 调度程序。此时处于中断处理中。
80001950:	3c09807f 25290080 8d2a0000 3c0c807f     ...<..)%..*....<
    addiu t1, %lo(TCBT)           // 获得TCBT地址
    lw t2, 0(t1)                    // 获得idle的TCB地址
    lui t4, %hi(current)
    lw t3, %lo(current)(t4)         // 获得current线程的TCB地址
80001960:	8d8b0088 00000000 154b0003 00000000     ..........K.....
    nop
    bne t2, t3, .LC0                // 判断current是哪个线程
    nop
    lw t2, 4(t1)                    // 切换为shell
80001970:	8d2a0004 00000000 0140e825 ad9d0088     ..*.....%.@.....
    nop
.LC0:
    or sp, t2, zero                 // 调换中断帧指针
    sw sp, %lo(current)(t4)         // 设置current为调度线程
    j RETURNFRMTRAP                 // 退出中断，加载调度线程中断帧，完成线程切换
80001980:	08000612 00000000 00000000 00000000     ................
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

8000200c <UTEST_PUTC>:
    /*  系统调用测试程序
     *  该测试仅在实现异常处理时有效
     */
#ifdef ENABLE_INT
UTEST_PUTC:
    ori v0, zero, SYS_putc          // 系统调用号
8000200c:	3402001e 	li	v0,0x1e
    ori a0, zero, 0x4F              // 'O'
80002010:	3404004f 	li	a0,0x4f
    syscall SYSCALL_BASE
80002014:	0000200c 	syscall	0x80
    nop
80002018:	00000000 	nop
    ori a0, zero, 0x4B              // 'K'
8000201c:	3404004b 	li	a0,0x4b
    syscall SYSCALL_BASE
80002020:	0000200c 	syscall	0x80
    nop
80002024:	00000000 	nop
    jr ra
80002028:	03e00008 	jr	ra
    nop
8000202c:	00000000 	nop

80002030 <UTEST_1PTB>:
     *  这段程序一般没有数据冲突和结构冲突，可作为性能标定。
     *  若执行延迟槽，执行这段程序需至少384M指令，384M/time可算得频率。
     *  不执行延迟槽，执行这段程序需至少320M指令，320M/time可算得频率。
     */
UTEST_1PTB:
    lui t0, %hi(TESTLOOP64)         // 装入64M
80002030:	3c080400 	lui	t0,0x400
	...
    nop
    nop
    nop
.LC0:
    addiu t0, t0, -1                // 滚动计数器
80002040:	2508ffff 	addiu	t0,t0,-1
    ori t1, zero, 0
80002044:	34090000 	li	t1,0x0
    ori t2, zero, 1
80002048:	340a0001 	li	t2,0x1
    ori t3, zero, 2
8000204c:	340b0002 	li	t3,0x2
    bne t0, zero, .LC0
80002050:	1500fffb 	bnez	t0,80002040 <UTEST_1PTB+0x10>
    nop
80002054:	00000000 	nop
    nop
80002058:	00000000 	nop
    jr ra
8000205c:	03e00008 	jr	ra
    nop
80002060:	00000000 	nop

80002064 <UTEST_2DCT>:
     *  这段程序含有大量数据冲突，可测试数据冲突对效率的影响。
     *  执行延迟槽，执行这段程序需至少192M指令。
     *  不执行延迟槽，执行这段程序需至少176M指令。
     */
UTEST_2DCT:
    lui t0, %hi(TESTLOOP16)         // 装入16M
80002064:	3c080100 	lui	t0,0x100
    ori t1, zero, 1
80002068:	34090001 	li	t1,0x1
    ori t2, zero, 2
8000206c:	340a0002 	li	t2,0x2
    ori t3, zero, 3
80002070:	340b0003 	li	t3,0x3
.LC1:
    xor t2, t2, t1                  // 交换t1,t2
80002074:	01495026 	xor	t2,t2,t1
    xor t1, t1, t2
80002078:	012a4826 	xor	t1,t1,t2
    xor t2, t2, t1
8000207c:	01495026 	xor	t2,t2,t1
    xor t3, t3, t2                  // 交换t2,t3
80002080:	016a5826 	xor	t3,t3,t2
    xor t2, t2, t3
80002084:	014b5026 	xor	t2,t2,t3
    xor t3, t3, t2
80002088:	016a5826 	xor	t3,t3,t2
    xor t1, t1, t3                  // 交换t3,t1
8000208c:	012b4826 	xor	t1,t1,t3
    xor t3, t3, t1
80002090:	01695826 	xor	t3,t3,t1
    xor t1, t1, t3
80002094:	012b4826 	xor	t1,t1,t3
    addiu t0, t0, -1
80002098:	2508ffff 	addiu	t0,t0,-1
    bne t0, zero, .LC1
8000209c:	1500fff5 	bnez	t0,80002074 <UTEST_2DCT+0x10>
    nop
800020a0:	00000000 	nop
    jr ra
800020a4:	03e00008 	jr	ra
    nop
800020a8:	00000000 	nop

800020ac <UTEST_3CCT>:
     *  这段程序有大量控制冲突。
     *  无延迟槽执行需要至少256M指令；
     *  有延迟槽需要224M指令。
     */
UTEST_3CCT:
    lui t0, %hi(TESTLOOP64)         // 装入64M
800020ac:	3c080400 	lui	t0,0x400
.LC2_0:
    bne t0, zero, .LC2_1
800020b0:	15000003 	bnez	t0,800020c0 <UTEST_3CCT+0x14>
    nop
800020b4:	00000000 	nop
    jr ra
800020b8:	03e00008 	jr	ra
    nop
800020bc:	00000000 	nop
.LC2_1:
    j .LC2_2
800020c0:	08000832 	j	800020c8 <UTEST_3CCT+0x1c>
    nop
800020c4:	00000000 	nop
.LC2_2:
    addiu t0, t0, -1
800020c8:	2508ffff 	addiu	t0,t0,-1
    j .LC2_0
800020cc:	0800082c 	j	800020b0 <UTEST_3CCT+0x4>
    addiu t0, t0, -1
800020d0:	2508ffff 	addiu	t0,t0,-1
    nop
800020d4:	00000000 	nop

800020d8 <UTEST_4MDCT>:
     *  这段程序反复对内存进行有数据冲突的读写。
     *  不执行延迟槽需要至少192M指令。
     *  执行延迟槽，需要至少224M指令。
     */
UTEST_4MDCT:
    lui t0, %hi(TESTLOOP32)          // 装入32M
800020d8:	3c080200 	lui	t0,0x200
    addiu sp, sp, -4
800020dc:	27bdfffc 	addiu	sp,sp,-4
.LC3:
    sw t0, 0(sp)
800020e0:	afa80000 	sw	t0,0(sp)
    lw t1, 0(sp)
800020e4:	8fa90000 	lw	t1,0(sp)
    addiu t1, t1, -1
800020e8:	2529ffff 	addiu	t1,t1,-1
    sw t1, 0(sp)
800020ec:	afa90000 	sw	t1,0(sp)
    lw t0, 0(sp)
800020f0:	8fa80000 	lw	t0,0(sp)
    bne t0, zero, .LC3
800020f4:	1500fffa 	bnez	t0,800020e0 <UTEST_4MDCT+0x8>
    nop
800020f8:	00000000 	nop
    addiu sp, sp, 4
800020fc:	27bd0004 	addiu	sp,sp,4
    jr ra
80002100:	03e00008 	jr	ra
    nop
80002104:	00000000 	nop
