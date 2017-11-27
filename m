Date: Mon, 27 Nov 2017 09:05:16 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
Message-ID: <20171127010516.ynak7b4kbqvg27tb@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="t5gnkjt3s3pvshqd"
Content-Disposition: inline
Subject: [kernel-hardening] f7dd250789 ("gcc-plugins: structleak: add option to init all vars
 used as byref args"): BUG: KASAN: use-after-scope in pcpu_setup_first_chunk
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: wfg@linux.intel.com, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kbuild@vger.kernel.org, LKP <lkp@01.org>
List-ID: <kernel-hardening.lists.openwall.com>


--t5gnkjt3s3pvshqd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ard,

FYI this commit triggers one new KASAN bug.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

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
844056fd74  Merge branch 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
6fc478f80f  Add linux-next specific files for 20171124
+--------------------------------+-----------+------------+------------+---------------+
|                                | v4.13-rc2 | f7dd250789 | 844056fd74 | next-20171124 |
+--------------------------------+-----------+------------+------------+---------------+
| boot_successes                 | 0         | 0          | 0          | 0             |
| boot_failures                  | 33        | 11         | 19         | 13            |
| BUG:KASAN:use-after-scope_in_e | 33        |            |            |               |
| BUG:KASAN:use-after-scope_in_p | 0         | 11         | 19         | 13            |
+--------------------------------+-----------+------------+------------+---------------+

[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] ==================================================================
[    0.000000] BUG: KASAN: use-after-scope in pcpu_setup_first_chunk+0xa5e/0x10bc
[    0.000000] Write of size 8 at addr ffffffff83c07c80 by task swapper/0
[    0.000000] 
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.13.0-rc2-00001-gf7dd2507 #1
[    0.000000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[    0.000000] Call Trace:
[    0.000000]  dump_stack+0x27/0x35
[    0.000000]  print_address_description+0x24e/0x3e0
[    0.000000]  kasan_report+0x1bb/0x3e0
[    0.000000]  ? pcpu_setup_first_chunk+0xa5e/0x10bc
[    0.000000]  __asan_store8+0x72/0x100
[    0.000000]  pcpu_setup_first_chunk+0xa5e/0x10bc
[    0.000000]  ? pcpu_free_alloc_info+0x44/0x44
[    0.000000]  ? memblock_reserve+0xd2/0x111
[    0.000000]  ? memset+0x49/0x60
[    0.000000]  ? memblock_virt_alloc_internal+0x1f6/0x214
[    0.000000]  setup_per_cpu_areas+0x107/0x131
[    0.000000]  start_kernel+0x279/0x7fb
[    0.000000]  ? thread_stack_cache_init+0xd/0xd
[    0.000000]  ? early_idt_handler_array+0x120/0x120
[    0.000000]  x86_64_start_reservations+0x46/0x4f
[    0.000000]  x86_64_start_kernel+0x160/0x18a
[    0.000000]  secondary_startup_64+0x9f/0x9f
[    0.000000] 
[    0.000000] Memory state around the buggy address:
[    0.000000]  ffffffff83c07b80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]  ffffffff83c07c00: 00 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1
[    0.000000] >ffffffff83c07c80: f8 f2 f2 f2 f2 f2 f2 f2 00 f2 f2 f2 f2 f2 f2 f2

The parent commit has this instead, much later on:

[  682.374391] init: Failed to create pty - disabling logging for job
[  682.382994] init: Temporary process spawn error: No such file or directory
[  682.844553] ==================================================================
[  682.846936] BUG: KASAN: use-after-scope in ep_poll+0x5df/0xe00
[  682.848804] Write of size 16 at addr ffff88001192f978 by task udevadm/200
[  682.850932]
[  682.851476] CPU: 0 PID: 200 Comm: udevadm Not tainted 4.13.0-rc2 #1
[  682.853215] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[  682.854874] Call Trace:
[  682.855441]  dump_stack+0x27/0x3b
[  682.856188]  print_address_description+0x8b/0x3e0
[  682.857157]  kasan_report+0x1b5/0x3e0
[  682.857911]  ? ep_poll+0x5df/0xe00
[  682.858610]  __asan_store16+0x7f/0xe0
[  682.859417]  ep_poll+0x5df/0xe00
[  682.860092]  ? ep_scan_ready_list+0x9c0/0x9c0
[  682.860968]  ? do_fault+0x1e0/0xec0
[  682.861699]  ? reacquire_held_locks+0x230/0x230
[  682.862652]  ? finish_fault+0xd0/0xd0
[  682.863422]  ? do_raw_spin_unlock+0xa8/0x1c0
[  682.864275]  ? validate_chain+0xeb/0x1b30
[  682.865220]  ? _raw_spin_unlock+0x3a/0x60
[  682.866113]  ? do_task_dead+0x1d0/0x1d0
[  682.866913]  ? pvclock_clocksource_read+0x189/0x330
[  682.867891]  ? pvclock_read_flags+0x80/0x80
[  682.868731]  ? kvm_sched_clock_read+0x26/0x50
[  682.869694]  ? sched_clock+0x11/0x20
[  682.870438]  ? clear_sched_clock_stable+0x140/0x140
[  682.871422]  ? __fget_light+0x1f4/0x2a0
[  682.872193]  ? __fget+0x470/0x470
[  682.872946]  ? syscall_trace_enter+0x148/0x4f0
[  682.873862]  SyS_epoll_wait+0x145/0x190
[  682.874650]  ? SyS_epoll_ctl+0xfa0/0xfa0
[  682.875451]  do_syscall_64+0x353/0x8a0
[  682.876262]  ? syscall_return_slowpath+0x4c0/0x4c0
[  682.877236]  ? clear_sched_clock_stable+0x140/0x140
[  682.878217]  ? check_chain_key+0x171/0x250
[  682.879042]  ? reacquire_held_locks+0x230/0x230
[  682.880019]  ? vtime_user_enter+0xbd/0xd0
[  682.880847]  ? __context_tracking_enter+0xb7/0xc0
[  682.881787]  ? __context_tracking_enter+0xb7/0xc0
[  682.882780]  ? prepare_exit_to_usermode+0x225/0x240
[  682.883762]  ? mark_held_locks+0x2b/0x100
[  682.884578]  ? retint_user+0x18/0x20
[  682.885307]  ? trace_hardirqs_on_caller+0x20a/0x3c0
[  682.886374]  ? trace_hardirqs_on_thunk+0x1a/0x1c
[  682.887307]  entry_SYSCALL64_slow_path+0x25/0x25
[  682.888232] RIP: 0033:0x7f8f7d7dfb33
[  682.888954] RSP: 002b:00007fffbe1168f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[  682.890523] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f8f7d7dfb33
[  682.891927] RDX: 0000000000000004 RSI: 00007fffbe116aa0 RDI: 0000000000000003
[  682.893401] RBP: 0000004904f6e2d0 R08: 000000000000000a R09: 0000000000000000
[  682.894800] R10: 00000000ffffffff R11: 0000000000000246 R12: 0000004904f6e110
[  682.896265] R13: 0000000000000001 R14: 00007fffbe116aac R15: 0000000000000004
[  682.897664]
[  682.897999] The buggy address belongs to the page:
[  682.898958] page:ffffea0000464bc0 count:0 mapcount:0 mapping:          (null) index:0x0
[  682.900624] flags: 0x0()
[  682.901161] raw: 0000000000000000 0000000000000000 0000000000000000 00000000ffffffff
[  682.902735] raw: 0000000000000000 dead000000000200 0000000000000000 0000000000000000
[  682.904245] page dumped because: kasan: bad access detected
[  682.905339]
[  682.905671] Memory state around the buggy address:
[  682.906707]  ffff88001192f800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  682.908113]  ffff88001192f880: 00 00 00 f1 f1 f1 f1 00 f2 f2 f2 f2 f2 f2 f2 00
[  682.909597] >ffff88001192f900: 00 f2 f2 f2 f2 f2 f2 00 00 f2 f2 f2 f2 f2 f2 f8
[  682.911020]                                                                 ^
[  682.912415]  ffff88001192f980: f8 f2 f2 f2 f2 f2 f2 00 00 00 00 00 f2 f2 f2 f2
[  682.913916]  ffff88001192fa00: f2 f2 f2 f8 f2 f2 f2 f2 f2 f2 f2 f8 f2 f2 f2 f2
[  682.915335] ==================================================================
[  682.916814] Disabling lock debugging due to kernel taint

                                                           # HH:MM RESULT GOOD BAD GOOD_BUT_DIRTY DIRTY_NOT_BAD
