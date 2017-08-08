Date: Tue, 08 Aug 2017 11:20:47 +0800
From: kernel test robot <fengguang.wu@intel.com>
Message-ID: <59892e0f.lF0HiAP5kclsDbx0%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_59892e0f.Lqx5dJ83Ns5KYYzYIYWEL6mysJJTr3vrBUJFdzTWPxAXw2tR"
Subject: [kernel-hardening] f7dd250789 ("gcc-plugins: structleak: add option to init all
 .."):  kmodloader/112 is trying to release lock (module_mutex) at:
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: LKP <lkp@01.org>, kernel-hardening@lists.openwall.com, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, wfg@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

This is a multi-part message in MIME format.

--=_59892e0f.Lqx5dJ83Ns5KYYzYIYWEL6mysJJTr3vrBUJFdzTWPxAXw2tR
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git for-next/gcc-plugin/structleak

commit f7dd2507893cc3425d3ffc2369559619960befb0
Author:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
AuthorDate: Sun Aug 6 12:06:27 2017 +0100
Commit:     Kees Cook <keescook@chromium.org>
CommitDate: Mon Aug 7 11:20:57 2017 -0700

    gcc-plugins: structleak: add option to init all vars used as byref args
    
    In the Linux kernel, struct type variables are rarely passed by-value,
    and so functions that initialize such variables typically take an input
    reference to the variable rather than returning a value that can
    subsequently be used in an assignment.
    
    If the initalization function is not part of the same compilation unit,
    the lack of an assignment operation defeats any analysis the compiler
    can perform as to whether the variable may be used before having been
    initialized. This means we may end up passing on such variables
    uninitialized, resulting in potential information leaks.
    
    So extend the existing structleak GCC plugin so it will [optionally]
    apply to all struct type variables that have their address taken at any
    point, rather than only to variables of struct types that have a __user
    annotation.
    
    Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
    Signed-off-by: Kees Cook <keescook@chromium.org>

520eccdfe1  Linux 4.13-rc2
f7dd250789  gcc-plugins: structleak: add option to init all vars used as byref args
f7dd250789  gcc-plugins: structleak: add option to init all vars used as byref args
+-------------------------------------------+-----------+------------+------------+
|                                           | v4.13-rc2 | f7dd250789 | f7dd250789 |
+-------------------------------------------+-----------+------------+------------+
| boot_successes                            | 163       | 0          | 0          |
| boot_failures                             | 0         | 32         | 32         |
| is_trying_to_release_lock(module_mutex)at | 0         | 32         | 32         |
| BUG:unable_to_handle_kernel               | 0         | 32         | 32         |
| Oops:#[##]                                | 0         | 32         | 32         |
| EIP:m_start                               | 0         | 32         | 32         |
| Kernel_panic-not_syncing:Fatal_exception  | 0         | 32         | 32         |
+-------------------------------------------+-----------+------------+------------+

[    7.063335] 
[    7.063494] =====================================
[    7.063922] WARNING: bad unlock balance detected!
[    7.064351] 4.13.0-rc2-00001-gf7dd2507 #191 Not tainted
[    7.064830] -------------------------------------
[    7.065259] kmodloader/112 is trying to release lock (module_mutex) at:
[    7.065865] [<7909ed9a>] m_stop+0xd/0xf
[    7.066216] but there are no more locks to release!
[    7.066663] 
[    7.066663] other info that might help us debug this:
[    7.066663] 
[    7.066663] other info that might help us debug this:
[    7.067257] 1 lock held by kmodloader/112:
[    7.067635]  #0:  (&p->lock){+.+.+.}, at: [<791311b2>] seq_read+0x27/0x368
[    7.068264] 
[    7.068264] stack backtrace:
[    7.068264] 
[    7.068264] stack backtrace:
[    7.068668] CPU: 0 PID: 112 Comm: kmodloader Not tainted 4.13.0-rc2-00001-gf7dd2507 #191
[    7.069408] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-20161025_171302-gandalf 04/01/2014
[    7.070338] Call Trace:
[    7.070569]  dump_stack+0x74/0xa7
[    7.070874]  ? m_stop+0xd/0xf
[    7.071149]  print_unlock_imbalance_bug+0xb1/0xbe
[    7.071582]  ? m_stop+0xd/0xf
[    7.071855]  ? m_stop+0xd/0xf
[    7.072128]  lock_release+0x11c/0x24d
[    7.072464]  ? m_stop+0xd/0xf
[    7.072747]  __mutex_unlock_slowpath+0x27/0x1bf
[    7.073163]  ? __kmalloc+0x5e/0x66
[    7.073477]  mutex_unlock+0xb/0xd
[    7.073786]  m_stop+0xd/0xf
[    7.074044]  seq_read+0x187/0x368
[    7.074349]  ? seq_lseek+0x13f/0x13f
[    7.074681]  proc_reg_read+0x47/0x64
[    7.075011]  ? proc_reg_mmap+0x54/0x54
[    7.075356]  __vfs_read+0x22/0x109
[    7.075673]  ? find_held_lock+0x29/0x6c
[    7.076027]  ? __do_page_fault+0x302/0x378
[    7.076402]  vfs_read+0x83/0xf4
[    7.076694]  SyS_read+0x3d/0x82
[    7.076984]  do_int80_syscall_32+0x4c/0xd9
[    7.077359]  entry_INT80_32+0x2c/0x2c
[    7.077697] EIP: 0x6ff5fd0e
[    7.077954] EFLAGS: 00000246 CPU: 0
[    7.078274] EAX: ffffffda EBX: 00000003 ECX: 094a4088 EDX: 00001000
[    7.078846] ESI: 094a4028 EDI: 00001000 EBP: 094a5090 ESP: 77d69f4c
[    7.079415]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
[    7.079925] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    7.080581] IP: m_start+0x12/0x24
[    7.080884] *pde = 00000000 
[    7.080885] 
[    7.081288] Oops: 0000 [#1] SMP
[    7.081579] Modules linked in:
[    7.081861] CPU: 0 PID: 112 Comm: kmodloader Not tainted 4.13.0-rc2-00001-gf7dd2507 #191
[    7.082593] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-20161025_171302-gandalf 04/01/2014
[    7.083513] task: 86cb4000 task.stack: 86cb6000
[    7.083926] EIP: m_start+0x12/0x24
[    7.084237] EFLAGS: 00010246 CPU: 0
[    7.084560] EAX: 00000000 EBX: 00000000 ECX: 7990e72c EDX: 7909f0bc
[    7.085126] ESI: 00000000 EDI: 00000000 EBP: 86cb7e94 ESP: 86cb7e90
[    7.085695]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[    7.086185] CR0: 80050033 CR2: 00000000 CR3: 0ecba000 CR4: 001406d0
[    7.086759] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    7.087327] DR6: fffe0ff0 DR7: 00000400
[    7.087679] Call Trace:
[    7.087906]  seq_read+0x258/0x368
[    7.088210]  ? seq_lseek+0x13f/0x13f
[    7.088541]  proc_reg_read+0x47/0x64
[    7.088868]  ? proc_reg_mmap+0x54/0x54
[    7.089214]  __vfs_read+0x22/0x109
[    7.089528]  ? find_held_lock+0x29/0x6c
[    7.089879]  ? __do_page_fault+0x302/0x378
[    7.090252]  vfs_read+0x83/0xf4
[    7.090545]  SyS_read+0x3d/0x82
[    7.090833]  do_int80_syscall_32+0x4c/0xd9
[    7.091206]  entry_INT80_32+0x2c/0x2c
[    7.091543] EIP: 0x6ff5fd0e
[    7.091800] EFLAGS: 00000246 CPU: 0
[    7.092118] EAX: ffffffda EBX: 00000003 ECX: 094a4088 EDX: 00001000
[    7.092689] ESI: 094a4028 EDI: 00001000 EBP: 094a5090 ESP: 77d69f4c
[    7.093257]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
[    7.093752] Code: 79 e8 61 1d 09 00 5d c3 55 89 d0 89 e5 ba e8 e6 90 79 e8 01 1d 09 00 5d c3 55 b8 f0 e6 90 79 89 e5 53 89 d3 31 d2 e8 54 74 56 00 <8b> 13 b8 e8 e6 90 79 8b 4b 04 e8 b3 1c 09 00 5b 5d c3 55 85 d2
[    7.095477] EIP: m_start+0x12/0x24 SS:ESP: 0068:86cb7e90
[    7.095963] CR2: 0000000000000000
[    7.096276] ---[ end trace 5d7df7bc417c7ad9 ]---
[    7.096710] Kernel panic - not syncing: Fatal exception

                                                          # HH:MM RESULT GOOD BAD GOOD_BUT_DIRTY DIRTY_NOT_BAD