git bisect start v4.14 v4.13 --
git bisect  bad 74de8187ff46bfc24fcb1533791515e46b256116  # 18:07  B      0    11   24   0  Merge tag 'pm-4.14-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect  bad 89fd915c402113528750353ad6de9ea68a787e5c  # 18:39  B      0    11   24   0  Merge tag 'libnvdimm-for-4.14' of git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
git bisect good 57e88b43b81301d9b28f124a5576ac43a1cf9e8d  # 19:16  G     11     0   11  11  Merge branch 'x86-platform-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 3aea311c1b4002bd730a09530f80f2f2ad3bf495  # 19:48  B      0     5   18   0  genksyms: fix gperf removal conversion
git bisect good 7d955656121f547ff9a708ed7ee4c86a08bf628a  # 20:24  G     11     0   11  11  Merge tag 'drm-intel-next-fixes-2017-09-07' of git://anongit.freedesktop.org/git/drm-intel
git bisect  bad 44ccba3f7b230af1bd7ebe173cbf5803df1df486  # 20:39  B      0     3   16   0  Merge tag 'gcc-plugins-v4.14-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux
git bisect good ae8ac6b7dbfd67f883050421fd195c153d02f5f3  # 21:20  G     11     0   11  11  Merge branch 'quota_scaling' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
git bisect good 8dc5b3a6cb2fc5d4f751bda56a378589202a118b  # 21:51  G     10     0   10  10  Merge tag '4.14-smb3-xattr-enable' of git://git.samba.org/sfrench/cifs-2.6
git bisect good 21d236bf2bde518844b5675ec4980f4b2fd13e1a  # 22:24  G     11     0   11  11  Merge tag 'pstore-v4.14-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux
git bisect good 9225331b310821760f39ba55b00b8973602adbb5  # 22:51  G     11     0   11  11  randstruct: Enable function pointer struct detection
git bisect  bad ad05e6ca7b5fcf15ff178da662035ec7718f938c  # 23:14  B      0     8   21   0  Merge branch 'for-next/gcc-plugin/structleak' into for-next/gcc-plugins
git bisect  bad f7dd2507893cc3425d3ffc2369559619960befb0  # 23:53  B      0    11   24   0  gcc-plugins: structleak: add option to init all vars used as byref args
# first bad commit: [f7dd2507893cc3425d3ffc2369559619960befb0] gcc-plugins: structleak: add option to init all vars used as byref args
git bisect good 520eccdfe187591a51ea9ab4c1a024ae4d0f68d9  # 00:28  G     33     0   33  33  Linux 4.13-rc2
# extra tests with debug options
git bisect  bad f7dd2507893cc3425d3ffc2369559619960befb0  # 01:03  B      0     2   15   0  gcc-plugins: structleak: add option to init all vars used as byref args
# extra tests on HEAD of linux-devel/devel-hourly-2017112611
git bisect  bad 596d5554a28b82b7c2d3b1904a466eb0cafce029  # 01:08  B      0    13   29   0  0day head guard for 'devel-hourly-2017112611'
# extra tests on tree/branch linus/master
git bisect  bad 844056fd74ebdd826bd23a7d989597e15f478acb  # 01:35  B      0     4   17   0  Merge branch 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
# extra tests with first bad commit reverted
git bisect good 2b7553bd68166948239d37d839a356237d06561f  # 02:17  G     11     0   11  11  Revert "gcc-plugins: structleak: add option to init all vars used as byref args"
# extra tests on tree/branch linux-next/master
git bisect  bad 6fc478f80f6809cc4b1a4230f47a62d3b7378dc0  # 02:41  B      0    11   26   2  Add linux-next specific files for 20171124

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/lkp                          Intel Corporation

--t5gnkjt3s3pvshqd
Content-Type: application/gzip
Content-Disposition: attachment; filename="dmesg-quantal-ivb41-109:20171126233844:x86_64-randconfig-b0-11261534:4.13.0-rc2-00001-gf7dd2507:1.gz"
Content-Transfer-Encoding: base64

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

--t5gnkjt3s3pvshqd
Content-Type: application/gzip
Content-Disposition: attachment; filename="dmesg-quantal-ivb41-105:20171127002253:x86_64-randconfig-b0-11261534:4.13.0-rc2:1.gz"
Content-Transfer-Encoding: base64

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

--t5gnkjt3s3pvshqd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="reproduce-quantal-ivb41-109:20171126233844:x86_64-randconfig-b0-11261534:4.13.0-rc2-00001-gf7dd2507:1"

#!/bin/bash

kernel=$1
initrd=quantal-core-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/quantal/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu kvm64
	-kernel $kernel
	-initrd $initrd
	-m 512
	-smp 2
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
	console=tty0
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	vga=normal
	rw
	drbd.minor_count=8
)

"${kvm[@]}" -append "${append[*]}"

--t5gnkjt3s3pvshqd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-4.13.0-rc2-00001-gf7dd2507"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 4.13.0-rc2 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_KASAN_SHADOW_OFFSET=0xdffffc0000000000
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=4
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
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
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
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
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
CONFIG_RCU_EXPERT=y
CONFIG_SRCU=y
CONFIG_TINY_SRCU=y
CONFIG_TASKS_RCU=y
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_RCU_NEED_SEGCBLIST is not set
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_CGROUPS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_CGROUP_PIDS is not set
CONFIG_CGROUP_RDMA=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_CGROUP_PERF is not set
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_SOCK_CGROUP_DATA is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_POSIX_TIMERS=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_ABSOLUTE_PERCPU is not set
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_BPF_SYSCALL is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_ADVISE_SYSCALLS is not set
CONFIG_USERFAULTFD=y
CONFIG_PCI_QUIRKS=y
CONFIG_MEMBARRIER=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y
CONFIG_PC104=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_SLUB_DEBUG is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLAB_MERGE_DEFAULT=y
CONFIG_SLAB_FREELIST_RANDOM=y
# CONFIG_SYSTEM_DATA_VERIFICATION is not set
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
CONFIG_GCC_PLUGIN_CYC_COMPLEXITY=y
CONFIG_GCC_PLUGIN_SANCOV=y
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
CONFIG_GCC_PLUGIN_STRUCTLEAK=y
CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL=y
# CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE is not set
# CONFIG_GCC_PLUGIN_RANDSTRUCT is not set
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
CONFIG_CC_STACKPROTECTOR_STRONG=y
CONFIG_THIN_ARCHIVES=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
# CONFIG_HAVE_ARCH_HASH is not set
# CONFIG_ISA_BUS_API is not set
# CONFIG_CPU_NO_EFFICIENT_FFS is not set
CONFIG_HAVE_ARCH_VMAP_STACK=y
# CONFIG_ARCH_OPTIONAL_KERNEL_RWX is not set
# CONFIG_ARCH_OPTIONAL_KERNEL_RWX_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_REFCOUNT_FULL=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
# CONFIG_GCOV_FORMAT_3_4 is not set
CONFIG_GCOV_FORMAT_4_7=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_MODULES_TREE_LOOKUP=y
# CONFIG_BLOCK is not set
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_FAST_FEATURE_TESTS=y
CONFIG_X86_X2APIC=y
# CONFIG_X86_MPPARSE is not set
CONFIG_GOLDFISH=y
# CONFIG_INTEL_RDT_A is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_UP_LATE_INIT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set