git bisect start f7dd2507893cc3425d3ffc2369559619960befb0 520eccdfe187591a51ea9ab4c1a024ae4d0f68d9 --
# first bad commit: [f7dd2507893cc3425d3ffc2369559619960befb0] gcc-plugins: structleak: add option to init all vars used as byref args
git bisect good 520eccdfe187591a51ea9ab4c1a024ae4d0f68d9  # 11:15  G     31     0    0   0  Linux 4.13-rc2
# extra tests on HEAD of kees/for-next/gcc-plugin/structleak
git bisect  bad f7dd2507893cc3425d3ffc2369559619960befb0  # 11:15  B      0    32   51   0  gcc-plugins: structleak: add option to init all vars used as byref args
# extra tests on tree/branch kees/for-next/gcc-plugin/structleak
git bisect  bad f7dd2507893cc3425d3ffc2369559619960befb0  # 11:15  B      0    32   51   0  gcc-plugins: structleak: add option to init all vars used as byref args
# extra tests with first bad commit reverted
git bisect good 39cfbbd528552f0d5733b33b52f1f2fc3ec2e117  # 11:20  G     11     0    0   0  Revert "gcc-plugins: structleak: add option to init all vars used as byref args"

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/lkp                          Intel Corporation

--=_59892e0f.Lqx5dJ83Ns5KYYzYIYWEL6mysJJTr3vrBUJFdzTWPxAXw2tR
Content-Type: application/gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg-openwrt-lkp-hsw01-105:20170808105332:i386-randconfig-n0-201732:4.13.0-rc2-00001-gf7dd2507:191.gz"

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

--=_59892e0f.Lqx5dJ83Ns5KYYzYIYWEL6mysJJTr3vrBUJFdzTWPxAXw2tR
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="reproduce-openwrt-lkp-hsw01-105:20170808105332:i386-randconfig-n0-201732:4.13.0-rc2-00001-gf7dd2507:191"

#!/bin/bash

kernel=$1
initrd=openwrt-trinity-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep
	-kernel $kernel
	-initrd $initrd
	-m 256
	-smp 1
	-device e1000,netdev=net0
	-netdev user,id=net0
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-watchdog-action debug
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null
)

append=(
	root=/dev/ram0
	hung_task_panic=1
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	net.ifnames=0
	printk.devkmsg=on
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	drbd.minor_count=8
	systemd.log_level=err
	ignore_loglevel
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	console=tty0
	vga=normal
	rw
	drbd.minor_count=8
)

"${kvm[@]}" -append "${append[*]}"

--=_59892e0f.Lqx5dJ83Ns5KYYzYIYWEL6mysJJTr3vrBUJFdzTWPxAXw2tR
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-4.13.0-rc2-00001-gf7dd2507"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 4.13.0-rc2 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_BITS_MAX=16
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=2
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_FHANDLE=y
CONFIG_USELIB=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
CONFIG_RCU_EXPERT=y
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_NOCB_CPU=y
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_SWAP is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_CGROUP_PIDS is not set
# CONFIG_CGROUP_RDMA is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_HUGETLB=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_DEBUG=y
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
# CONFIG_RD_LZMA is not set
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
# CONFIG_SYSFS_SYSCALL is not set
# CONFIG_POSIX_TIMERS is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_ABSOLUTE_PERCPU is not set
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_BPF_SYSCALL is not set
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_USERFAULTFD=y
CONFIG_PCI_QUIRKS=y
CONFIG_MEMBARRIER=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_SLAB_MERGE_DEFAULT=y
# CONFIG_SYSTEM_DATA_VERIFICATION is not set
# CONFIG_PROFILING is not set
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
CONFIG_JUMP_LABEL=y
CONFIG_STATIC_KEYS_SELFTEST=y
# CONFIG_UPROBES is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_CYC_COMPLEXITY is not set
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK is not set
CONFIG_GCC_PLUGIN_RANDSTRUCT=y
CONFIG_GCC_PLUGIN_RANDSTRUCT_PERFORMANCE=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_THIN_ARCHIVES=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=8
CONFIG_HAVE_COPY_THREAD_TLS=y
# CONFIG_HAVE_ARCH_HASH is not set
CONFIG_ISA_BUS_API=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y
# CONFIG_CPU_NO_EFFICIENT_FFS is not set
# CONFIG_HAVE_ARCH_VMAP_STACK is not set
# CONFIG_ARCH_OPTIONAL_KERNEL_RWX is not set
# CONFIG_ARCH_OPTIONAL_KERNEL_RWX_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
# CONFIG_REFCOUNT_FULL is not set

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
# CONFIG_MODULE_COMPRESS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_ZONED is not set
# CONFIG_BLK_CMDLINE_PARSER is not set
CONFIG_BLK_WBT=y
# CONFIG_BLK_WBT_SQ is not set
CONFIG_BLK_WBT_MQ=y
# CONFIG_BLK_DEBUG_FS is not set
# CONFIG_BLK_SED_OPAL is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=m
CONFIG_IOSCHED_BFQ=m
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_FAST_FEATURE_TESTS=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
CONFIG_GOLDFISH=y
CONFIG_INTEL_RDT_A=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_RDC321X=y
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
# CONFIG_PERF_EVENTS_AMD_POWER is not set
# CONFIG_X86_LEGACY_VM86 is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
# CONFIG_X86_CPUID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
CONFIG_VMSPLIT_2G_OPT=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x78000000
# CONFIG_X86_PAE is not set
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_HAVE_GENERIC_GUP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_ARCH_WANTS_THP_SWAP is not set
CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
# CONFIG_CMA is not set
CONFIG_ZSWAP=y
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
CONFIG_Z3FOLD=y
CONFIG_ZSMALLOC=m
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_ZSMALLOC_STAT is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_FRAME_VECTOR=y
CONFIG_PERCPU_STATS=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_X86_INTEL_MPX is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
# CONFIG_MODIFY_LDT_SYSCALL is not set

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_OPP=y
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_DPTF_POWER is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_PMIC_OPREGION is not set
# CONFIG_ACPI_CONFIGFS is not set
# CONFIG_SFI is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=m
CONFIG_APM_IGNORE_USER_SUSPEND=y
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_CPUFREQ_DT=y
CONFIG_CPUFREQ_DT_PLATDEV=y
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=m
# CONFIG_X86_POWERNOW_K7 is not set
CONFIG_X86_GX_SUSPMOD=y
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
CONFIG_PCI_GOMMCONFIG=y
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
# CONFIG_PCIEAER is not set
# CONFIG_PCIEASPM is not set
CONFIG_PCIE_PME=y
# CONFIG_PCIE_DPC is not set
# CONFIG_PCIE_PTM is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=m
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# DesignWare PCI Core Support
#