#
# Performance monitoring
#
# CONFIG_PERF_EVENTS_INTEL_UNCORE is not set
CONFIG_PERF_EVENTS_INTEL_RAPL=y
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
# CONFIG_VM86 is not set
# CONFIG_X86_16BIT is not set
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_I8K=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_X86_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_HAVE_GENERIC_GUP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_THP_SWAP=y
CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
CONFIG_Z3FOLD=y
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
# CONFIG_ZSMALLOC_STAT is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_ZONE_DEVICE=y
CONFIG_FRAME_VECTOR=y
CONFIG_PERCPU_STATS=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_X86_INTEL_MPX is not set
# CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_KEXEC_FILE is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_LEGACY_VSYSCALL_NATIVE is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_HAVE_LIVEPATCH=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_HOTPLUG_IOAPIC=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_DPTF_POWER is not set
# CONFIG_PMIC_OPREGION is not set
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_BUS_ADDR_T_64BIT=y
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y
# CONFIG_HOTPLUG_PCI is not set

#
# DesignWare PCI Core Support
#
CONFIG_PCIE_DW=y
CONFIG_PCIE_DW_HOST=y
CONFIG_PCIE_DW_PLAT=y

#
# PCI host controller drivers
#
# CONFIG_VMD is not set

#
# PCI Endpoint
#
CONFIG_PCI_ENDPOINT=y
CONFIG_PCI_ENDPOINT_CONFIGFS=y
# CONFIG_PCI_EPF_TEST is not set

#
# PCI switch controller drivers
#
CONFIG_PCI_SW_SWITCHTEC=y
# CONFIG_ISA_BUS is not set
# CONFIG_ISA_DMA_API is not set
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NET_PTP_CLASSIFY is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_MPLS is not set
# CONFIG_HSR is not set
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_STREAM_PARSER is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set
# CONFIG_PSAMPLE is not set
# CONFIG_NET_IFE is not set
# CONFIG_LWTUNNEL is not set
# CONFIG_DST_CACHE is not set
# CONFIG_GRO_CELLS is not set
# CONFIG_NET_DEVLINK is not set
CONFIG_MAY_USE_DEVLINK=y
CONFIG_HAVE_EBPF_JIT=y

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
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
CONFIG_DEBUG_TEST_DRIVER_REMOVE=y
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
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_OF_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# Partition parsers
#

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=y
CONFIG_MTD_PARTITIONED_MASTER=y

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
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
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_PHYSMAP_OF=y
# CONFIG_MTD_PHYSMAP_OF_VERSATILE is not set
CONFIG_MTD_PHYSMAP_OF_GEMINI=y
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
CONFIG_MTD_PCI=y
CONFIG_MTD_PCMCIA=y
CONFIG_MTD_PCMCIA_ANONYMOUS=y
CONFIG_MTD_GPIO_ADDR=y
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
CONFIG_MTD_NAND_DENALI_PCI=y
# CONFIG_MTD_NAND_DENALI_DT is not set
CONFIG_MTD_NAND_GPIO=y
# CONFIG_MTD_NAND_OMAP_BCH_BUILD is not set
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=y
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_OF=y
# CONFIG_OF_UNITTEST is not set
CONFIG_OF_DYNAMIC=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_ADDRESS_PCI=y
CONFIG_OF_IRQ=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_RESOLVE=y
CONFIG_OF_OVERLAY=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PARPORT_PC_PCMCIA=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
CONFIG_VMWARE_BALLOON=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
CONFIG_PCI_ENDPOINT_TEST=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_IDT_89HPESX=y
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_INTEL_MEI_TXE is not set
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Bus Driver
#
CONFIG_INTEL_MIC_BUS=y

#
# SCIF Bus Driver
#
CONFIG_SCIF_BUS=y

#
# VOP Bus Driver
#
CONFIG_VOP_BUS=y

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
CONFIG_VOP=y
CONFIG_VHOST_RING=y
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_CXL_BASE is not set
# CONFIG_CXL_AFU_DRIVER_OPS is not set
# CONFIG_CXL_LIB is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADC is not set
# CONFIG_KEYBOARD_ADP5520 is not set
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
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CAP11XX is not set
# CONFIG_KEYBOARD_BCM is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
# CONFIG_MOUSE_PS2_VMMOUSE is not set
CONFIG_MOUSE_PS2_SMBUS=y
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_ELAN_I2C is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set
# CONFIG_RMI4_CORE is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
# CONFIG_SERIO_APBPS2 is not set
CONFIG_USERIO=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=y

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
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
# CONFIG_SERIAL_8250_CS is not set
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
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_CONEXANT_DIGICOLOR is not set
# CONFIG_SERIAL_MEN_Z135 is not set
CONFIG_SERIAL_DEV_BUS=y
# CONFIG_SERIAL_DEV_CTRL_TTYPORT is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_SSIF=y
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
# CONFIG_SCR24X is not set
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_CRB is not set
CONFIG_TCG_VTPM_PROXY=y
CONFIG_TCG_TIS_ST33ZP24=y
CONFIG_TCG_TIS_ST33ZP24_I2C=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_ARB_GPIO_CHALLENGE is not set
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_GPMUX=y
CONFIG_I2C_MUX_LTC4306=y
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_MUX_REG=y
# CONFIG_I2C_MUX_MLXCPLD is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EMEV2=y
CONFIG_I2C_GPIO=y
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RK3X=y
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_DLN2=y
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_ROBOTFUZZ_OSIF=y
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=y
CONFIG_I2C_SLAVE=y
# CONFIG_I2C_SLAVE_EEPROM is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=y
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=y
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
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
# CONFIG_GPIO_AXP209 is not set
CONFIG_GPIO_DWAPB=y
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_FTGPIO010 is not set
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_GRGPIO is not set
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_LYNXPOINT is not set
# CONFIG_GPIO_MENZ127 is not set
CONFIG_GPIO_MOCKUP=y
CONFIG_GPIO_SYSCON=y
# CONFIG_GPIO_VX855 is not set
CONFIG_GPIO_XILINX=y

#
# Port-mapped I/O GPIO drivers
#
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_IT87 is not set
CONFIG_GPIO_SCH=y
CONFIG_GPIO_SCH311X=y

#
# I2C GPIO expanders
#
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y
# CONFIG_GPIO_ADNP is not set
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_TPIC2810=y

#
# MFD GPIO expanders
#
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_DLN2=y
CONFIG_GPIO_LP873X=y
# CONFIG_GPIO_LP87565 is not set
CONFIG_GPIO_MAX77620=y
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TPS65086=y
# CONFIG_GPIO_TPS65218 is not set
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM8994=y