#
# PCI host controller drivers
#

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set

#
# PCI switch controller drivers
#
CONFIG_PCI_SW_SWITCHTEC=m
CONFIG_ISA_BUS=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_OLPC_XO1_PM is not set
# CONFIG_OLPC_XO15_SCI is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
# CONFIG_RAPIDIO_ENUM_BASIC is not set
CONFIG_RAPIDIO_CHMAN=m
CONFIG_RAPIDIO_MPORT_CDEV=m

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
# CONFIG_RAPIDIO_CPS_GEN2 is not set
CONFIG_RAPIDIO_RXS_GEN3=y
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m
# CONFIG_COREDUMP is not set
CONFIG_COMPAT_32=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NET_PTP_CLASSIFY is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
# CONFIG_IPDDP_ENCAP is not set
CONFIG_X25=y
CONFIG_LAPB=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=m
# CONFIG_MAC802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
CONFIG_BATMAN_ADV=m
# CONFIG_BATMAN_ADV_BATMAN_V is not set
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_DEBUGFS=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_VSOCKETS=m
# CONFIG_VIRTIO_VSOCKETS is not set
CONFIG_NETLINK_DIAG=m
# CONFIG_MPLS is not set
CONFIG_HSR=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_TOSHIBA_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=m
CONFIG_BT=y
CONFIG_BT_BREDR=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m
# CONFIG_BT_HS is not set
# CONFIG_BT_LE is not set
# CONFIG_BT_LEDS is not set
CONFIG_BT_SELFTEST=y
# CONFIG_BT_DEBUGFS is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
# CONFIG_STREAM_PARSER is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_NET_9P=m
# CONFIG_NET_9P_VIRTIO is not set
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
CONFIG_NFC=m
# CONFIG_NFC_DIGITAL is not set
# CONFIG_NFC_NCI is not set
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=m
CONFIG_NFC_PN533_USB=m
# CONFIG_NFC_PN533_I2C is not set
CONFIG_PSAMPLE=y
CONFIG_NET_IFE=m
CONFIG_LWTUNNEL=y
# CONFIG_LWTUNNEL_BPF is not set
# CONFIG_DST_CACHE is not set
CONFIG_GRO_CELLS=y
CONFIG_NET_DEVLINK=y
CONFIG_MAY_USE_DEVLINK=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_ALLOW_DEV_COREDUMP is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
CONFIG_DEBUG_TEST_DRIVER_REMOVE=y
CONFIG_TEST_ASYNC_DRIVER_PROBE=m
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_FENCE_TRACE=y

#
# Bus devices
#
CONFIG_SIMPLE_PM_BUS=y
CONFIG_CONNECTOR=m
CONFIG_MTD=m
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=m
# CONFIG_MTD_OF_PARTS is not set
CONFIG_MTD_AR7_PARTS=m

#
# Partition parsers
#

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
# CONFIG_SSFDC is not set
CONFIG_SM_FTL=m
CONFIG_MTD_OOPS=m
CONFIG_MTD_SWAP=m
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=m
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_PHYSMAP_OF=m
CONFIG_MTD_SCx200_DOCFLASH=m
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=m
CONFIG_MTD_CK804XROM=m
CONFIG_MTD_SCB2_FLASH=m
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
CONFIG_MTD_INTEL_VR_NOR=m
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_ECC_BCH is not set
CONFIG_MTD_SM_COMMON=m
CONFIG_MTD_NAND_DENALI=m
CONFIG_MTD_NAND_DENALI_PCI=m
CONFIG_MTD_NAND_DENALI_DT=m
# CONFIG_MTD_NAND_GPIO is not set
# CONFIG_MTD_NAND_OMAP_BCH_BUILD is not set
CONFIG_MTD_NAND_RICOH=m
CONFIG_MTD_NAND_DISKONCHIP=m
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=m
# CONFIG_MTD_NAND_NANDSIM is not set
# CONFIG_MTD_NAND_PLATFORM is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=m
# CONFIG_MTD_UBI_BLOCK is not set
CONFIG_DTC=y
CONFIG_OF=y
CONFIG_OF_UNITTEST=y
CONFIG_OF_FLATTREE=y
CONFIG_OF_EARLY_FLATTREE=y
CONFIG_OF_PROMTREE=y
# CONFIG_OF_DYNAMIC is not set
CONFIG_OF_ADDRESS=y
CONFIG_OF_ADDRESS_PCI=y
CONFIG_OF_IRQ=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_RESOLVE=y
# CONFIG_OF_OVERLAY is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=m
# CONFIG_VIRTIO_BLK_SCSI is not set
# CONFIG_BLK_DEV_RSXX is not set
CONFIG_NVME_CORE=y
CONFIG_BLK_DEV_NVME=y
CONFIG_NVME_FABRICS=m
# CONFIG_NVME_FC is not set
CONFIG_NVME_TARGET=m
CONFIG_NVME_TARGET_LOOP=m
CONFIG_NVME_TARGET_FC=m

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
CONFIG_IBM_ASM=m
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_SRAM=y
CONFIG_PCI_ENDPOINT_TEST=m
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=m
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=m
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Bus Driver
#

#
# SCIF Bus Driver
#

#
# VOP Bus Driver
#

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#

#
# SCIF Driver
#

#
# Intel MIC Coprocessor State Management (COSM) Drivers
#