#
# PCI GPIO expanders
#
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
CONFIG_GPIO_RDC321X=y
# CONFIG_GPIO_SODAVILLE is not set

#
# USB GPIO expanders
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2405 is not set
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2406=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2438 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_AVS=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_AS3722 is not set
# CONFIG_POWER_RESET_GPIO is not set
# CONFIG_POWER_RESET_GPIO_RESTART is not set
# CONFIG_POWER_RESET_LTC2952 is not set
# CONFIG_POWER_RESET_RESTART is not set
# CONFIG_POWER_RESET_SYSCON is not set
# CONFIG_POWER_RESET_SYSCON_POWEROFF is not set
CONFIG_REBOOT_MODE=y
CONFIG_SYSCON_REBOOT_MODE=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_LEGO_EV3=y
CONFIG_BATTERY_SBS=y
CONFIG_CHARGER_SBS=y
CONFIG_BATTERY_BQ27XXX=y
# CONFIG_BATTERY_BQ27XXX_I2C is not set
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=y
CONFIG_CHARGER_DA9150=y
# CONFIG_BATTERY_DA9150 is not set
# CONFIG_CHARGER_AXP20X is not set
CONFIG_BATTERY_AXP20X=y
CONFIG_AXP20X_POWER=y
# CONFIG_AXP288_CHARGER is not set
# CONFIG_AXP288_FUEL_GAUGE is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=y
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_LTC3651=y
CONFIG_CHARGER_MAX14577=y
CONFIG_CHARGER_DETECTOR_MAX14656=y
CONFIG_CHARGER_MAX77693=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24257=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_BQ25890=y
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65217=y
CONFIG_BATTERY_GAUGE_LTC2941=y
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_BATTERY_RT5033 is not set
CONFIG_CHARGER_RT9455=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ASPEED=y
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DELL_SMM=y
# CONFIG_SENSORS_DA9052_ADC is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_I5500=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_POWR1220=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2990 is not set
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4260 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_TC654=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_NCT6683=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_NCT7802=y
# CONFIG_SENSORS_NCT7904 is not set
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHT3x=y
CONFIG_SENSORS_SHTC1=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_STTS751=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_INA3221=y
CONFIG_SENSORS_TC74=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP103 is not set
CONFIG_SENSORS_TMP108=y
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_OF is not set
CONFIG_THERMAL_WRITABLE_TRIPS=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_BANG_BANG=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_POWER_ALLOCATOR=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_MAX77620_THERMAL=y
CONFIG_INTEL_POWERCLAMP=y
CONFIG_INTEL_SOC_DTS_IOSF_CORE=y
CONFIG_INTEL_SOC_DTS_THERMAL=y

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
CONFIG_INTEL_PCH_THERMAL=y
CONFIG_GENERIC_ADC_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_ACT8945A is not set
CONFIG_MFD_AS3711=y
CONFIG_MFD_AS3722=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_ATMEL_FLEXCOM=y
CONFIG_MFD_ATMEL_HLCDC=y
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_AXP20X=y
CONFIG_MFD_AXP20X_I2C=y
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_DA9150=y
CONFIG_MFD_DLN2=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_MFD_HI6421_PMIC=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_MFD_INTEL_QUARK_I2C_GPIO=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_INTEL_SOC_PMIC is not set
# CONFIG_INTEL_SOC_PMIC_CHTWC is not set
# CONFIG_MFD_INTEL_LPSS_ACPI is not set
# CONFIG_MFD_INTEL_LPSS_PCI is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77620=y
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX77843=y
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_MT6397=y
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RT5033=y
CONFIG_MFD_RTSX_USB=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_RK808 is not set
# CONFIG_MFD_RN5T618 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SKY81452=y
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_TI_LMU=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65086=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TI_LP873X=y
CONFIG_MFD_TI_LP87565=y
CONFIG_MFD_TPS65218=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_CS47L24 is not set
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8997 is not set
CONFIG_MFD_WM8998=y
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM800 is not set
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
# CONFIG_REGULATOR_AS3711 is not set
CONFIG_REGULATOR_AS3722=y
# CONFIG_REGULATOR_AXP20X is not set
CONFIG_REGULATOR_BCM590XX=y
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9063=y
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_DA9211=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_HI6421=y
CONFIG_REGULATOR_HI6421V530=y
CONFIG_REGULATOR_ISL9305=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LM363X=y
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP873X is not set
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_LP87565 is not set
# CONFIG_REGULATOR_LTC3589 is not set
CONFIG_REGULATOR_LTC3676=y
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX77620=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX77686 is not set
# CONFIG_REGULATOR_MAX77693 is not set
# CONFIG_REGULATOR_MAX77802 is not set
CONFIG_REGULATOR_MT6311=y
CONFIG_REGULATOR_MT6323=y
CONFIG_REGULATOR_MT6397=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_PV88060=y
CONFIG_REGULATOR_PV88080=y
CONFIG_REGULATOR_PV88090=y
# CONFIG_REGULATOR_RC5T583 is not set
# CONFIG_REGULATOR_RT5033 is not set
CONFIG_REGULATOR_S2MPA01=y
CONFIG_REGULATOR_S2MPS11=y
CONFIG_REGULATOR_S5M8767=y
# CONFIG_REGULATOR_SKY81452 is not set
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS65086 is not set
CONFIG_REGULATOR_TPS65132=y
# CONFIG_REGULATOR_TPS65217 is not set
# CONFIG_REGULATOR_TPS65218 is not set
# CONFIG_REGULATOR_TPS6586X is not set
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TPS65912=y
# CONFIG_REGULATOR_TPS80031 is not set
CONFIG_REGULATOR_VCTRL=y
# CONFIG_REGULATOR_WM8994 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_SDR_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_MEDIA_CEC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_MEDIA_CONTROLLER_DVB=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_PCI_SKELETON=y
CONFIG_VIDEO_TUNER=y
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_VIDEOBUF2_DMA_SG=y
CONFIG_DVB_CORE=y
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_MAX_ADAPTERS=16
# CONFIG_DVB_DYNAMIC_MINORS is not set
CONFIG_DVB_DEMUX_SECTION_LOSS_LOG=y

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_VIDEO_CLASS=y
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=y
CONFIG_USB_M5602=y
CONFIG_USB_STV06XX=y
# CONFIG_USB_GL860 is not set
CONFIG_USB_GSPCA_BENQ=y
CONFIG_USB_GSPCA_CONEX=y
CONFIG_USB_GSPCA_CPIA1=y
CONFIG_USB_GSPCA_DTCS033=y
CONFIG_USB_GSPCA_ETOMS=y
CONFIG_USB_GSPCA_FINEPIX=y
CONFIG_USB_GSPCA_JEILINJ=y
CONFIG_USB_GSPCA_JL2005BCD=y
CONFIG_USB_GSPCA_KINECT=y
CONFIG_USB_GSPCA_KONICA=y
# CONFIG_USB_GSPCA_MARS is not set
# CONFIG_USB_GSPCA_MR97310A is not set
CONFIG_USB_GSPCA_NW80X=y
CONFIG_USB_GSPCA_OV519=y
CONFIG_USB_GSPCA_OV534=y
CONFIG_USB_GSPCA_OV534_9=y
CONFIG_USB_GSPCA_PAC207=y
CONFIG_USB_GSPCA_PAC7302=y
CONFIG_USB_GSPCA_PAC7311=y
CONFIG_USB_GSPCA_SE401=y
CONFIG_USB_GSPCA_SN9C2028=y
CONFIG_USB_GSPCA_SN9C20X=y
# CONFIG_USB_GSPCA_SONIXB is not set
# CONFIG_USB_GSPCA_SONIXJ is not set
CONFIG_USB_GSPCA_SPCA500=y
CONFIG_USB_GSPCA_SPCA501=y
CONFIG_USB_GSPCA_SPCA505=y
CONFIG_USB_GSPCA_SPCA506=y
CONFIG_USB_GSPCA_SPCA508=y
CONFIG_USB_GSPCA_SPCA561=y
# CONFIG_USB_GSPCA_SPCA1528 is not set
CONFIG_USB_GSPCA_SQ905=y
CONFIG_USB_GSPCA_SQ905C=y
CONFIG_USB_GSPCA_SQ930X=y
# CONFIG_USB_GSPCA_STK014 is not set
# CONFIG_USB_GSPCA_STK1135 is not set
CONFIG_USB_GSPCA_STV0680=y
CONFIG_USB_GSPCA_SUNPLUS=y
# CONFIG_USB_GSPCA_T613 is not set
# CONFIG_USB_GSPCA_TOPRO is not set
# CONFIG_USB_GSPCA_TOUPTEK is not set
CONFIG_USB_GSPCA_TV8532=y
# CONFIG_USB_GSPCA_VC032X is not set
CONFIG_USB_GSPCA_VICAM=y
# CONFIG_USB_GSPCA_XIRLINK_CIT is not set
CONFIG_USB_GSPCA_ZC3XX=y
# CONFIG_USB_PWC is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_USB_ZR364XX is not set
CONFIG_USB_STKWEBCAM=y
CONFIG_USB_S2255=y