#
# VOP Driver
#
CONFIG_ECHO=y
# CONFIG_CXL_BASE is not set
# CONFIG_CXL_AFU_DRIVER_OPS is not set
# CONFIG_CXL_LIB is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_IDE_GD is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=m
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
CONFIG_BLK_DEV_PLATFORM=m
CONFIG_BLK_DEV_CMD640=m
CONFIG_BLK_DEV_CMD640_ENHANCED=y
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=m
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=m
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=m
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=m
CONFIG_BLK_DEV_TRIFLEX=m
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
CONFIG_BLK_DEV_CS5535=m
CONFIG_BLK_DEV_CS5536=m
CONFIG_BLK_DEV_HPT366=m
# CONFIG_BLK_DEV_JMICRON is not set
CONFIG_BLK_DEV_SC1200=m
# CONFIG_BLK_DEV_PIIX is not set
CONFIG_BLK_DEV_IT8172=m
CONFIG_BLK_DEV_IT8213=m
CONFIG_BLK_DEV_IT821X=m
CONFIG_BLK_DEV_NS87415=m
CONFIG_BLK_DEV_PDC202XX_OLD=m
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
CONFIG_BLK_DEV_SVWKS=m
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
CONFIG_BLK_DEV_TRM290=m
CONFIG_BLK_DEV_VIA82CXXX=m
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_ENCLOSURE is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=m
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_AHCI_CEVA=y
CONFIG_AHCI_QORIQ=y
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=y
# CONFIG_SATA_SX4 is not set
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=y
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PLATFORM is not set
CONFIG_PATA_RZ1000=y

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_LEGACY=m
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=y
# CONFIG_MD_FAULTY is not set
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
# CONFIG_BLK_DEV_DM is not set
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=y
# CONFIG_TCM_PSCSI is not set
# CONFIG_TCM_USER2 is not set
# CONFIG_LOOPBACK_TARGET is not set
# CONFIG_ISCSI_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=m
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set
# CONFIG_NVM is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=m
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_GOLDFISH_EVENTS is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_KEYBOARD_CAP11XX is not set
# CONFIG_KEYBOARD_BCM is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=m
# CONFIG_JOYSTICK_IFORCE_USB is not set
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=m
# CONFIG_JOYSTICK_XPAD_FF is not set
# CONFIG_JOYSTICK_XPAD_LEDS is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=m
CONFIG_RMI4_I2C=m
# CONFIG_RMI4_SMB is not set
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
# CONFIG_RMI4_F34 is not set
CONFIG_RMI4_F54=y
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=m
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_SERIO_APBPS2=m
CONFIG_SERIO_OLPC_APSP=y
CONFIG_USERIO=m
CONFIG_GAMEPORT=m
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=m
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_GOLDFISH_TTY is not set
CONFIG_DEVMEM=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_ASPEED_VUART is not set
# CONFIG_SERIAL_8250_FSL is not set
# CONFIG_SERIAL_8250_DW is not set
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
# CONFIG_SERIAL_8250_MOXA is not set
# CONFIG_SERIAL_OF_PLATFORM is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_CONEXANT_DIGICOLOR is not set
CONFIG_SERIAL_DEV_BUS=m
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=y
# CONFIG_IPMI_SSIF is not set
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=m
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=m
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_CRB is not set
CONFIG_TCG_VTPM_PROXY=m
# CONFIG_TCG_TIS_ST33ZP24_I2C is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_XILLYBUS=y
CONFIG_XILLYBUS_OF=y

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=m
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
CONFIG_I2C_DESIGNWARE_PCI=m
# CONFIG_I2C_DESIGNWARE_BAYTRAIL is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_EMEV2=m
CONFIG_I2C_GPIO=m
CONFIG_I2C_KEMPLD=m
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_PXA=y
CONFIG_I2C_PXA_PCI=y
CONFIG_I2C_RK3X=m
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_DLN2 is not set
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_ROBOTFUZZ_OSIF=m
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_CROS_EC_TUNNEL=y
CONFIG_SCx200_ACB=m
CONFIG_I2C_STUB=m
CONFIG_I2C_SLAVE=y
CONFIG_I2C_SLAVE_EEPROM=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=m
# CONFIG_HSI is not set
# CONFIG_PPS is not set

#
# PTP clock support
#

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=m
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_74XX_MMIO=y
CONFIG_GPIO_ALTERA=y
# CONFIG_GPIO_AMDPT is not set
CONFIG_GPIO_AXP209=m
CONFIG_GPIO_DWAPB=y
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_FTGPIO010 is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_GRGPIO is not set
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_LYNXPOINT is not set
CONFIG_GPIO_MOCKUP=m
# CONFIG_GPIO_VX855 is not set
CONFIG_GPIO_XILINX=y

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_IT87=m
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_SCH311X=m
CONFIG_GPIO_WS16C48=m

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
CONFIG_GPIO_ADNP=m
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_TPIC2810=y

#
# MFD GPIO expanders
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_CRYSTAL_COVE is not set
CONFIG_GPIO_CS5535=m
CONFIG_GPIO_DLN2=m
# CONFIG_GPIO_KEMPLD is not set
# CONFIG_GPIO_LP3943 is not set
CONFIG_GPIO_LP873X=m
CONFIG_GPIO_LP87565=y
CONFIG_GPIO_MAX77620=y
# CONFIG_GPIO_STMPE is not set
# CONFIG_GPIO_TC3589X is not set
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_TPS65086=y
CONFIG_GPIO_TPS65218=m
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65912=m
# CONFIG_GPIO_TWL4030 is not set
# CONFIG_GPIO_TWL6040 is not set
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8350 is not set
CONFIG_GPIO_WM8994=m

#
# PCI GPIO expanders
#
CONFIG_GPIO_AMD8111=m
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_ML_IOH is not set
CONFIG_GPIO_PCH=m
# CONFIG_GPIO_PCI_IDIO_16 is not set
CONFIG_GPIO_RDC321X=y
CONFIG_GPIO_SODAVILLE=y