#
# Analog TV USB devices
#
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_HDPVR is not set
# CONFIG_VIDEO_USBVISION is not set
CONFIG_VIDEO_STK1160_COMMON=y
CONFIG_VIDEO_STK1160=y

#
# Analog/digital TV USB devices
#
# CONFIG_VIDEO_AU0828 is not set

#
# Digital TV USB devices
#
CONFIG_DVB_USB_V2=y
CONFIG_DVB_USB_AF9015=y
# CONFIG_DVB_USB_AF9035 is not set
CONFIG_DVB_USB_ANYSEE=y
# CONFIG_DVB_USB_AU6610 is not set
CONFIG_DVB_USB_AZ6007=y
CONFIG_DVB_USB_CE6230=y
# CONFIG_DVB_USB_EC168 is not set
CONFIG_DVB_USB_GL861=y
# CONFIG_DVB_USB_MXL111SF is not set
CONFIG_DVB_USB_RTL28XXU=y
CONFIG_DVB_USB_DVBSKY=y
CONFIG_DVB_USB_ZD1301=y
CONFIG_DVB_TTUSB_BUDGET=y
# CONFIG_DVB_TTUSB_DEC is not set
CONFIG_SMS_USB_DRV=y
# CONFIG_DVB_B2C2_FLEXCOP_USB is not set
# CONFIG_DVB_AS102 is not set

#
# Webcam, TV (analog/digital) USB devices
#
# CONFIG_VIDEO_EM28XX is not set

#
# Software defined radio USB devices
#
CONFIG_USB_AIRSPY=y
CONFIG_USB_HACKRF=y

#
# USB HDMI CEC adapters
#
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
CONFIG_VIDEO_TW5864=y
# CONFIG_VIDEO_TW68 is not set
CONFIG_VIDEO_ZORAN=y
CONFIG_VIDEO_ZORAN_DC30=y
# CONFIG_VIDEO_ZORAN_ZR36060 is not set

#
# Media capture/analog TV support
#
CONFIG_VIDEO_HEXIUM_GEMINI=y
CONFIG_VIDEO_HEXIUM_ORION=y
CONFIG_VIDEO_MXB=y
CONFIG_VIDEO_DT3155=y

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX25821=y
CONFIG_VIDEO_SAA7134=y
# CONFIG_VIDEO_SAA7134_DVB is not set
CONFIG_VIDEO_SAA7164=y

#
# Media digital TV PCI Adapters
#
# CONFIG_DVB_AV7110 is not set
CONFIG_DVB_BUDGET_CORE=y
CONFIG_DVB_BUDGET=y
# CONFIG_DVB_BUDGET_AV is not set
CONFIG_DVB_B2C2_FLEXCOP_PCI=y
CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG=y
CONFIG_DVB_PLUTO2=y
CONFIG_DVB_PT1=y
CONFIG_DVB_PT3=y
CONFIG_DVB_NGENE=y
CONFIG_DVB_DDBRIDGE=y
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_V4L_TEST_DRIVERS=y
# CONFIG_VIDEO_VIMC is not set
# CONFIG_VIDEO_VIVID is not set
CONFIG_VIDEO_VIM2M=y
CONFIG_DVB_PLATFORM_DRIVERS=y
# CONFIG_CEC_PLATFORM_DRIVERS is not set
# CONFIG_SDR_PLATFORM_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
CONFIG_RADIO_SI4713=y
CONFIG_USB_SI4713=y
# CONFIG_PLATFORM_SI4713 is not set
CONFIG_I2C_SI4713=y
CONFIG_USB_MR800=y
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
CONFIG_RADIO_SHARK2=y
CONFIG_USB_KEENE=y
CONFIG_USB_RAREMONO=y
CONFIG_USB_MA901=y
CONFIG_RADIO_TEA5764=y
# CONFIG_RADIO_TEA5764_XTAL is not set
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_TEF6862=y
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_TVEEPROM=y
CONFIG_CYPRESS_FIRMWARE=y
CONFIG_DVB_B2C2_FLEXCOP=y
CONFIG_DVB_B2C2_FLEXCOP_DEBUG=y
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y
CONFIG_SMS_SIANO_MDTV=y

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=y

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#

#
# Video encoders
#
CONFIG_VIDEO_ADV7175=y

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=y

#
# SDR tuner chips
#

#
# Miscellaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_SI2157=y
CONFIG_MEDIA_TUNER_R820T=y
CONFIG_MEDIA_TUNER_MXL301RF=y
CONFIG_MEDIA_TUNER_QM1D1C0042=y

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STV090x=y
CONFIG_DVB_STV6110x=y
CONFIG_DVB_M88DS3103=y

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
CONFIG_DVB_TDA18271C2DD=y
CONFIG_DVB_MN88472=y
CONFIG_DVB_MN88473=y

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24123=y
CONFIG_DVB_MT312=y
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
CONFIG_DVB_TDA8083=y
CONFIG_DVB_TDA10086=y
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TUNER_ITD1000=y
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TDA826X=y
CONFIG_DVB_CX24116=y
CONFIG_DVB_CX24120=y
CONFIG_DVB_TS2020=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_CX22700=y
CONFIG_DVB_L64781=y
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y
CONFIG_DVB_TDA10048=y
CONFIG_DVB_AF9013=y
CONFIG_DVB_STV0367=y
CONFIG_DVB_CXD2820R=y
CONFIG_DVB_CXD2841ER=y
CONFIG_DVB_RTL2830=y
CONFIG_DVB_RTL2832=y
CONFIG_DVB_RTL2832_SDR=y
CONFIG_DVB_SI2168=y
# CONFIG_DVB_AS102_FE is not set
CONFIG_DVB_ZD1301_DEMOD=y
# CONFIG_DVB_GP8PSK_FE is not set

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10023=y
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
CONFIG_DVB_BCM3510=y
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
CONFIG_DVB_TC90522=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=y
CONFIG_DVB_ISL6421=y
CONFIG_DVB_ISL6423=y
CONFIG_DVB_SP2=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_DP_AUX_CHARDEV=y
CONFIG_DRM_DEBUG_MM=y
CONFIG_DRM_DEBUG_MM_SELFTEST=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y
CONFIG_DRM_GEM_CMA_HELPER=y
CONFIG_DRM_KMS_CMA_HELPER=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_USERPTR=y
# CONFIG_DRM_AMDGPU is not set

#
# ACP (Audio CoProcessor) Configuration
#
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=y
# CONFIG_DRM_I915_ALPHA_SUPPORT is not set
# CONFIG_DRM_I915_CAPTURE_ERROR is not set
# CONFIG_DRM_I915_USERPTR is not set
CONFIG_DRM_I915_GVT=y

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
CONFIG_DRM_I915_DEBUG=y
CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS=y
CONFIG_DRM_I915_SW_FENCE_CHECK_DAG=y
CONFIG_DRM_I915_SELFTEST=y
CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS=y
CONFIG_DRM_I915_DEBUG_VBLANK_EVADE=y
CONFIG_DRM_VGEM=y
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=y
CONFIG_DRM_GMA600=y
# CONFIG_DRM_GMA3600 is not set
CONFIG_DRM_UDL=y
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_RCAR_DW_HDMI=y
CONFIG_DRM_QXL=y
# CONFIG_DRM_BOCHS is not set
CONFIG_DRM_VIRTIO_GPU=y
CONFIG_DRM_PANEL=y

#
# Display Panels
#
CONFIG_DRM_PANEL_LVDS=y
CONFIG_DRM_PANEL_SIMPLE=y
CONFIG_DRM_PANEL_INNOLUX_P079ZCA=y
CONFIG_DRM_PANEL_JDI_LT070ME05000=y
CONFIG_DRM_PANEL_PANASONIC_VVX10F034N00=y
CONFIG_DRM_PANEL_SAMSUNG_S6E3HA2=y
CONFIG_DRM_PANEL_SAMSUNG_S6E8AA0=y
CONFIG_DRM_PANEL_SHARP_LQ101R1SX01=y
CONFIG_DRM_PANEL_SHARP_LS043T1LE01=y
CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
CONFIG_DRM_ANALOGIX_ANX78XX=y
CONFIG_DRM_DUMB_VGA_DAC=y
CONFIG_DRM_LVDS_ENCODER=y
# CONFIG_DRM_MEGACHIPS_STDPXXXX_GE_B850V3_FW is not set
# CONFIG_DRM_NXP_PTN3460 is not set
# CONFIG_DRM_PARADE_PS8622 is not set
# CONFIG_DRM_SIL_SII8620 is not set
# CONFIG_DRM_SII902X is not set
CONFIG_DRM_TOSHIBA_TC358767=y
CONFIG_DRM_TI_TFP410=y
# CONFIG_DRM_I2C_ADV7511 is not set
CONFIG_DRM_DW_HDMI=y
# CONFIG_DRM_ARCPGU is not set
# CONFIG_DRM_HISI_HIBMC is not set
CONFIG_DRM_MXS=y
CONFIG_DRM_MXSFB=y
# CONFIG_DRM_TINYDRM is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_LIB_RANDOM=y

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_PROVIDE_GET_FB_UNMAPPED_AREA is not set
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=y
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
# CONFIG_FB_ATY_GX is not set
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=y
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
# CONFIG_FB_3DFX_I2C is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=y
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_GOLDFISH is not set
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=y
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SSD1307 is not set
# CONFIG_FB_SM712 is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_DA903X=y
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_PM8941_WLED is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_PCF50633=y
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_SKY81452 is not set
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_AS3711=y
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_BACKLIGHT_ARCXCNN=y
CONFIG_VGASTATE=y
CONFIG_VIDEOMODE_HELPERS=y
CONFIG_HDMI=y
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACCUTOUCH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_ASUS is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_BETOP_FF is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_CMEDIA is not set
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_GEMBIRD is not set
# CONFIG_HID_GFRM is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_GT683R is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_ITE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LED is not set
# CONFIG_HID_LENOVO is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTI is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PENMOUNT is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PLANTRONICS is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_RETRODE is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_RMI is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set
# CONFIG_HID_ALPS is not set

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set

#
# Intel ISH HID support
#
# CONFIG_INTEL_ISH_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PCI=y
CONFIG_USB_XHCI_PLATFORM=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=y
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_TEST_MODE=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_PCI=y
# CONFIG_USB_DWC3_OF_SIMPLE is not set
# CONFIG_USB_DWC2 is not set
CONFIG_USB_CHIPIDEA=y
CONFIG_USB_CHIPIDEA_OF=y
# CONFIG_USB_CHIPIDEA_HOST is not set
CONFIG_USB_ISP1760=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1760_HOST_ROLE=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=y
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
# CONFIG_USB_EZUSB_FX2 is not set
CONFIG_USB_HUB_USB251XB=y
# CONFIG_USB_HSIC_USB3503 is not set
CONFIG_USB_HSIC_USB4604=y
# CONFIG_USB_LINK_LAYER_TEST is not set
CONFIG_USB_CHAOSKEY=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_USB_GPIO_VBUS=y
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_GADGET is not set

#
# USB Power Delivery and Type-C drivers
#
CONFIG_TYPEC=y
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_ACPI is not set
# CONFIG_USB_ULPI_BUS is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
# CONFIG_UWB_WHCI is not set
# CONFIG_UWB_I1480U is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
# CONFIG_MEMSTICK_REALTEK_PCI is not set
# CONFIG_MEMSTICK_REALTEK_USB is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
CONFIG_LEDS_BRIGHTNESS_HW_CHANGED=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_BCM6328=y
CONFIG_LEDS_BCM6358=y
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_MT6323=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
# CONFIG_LEDS_LP3952 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_LP8860=y
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_TLC591XX=y
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_IS31FL319X=y
CONFIG_LEDS_IS31FL32XX=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set
CONFIG_LEDS_SYSCON=y
CONFIG_LEDS_MLXCPLD=y
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_SYSTOHC_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y
# CONFIG_RTC_NVMEM is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
CONFIG_RTC_DRV_88PM80X=y
CONFIG_RTC_DRV_ABB5ZES3=y
CONFIG_RTC_DRV_ABX80X=y
CONFIG_RTC_DRV_AS3722=y
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1374_WDT=y
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_HYM8563=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX77686=y
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF85063=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TPS6586X=y
# CONFIG_RTC_DRV_TPS65910 is not set
CONFIG_RTC_DRV_TPS80031=y
# CONFIG_RTC_DRV_RC5T583 is not set
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8010=y
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=y
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV8803=y
CONFIG_RTC_DRV_S5M=y