#
# USB GPIO expanders
#
CONFIG_GPIO_VIPERBOARD=m
CONFIG_W1=m
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2405=m
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=m
# CONFIG_W1_SLAVE_DS2406 is not set
CONFIG_W1_SLAVE_DS2423=m
CONFIG_W1_SLAVE_DS2431=m
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2438 is not set
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_AVS=y
# CONFIG_POWER_RESET is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_MAX8925_POWER=y
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=m
CONFIG_WM8350_POWER=m
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_88PM860X is not set
CONFIG_BATTERY_ACT8945A=y
CONFIG_BATTERY_DS2760=m
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_OLPC=m
# CONFIG_BATTERY_SBS is not set
CONFIG_CHARGER_SBS=y
# CONFIG_BATTERY_BQ27XXX is not set
CONFIG_BATTERY_DA9030=m
# CONFIG_BATTERY_DA9150 is not set
CONFIG_AXP288_CHARGER=m
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_ISP1704=m
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_LTC3651=y
CONFIG_CHARGER_MAX14577=m
CONFIG_CHARGER_DETECTOR_MAX14656=m
# CONFIG_CHARGER_MAX77693 is not set
CONFIG_CHARGER_MAX8998=y
CONFIG_CHARGER_BQ2415X=m
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_BQ24257=y
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ25890 is not set
CONFIG_CHARGER_SMB347=m
CONFIG_CHARGER_TPS65090=y
CONFIG_CHARGER_TPS65217=m
CONFIG_BATTERY_GAUGE_LTC2941=y
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_BATTERY_RT5033=y
# CONFIG_CHARGER_RT9455 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=m
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ASPEED=m
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=m
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_DELL_SMM is not set
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_MC13783_ADC is not set
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_I5500=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LTC2945=y
# CONFIG_SENSORS_LTC2990 is not set
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=m
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=m
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MAX31790=m
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_TC654 is not set
CONFIG_SENSORS_MENF21BMC_HWMON=m
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=y
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_NCT7802=m
CONFIG_SENSORS_NCT7904=y
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
CONFIG_SENSORS_PWM_FAN=y
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SHT3x is not set
CONFIG_SENSORS_SHTC1=m
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_STTS751 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_INA3221 is not set
CONFIG_SENSORS_TC74=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
CONFIG_SENSORS_TMP108=m
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_WM831X is not set
# CONFIG_SENSORS_WM8350 is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_OF=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_BANG_BANG is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
# CONFIG_CPU_THERMAL is not set
# CONFIG_CLOCK_THERMAL is not set
# CONFIG_DEVFREQ_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_MAX77620_THERMAL is not set
# CONFIG_QORIQ_THERMAL is not set
# CONFIG_DA9062_THERMAL is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
# CONFIG_INTEL_PCH_THERMAL is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
CONFIG_SSB_SILENT=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=m
CONFIG_MFD_ACT8945A=y
CONFIG_MFD_AS3711=y
CONFIG_MFD_AS3722=m
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_ATMEL_FLEXCOM=y
CONFIG_MFD_ATMEL_HLCDC=m
# CONFIG_MFD_BCM590XX is not set
CONFIG_MFD_AXP20X=y
CONFIG_MFD_AXP20X_I2C=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=m
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9062=y
CONFIG_MFD_DA9063=m
CONFIG_MFD_DA9150=m
CONFIG_MFD_DLN2=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
# CONFIG_MFD_HI6421_PMIC is not set
CONFIG_HTC_PASIC3=m
CONFIG_HTC_I2CPLD=y
CONFIG_MFD_INTEL_QUARK_I2C_GPIO=y
CONFIG_LPC_ICH=y
# CONFIG_LPC_SCH is not set
CONFIG_INTEL_SOC_PMIC=y
# CONFIG_INTEL_SOC_PMIC_CHTWC is not set
CONFIG_MFD_INTEL_LPSS=y
# CONFIG_MFD_INTEL_LPSS_ACPI is not set
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=m
CONFIG_MFD_88PM800=m
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=m
CONFIG_MFD_MAX77620=y
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=m
CONFIG_MFD_MAX77843=y
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_MT6397 is not set
CONFIG_MFD_MENF21BMC=m
CONFIG_MFD_VIPERBOARD=m
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RT5033=y
# CONFIG_MFD_RTSX_USB is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_RK808 is not set
# CONFIG_MFD_RN5T618 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=m
CONFIG_MFD_LP8788=y
CONFIG_MFD_TI_LMU=m
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65086=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TI_LP873X=m
CONFIG_MFD_TI_LP87565=y
CONFIG_MFD_TPS65218=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=m
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_CS47L24 is not set
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8998=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_88PM800=m
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_ACT8865=m
# CONFIG_REGULATOR_ACT8945A is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_AS3711=y
CONFIG_REGULATOR_AS3722=m
CONFIG_REGULATOR_AXP20X=m
CONFIG_REGULATOR_DA903X=y
# CONFIG_REGULATOR_DA9062 is not set
CONFIG_REGULATOR_DA9063=m
CONFIG_REGULATOR_DA9210=m
# CONFIG_REGULATOR_DA9211 is not set
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL9305=m
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_LM363X=m
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=m
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP873X=m
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_LP87565=y
CONFIG_REGULATOR_LP8788=m
CONFIG_REGULATOR_LTC3589=m
CONFIG_REGULATOR_LTC3676=y
CONFIG_REGULATOR_MAX14577=m
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX77620=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8925=m
CONFIG_REGULATOR_MAX8952=m
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8998=y
# CONFIG_REGULATOR_MAX77686 is not set
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_MAX77802=y
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_MT6311=y
CONFIG_REGULATOR_PFUZE100=m
CONFIG_REGULATOR_PV88060=y
CONFIG_REGULATOR_PV88080=m
CONFIG_REGULATOR_PV88090=m
# CONFIG_REGULATOR_PWM is not set
CONFIG_REGULATOR_QCOM_SPMI=m
CONFIG_REGULATOR_RT5033=y
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65086=m
# CONFIG_REGULATOR_TPS65090 is not set
CONFIG_REGULATOR_TPS65132=m
CONFIG_REGULATOR_TPS65217=m
# CONFIG_REGULATOR_TPS65218 is not set
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TWL4030=m
# CONFIG_REGULATOR_VCTRL is not set
CONFIG_REGULATOR_WM831X=m
# CONFIG_REGULATOR_WM8350 is not set
# CONFIG_REGULATOR_WM8400 is not set
CONFIG_REGULATOR_WM8994=m
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
# CONFIG_MEDIA_CEC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_PCI_SKELETON=m
CONFIG_VIDEO_TUNER=m
CONFIG_V4L2_MEM2MEM_DEV=m
CONFIG_V4L2_FWNODE=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_DMA_CONTIG=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEOBUF2_DMA_SG=m
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
# CONFIG_RC_DECODERS is not set
CONFIG_RC_DEVICES=y
CONFIG_RC_ATI_REMOTE=m
# CONFIG_IR_ENE is not set
CONFIG_IR_HIX5HD2=m
# CONFIG_IR_IMON is not set
CONFIG_IR_MCEUSB=m
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
CONFIG_IR_REDRAT3=m
CONFIG_IR_STREAMZAP=m
# CONFIG_IR_WINBOND_CIR is not set
# CONFIG_IR_IGORPLUGUSB is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
# CONFIG_RC_LOOPBACK is not set
CONFIG_IR_GPIO_CIR=m
CONFIG_IR_SERIAL=m
CONFIG_IR_SERIAL_TRANSMITTER=y
# CONFIG_IR_SIR is not set
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
# CONFIG_USB_VIDEO_CLASS is not set
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
# CONFIG_USB_GSPCA_BENQ is not set
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
# CONFIG_USB_GSPCA_DTCS033 is not set
# CONFIG_USB_GSPCA_ETOMS is not set
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
# CONFIG_USB_GSPCA_JL2005BCD is not set
CONFIG_USB_GSPCA_KINECT=m
# CONFIG_USB_GSPCA_KONICA is not set
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
# CONFIG_USB_GSPCA_OV519 is not set
CONFIG_USB_GSPCA_OV534=m
# CONFIG_USB_GSPCA_OV534_9 is not set
# CONFIG_USB_GSPCA_PAC207 is not set
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SE401=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
# CONFIG_USB_GSPCA_SPCA500 is not set
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
# CONFIG_USB_GSPCA_SQ930X is not set
CONFIG_USB_GSPCA_STK014=m
# CONFIG_USB_GSPCA_STK1135 is not set
# CONFIG_USB_GSPCA_STV0680 is not set
# CONFIG_USB_GSPCA_SUNPLUS is not set
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TOPRO=m
CONFIG_USB_GSPCA_TOUPTEK=m
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
# CONFIG_USB_GSPCA_ZC3XX is not set
# CONFIG_USB_PWC is not set
CONFIG_VIDEO_CPIA2=m
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_V4L2=m
# CONFIG_VIDEO_EM28XX_RC is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
# CONFIG_VIDEO_TW5864 is not set
CONFIG_VIDEO_TW68=m
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_DC30=m
CONFIG_VIDEO_ZORAN_ZR36060=m
CONFIG_VIDEO_ZORAN_BUZ=m
# CONFIG_VIDEO_ZORAN_DC10 is not set
CONFIG_VIDEO_ZORAN_LML33=m
CONFIG_VIDEO_ZORAN_LML33R10=m
CONFIG_VIDEO_ZORAN_AVS6EYES=m
# CONFIG_V4L_PLATFORM_DRIVERS is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_MEM2MEM_DEINTERLACE=m
# CONFIG_VIDEO_SH_VEU is not set
CONFIG_V4L_TEST_DRIVERS=y
CONFIG_VIDEO_VIM2M=m

#
# Supported MMC/SDIO adapters
#
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_VIDEO_TVEEPROM=m
# CONFIG_CYPRESS_FIRMWARE is not set

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# I2C Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
CONFIG_VIDEO_TDA7432=m
# CONFIG_VIDEO_TDA9840 is not set
CONFIG_VIDEO_TEA6415C=m
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS3308=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
# CONFIG_VIDEO_TLV320AIC23B is not set
CONFIG_VIDEO_UDA1342=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
# CONFIG_VIDEO_SONY_BTF_MPX is not set

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
CONFIG_VIDEO_ADV7183=m
# CONFIG_VIDEO_BT819 is not set
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_ML86V7667=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
# CONFIG_VIDEO_TVP514X is not set
CONFIG_VIDEO_TVP5150=m
# CONFIG_VIDEO_TVP7002 is not set
CONFIG_VIDEO_TW2804=m
CONFIG_VIDEO_TW9903=m
CONFIG_VIDEO_TW9906=m
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
# CONFIG_VIDEO_SAA7185 is not set
CONFIG_VIDEO_ADV7170=m
# CONFIG_VIDEO_ADV7175 is not set
CONFIG_VIDEO_ADV7343=m
CONFIG_VIDEO_ADV7393=m
CONFIG_VIDEO_AK881X=m
# CONFIG_VIDEO_THS8200 is not set