#
# SPI RTC drivers
#
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=y
# CONFIG_RTC_DRV_DS3232_HWMON is not set
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=y
CONFIG_RTC_DRV_RV3029_HWMON=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1685_FAMILY=y
# CONFIG_RTC_DRV_DS1685 is not set
CONFIG_RTC_DRV_DS1689=y
# CONFIG_RTC_DRV_DS17285 is not set
# CONFIG_RTC_DRV_DS17485 is not set
# CONFIG_RTC_DRV_DS17885 is not set
CONFIG_RTC_DS1685_PROC_REGS=y
# CONFIG_RTC_DS1685_SYSFS_REGS is not set
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_DA9052 is not set
CONFIG_RTC_DRV_DA9063=y
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_PCF50633=y
# CONFIG_RTC_DRV_ZYNQMP is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_FTRTC010=y
CONFIG_RTC_DRV_SNVS=y
CONFIG_RTC_DRV_MT6397=y
CONFIG_RTC_DRV_R7301=y

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
# CONFIG_DMADEVICES is not set

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
# CONFIG_AUXDISPLAY is not set
CONFIG_CHARLCD=y
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
CONFIG_UIO_PRUSS=y
CONFIG_UIO_MF624=y
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_PCI_LEGACY is not set
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_INPUT is not set
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_HYPERV_TSCPAGE is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_PMC_ATOM=y
CONFIG_GOLDFISH_BUS=y
CONFIG_GOLDFISH_PIPE=y
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=y
CONFIG_CHROMEOS_PSTORE=y
# CONFIG_CROS_KBD_LED_BACKLIGHT is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_MAX77686 is not set
CONFIG_COMMON_CLK_SI5351=y
CONFIG_COMMON_CLK_SI514=y
# CONFIG_COMMON_CLK_SI570 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CDCE925 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_S2MPS11 is not set
# CONFIG_CLK_TWL6040 is not set
# CONFIG_COMMON_CLK_NXP is not set
# CONFIG_COMMON_CLK_PXA is not set
# CONFIG_COMMON_CLK_PIC32 is not set
# CONFIG_COMMON_CLK_VC5 is not set
# CONFIG_HWSPINLOCK is not set

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
CONFIG_PLATFORM_MHU=y
# CONFIG_PCC is not set
CONFIG_ALTERA_MBOX=y
CONFIG_MAILBOX_TEST=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y

#
# Rpmsg drivers
#
CONFIG_RPMSG=y
# CONFIG_RPMSG_CHAR is not set
CONFIG_RPMSG_QCOM_GLINK_RPM=y

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
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_ADC_JACK is not set
CONFIG_EXTCON_AXP288=y
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_INTEL_INT3496 is not set
CONFIG_EXTCON_MAX14577=y
# CONFIG_EXTCON_MAX3355 is not set
# CONFIG_EXTCON_MAX77693 is not set
# CONFIG_EXTCON_MAX77843 is not set
CONFIG_EXTCON_RT8973A=y
# CONFIG_EXTCON_SM5502 is not set
CONFIG_EXTCON_USB_GPIO=y
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_CONFIGFS=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
CONFIG_IIO_SW_DEVICE=y
CONFIG_IIO_SW_TRIGGER=y

#
# Accelerometers
#
CONFIG_ADXL345=y
CONFIG_ADXL345_I2C=y
# CONFIG_BMA180 is not set
CONFIG_BMC150_ACCEL=y
CONFIG_BMC150_ACCEL_I2C=y
CONFIG_DA280=y
CONFIG_DA311=y
# CONFIG_DMARD06 is not set
CONFIG_DMARD09=y
CONFIG_DMARD10=y
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
CONFIG_KXSD9=y
CONFIG_KXSD9_I2C=y
CONFIG_KXCJK1013=y
CONFIG_MC3230=y
CONFIG_MMA7455=y
CONFIG_MMA7455_I2C=y
CONFIG_MMA7660=y
# CONFIG_MMA8452 is not set
CONFIG_MMA9551_CORE=y
CONFIG_MMA9551=y
# CONFIG_MMA9553 is not set
CONFIG_MXC4005=y
# CONFIG_MXC6255 is not set
CONFIG_STK8312=y
# CONFIG_STK8BA50 is not set

#
# Analog to digital converters
#
CONFIG_AD7291=y
CONFIG_AD799X=y
CONFIG_AXP20X_ADC=y
# CONFIG_AXP288_ADC is not set
CONFIG_CC10001_ADC=y
CONFIG_DA9150_GPADC=y
# CONFIG_ENVELOPE_DETECTOR is not set
CONFIG_HX711=y
CONFIG_LTC2485=y
CONFIG_LTC2497=y
# CONFIG_MAX1363 is not set
CONFIG_MAX9611=y
# CONFIG_MCP3422 is not set
CONFIG_MEN_Z188_ADC=y
CONFIG_NAU7802=y
# CONFIG_TI_ADC081C is not set
# CONFIG_TI_AM335X_ADC is not set
# CONFIG_VF610_ADC is not set

#
# Amplifiers
#

#
# Chemical Sensors
#
# CONFIG_ATLAS_PH_SENSOR is not set
# CONFIG_IAQCORE is not set
CONFIG_VZ89X=y

#
# Hid Sensor IIO Common
#
CONFIG_IIO_MS_SENSORS_I2C=y

#
# SSP Sensor Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Counters
#

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
CONFIG_AD5380=y
CONFIG_AD5446=y
# CONFIG_AD5593R is not set
CONFIG_DPOT_DAC=y
CONFIG_M62332=y
CONFIG_MAX517=y
# CONFIG_MAX5821 is not set
# CONFIG_MCP4725 is not set
CONFIG_VF610_DAC=y

#
# IIO dummy driver
#
CONFIG_IIO_DUMMY_EVGEN=y
CONFIG_IIO_SIMPLE_DUMMY=y
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
CONFIG_BMG160=y
CONFIG_BMG160_I2C=y
CONFIG_MPU3050=y
CONFIG_MPU3050_I2C=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_ITG3200=y

#
# Health Sensors
#

#
# Heart Rate Monitors
#
CONFIG_AFE4404=y
CONFIG_MAX30100=y
CONFIG_MAX30102=y

#
# Humidity sensors
#
CONFIG_AM2315=y
CONFIG_DHT11=y
# CONFIG_HDC100X is not set
CONFIG_HTS221=y
CONFIG_HTS221_I2C=y
CONFIG_HTU21=y
# CONFIG_SI7005 is not set
CONFIG_SI7020=y

#
# Inertial measurement units
#
CONFIG_BMI160=y
CONFIG_BMI160_I2C=y
CONFIG_KMX61=y
CONFIG_INV_MPU6050_IIO=y
CONFIG_INV_MPU6050_I2C=y
CONFIG_IIO_ST_LSM6DSX=y
CONFIG_IIO_ST_LSM6DSX_I2C=y

#
# Light sensors
#
# CONFIG_ACPI_ALS is not set
CONFIG_ADJD_S311=y
CONFIG_AL3320A=y
# CONFIG_APDS9300 is not set
CONFIG_APDS9960=y
# CONFIG_BH1750 is not set
CONFIG_BH1780=y
CONFIG_CM32181=y
CONFIG_CM3232=y
# CONFIG_CM3323 is not set
# CONFIG_CM3605 is not set
CONFIG_CM36651=y
CONFIG_GP2AP020A00F=y
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
# CONFIG_ISL29125 is not set
CONFIG_JSA1212=y
# CONFIG_RPR0521 is not set
# CONFIG_SENSORS_LM3533 is not set
CONFIG_LTR501=y
# CONFIG_MAX44000 is not set
# CONFIG_OPT3001 is not set
CONFIG_PA12203001=y
CONFIG_SI1145=y
CONFIG_STK3310=y
# CONFIG_TCS3414 is not set
CONFIG_TCS3472=y
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_TSL2583=y
CONFIG_TSL4531=y
CONFIG_US5182D=y
CONFIG_VCNL4000=y
CONFIG_VEML6070=y
CONFIG_VL6180=y

#
# Magnetometer sensors
#
CONFIG_AK8974=y
CONFIG_AK8975=y
CONFIG_AK09911=y
CONFIG_BMC150_MAGN=y
CONFIG_BMC150_MAGN_I2C=y
# CONFIG_MAG3110 is not set
CONFIG_MMC35240=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
# CONFIG_SENSORS_HMC5843_I2C is not set

#
# Multiplexers
#
CONFIG_IIO_MUX=y

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
CONFIG_IIO_HRTIMER_TRIGGER=y
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
CONFIG_IIO_TIGHTLOOP_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Digital potentiometers
#
# CONFIG_DS1803 is not set
CONFIG_MCP4531=y
# CONFIG_TPL0102 is not set

#
# Digital potentiostats
#
CONFIG_LMP91000=y

#
# Pressure sensors
#
CONFIG_ABP060MG=y
CONFIG_BMP280=y
CONFIG_BMP280_I2C=y
CONFIG_HP03=y
# CONFIG_MPL115_I2C is not set
# CONFIG_MPL3115 is not set
# CONFIG_MS5611 is not set
CONFIG_MS5637=y
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
# CONFIG_T5403 is not set
# CONFIG_HP206C is not set
CONFIG_ZPA2326=y
CONFIG_ZPA2326_I2C=y

#
# Lightning sensors
#

#
# Proximity and distance sensors
#
# CONFIG_LIDAR_LITE_V2 is not set
# CONFIG_SRF04 is not set
# CONFIG_SX9500 is not set
CONFIG_SRF08=y

#
# Temperature sensors
#
CONFIG_MLX90614=y
# CONFIG_TMP006 is not set
# CONFIG_TMP007 is not set
# CONFIG_TSYS01 is not set
# CONFIG_TSYS02D is not set
# CONFIG_NTB is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=y
# CONFIG_VME_FAKE is not set

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
# CONFIG_PWM is not set
CONFIG_IRQCHIP=y
CONFIG_ARM_GIC_MAX_NR=1
# CONFIG_IPACK_BUS is not set
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
CONFIG_RESET_TI_SYSCON=y
# CONFIG_RESET_ZYNQ is not set
# CONFIG_RESET_TEGRA_BPMP is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_PXA_28NM_HSIC=y
# CONFIG_PHY_PXA_28NM_USB2 is not set
CONFIG_PHY_CPCAP_USB=y
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
CONFIG_MCB=y
CONFIG_MCB_PCI=y
CONFIG_MCB_LPC=y

#
# Performance monitor support
#
CONFIG_RAS=y
CONFIG_THUNDERBOLT=y

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
CONFIG_DAX=y
CONFIG_DEV_DAX=y
CONFIG_NVMEM=y
# CONFIG_STM is not set
CONFIG_INTEL_TH=y
CONFIG_INTEL_TH_PCI=y
CONFIG_INTEL_TH_GTH=y
CONFIG_INTEL_TH_MSU=y
CONFIG_INTEL_TH_PTI=y
# CONFIG_INTEL_TH_DEBUG is not set

#
# FPGA Configuration Support
#
# CONFIG_FPGA is not set

#
# FSI support
#
CONFIG_FSI=y
# CONFIG_FSI_MASTER_GPIO is not set
CONFIG_FSI_MASTER_HUB=y
CONFIG_FSI_SCOM=y
CONFIG_MULTIPLEXER=y

#
# Multiplexer drivers
#
CONFIG_MUX_ADG792A=y
CONFIG_MUX_GPIO=y
# CONFIG_MUX_MMIO is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_FW_CFG_SYSFS=y
CONFIG_FW_CFG_SYSFS_CMDLINE=y
# CONFIG_GOOGLE_FIRMWARE is not set
# CONFIG_EFI_DEV_PATH_PARSER is not set

#
# Tegra firmware driver
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
# CONFIG_FS_ENCRYPTION is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
# CONFIG_OVERLAY_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
# CONFIG_PROC_CHILDREN is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ORANGEFS_FS=y
# CONFIG_JFFS2_FS is not set
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
# CONFIG_UBIFS_FS_LZO is not set
CONFIG_UBIFS_FS_ZLIB=y
CONFIG_UBIFS_ATIME_SUPPORT=y
CONFIG_UBIFS_FS_SECURITY=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_ZLIB_COMPRESS is not set
CONFIG_PSTORE_LZO_COMPRESS=y
# CONFIG_PSTORE_LZ4_COMPRESS is not set
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
CONFIG_PSTORE_RAM=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y

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
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_SPLIT is not set
# CONFIG_DEBUG_INFO_DWARF4 is not set
# CONFIG_GDB_SCRIPTS is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=8192
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_PAGE_OWNER is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
# CONFIG_SECTION_MISMATCH_WARN_ONLY is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_STACK_VALIDATION=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_POISONING is not set
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_KASAN=y
CONFIG_KASAN_OUTLINE=y
# CONFIG_KASAN_INLINE is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_KCOV=y
# CONFIG_KCOV_INSTRUMENT_ALL is not set
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_WQ_WATCHDOG is not set
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
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_WW_MUTEX_SELFTEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PI_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_PERF_TEST is not set
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TRACE=y
CONFIG_RCU_EQS_DEBUG=y
CONFIG_DEBUG_WQ_FORCE_RR_CPU=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_FUTEX is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
CONFIG_TEST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_INTERVAL_TREE_TEST=y
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_HEXDUMP=y
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_PRINTF is not set
CONFIG_TEST_BITMAP=y
CONFIG_TEST_UUID=y
CONFIG_TEST_RHASHTABLE=y
# CONFIG_TEST_HASH is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_FIRMWARE=y
CONFIG_TEST_SYSCTL=y
CONFIG_TEST_UDELAY=y
# CONFIG_MEMTEST is not set
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
CONFIG_STRICT_DEVMEM=y
CONFIG_IO_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP_CORE=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_WX is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_ENTRY=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_FPU=y
CONFIG_PUNIT_ATOM_DEBUG=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_HARDENED_USERCOPY_PAGESPAN=y
# CONFIG_FORTIFY_SOURCE is not set
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_RSA=y
# CONFIG_CRYPTO_DH is not set
CONFIG_CRYPTO_ECDH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_MCRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_SIMD=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_CHACHA20POLY1305=y
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
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_KEYWRAP=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=y
# CONFIG_CRYPTO_POLY1305_X86_64 is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA1_MB=y
# CONFIG_CRYPTO_SHA256_MB is not set
CONFIG_CRYPTO_SHA512_MB=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_DES3_EDE_X86_64=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_CHACHA20=y
CONFIG_CRYPTO_CHACHA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
# CONFIG_CRYPTO_DRBG_HASH is not set
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_USER_API_RNG is not set
# CONFIG_CRYPTO_USER_API_AEAD is not set
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set

#
# Certificates for signature checking
#
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC4=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_INTERVAL_TREE=y
CONFIG_RADIX_TREE_MULTIORDER=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
# CONFIG_DMA_NOOP_OPS is not set
# CONFIG_DMA_VIRT_OPS is not set
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
# CONFIG_SG_SPLIT is not set
# CONFIG_SG_POOL is not set
CONFIG_ARCH_HAS_SG_CHAIN=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_MMIO_FLUSH=y
CONFIG_STACKDEPOT=y
CONFIG_PRIME_NUMBERS=y

--t5gnkjt3s3pvshqd--