#
# Camera sensor devices
#
CONFIG_VIDEO_OV2640=m
# CONFIG_VIDEO_OV2659 is not set
CONFIG_VIDEO_OV7640=m
# CONFIG_VIDEO_OV7670 is not set
CONFIG_VIDEO_VS6624=m
# CONFIG_VIDEO_MT9M111 is not set
CONFIG_VIDEO_MT9V011=m
# CONFIG_VIDEO_SR030PC30 is not set

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
# CONFIG_VIDEO_UPD64083 is not set

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=m

#
# SDR tuner chips
#

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=m
# CONFIG_VIDEO_M52790 is not set

#
# Sensors used on soc_camera driver
#

#
# SPI helper chips
#
CONFIG_MEDIA_TUNER=m

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
# CONFIG_MEDIA_TUNER_MT20XX is not set
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
# CONFIG_MEDIA_TUNER_XC5000 is not set
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
# CONFIG_MEDIA_TUNER_MAX2165 is not set
CONFIG_MEDIA_TUNER_TDA18218=m
# CONFIG_MEDIA_TUNER_FC0011 is not set
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88RS6000T=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m
CONFIG_MEDIA_TUNER_MXL301RF=m
# CONFIG_MEDIA_TUNER_QM1D1C0042 is not set

#
# Customise DVB Frontends
#

#
# Tools to develop new frontends
#

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set

#
# ACP (Audio CoProcessor) Configuration
#
# CONFIG_DRM_LIB_RANDOM is not set

#
# Frame buffer Devices
#
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_PWM=m
CONFIG_BACKLIGHT_DA903X=m
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_PM8941_WLED=m
CONFIG_BACKLIGHT_SAHARA=m
# CONFIG_BACKLIGHT_WM831X is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_88PM860X=m
CONFIG_BACKLIGHT_LM3630A=m
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_LP8788 is not set
# CONFIG_BACKLIGHT_PANDORA is not set
CONFIG_BACKLIGHT_TPS65217=m
CONFIG_BACKLIGHT_AS3711=m
CONFIG_BACKLIGHT_GPIO=m
CONFIG_BACKLIGHT_LV5207LP=m
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_BACKLIGHT_ARCXCNN=m
# CONFIG_VGASTATE is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=m
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=m
CONFIG_HID_ASUS=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CORSAIR=m
CONFIG_HID_CMEDIA=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
# CONFIG_HID_GEMBIRD is not set
CONFIG_HID_GFRM=m
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
# CONFIG_HID_LENOVO is not set
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=m
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTI=m
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_BACKLIGHT=y
# CONFIG_HID_PICOLCD_LEDS is not set
# CONFIG_HID_PICOLCD_CIR is not set
# CONFIG_HID_PLANTRONICS is not set
CONFIG_HID_PRIMAX=m
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=m
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_UDRAW_PS3=m
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set
CONFIG_HID_ALPS=m

#
# USB HID support
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
# CONFIG_USB_MOUSE is not set

#
# I2C HID support
#
CONFIG_I2C_HID=m
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=m
# CONFIG_USB_PCI is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_OTG_FSM=m
CONFIG_USB_LEDS_TRIGGER_USBPORT=m
CONFIG_USB_MON=m
CONFIG_USB_WUSB=m
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_XHCI_PLATFORM=m
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_HCD_PLATFORM=m
CONFIG_USB_OXU210HP_HCD=m
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FOTG210_HCD=m
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=m
# CONFIG_USB_HWA_HCD is not set
CONFIG_USB_HCD_SSB=m
CONFIG_USB_HCD_TEST_MODE=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
CONFIG_USB_STORAGE_SDDR55=m
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
CONFIG_USB_UAS=m

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USB_MICROTEK=m
CONFIG_USBIP_CORE=m
CONFIG_USBIP_VHCI_HCD=m
CONFIG_USBIP_VHCI_HC_PORTS=8
CONFIG_USBIP_VHCI_NR_HCS=1
CONFIG_USBIP_HOST=m
CONFIG_USBIP_VUDC=m
# CONFIG_USBIP_DEBUG is not set
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_GADGET=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OF_SIMPLE=y
# CONFIG_USB_DWC2 is not set
CONFIG_USB_CHIPIDEA=m
CONFIG_USB_CHIPIDEA_OF=m
# CONFIG_USB_CHIPIDEA_UDC is not set
CONFIG_USB_CHIPIDEA_HOST=y
# CONFIG_USB_CHIPIDEA_ULPI is not set
CONFIG_USB_ISP1760=m
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1761_UDC=y
# CONFIG_USB_ISP1760_HOST_ROLE is not set
# CONFIG_USB_ISP1760_GADGET_ROLE is not set
CONFIG_USB_ISP1760_DUAL_ROLE=y

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=m
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=m
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=m
CONFIG_USB_EHSET_TEST_FIXTURE=m
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=m
CONFIG_USB_EZUSB_FX2=m
CONFIG_USB_HUB_USB251XB=m
CONFIG_USB_HSIC_USB3503=m
CONFIG_USB_HSIC_USB4604=m
CONFIG_USB_LINK_LAYER_TEST=m
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
# CONFIG_USB_CXACRU is not set
# CONFIG_USB_UEAGLEATM is not set
# CONFIG_USB_XUSBATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=m
CONFIG_USB_GPIO_VBUS=m
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FUSB300=m
CONFIG_USB_FOTG210_UDC=m
# CONFIG_USB_GR_UDC is not set
CONFIG_USB_R8A66597=m
CONFIG_USB_PXA27X=y
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=m
CONFIG_USB_SNP_CORE=m
CONFIG_USB_SNP_UDC_PLAT=m
# CONFIG_USB_M66592 is not set
# CONFIG_USB_BDC_UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_GADGET_XILINX is not set
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_U_ETHER=m
CONFIG_USB_F_NCM=m
CONFIG_USB_F_ECM=m
CONFIG_USB_F_MASS_STORAGE=m
CONFIG_USB_F_FS=m
CONFIG_USB_F_UVC=m
CONFIG_USB_F_HID=m
CONFIG_USB_F_PRINTER=m
CONFIG_USB_CONFIGFS=m
# CONFIG_USB_CONFIGFS_SERIAL is not set
# CONFIG_USB_CONFIGFS_ACM is not set
# CONFIG_USB_CONFIGFS_OBEX is not set
CONFIG_USB_CONFIGFS_NCM=y
CONFIG_USB_CONFIGFS_ECM=y
# CONFIG_USB_CONFIGFS_ECM_SUBSET is not set
# CONFIG_USB_CONFIGFS_RNDIS is not set
# CONFIG_USB_CONFIGFS_EEM is not set
CONFIG_USB_CONFIGFS_MASS_STORAGE=y
# CONFIG_USB_CONFIGFS_F_LB_SS is not set
CONFIG_USB_CONFIGFS_F_FS=y
CONFIG_USB_CONFIGFS_F_HID=y
CONFIG_USB_CONFIGFS_F_UVC=y
CONFIG_USB_CONFIGFS_F_PRINTER=y
# CONFIG_USB_CONFIGFS_F_TCM is not set

#
# USB Power Delivery and Type-C drivers
#
CONFIG_TYPEC=m
CONFIG_TYPEC_UCSI=m
# CONFIG_UCSI_ACPI is not set
# CONFIG_USB_LED_TRIG is not set
CONFIG_USB_ULPI_BUS=m
CONFIG_UWB=y
# CONFIG_UWB_HWA is not set
CONFIG_UWB_WHCI=y
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=m
CONFIG_MS_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=y
# CONFIG_MEMSTICK_R592 is not set
# CONFIG_MEMSTICK_REALTEK_PCI is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m
# CONFIG_LEDS_CLASS_FLASH is not set
CONFIG_LEDS_BRIGHTNESS_HW_CHANGED=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=m
CONFIG_LEDS_BCM6328=m
CONFIG_LEDS_BCM6358=m
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_NET48XX=m
CONFIG_LEDS_WRAP=m
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=m
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP3952=m
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_LP8788=m
CONFIG_LEDS_LP8860=m
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=m
CONFIG_LEDS_DA903X=m
CONFIG_LEDS_PWM=m
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_TLC591XX=m
CONFIG_LEDS_LM355x=m
CONFIG_LEDS_OT200=m
CONFIG_LEDS_MENF21BMC=m
CONFIG_LEDS_IS31FL319X=m
# CONFIG_LEDS_IS31FL32XX is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set
CONFIG_LEDS_USER=m
# CONFIG_LEDS_NIC78BX is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=m
CONFIG_LEDS_TRIGGER_DISK=y
# CONFIG_LEDS_TRIGGER_MTD is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=m
CONFIG_LEDS_TRIGGER_PANIC=y
CONFIG_ACCESSIBILITY=y
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=m
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_AMD76X is not set
# CONFIG_EDAC_E7XXX is not set
CONFIG_EDAC_E752X=m
# CONFIG_EDAC_I82875P is not set
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
# CONFIG_EDAC_I7CORE is not set
CONFIG_EDAC_I82860=m
CONFIG_EDAC_R82600=m
# CONFIG_EDAC_I5000 is not set
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_SYSTOHC_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
# CONFIG_RTC_DRV_88PM80X is not set
CONFIG_RTC_DRV_ABB5ZES3=y
CONFIG_RTC_DRV_ABX80X=m
CONFIG_RTC_DRV_AS3722=m
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1307_HWMON=y
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
# CONFIG_RTC_DRV_HYM8563 is not set
CONFIG_RTC_DRV_LP8788=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_MAX8925=m
# CONFIG_RTC_DRV_MAX8998 is not set
# CONFIG_RTC_DRV_MAX77686 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=y
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=m
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_TWL4030 is not set
CONFIG_RTC_DRV_TPS6586X=m
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8010 is not set
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV8803 is not set

#
# SPI RTC drivers
#
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_RV3029C2=m
# CONFIG_RTC_DRV_RV3029_HWMON is not set

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=m
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1685_FAMILY=y
# CONFIG_RTC_DRV_DS1685 is not set
# CONFIG_RTC_DRV_DS1689 is not set
# CONFIG_RTC_DRV_DS17285 is not set
# CONFIG_RTC_DRV_DS17485 is not set
CONFIG_RTC_DRV_DS17885=y
CONFIG_RTC_DS1685_PROC_REGS=y
# CONFIG_RTC_DS1685_SYSFS_REGS is not set
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_DA9063=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_WM831X=m
CONFIG_RTC_DRV_WM8350=m
CONFIG_RTC_DRV_ZYNQMP=m

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_FTRTC010=y
# CONFIG_RTC_DRV_MC13XXX is not set
# CONFIG_RTC_DRV_SNVS is not set
# CONFIG_RTC_DRV_R7301 is not set

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
CONFIG_DMA_OF=y
CONFIG_FSL_EDMA=y
CONFIG_INTEL_IDMA64=y
CONFIG_PCH_DMA=y
# CONFIG_TIMB_DMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
CONFIG_QCOM_HIDMA=y
CONFIG_DW_DMAC_CORE=y
# CONFIG_DW_DMAC is not set
CONFIG_DW_DMAC_PCI=m
CONFIG_HSU_DMA=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
# CONFIG_SYNC_FILE is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=m
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=m
# CONFIG_UIO_PRUSS is not set
CONFIG_UIO_MF624=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=m

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
# CONFIG_VIRTIO_PCI_LEGACY is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_INPUT=m
CONFIG_VIRTIO_MMIO=m
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_HYPERV_TSCPAGE is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_SMBIOS=m
CONFIG_DELL_LAPTOP=m
# CONFIG_DELL_SMO8800 is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WIRELESS is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_CHT_INT33FE is not set
# CONFIG_INTEL_INT0002_VGPIO is not set
# CONFIG_INTEL_HID_EVENT is not set
# CONFIG_INTEL_VBTN is not set
# CONFIG_INTEL_IPS is not set
CONFIG_INTEL_PMC_CORE=y
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=m
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_INTEL_PMC_IPC is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
CONFIG_INTEL_PUNIT_IPC=y
CONFIG_MLX_CPLD_PLATFORM=y
CONFIG_PMC_ATOM=y
# CONFIG_GOLDFISH_BUS is not set
CONFIG_GOLDFISH_PIPE=m
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_LAPTOP is not set
CONFIG_CHROMEOS_PSTORE=m
# CONFIG_CROS_EC_CHARDEV is not set
# CONFIG_CROS_EC_LPC is not set
CONFIG_CROS_EC_PROTO=y
# CONFIG_CROS_KBD_LED_BACKLIGHT is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_WM831X=y
CONFIG_COMMON_CLK_MAX77686=y
CONFIG_COMMON_CLK_SI5351=y
CONFIG_COMMON_CLK_SI514=m
CONFIG_COMMON_CLK_SI570=y
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CDCE925 is not set
CONFIG_COMMON_CLK_CS2000_CP=y
CONFIG_CLK_TWL6040=y
# CONFIG_COMMON_CLK_NXP is not set
CONFIG_COMMON_CLK_PWM=m
# CONFIG_COMMON_CLK_PXA is not set
# CONFIG_COMMON_CLK_PIC32 is not set
CONFIG_COMMON_CLK_VC5=y
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
CONFIG_PLATFORM_MHU=m
# CONFIG_PCC is not set
# CONFIG_ALTERA_MBOX is not set
# CONFIG_MAILBOX_TEST is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set

#
# Rpmsg drivers
#
CONFIG_RPMSG=m
# CONFIG_RPMSG_CHAR is not set
CONFIG_RPMSG_QCOM_GLINK_RPM=m

#
# SOC (System On Chip) specific Drivers
#

#
# Broadcom SoC drivers
#

#
# i.MX SoC drivers
#
# CONFIG_SUNXI_SRAM is not set
# CONFIG_SOC_TI is not set
# CONFIG_SOC_ZTE is not set
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=m
CONFIG_DEVFREQ_GOV_USERSPACE=m
CONFIG_DEVFREQ_GOV_PASSIVE=y

#
# DEVFREQ Drivers
#
CONFIG_PM_DEVFREQ_EVENT=y
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_AXP288=m
# CONFIG_EXTCON_GPIO is not set
# CONFIG_EXTCON_INTEL_INT3496 is not set
CONFIG_EXTCON_MAX14577=m
CONFIG_EXTCON_MAX3355=m
CONFIG_EXTCON_MAX77693=m
# CONFIG_EXTCON_MAX77843 is not set
CONFIG_EXTCON_RT8973A=y
# CONFIG_EXTCON_SM5502 is not set
# CONFIG_EXTCON_USB_GPIO is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
CONFIG_NTB=y
# CONFIG_NTB_IDT is not set
# CONFIG_NTB_PINGPONG is not set
CONFIG_NTB_TOOL=y
# CONFIG_NTB_PERF is not set
# CONFIG_NTB_TRANSPORT is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_ATMEL_HLCDC_PWM=m
# CONFIG_PWM_CRC is not set
CONFIG_PWM_CROS_EC=y
# CONFIG_PWM_FSL_FTM is not set
CONFIG_PWM_LP3943=m
CONFIG_PWM_LPSS=m
CONFIG_PWM_LPSS_PCI=m
# CONFIG_PWM_LPSS_PLATFORM is not set
CONFIG_PWM_PCA9685=m
# CONFIG_PWM_STMPE is not set
CONFIG_PWM_TWL=m
# CONFIG_PWM_TWL_LED is not set
CONFIG_IRQCHIP=y
CONFIG_ARM_GIC_MAX_NR=1
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_RESET_ATH79 is not set
# CONFIG_RESET_BERLIN is not set
# CONFIG_RESET_GEMINI is not set
# CONFIG_RESET_IMX7 is not set
# CONFIG_RESET_LPC18XX is not set
# CONFIG_RESET_MESON is not set
# CONFIG_RESET_PISTACHIO is not set
# CONFIG_RESET_SOCFPGA is not set
# CONFIG_RESET_STM32 is not set
# CONFIG_RESET_SUNXI is not set
# CONFIG_RESET_TI_SYSCON is not set
# CONFIG_RESET_ZYNQ is not set
# CONFIG_RESET_TEGRA_BPMP is not set
CONFIG_FMC=m
# CONFIG_FMC_FAKEDEV is not set
# CONFIG_FMC_TRIVIAL is not set
# CONFIG_FMC_WRITE_EEPROM is not set
CONFIG_FMC_CHARDEV=m

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_PHY_PXA_28NM_HSIC is not set
CONFIG_PHY_PXA_28NM_USB2=m
CONFIG_PHY_QCOM_USB_HS=m
# CONFIG_PHY_QCOM_USB_HSIC is not set
CONFIG_PHY_TUSB1210=m
# CONFIG_POWERCAP is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
CONFIG_RAS=y
# CONFIG_THUNDERBOLT is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_NVMEM=y
# CONFIG_STM is not set
# CONFIG_INTEL_TH is not set

#
# FPGA Configuration Support
#
# CONFIG_FPGA is not set

#
# FSI support
#
# CONFIG_FSI is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_FW_CFG_SYSFS=y
CONFIG_FW_CFG_SYSFS_CMDLINE=y
CONFIG_GOOGLE_FIRMWARE=y
CONFIG_GOOGLE_COREBOOT_TABLE=y
# CONFIG_GOOGLE_COREBOOT_TABLE_ACPI is not set
CONFIG_GOOGLE_COREBOOT_TABLE_OF=y
CONFIG_GOOGLE_MEMCONSOLE=m
# CONFIG_GOOGLE_MEMCONSOLE_X86_LEGACY is not set
CONFIG_GOOGLE_MEMCONSOLE_COREBOOT=m
CONFIG_GOOGLE_VPD=m
# CONFIG_EFI_DEV_PATH_PARSER is not set

#
# Tegra firmware driver
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=m
# CONFIG_EXT4_USE_FOR_EXT2 is not set
# CONFIG_EXT4_FS_POSIX_ACL is not set
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_ENCRYPTION=y
CONFIG_EXT4_FS_ENCRYPTION=y
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=m
# CONFIG_OCFS2_FS_STATS is not set
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
CONFIG_NILFS2_FS=m
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
# CONFIG_F2FS_FS_XATTR is not set
CONFIG_F2FS_CHECK_FS=y
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_FS_DAX is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=m
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
CONFIG_OVERLAY_FS=m
CONFIG_OVERLAY_FS_REDIRECT_DIR=y
CONFIG_OVERLAY_FS_INDEX=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_FAT_DEFAULT_UTF8=y
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_SYSCTL is not set
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_PROC_CHILDREN=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NCP_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=m
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=m
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=m
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_PAGE_OWNER=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_POISONING is not set
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_VMACACHE is not set
CONFIG_DEBUG_VM_RB=y
# CONFIG_DEBUG_VM_PGFLAGS is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_WQ_WATCHDOG=y
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
CONFIG_SCHED_STACK_END_CHECK=y
# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
# CONFIG_WW_MUTEX_SELFTEST is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_PI_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_TORTURE_TEST=y
CONFIG_RCU_PERF_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_RCU_EQS_DEBUG is not set
# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
CONFIG_NETDEV_NOTIFIER_ERROR_INJECT=m
CONFIG_FAULT_INJECTION=y
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
# CONFIG_FAIL_FUTEX is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=m
CONFIG_TEST_LIST_SORT=m
CONFIG_TEST_SORT=m
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
CONFIG_ATOMIC64_SELFTEST=m
CONFIG_ASYNC_RAID6_TEST=m
CONFIG_TEST_HEXDUMP=m
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=m
CONFIG_TEST_PRINTF=y
# CONFIG_TEST_BITMAP is not set
CONFIG_TEST_UUID=y
CONFIG_TEST_RHASHTABLE=y
CONFIG_TEST_HASH=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_LKM=m
CONFIG_TEST_USER_COPY=m
# CONFIG_TEST_BPF is not set
CONFIG_TEST_FIRMWARE=m
CONFIG_TEST_UDELAY=y
CONFIG_MEMTEST=y
# CONFIG_TEST_STATIC_KEYS is not set
# CONFIG_BUG_ON_DATA_CORRUPTION is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_ARCH_WANTS_UBSAN_NO_NULL is not set
CONFIG_UBSAN=y
# CONFIG_UBSAN_SANITIZE_ALL is not set
# CONFIG_UBSAN_ALIGNMENT is not set
# CONFIG_UBSAN_NULL is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_EARLY_PRINTK_USB_XDBC is not set
CONFIG_X86_PTDUMP_CORE=y
CONFIG_X86_PTDUMP=m
CONFIG_DEBUG_WX=y
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_ENTRY=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_FPU=y
# CONFIG_PUNIT_ATOM_DEBUG is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEY_DH_OPERATIONS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
# CONFIG_FORTIFY_SOURCE is not set
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=y
CONFIG_CRYPTO_ECDH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_MCRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_SIMD=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=m
CONFIG_CRYPTO_SEQIV=y
# CONFIG_CRYPTO_ECHAINIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=m
CONFIG_CRYPTO_KEYWRAP=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_TI=y
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_AES_NI_INTEL=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST_COMMON=m
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=m
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_CHACHA20=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_842=y
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
# CONFIG_CRYPTO_DRBG_HASH is not set
# CONFIG_CRYPTO_DRBG_CTR is not set
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_USER_API_RNG is not set
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS7_MESSAGE_PARSER=y

#
# Certificates for signature checking
#
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
CONFIG_SYSTEM_EXTRA_CERTIFICATE=y
CONFIG_SYSTEM_EXTRA_CERTIFICATE_SIZE=4096
CONFIG_SECONDARY_TRUSTED_KEYRING=y
# CONFIG_SYSTEM_BLACKLIST_KEYRING is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
# CONFIG_HAVE_ARCH_BITREVERSE is not set
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC4=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=m
# CONFIG_CRC8 is not set
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_842_COMPRESS=y
CONFIG_842_DECOMPRESS=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_INTERVAL_TREE=y
CONFIG_RADIX_TREE_MULTIORDER=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
# CONFIG_DMA_NOOP_OPS is not set
# CONFIG_DMA_VIRT_OPS is not set
CONFIG_CHECK_SIGNATURE=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
CONFIG_DDR=y
# CONFIG_IRQ_POLL is not set
CONFIG_MPILIB=y
CONFIG_LIBFDT=y
CONFIG_OID_REGISTRY=y
# CONFIG_SG_SPLIT is not set
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_SG_CHAIN=y
CONFIG_ARCH_HAS_MMIO_FLUSH=y
CONFIG_STACKDEPOT=y
CONFIG_SBITMAP=y

--=_59892e0f.Lqx5dJ83Ns5KYYzYIYWEL6mysJJTr3vrBUJFdzTWPxAXw2tR--
