Date: Thu, 19 Apr 2018 09:38:55 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [gcc-plugins] c61f13eaa1 BUG: KASAN: use-after-scope in ep_poll at
 addr ffff88001ee87d00
Message-ID: <20180419013855.4tyssb556l4lkgba@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="g5zwo56l4e3vkrzx"
Content-Disposition: inline
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kbuild@vger.kernel.org, LKP <lkp@01.org>
List-ID: <kernel-hardening.lists.openwall.com>


--g5zwo56l4e3vkrzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

commit c61f13eaa1ee17728c41370100d2d45c254ce76f
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Fri Jan 13 11:14:39 2017 -0800
Commit:     Kees Cook <keescook@chromium.org>
CommitDate: Wed Jan 18 12:02:35 2017 -0800

     gcc-plugins: Add structleak for more stack initialization
     
     This plugin detects any structures that contain __user attributes and
     makes sure it is being fully initialized so that a specific class of
     information exposure is eliminated. (This plugin was originally designed
     to block the exposure of siginfo in CVE-2013-2141.)
     
     Ported from grsecurity/PaX. This version adds a verbose option to the
     plugin and the Kconfig.
     
     Signed-off-by: Kees Cook <keescook@chromium.org>

8d4973a1c0  gcc-plugins: add PASS_INFO and build_const_char_string()
c61f13eaa1  gcc-plugins: Add structleak for more stack initialization
c4e0ca7fa2  Merge tag 'riscv-for-linus-4.15-maintainers' of git://git.kernel.org/pub/scm/linux/kernel/git/palmer/riscv-linux
f0701bf7db  Add linux-next specific files for 20180126
+--------------------------------+------------+------------+------------+---------------+
|                                | 8d4973a1c0 | c61f13eaa1 | c4e0ca7fa2 | next-20180126 |
+--------------------------------+------------+------------+------------+---------------+
| boot_successes                 | 39         | 0          | 1          | 13            |
| boot_failures                  | 0          | 13         | 20         |               |
| BUG:KASAN:use-after-scope_in_e | 0          | 13         | 20         |               |
+--------------------------------+------------+------------+------------+---------------+

[   28.855033] init: Temporary process spawn error: No such file or directory
[   28.863505] init: Failed to create pty - disabling logging for job
[   28.864418] init: Temporary process spawn error: No such file or directory
udevd[253]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:LNXSYSTM:': No such file or directory
[   28.975924] ==================================================================
[   28.976803] BUG: KASAN: use-after-scope in ep_poll+0xb51/0xc33 at addr ffff88001ee87d00
[   28.977751] Write of size 16 by task udevadm/248
[   28.978321] page:ffffea00007ba1c0 count:0 mapcount:0 mapping:          (null) index:0x1
[   28.979273] flags: 0x0()
[   28.979600] raw: 0000000000000000 0000000000000000 0000000000000001 00000000ffffffff
[   28.980537] raw: 0000000000000000 dead000000000200 0000000000000000 0000000000000000
[   28.981458] page dumped because: kasan: bad access detected
[   28.982135] CPU: 0 PID: 248 Comm: udevadm Not tainted 4.10.0-rc2-00004-gc61f13e #1
[   28.983038] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[   28.984135] Call Trace:
[   28.984611]  dump_stack+0x1e/0x20
[   28.985172]  kasan_report+0x32e/0x435
[   28.985625]  ? ep_poll+0xb51/0xc33
[   28.986053]  ? ep_poll+0xb13/0xc33
[   28.986478]  __asan_report_store16_noabort+0x1c/0x1e
[   28.987286]  ep_poll+0xb51/0xc33
[   28.987803]  ? ep_poll_readyevents_proc+0x86/0x86
[   28.988551]  ? sock_enable_timestamp+0xa1/0xa1
[   28.989255]  ? bit_waitqueue+0x34/0x34
[   28.989831]  ? get_usage_char+0x3b/0x3b
[   28.990398]  ? get_usage_char+0x3b/0x3b
[   28.991120]  ? __lock_acquire+0x113d/0x1245
[   28.991675]  ? __context_tracking_exit+0xe4/0x266
[   28.992348]  ? lock_acquire+0x318/0x318
[   28.992963]  ? __fget_light+0x2e6/0x318
[   28.993566]  ? __fget+0x35b/0x35b
[   28.994101]  ? syscall_slow_exit_work+0x591/0x591
[   28.994850]  ? __this_cpu_preempt_check+0x1c/0x1f
[   28.995590]  ? do_task_dead+0x1cb/0x1cb
[   28.996204]  SyS_epoll_wait+0x16e/0x1a2
[   28.996811]  ? SyS_epoll_ctl+0x1571/0x1571
[   28.997461]  do_syscall_64+0x307/0x522
[   28.998060]  ? check_preemption_disabled+0x198/0x1a1
[   28.998866]  ? syscall_return_slowpath+0x25b/0x25b
[   28.999733]  ? context_tracking_user_enter+0x30/0x30
[   29.000486]  ? prepare_exit_to_usermode+0x13e/0x166
[   29.001217]  ? enter_from_user_mode+0x72/0x72
[   29.001909]  entry_SYSCALL64_slow_path+0x25/0x25
[   29.002627] RIP: 0033:0x7ffb5675cb33
[   29.003196] RSP: 002b:00007ffe90b896a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[   29.004363] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007ffb5675cb33
[   29.005460] RDX: 0000000000000004 RSI: 00007ffe90b89850 RDI: 0000000000000003
[   29.006556] RBP: 000055e3eed8e2d0 R08: 000000000000000a R09: 0000000000000000
[   29.007660] R10: 00000000ffffffff R11: 0000000000000246 R12: 000055e3eed8e110
[   29.008758] R13: 0000000000000001 R14: 00007ffe90b8985c R15: 0000000000000004
[   29.009872] Memory state around the buggy address:
[   29.010618]  ffff88001ee87c00: f8 f2 f2 f2 f2 f2 f2 f2 f8 f2 f2 f2 f2 f2 f2 f2
[   29.011730]  ffff88001ee87c80: 00 00 f2 f2 f2 f2 f2 f2 00 00 f2 f2 f2 f2 f2 f2

                                                           # HH:MM RESULT GOOD BAD GOOD_BUT_DIRTY DIRTY_NOT_BAD
git bisect start v4.11 v4.10 --
git bisect  bad ce70df089143c49385b4f32f39d41fb50fbf6a7c  # 11:07  B      0     3   16   0  mm, gup: fix typo in gup_p4d_range()
git bisect  bad 94eae8034002401d71ae950106659e16add36e77  # 11:38  B      0    11   24   0  Merge tag 'platform-drivers-x86-v4.11-1' of git://git.infradead.org/linux-platform-drivers-x86
git bisect good 7bb033829ef3ecfc491c0ed0197966e8f197fbdc  # 12:12  G     13     0   13  13  Merge tag 'rodata-v4.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux
git bisect  bad a3919caaa27a5fde1cbda46e394bb17953e104a1  # 12:52  B      0     4   17   0  Merge tag 'rproc-v4.11' of git://github.com/andersson/remoteproc
git bisect  bad a27fcb0cd1bcc812017192bdde41cc456dcd6afe  # 13:05  B      0    12   25   0  Merge tag 'xfs-4.11-merge-7' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux
git bisect  bad 8ff546b801e5cca0337c0f0a7234795d0a6309a1  # 13:22  B      0     3   16   0  Merge tag 'usb-4.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
git bisect  bad ff47d8c05019d6e7753cef270d6399cb5a33be57  # 13:42  B      0     7   20   0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
git bisect  bad 1e74a2eb1f5cc7f2f2b5aa9c9eeecbcf352220a3  # 13:56  B      0     1   14   0  Merge tag 'gcc-plugins-v4.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux
git bisect good e7e04c0c8c7ea931d966e5bd349a0b1c836b1ebf  # 14:16  G     12     0    0   0  Merge branch 'for-next/gcc-plugin-infrastructure' into for-linus/gcc-plugins
git bisect  bad c054ee3bbf69ebcabb1f3218b7faf4b1b37a8eb6  # 14:32  B      0     3   16   0  Merge branch 'for-next/gcc-plugin/structleak' into for-linus/gcc-plugins
git bisect  bad c61f13eaa1ee17728c41370100d2d45c254ce76f  # 14:50  B      0    10   23   0  gcc-plugins: Add structleak for more stack initialization
# first bad commit: [c61f13eaa1ee17728c41370100d2d45c254ce76f] gcc-plugins: Add structleak for more stack initialization
git bisect good 8d4973a1c01d4b38871fbc6631e1fdd20e6c9e90  # 15:06  G     39     0    0   0  gcc-plugins: add PASS_INFO and build_const_char_string()
# extra tests with debug options
git bisect  bad c61f13eaa1ee17728c41370100d2d45c254ce76f  # 15:42  B      0     9   22   0  gcc-plugins: Add structleak for more stack initialization
# extra tests on HEAD of linux-devel/devel-hourly-2018012623
git bisect  bad 053f055c57c24ecc91e16dc1056be540bec47d3e  # 15:42  B      0    13   29   0  0day head guard for 'devel-hourly-2018012623'
# extra tests on tree/branch linus/master
git bisect  bad c4e0ca7fa24137e372d6135fe16e8df8e123f116  # 16:24  B      1    12    0   0  Merge tag 'riscv-for-linus-4.15-maintainers' of git://git.kernel.org/pub/scm/linux/kernel/git/palmer/riscv-linux
# extra tests on tree/branch linux-next/master
git bisect good f0701bf7db7ab816244aed52d28ac49f32c8c2c9  # 16:46  G     13     0    0   0  Add linux-next specific files for 20180126

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/lkp                          Intel Corporation

--g5zwo56l4e3vkrzx
Content-Type: application/gzip
Content-Disposition: attachment; filename="dmesg-quantal-intel12-10:20180127145039:x86_64-randconfig-s5-01270457:4.10.0-rc2-00004-gc61f13e:1.gz"
Content-Transfer-Encoding: base64

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
G15sSASPusLDfyeax2NDrpA5QhSxSpaBjqus7TxRxI66HBesdzxNFLGj//BhXvO47+gfxPEE
3Bqz6SS40jweO5bF8Ga143miiB2hnmVPyP/vbdV2vq3aL3G//ekPf/sfKf/5Lyn95h/Qz/+e
Uk8zt39vr3WO/5d/+n//1//X/+N//qeu1nG80CD/0Tr+L3/+7U9//2+eTvz7n7v+Jk/4m//t
X77++tbuT/fvhYQF4TwujB2pCtTTuTC2lhJDWvq5MNZo7RadzoWxtUGUYm+5sD4merrH5BUX
+r6aa+PwXC6MfSHbWX0olmPNKd/HhfE3qFoSvYULY3uuY9U2XBgPCeZjhSiCop2pyYU18D5q
6CWVRZTdAeslF9YoteGhYr7OkhxzYcTkojTEhbGopJvU8ooLaxDDMRBFEJQul/QaqrfGjwYX
RiySjWlNsYgQergwQsMap4MLa6hAar4NcvcW6eXCWORfxrFKNfh9NONBDxdGaF4koRYXRmi5
i4BNLoxowNJRqRaReHdI7ObCWEVSBl3SY5WkcaUp1immUS6MZSa3t6yHC31B5Kg0woWx5gZS
h1xY46Q6qEzlwux3saqSzOLCnGkxNZ/FhTFhL76J07gwZ7/BnPdH3HKhf4C1ynAaF+ZSaofg
GBfmsvhWzOPCXGjxB53GhdnvN5hncmH8KvBwqFjEaEGayYW5GG/fmStcmMFTgTlK041f/L5w
ml/+9OsP//S3n3/92/evDgy+3W/ff+b/9X/6p//tv/yXL//49O89KCVlwpix3DWe2d9Ji6Ls
mSTliWt1yn4DSXniW4vkR0gqlIRdf/jrJOW3Io5L2R5JRX1fPu0M+ZqkSsKDfc+TlOe/OZ31
h6/LNQ7n3klSJXEtW30TSZWkCfamfdWHsOaYRyTlQVZVmBZJFU/mc2PaV43Se+HOa5Iqnqjy
CZLydVY7H46eQc5gY+OZY5F/7VKDpErcKxfF4l9+/vHnX377/s9xgVrCKwgFHpBF7qyfv+QM
90z/n//59TrQ+sf018M64Z62/QjFu0tNE8lKGD/LIJKVTNBV/ldDlXukughlTI+VgntI5kGa
1y3vbSQrWRDu5NGLZCX7tbtnznMNXfrR2kgWrpI37uxAshIl2dCDZB5puh6t0IFkxa9GPIxk
UX4tw61DdZ3xOJKVUvg+r68LyUrxb9XQnOe6RtPGpmbLOp6mQxxpzkUyx3TI7QECD/81kMzf
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
L/72+uYOG9fV/YNRoP398893V7c3Xx7e2uV78wFXKF7N5/e/PpRZmW9PXpDXHx/u39+Ux6/f
v3v76/vP5rdtrd+wNmxYGzesTRvW5g1r6dRauxze33wwuL+fXL3/8tOHm39cfXr8hG/w46Nd
ko+fr5DVfPVfXr26sZ3x0z0u9c92jbx9Y1fUm883H+1K+vMvtruVrf6nm0/v7976V1/N18bN
T/af87/bb+PzX3+4+fC3m398+WH6Ydybr7tffrq339vX9i/l/vLlZ2zXuIoef/n5rV3Mr76y
6/Xr9++QyPvy1v5z2rS/tuf/y8cvP759/GR/Ks/72p74y+O7n7GN/vLT84v59PH9D7uL9235
66uvHh9/+rL79w+PN/c/2FvBB/Q24AkecYfb/cWe8v7z7f3XH99/evz8Q8n/vpXyfuy3fv/1
h8cff/jw8OvDh7cPnz+/+ur9j2b18IP9tfzx1Vd2H/jyaF/Pzz//wzw93Hz+8I/pHeAv/9Nd
e2+3Zrdn9+Kvv/5489YcfrwxT5//9uqr2883n+7+/PbD+0+//B0/+YcPb8r/v/7z4y/m+XVw
XpwPFOKrr77/t3/7Xz/8t//x3b/+/u2bn/7y45uy6M20ibw2P/f2lO/e//j6S35tS4yiMr/5
8e7uNb+Z86o3N/7hwTMHuYOaMZRG78N9ynchp7sHpndvfv0Ip//x+mRq9vhnh2/94fO7r7/8
+Zef7x//9sk+Y7vC/uk//R/bH//0X//9//7T1evpcruyv03/9qd/tj+/+n8ezeukGooKAA==

--g5zwo56l4e3vkrzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="reproduce-quantal-intel12-10:20180127145039:x86_64-randconfig-s5-01270457:4.10.0-rc2-00004-gc61f13e:1"

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
	rcuperf.shutdown=0
)

"${kvm[@]}" -append "${append[*]}"

--g5zwo56l4e3vkrzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-4.10.0-rc2-00004-gc61f13e"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 4.10.0-rc2 Kernel Configuration
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
CONFIG_DEBUG_RODATA=y
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
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

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
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
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
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_EXPERT=y
CONFIG_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
CONFIG_RCU_KTHREAD_PRIO=0
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_NONE=y
# CONFIG_RCU_NOCB_CPU_ZERO is not set
# CONFIG_RCU_NOCB_CPU_ALL is not set
# CONFIG_RCU_EXPEDITE_BOOT is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_NMI_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_CGROUPS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_BPF=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CHECKPOINT_RESTORE=y
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
CONFIG_INITRAMFS_COMPRESSION=".gz"
# CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
# CONFIG_SYSFS_SYSCALL is not set
# CONFIG_SYSCTL_SYSCALL is not set
# CONFIG_POSIX_TIMERS is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_ABSOLUTE_PERCPU is not set
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
CONFIG_BPF_SYSCALL=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_ADVISE_SYSCALLS=y
# CONFIG_USERFAULTFD is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_MEMBARRIER is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_SLAB_FREELIST_RANDOM is not set
# CONFIG_SYSTEM_DATA_VERIFICATION is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_KEXEC_CORE=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
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
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
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
CONFIG_GCC_PLUGIN_LATENT_ENTROPY=y
CONFIG_GCC_PLUGIN_STRUCTLEAK=y
# CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE is not set
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
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
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_HAVE_STACK_VALIDATION=y
# CONFIG_HAVE_ARCH_HASH is not set
CONFIG_ISA_BUS_API=y
# CONFIG_CPU_NO_EFFICIENT_FFS is not set
CONFIG_HAVE_ARCH_VMAP_STACK=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
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
# CONFIG_X86_FAST_FEATURE_TESTS is not set
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
# CONFIG_INTEL_RDT_A is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_AMD_PLATFORM_DEVICE=y
CONFIG_IOSF_MBI=y
CONFIG_IOSF_MBI_DEBUG=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_UP_LATE_INIT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y

#
# Performance monitoring
#
# CONFIG_PERF_EVENTS_INTEL_UNCORE is not set
CONFIG_PERF_EVENTS_INTEL_RAPL=y
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
# CONFIG_PERF_EVENTS_AMD_POWER is not set
# CONFIG_VM86 is not set
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_X86_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
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
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
# CONFIG_COMPACTION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_ZPOOL=y
# CONFIG_ZBUD is not set
CONFIG_Z3FOLD=y
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
# CONFIG_ZSMALLOC_STAT is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT=y
# CONFIG_IDLE_PAGE_TRACKING is not set
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_INTEL_MPX=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
# CONFIG_EFI_MIXED is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_KEXEC_FILE is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
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
CONFIG_ACPI_EC_DEBUGFS=y
# CONFIG_ACPI_AC is not set
CONFIG_ACPI_BATTERY=y
# CONFIG_ACPI_BUTTON is not set
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
# CONFIG_ACPI_THERMAL is not set
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_EINJ=y
CONFIG_ACPI_APEI_ERST_DEBUG=y
# CONFIG_DPTF_POWER is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_PMIC_OPREGION is not set
# CONFIG_ACPI_CONFIGFS is not set
# CONFIG_SFI is not set

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
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_BUS_ADDR_T_64BIT=y
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y
# CONFIG_HOTPLUG_PCI is not set

#
# PCI host controller drivers
#
CONFIG_PCIE_DW_PLAT=y
CONFIG_PCIE_DW=y
CONFIG_VMD=y
CONFIG_ISA_BUS=y
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
# CONFIG_YENTA_O2 is not set
CONFIG_YENTA_RICOH=y
# CONFIG_YENTA_TI is not set
# CONFIG_YENTA_TOSHIBA is not set
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=y
CONFIG_RAPIDIO_CHMAN=y
# CONFIG_RAPIDIO_MPORT_CDEV is not set

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_RAPIDIO_RXS_GEN3=y
# CONFIG_X86_SYSFB is not set

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
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_PMC_ATOM=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_NET_INGRESS=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_SYN_COOKIES is not set
CONFIG_NET_IPVTI=y
CONFIG_NET_UDP_TUNNEL=y
CONFIG_NET_FOU=y
CONFIG_NET_FOU_IP_TUNNELS=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_INET_RAW_DIAG=y
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
# CONFIG_TCP_CONG_NV is not set
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
CONFIG_TCP_CONG_DCTCP=y
CONFIG_TCP_CONG_CDG=y
# CONFIG_TCP_CONG_BBR is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HYBLA is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_DCTCP is not set
# CONFIG_DEFAULT_CDG is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
# CONFIG_IPV6_ROUTE_INFO is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_IPV6_ILA=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_VTI=y
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
# CONFIG_IPV6_GRE is not set
CONFIG_IPV6_FOU=y
CONFIG_IPV6_FOU_TUNNEL=y
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IPV6_PIMSM_V2=y
CONFIG_IPV6_SEG6_LWTUNNEL=y
# CONFIG_IPV6_SEG6_INLINE is not set
CONFIG_IPV6_SEG6_HMAC=y
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_LOG_COMMON=y
CONFIG_NF_LOG_NETDEV=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_FTP=y
# CONFIG_NF_CONNTRACK_IRC is not set
CONFIG_NF_CONNTRACK_BROADCAST=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NETFILTER_NETLINK_GLUE_CT=y
# CONFIG_NF_TABLES is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_LOG=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
CONFIG_IP_SET=y
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=y
# CONFIG_IP_SET_BITMAP_IPMAC is not set
CONFIG_IP_SET_BITMAP_PORT=y
CONFIG_IP_SET_HASH_IP=y
# CONFIG_IP_SET_HASH_IPMARK is not set
CONFIG_IP_SET_HASH_IPPORT=y
CONFIG_IP_SET_HASH_IPPORTIP=y
# CONFIG_IP_SET_HASH_IPPORTNET is not set
CONFIG_IP_SET_HASH_IPMAC=y
# CONFIG_IP_SET_HASH_MAC is not set
CONFIG_IP_SET_HASH_NETPORTNET=y
CONFIG_IP_SET_HASH_NET=y
CONFIG_IP_SET_HASH_NETNET=y
CONFIG_IP_SET_HASH_NETPORT=y
CONFIG_IP_SET_HASH_NETIFACE=y
# CONFIG_IP_SET_LIST_SET is not set
CONFIG_IP_VS=y
CONFIG_IP_VS_IPV6=y
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
# CONFIG_IP_VS_PROTO_TCP is not set
# CONFIG_IP_VS_PROTO_UDP is not set
# CONFIG_IP_VS_PROTO_AH_ESP is not set
# CONFIG_IP_VS_PROTO_ESP is not set
# CONFIG_IP_VS_PROTO_AH is not set
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=y
CONFIG_IP_VS_WRR=y
CONFIG_IP_VS_LC=y
CONFIG_IP_VS_WLC=y
CONFIG_IP_VS_FO=y
# CONFIG_IP_VS_OVF is not set
CONFIG_IP_VS_LBLC=y
# CONFIG_IP_VS_LBLCR is not set
CONFIG_IP_VS_DH=y
# CONFIG_IP_VS_SH is not set
CONFIG_IP_VS_SED=y
CONFIG_IP_VS_NQ=y

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
CONFIG_IP_VS_NFCT=y

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_NF_CONNTRACK_IPV4 is not set
# CONFIG_NF_SOCKET_IPV4 is not set
CONFIG_NF_DUP_IPV4=y
CONFIG_NF_LOG_ARP=y
CONFIG_NF_LOG_IPV4=y
# CONFIG_NF_REJECT_IPV4 is not set
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_FILTER=y
# CONFIG_IP_NF_TARGET_REJECT is not set
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_RAW=y

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
# CONFIG_NF_CONNTRACK_IPV6 is not set
CONFIG_NF_SOCKET_IPV6=y
CONFIG_NF_DUP_IPV6=y
# CONFIG_NF_REJECT_IPV6 is not set
CONFIG_NF_LOG_IPV6=y
CONFIG_IP6_NF_IPTABLES=y
# CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
CONFIG_IP6_NF_FILTER=y
# CONFIG_IP6_NF_TARGET_REJECT is not set
CONFIG_IP6_NF_MANGLE=y
CONFIG_IP6_NF_RAW=y
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
# CONFIG_BRIDGE_EBT_T_NAT is not set
# CONFIG_BRIDGE_EBT_802_3 is not set
CONFIG_BRIDGE_EBT_AMONG=y
CONFIG_BRIDGE_EBT_ARP=y
# CONFIG_BRIDGE_EBT_IP is not set
CONFIG_BRIDGE_EBT_IP6=y
CONFIG_BRIDGE_EBT_LIMIT=y
CONFIG_BRIDGE_EBT_MARK=y
CONFIG_BRIDGE_EBT_PKTTYPE=y
CONFIG_BRIDGE_EBT_STP=y
CONFIG_BRIDGE_EBT_VLAN=y
CONFIG_BRIDGE_EBT_ARPREPLY=y
# CONFIG_BRIDGE_EBT_DNAT is not set
CONFIG_BRIDGE_EBT_MARK_T=y
CONFIG_BRIDGE_EBT_REDIRECT=y
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
# CONFIG_BRIDGE_EBT_NFLOG is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_L2TP=y
CONFIG_L2TP_DEBUGFS=y
# CONFIG_L2TP_V3 is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_HWMON=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_QCA=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_6LOWPAN=y
# CONFIG_6LOWPAN_DEBUGFS is not set
CONFIG_6LOWPAN_NHC=y
CONFIG_6LOWPAN_NHC_DEST=y
# CONFIG_6LOWPAN_NHC_FRAGMENT is not set
CONFIG_6LOWPAN_NHC_HOP=y
CONFIG_6LOWPAN_NHC_IPV6=y
CONFIG_6LOWPAN_NHC_MOBILITY=y
CONFIG_6LOWPAN_NHC_ROUTING=y
# CONFIG_6LOWPAN_NHC_UDP is not set
CONFIG_6LOWPAN_GHC_EXT_HDR_HOP=y
# CONFIG_6LOWPAN_GHC_UDP is not set
CONFIG_6LOWPAN_GHC_ICMPV6=y
CONFIG_6LOWPAN_GHC_EXT_HDR_DEST=y
CONFIG_6LOWPAN_GHC_EXT_HDR_FRAG=y
# CONFIG_6LOWPAN_GHC_EXT_HDR_ROUTE is not set
CONFIG_IEEE802154=y
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
# CONFIG_IEEE802154_SOCKET is not set
# CONFIG_IEEE802154_6LOWPAN is not set
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BATMAN_V is not set
CONFIG_BATMAN_ADV_BLA=y
# CONFIG_BATMAN_ADV_DAT is not set
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_MCAST=y
# CONFIG_BATMAN_ADV_DEBUGFS is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
# CONFIG_VMWARE_VMCI_VSOCKETS is not set
CONFIG_VIRTIO_VSOCKETS=y
CONFIG_VIRTIO_VSOCKETS_COMMON=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
CONFIG_MPLS_ROUTING=y
CONFIG_MPLS_IPTUNNEL=y
CONFIG_HSR=y
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
CONFIG_NET_NCSI=y
CONFIG_SOCK_CGROUP_DATA=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_LEDS is not set
# CONFIG_CAN_GRCAN is not set
# CONFIG_CAN_JANZ_ICAN3 is not set
# CONFIG_CAN_C_CAN is not set
CONFIG_CAN_CC770=y
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=y
CONFIG_CAN_IFI_CANFD=y
CONFIG_CAN_M_CAN=y
CONFIG_CAN_SJA1000=y
CONFIG_CAN_SJA1000_ISA=y
# CONFIG_CAN_SJA1000_PLATFORM is not set
CONFIG_CAN_EMS_PCMCIA=y
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCMCIA is not set
CONFIG_CAN_PEAK_PCI=y
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_KVASER_PCI=y
# CONFIG_CAN_PLX_PCI is not set
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_BREDR=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
# CONFIG_BT_BNEP_PROTO_FILTER is not set
CONFIG_BT_HIDP=y
CONFIG_BT_HS=y
# CONFIG_BT_LE is not set
CONFIG_BT_LEDS=y
# CONFIG_BT_SELFTEST is not set
# CONFIG_BT_DEBUGFS is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=y
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIDTL1 is not set
CONFIG_BT_HCIBT3C=y
# CONFIG_BT_HCIBLUECARD is not set
CONFIG_BT_HCIBTUART=y
CONFIG_BT_HCIVHCI=y
# CONFIG_BT_MRVL is not set
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_IPV6 is not set
CONFIG_AF_RXRPC_INJECT_LOSS=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_AF_KCM=y
CONFIG_STREAM_PARSER=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_CERTIFICATION_ONUS=y
# CONFIG_CFG80211_REG_CELLULAR_HINTS is not set
# CONFIG_CFG80211_REG_RELAX_NO_IR is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT=""

#
# Some wireless drivers require a rate control algorithm
#
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_LEDS is not set
# CONFIG_MAC80211_DEBUGFS is not set
CONFIG_MAC80211_MESSAGE_TRACING=y
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_RFKILL_GPIO=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_RDMA=y
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
CONFIG_CEPH_LIB_PRETTYDEBUG=y
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=y
CONFIG_NFC_NCI=y
# CONFIG_NFC_NCI_UART is not set
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_MEI_PHY=y
CONFIG_NFC_SIM=y
# CONFIG_NFC_FDP is not set
CONFIG_NFC_PN544=y
CONFIG_NFC_PN544_I2C=y
# CONFIG_NFC_PN544_MEI is not set
CONFIG_NFC_PN533=y
CONFIG_NFC_PN533_I2C=y
CONFIG_NFC_MICROREAD=y
# CONFIG_NFC_MICROREAD_I2C is not set
CONFIG_NFC_MICROREAD_MEI=y
CONFIG_NFC_ST21NFCA=y
CONFIG_NFC_ST21NFCA_I2C=y
CONFIG_NFC_ST_NCI=y
CONFIG_NFC_ST_NCI_I2C=y
# CONFIG_NFC_NXP_NCI is not set
CONFIG_NFC_S3FWRN5=y
CONFIG_NFC_S3FWRN5_I2C=y
CONFIG_LWTUNNEL=y
# CONFIG_LWTUNNEL_BPF is not set
CONFIG_DST_CACHE=y
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
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPMI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_FENCE_TRACE=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
# CONFIG_MTD is not set
CONFIG_DTC=y
CONFIG_OF=y
CONFIG_OF_UNITTEST=y
CONFIG_OF_FLATTREE=y
CONFIG_OF_EARLY_FLATTREE=y
CONFIG_OF_DYNAMIC=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_ADDRESS_PCI=y
CONFIG_OF_IRQ=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_RESOLVE=y
CONFIG_OF_OVERLAY=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=y
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=y
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# SCIF Bus Driver
#
CONFIG_SCIF_BUS=y

#
# VOP Bus Driver
#
# CONFIG_VOP_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#

#
# SCIF Driver
#
CONFIG_SCIF=y

#
# Intel MIC Coprocessor State Management (COSM) Drivers
#
CONFIG_MIC_COSM=y

#
# VOP Driver
#
CONFIG_GENWQE=y
CONFIG_GENWQE_PLATFORM_ERROR_RECOVERY=0
CONFIG_ECHO=y
# CONFIG_CXL_BASE is not set
# CONFIG_CXL_AFU_DRIVER_OPS is not set
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
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_NET=y
CONFIG_FIREWIRE_NOSY=y
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_BCM_SF2 is not set
CONFIG_B53=y
CONFIG_B53_MDIO_DRIVER=y
# CONFIG_B53_MMAP_DRIVER is not set
# CONFIG_B53_SRAB_DRIVER is not set
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6XXX_GLOBAL2=y
CONFIG_NET_DSA_QCA8K=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
CONFIG_SLICOSS=y
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_ALTERA_TSE=y
# CONFIG_NET_VENDOR_AMAZON is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
CONFIG_PCMCIA_NMCLAN=y
CONFIG_AMD_XGBE=y
# CONFIG_AMD_XGBE_DCB is not set
CONFIG_AMD_XGBE_HAVE_ECC=y
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
CONFIG_NET_VENDOR_AURORA=y
CONFIG_AURORA_NB8800=y
# CONFIG_NET_CADENCE is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=y
# CONFIG_NET_VENDOR_CAVIUM is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=y
CONFIG_CX_ECAT=y
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
# CONFIG_NET_VENDOR_EMULEX is not set
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_EZCHIP_NPS_MANAGEMENT_ENET=y
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
CONFIG_VXGE=y
CONFIG_VXGE_DEBUG_TRACE_ALL=y
CONFIG_NET_VENDOR_FUJITSU=y
# CONFIG_PCMCIA_FMVJ18X is not set
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
# CONFIG_IXGBE_DCB is not set
# CONFIG_IXGBEVF is not set
# CONFIG_I40E is not set
# CONFIG_I40EVF is not set
# CONFIG_FM10K is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_JME=y
# CONFIG_NET_VENDOR_MARVELL is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
CONFIG_MLX4_CORE=y
CONFIG_MLX4_DEBUG=y
CONFIG_MLX5_CORE=y
CONFIG_MLX5_CORE_EN=y
# CONFIG_MLX5_CORE_EN_DCB is not set
CONFIG_MLXSW_CORE=y
# CONFIG_MLXSW_CORE_HWMON is not set
# CONFIG_MLXSW_CORE_THERMAL is not set
CONFIG_MLXSW_PCI=y
CONFIG_MLXSW_I2C=y
CONFIG_MLXSW_SWITCHIB=y
# CONFIG_MLXSW_SWITCHX2 is not set
CONFIG_MLXSW_SPECTRUM=y
# CONFIG_MLXSW_SPECTRUM_DCB is not set
CONFIG_MLXSW_MINIMAL=y
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8851_MLL=y
# CONFIG_KSZ884X_PCI is not set
# CONFIG_NET_VENDOR_MYRI is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
CONFIG_NS83820=y
# CONFIG_NET_VENDOR_NETRONOME is not set
CONFIG_NET_VENDOR_8390=y
CONFIG_PCMCIA_AXNET=y
CONFIG_NE2K_PCI=y
CONFIG_PCMCIA_PCNET=y
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_ETHOC=y
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=y
CONFIG_QLCNIC=y
# CONFIG_QLCNIC_SRIOV is not set
# CONFIG_QLCNIC_DCB is not set
# CONFIG_QLCNIC_HWMON is not set
CONFIG_QLGE=y
CONFIG_NETXEN_NIC=y
CONFIG_QED=y
CONFIG_QED_LL2=y
CONFIG_QED_SRIOV=y
CONFIG_QEDE=y
CONFIG_QED_RDMA=y
CONFIG_NET_VENDOR_QUALCOMM=y
CONFIG_QCOM_EMAC=y
# CONFIG_NET_VENDOR_REALTEK is not set
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
# CONFIG_NET_VENDOR_ROCKER is not set
# CONFIG_NET_VENDOR_SAMSUNG is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_PCMCIA_SMC91C92 is not set
CONFIG_EPIC100=y
CONFIG_SMSC911X=y
# CONFIG_SMSC911X_ARCH_HOOKS is not set
CONFIG_SMSC9420=y
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=y
CONFIG_STMMAC_PLATFORM=y
CONFIG_DWMAC_GENERIC=y
CONFIG_STMMAC_PCI=y
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_SYNOPSYS is not set
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=y
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_ALE is not set
CONFIG_TLAN=y
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
CONFIG_VIA_VELOCITY=y
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
CONFIG_WIZNET_W5300=y
# CONFIG_WIZNET_BUS_DIRECT is not set
CONFIG_WIZNET_BUS_INDIRECT=y
# CONFIG_WIZNET_BUS_ANY is not set
# CONFIG_NET_VENDOR_XIRCOM is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
CONFIG_SKFP=y
CONFIG_HIPPI=y
# CONFIG_ROADRUNNER is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
# CONFIG_LED_TRIGGER_PHY is not set

#
# MDIO bus device drivers
#
CONFIG_MDIO_BCM_UNIMAC=y
# CONFIG_MDIO_BITBANG is not set
CONFIG_MDIO_BUS_MUX=y
CONFIG_MDIO_BUS_MUX_GPIO=y
CONFIG_MDIO_BUS_MUX_MMIOREG=y
CONFIG_MDIO_HISI_FEMAC=y
# CONFIG_MDIO_OCTEON is not set
# CONFIG_MDIO_THUNDER is not set

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
CONFIG_AQUANTIA_PHY=y
# CONFIG_AT803X_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
CONFIG_BCM87XX_PHY=y
CONFIG_BCM_NET_PHYLIB=y
CONFIG_BROADCOM_PHY=y
CONFIG_CICADA_PHY=y
# CONFIG_DAVICOM_PHY is not set
CONFIG_DP83848_PHY=y
CONFIG_DP83867_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_INTEL_XWAY_PHY=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_LXT_PHY=y
CONFIG_MARVELL_PHY=y
# CONFIG_MESON_GXL_PHY is not set
CONFIG_MICREL_PHY=y
CONFIG_MICROCHIP_PHY=y
CONFIG_MICROSEMI_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_STE10XP is not set
CONFIG_TERANETICS_PHY=y
# CONFIG_VITESSE_PHY is not set
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# Host-side USB support is needed for USB Network Adapter support
#
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
# CONFIG_HDLC_RAW is not set
CONFIG_HDLC_RAW_ETH=y
# CONFIG_HDLC_CISCO is not set
# CONFIG_HDLC_FR is not set
CONFIG_HDLC_PPP=y
# CONFIG_HDLC_X25 is not set
CONFIG_PCI200SYN=y
CONFIG_WANXL=y
# CONFIG_PC300TOO is not set
CONFIG_FARSYNC=y
# CONFIG_DLCI is not set
CONFIG_LAPBETHER=y
# CONFIG_X25_ASY is not set
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKELB=y
CONFIG_VMXNET3=y
CONFIG_FUJITSU_ES=y
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_LEDS is not set
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADC=y
CONFIG_KEYBOARD_ADP5520=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=y
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_OMAP4 is not set
CONFIG_KEYBOARD_TC3589X=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_CAP11XX=y
CONFIG_KEYBOARD_BCM=y
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
# CONFIG_MOUSE_ELAN_I2C is not set
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_ATMEL_CAPTOUCH=y
CONFIG_INPUT_BMA150=y
# CONFIG_INPUT_E3X0_BUTTON is not set
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MAX77693_HAPTIC=y
CONFIG_INPUT_MAX8997_HAPTIC=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=y
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_BEEPER is not set
CONFIG_INPUT_GPIO_TILT_POLLED=y
# CONFIG_INPUT_GPIO_DECODER is not set
CONFIG_INPUT_ATLAS_BTNS=y
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_REGULATOR_HAPTIC=y
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_TPS65218_PWRBUTTON=y
# CONFIG_INPUT_AXP20X_PEK is not set
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_PCF50633_PMU=y
CONFIG_INPUT_PCF8574=y
# CONFIG_INPUT_PWM_BEEPER is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9063_ONKEY=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_SOC_BUTTON_ARRAY is not set
CONFIG_INPUT_DRV260X_HAPTICS=y
CONFIG_INPUT_DRV2665_HAPTICS=y
# CONFIG_INPUT_DRV2667_HAPTICS is not set
CONFIG_RMI4_CORE=y
# CONFIG_RMI4_I2C is not set
# CONFIG_RMI4_SMB is not set
# CONFIG_RMI4_F03 is not set
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
# CONFIG_RMI4_F12 is not set
CONFIG_RMI4_F30=y
CONFIG_RMI4_F34=y
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
# CONFIG_SERIO_APBPS2 is not set
CONFIG_USERIO=y
# CONFIG_GAMEPORT is not set

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
# CONFIG_DEVMEM is not set
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
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
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
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_SCR24X is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=y
CONFIG_TCG_CRB=y
CONFIG_TCG_VTPM_PROXY=y
CONFIG_TCG_TIS_ST33ZP24=y
CONFIG_TCG_TIS_ST33ZP24_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_XILLYBUS=y
CONFIG_XILLYBUS_PCIE=y
CONFIG_XILLYBUS_OF=y

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
CONFIG_I2C_ARB_GPIO_CHALLENGE=y
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_PINCTRL is not set
CONFIG_I2C_MUX_REG=y
CONFIG_I2C_DEMUX_PINCTRL=y
# CONFIG_I2C_MUX_MLXCPLD is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_DESIGNWARE_BAYTRAIL is not set
CONFIG_I2C_EMEV2=y
CONFIG_I2C_GPIO=y
# CONFIG_I2C_KEMPLD is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RK3X=y
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_MLXCPLD is not set
CONFIG_I2C_SLAVE=y
# CONFIG_I2C_SLAVE_EEPROM is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PINCTRL=y

#
# Pin controllers
#
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
CONFIG_DEBUG_PINCTRL=y
CONFIG_PINCTRL_AS3722=y
CONFIG_PINCTRL_AMD=y
CONFIG_PINCTRL_SINGLE=y
CONFIG_PINCTRL_SX150X=y
CONFIG_PINCTRL_MAX77620=y
# CONFIG_PINCTRL_BAYTRAIL is not set
CONFIG_PINCTRL_CHERRYVIEW=y
CONFIG_PINCTRL_INTEL=y
CONFIG_PINCTRL_BROXTON=y
CONFIG_PINCTRL_SUNRISEPOINT=y
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_74XX_MMIO=y
# CONFIG_GPIO_ALTERA is not set
CONFIG_GPIO_AMDPT=y
# CONFIG_GPIO_AXP209 is not set
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_GRGPIO is not set
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_LYNXPOINT is not set
# CONFIG_GPIO_MENZ127 is not set
CONFIG_GPIO_MOCKUP=y
CONFIG_GPIO_SYSCON=y
CONFIG_GPIO_VX855=y
CONFIG_GPIO_XILINX=y

#
# Port-mapped I/O GPIO drivers
#
CONFIG_GPIO_104_DIO_48E=y
CONFIG_GPIO_104_IDIO_16=y
CONFIG_GPIO_104_IDI_48=y
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_GPIO_MM is not set
CONFIG_GPIO_IT87=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_WS16C48=y

#
# I2C GPIO expanders
#
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y
CONFIG_GPIO_ADNP=y
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_TPIC2810 is not set

#
# MFD GPIO expanders
#
# CONFIG_GPIO_ADP5520 is not set
# CONFIG_GPIO_JANZ_TTL is not set
CONFIG_GPIO_KEMPLD=y
# CONFIG_GPIO_MAX77620 is not set
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65086=y
CONFIG_GPIO_TPS65218=y
CONFIG_GPIO_TPS6586X=y

#
# PCI GPIO expanders
#
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_ML_IOH is not set
CONFIG_GPIO_RDC321X=y
CONFIG_GPIO_SODAVILLE=y

#
# SPI or I2C GPIO expanders
#
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2406=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
# CONFIG_POWER_AVS is not set
CONFIG_POWER_RESET=y
CONFIG_POWER_RESET_AS3722=y
# CONFIG_POWER_RESET_GPIO is not set
# CONFIG_POWER_RESET_GPIO_RESTART is not set
# CONFIG_POWER_RESET_LTC2952 is not set
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_RESET_SYSCON=y
CONFIG_POWER_RESET_SYSCON_POWEROFF=y
CONFIG_REBOOT_MODE=y
CONFIG_SYSCON_REBOOT_MODE=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_ACT8945A=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_DA9150 is not set
CONFIG_AXP288_FUEL_GAUGE=y
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_PCF50633=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_MAX14577=y
CONFIG_CHARGER_MAX77693=y
CONFIG_CHARGER_MAX8997=y
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_BQ25890=y
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_CHARGER_TPS65090 is not set
CONFIG_BATTERY_GAUGE_LTC2941=y
CONFIG_CHARGER_RT9455=y
CONFIG_AXP20X_POWER=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=y
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DELL_SMM=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_MC13783_ADC is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_I5500=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_POWR1220=y
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LTC2945 is not set
CONFIG_SENSORS_LTC2990=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MAX31790=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_TC654=y
CONFIG_SENSORS_MENF21BMC_HWMON=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_NCT6683 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NCT7802 is not set
CONFIG_SENSORS_NCT7904=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_LTC2978_REGULATOR=y
# CONFIG_SENSORS_LTC3815 is not set
# CONFIG_SENSORS_MAX16064 is not set
# CONFIG_SENSORS_MAX20751 is not set
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
# CONFIG_SENSORS_TPS40422 is not set
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_PWM_FAN=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SHT3x is not set
CONFIG_SENSORS_SHTC1=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_OF is not set
CONFIG_THERMAL_WRITABLE_TRIPS=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_GOV_STEP_WISE is not set
# CONFIG_THERMAL_GOV_BANG_BANG is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_MAX77620_THERMAL is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_X86_PKG_TEMP_THERMAL is not set
CONFIG_INTEL_SOC_DTS_IOSF_CORE=y
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=y
CONFIG_ACPI_THERMAL_REL=y
CONFIG_INTEL_PCH_THERMAL=y
CONFIG_QCOM_SPMI_TEMP_ALARM=y
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
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_ACT8945A=y
CONFIG_MFD_AS3711=y
CONFIG_MFD_AS3722=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_ATMEL_FLEXCOM=y
CONFIG_MFD_ATMEL_HLCDC=y
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_AXP20X=y
CONFIG_MFD_AXP20X_I2C=y
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9062=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_DA9150=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_MFD_HI6421_PMIC=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_MFD_INTEL_QUARK_I2C_GPIO=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_INTEL_SOC_PMIC is not set
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77620=y
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX77843=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_MT6397 is not set
CONFIG_MFD_MENF21BMC=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RT5033 is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_RK808=y
# CONFIG_MFD_RN5T618 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_SKY81452=y
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65086=y
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TI_LP873X is not set
CONFIG_MFD_TPS65218=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_ACT8945A=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
# CONFIG_REGULATOR_AAT2870 is not set
# CONFIG_REGULATOR_AB3100 is not set
CONFIG_REGULATOR_AS3711=y
CONFIG_REGULATOR_AS3722=y
CONFIG_REGULATOR_AXP20X=y
CONFIG_REGULATOR_BCM590XX=y
CONFIG_REGULATOR_DA9062=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_DA9211=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_HI6421=y
CONFIG_REGULATOR_ISL9305=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_LTC3589=y
CONFIG_REGULATOR_LTC3676=y
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX77620 is not set
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX8998 is not set
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MAX77693=y
# CONFIG_REGULATOR_MAX77802 is not set
# CONFIG_REGULATOR_MC13783 is not set
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_MT6311=y
# CONFIG_REGULATOR_PCF50633 is not set
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_PV88060=y
# CONFIG_REGULATOR_PV88080 is not set
CONFIG_REGULATOR_PV88090=y
# CONFIG_REGULATOR_PWM is not set
CONFIG_REGULATOR_QCOM_SPMI=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_RK808=y
CONFIG_REGULATOR_SKY81452=y
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65086=y
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65218=y
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS80031=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
# CONFIG_DRM is not set

#
# ACP (Audio CoProcessor) Configuration
#

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
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
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
# CONFIG_FB_INTEL is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_MATROX_MAVEN=y
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_SM501=y
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_FB_SIMPLE is not set
CONFIG_FB_SSD1307=y
CONFIG_FB_SM712=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_CARILLO_RANCH is not set
# CONFIG_BACKLIGHT_PWM is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_PM8941_WLED=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=y
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_SKY81452=y
CONFIG_BACKLIGHT_AS3711=y
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_VGASTATE=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CMEDIA=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_GEMBIRD is not set
CONFIG_HID_GFRM=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
CONFIG_HID_WALTOP=y
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LED=y
CONFIG_HID_LENOVO=y
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_HID_LOGITECH_HIDPP is not set
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MAYFLASH=y
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PLANTRONICS=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
# CONFIG_HID_RMI is not set
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_UDRAW_PS3=y
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y
# CONFIG_HID_SENSOR_CUSTOM_SENSOR is not set
CONFIG_HID_ALPS=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
CONFIG_UWB=y
# CONFIG_UWB_WHCI is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
CONFIG_PWRSEQ_EMMC=y
CONFIG_PWRSEQ_SIMPLE=y
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SDRICOH_CS=y
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=y
# CONFIG_MMC_USDHI6ROL0 is not set
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MMC_TOSHIBA_PCI=y
# CONFIG_MMC_MTK is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_MEMSTICK_R592=y
# CONFIG_MEMSTICK_REALTEK_PCI is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_CLASS_FLASH=y

#
# LED drivers
#
CONFIG_LEDS_AAT1290=y
CONFIG_LEDS_BCM6328=y
# CONFIG_LEDS_BCM6358 is not set
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP3952=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_LP8860=y
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_PWM=y
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_MC13783 is not set
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_TLC591XX=y
CONFIG_LEDS_MAX77693=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_MENF21BMC=y
CONFIG_LEDS_KTD2692=y
CONFIG_LEDS_IS31FL319X=y
CONFIG_LEDS_IS31FL32XX=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y
CONFIG_LEDS_SYSCON=y
# CONFIG_LEDS_MLXCPLD is not set
# CONFIG_LEDS_USER is not set
CONFIG_LEDS_NIC78BX=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_LEDS_TRIGGER_PANIC=y
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ON_DEMAND_PAGING=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS=y
CONFIG_INFINIBAND_MTHCA=y
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_QIB=y
CONFIG_MLX4_INFINIBAND=y
# CONFIG_MLX5_INFINIBAND is not set
# CONFIG_INFINIBAND_NES is not set
# CONFIG_INFINIBAND_OCRDMA is not set
# CONFIG_INFINIBAND_VMWARE_PVRDMA is not set
CONFIG_INFINIBAND_IPOIB=y
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
CONFIG_INFINIBAND_RDMAVT=y
# CONFIG_RDMA_RXE is not set
# CONFIG_INFINIBAND_HFI1 is not set
CONFIG_INFINIBAND_QEDR=y
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_SYSTOHC_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_ABB5ZES3=y
CONFIG_RTC_DRV_ABX80X=y
# CONFIG_RTC_DRV_AS3722 is not set
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_HYM8563 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8907=y
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_MAX8997=y
CONFIG_RTC_DRV_MAX77686=y
CONFIG_RTC_DRV_RK808=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF85063=y
CONFIG_RTC_DRV_PCF8563=y
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TPS6586X=y
CONFIG_RTC_DRV_TPS80031=y
CONFIG_RTC_DRV_RC5T583=y
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV8803=y

#
# SPI RTC drivers
#
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_PCF2127=y
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_DA9063 is not set
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_PCF50633 is not set
CONFIG_RTC_DRV_AB3100=y
CONFIG_RTC_DRV_ZYNQMP=y

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set
CONFIG_RTC_DRV_SNVS=y
CONFIG_RTC_DRV_R7301=y

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_SW_SYNC is not set
CONFIG_AUXDISPLAY=y
# CONFIG_IMG_ASCII_LCD is not set
# CONFIG_HT16K33 is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
CONFIG_UIO_MF624=y
# CONFIG_VFIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_INPUT is not set
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
CONFIG_AD7606=y
# CONFIG_AD7606_IFACE_PARALLEL is not set

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
CONFIG_ADT7316_I2C=y

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
CONFIG_AD7152=y
CONFIG_AD7746=y

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Light sensors
#
# CONFIG_SENSORS_ISL29028 is not set
# CONFIG_TSL2x7x is not set

#
# Active energy metering IC
#
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_FB_SM750=y
CONFIG_FB_XGI=y

#
# Speakup console speech
#
CONFIG_STAGING_MEDIA=y

#
# Android
#
# CONFIG_ASHMEM is not set
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
# CONFIG_ION is not set
# CONFIG_STAGING_BOARD is not set
# CONFIG_FIREWIRE_SERIAL is not set
# CONFIG_DGNC is not set
CONFIG_GS_FPGABOOT=y
CONFIG_CRYPTO_SKEIN=y
CONFIG_UNISYSSPAR=y
CONFIG_UNISYS_VISORBUS=y
CONFIG_UNISYS_VISORNIC=y
CONFIG_UNISYS_VISORINPUT=y
CONFIG_COMMON_CLK_XLNX_CLKWZRD=y
CONFIG_WILC1000=y
CONFIG_WILC1000_SDIO=y
CONFIG_WILC1000_HW_OOB_INTR=y
CONFIG_MOST=y
CONFIG_MOSTCORE=y
# CONFIG_AIM_CDEV is not set
CONFIG_AIM_NETWORK=y
CONFIG_HDM_DIM2=y
CONFIG_HDM_I2C=y
# CONFIG_KS7010 is not set
CONFIG_GREYBUS=y
CONFIG_GREYBUS_AUDIO=y
CONFIG_GREYBUS_BOOTROM=y
CONFIG_GREYBUS_HID=y
CONFIG_GREYBUS_LIGHT=y
# CONFIG_GREYBUS_LOG is not set
# CONFIG_GREYBUS_LOOPBACK is not set
# CONFIG_GREYBUS_POWER is not set
CONFIG_GREYBUS_RAW=y
CONFIG_GREYBUS_VIBRATOR=y
CONFIG_GREYBUS_BRIDGED_PHY=y
CONFIG_GREYBUS_GPIO=y
CONFIG_GREYBUS_I2C=y
CONFIG_GREYBUS_PWM=y
CONFIG_GREYBUS_SDIO=y
# CONFIG_GREYBUS_UART is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_MAX77686=y
CONFIG_COMMON_CLK_RK808=y
CONFIG_COMMON_CLK_SI5351=y
# CONFIG_COMMON_CLK_SI514 is not set
# CONFIG_COMMON_CLK_SI570 is not set
CONFIG_COMMON_CLK_CDCE706=y
CONFIG_COMMON_CLK_CDCE925=y
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_NXP is not set
CONFIG_COMMON_CLK_PWM=y
# CONFIG_COMMON_CLK_PXA is not set
# CONFIG_COMMON_CLK_PIC32 is not set
# CONFIG_COMMON_CLK_MT2701 is not set
# CONFIG_COMMON_CLK_MT2701_MMSYS is not set
# CONFIG_COMMON_CLK_MT2701_IMGSYS is not set
# CONFIG_COMMON_CLK_MT2701_VDECSYS is not set
# CONFIG_COMMON_CLK_MT2701_HIFSYS is not set
# CONFIG_COMMON_CLK_MT2701_ETHSYS is not set
# CONFIG_COMMON_CLK_MT2701_BDPSYS is not set

#
# Hardware Spinlock drivers
#

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
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
CONFIG_IOMMU_IOVA=y
CONFIG_OF_IOMMU=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_V2=y
CONFIG_DMAR_TABLE=y
# CONFIG_INTEL_IOMMU is not set
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y

#
# Rpmsg drivers
#

#
# SOC (System On Chip) specific Drivers
#

#
# Broadcom SoC drivers
#
# CONFIG_SUNXI_SRAM is not set
CONFIG_SOC_TI=y
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_CONFIGFS=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
# CONFIG_IIO_SW_DEVICE is not set
CONFIG_IIO_SW_TRIGGER=y

#
# Accelerometers
#
CONFIG_BMA180=y
# CONFIG_BMC150_ACCEL is not set
CONFIG_DA280=y
CONFIG_DA311=y
CONFIG_DMARD06=y
# CONFIG_DMARD09 is not set
CONFIG_DMARD10=y
CONFIG_HID_SENSOR_ACCEL_3D=y
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
CONFIG_KXSD9=y
CONFIG_KXSD9_I2C=y
# CONFIG_KXCJK1013 is not set
# CONFIG_MC3230 is not set
CONFIG_MMA7455=y
CONFIG_MMA7455_I2C=y
CONFIG_MMA7660=y
CONFIG_MMA8452=y
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
# CONFIG_AD7291 is not set
CONFIG_AD799X=y
CONFIG_AXP288_ADC=y
# CONFIG_CC10001_ADC is not set
# CONFIG_DA9150_GPADC is not set
# CONFIG_ENVELOPE_DETECTOR is not set
# CONFIG_LTC2485 is not set
CONFIG_MAX1363=y
# CONFIG_MCP3422 is not set
# CONFIG_MEN_Z188_ADC is not set
CONFIG_NAU7802=y
# CONFIG_QCOM_SPMI_IADC is not set
# CONFIG_QCOM_SPMI_VADC is not set
CONFIG_STX104=y
CONFIG_TI_ADC081C=y
# CONFIG_TI_ADS1015 is not set
CONFIG_VF610_ADC=y

#
# Amplifiers
#

#
# Chemical Sensors
#
CONFIG_ATLAS_PH_SENSOR=y
# CONFIG_IAQCORE is not set
# CONFIG_VZ89X is not set

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_IIO_MS_SENSORS_I2C=y

#
# SSP Sensor Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Counters
#
CONFIG_104_QUAD_8=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5380=y
CONFIG_AD5446=y
CONFIG_AD5592R_BASE=y
CONFIG_AD5593R=y
# CONFIG_CIO_DAC is not set
CONFIG_DPOT_DAC=y
# CONFIG_M62332 is not set
# CONFIG_MAX517 is not set
CONFIG_MAX5821=y
CONFIG_MCP4725=y
# CONFIG_VF610_DAC is not set

#
# IIO dummy driver
#

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
# CONFIG_BMG160 is not set
CONFIG_HID_SENSOR_GYRO_3D=y
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

#
# Humidity sensors
#
CONFIG_AM2315=y
# CONFIG_DHT11 is not set
# CONFIG_HDC100X is not set
CONFIG_HTS221=y
CONFIG_HTS221_I2C=y
CONFIG_HTU21=y
CONFIG_SI7005=y
# CONFIG_SI7020 is not set

#
# Inertial measurement units
#
# CONFIG_BMI160_I2C is not set
CONFIG_KMX61=y
CONFIG_INV_MPU6050_IIO=y
CONFIG_INV_MPU6050_I2C=y

#
# Light sensors
#
CONFIG_ACPI_ALS=y
CONFIG_ADJD_S311=y
CONFIG_AL3320A=y
CONFIG_APDS9300=y
# CONFIG_APDS9960 is not set
CONFIG_BH1750=y
CONFIG_BH1780=y
CONFIG_CM32181=y
CONFIG_CM3232=y
# CONFIG_CM3323 is not set
CONFIG_CM36651=y
CONFIG_GP2AP020A00F=y
# CONFIG_SENSORS_ISL29018 is not set
CONFIG_ISL29125=y
# CONFIG_HID_SENSOR_ALS is not set
CONFIG_HID_SENSOR_PROX=y
CONFIG_JSA1212=y
CONFIG_RPR0521=y
CONFIG_SENSORS_LM3533=y
CONFIG_LTR501=y
CONFIG_MAX44000=y
CONFIG_OPT3001=y
CONFIG_PA12203001=y
CONFIG_SI1145=y
CONFIG_STK3310=y
# CONFIG_TCS3414 is not set
CONFIG_TCS3472=y
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL2583 is not set
CONFIG_TSL4531=y
CONFIG_US5182D=y
CONFIG_VCNL4000=y
# CONFIG_VEML6070 is not set

#
# Magnetometer sensors
#
# CONFIG_AK8974 is not set
CONFIG_AK8975=y
CONFIG_AK09911=y
CONFIG_BMC150_MAGN=y
CONFIG_BMC150_MAGN_I2C=y
# CONFIG_MAG3110 is not set
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
CONFIG_MMC35240=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_SENSORS_HMC5843=y
CONFIG_SENSORS_HMC5843_I2C=y

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=y
# CONFIG_HID_SENSOR_DEVICE_ROTATION is not set

#
# Triggers - standalone
#
# CONFIG_IIO_HRTIMER_TRIGGER is not set
CONFIG_IIO_INTERRUPT_TRIGGER=y
# CONFIG_IIO_TIGHTLOOP_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Digital potentiometers
#
CONFIG_DS1803=y
CONFIG_MCP4531=y
CONFIG_TPL0102=y

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
CONFIG_HID_SENSOR_PRESS=y
# CONFIG_HP03 is not set
CONFIG_MPL115=y
CONFIG_MPL115_I2C=y
CONFIG_MPL3115=y
# CONFIG_MS5611 is not set
CONFIG_MS5637=y
# CONFIG_IIO_ST_PRESS is not set
# CONFIG_T5403 is not set
# CONFIG_HP206C is not set
# CONFIG_ZPA2326 is not set

#
# Lightning sensors
#

#
# Proximity sensors
#
# CONFIG_LIDAR_LITE_V2 is not set
# CONFIG_SX9500 is not set

#
# Temperature sensors
#
CONFIG_MLX90614=y
CONFIG_TMP006=y
CONFIG_TSYS01=y
# CONFIG_TSYS02D is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_ATMEL_HLCDC_PWM=y
# CONFIG_PWM_FSL_FTM is not set
CONFIG_PWM_LPSS=y
CONFIG_PWM_LPSS_PCI=y
CONFIG_PWM_LPSS_PLATFORM=y
CONFIG_PWM_PCA9685=y
CONFIG_IRQCHIP=y
CONFIG_ARM_GIC_MAX_NR=1
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_RESET_ATH79 is not set
# CONFIG_RESET_BERLIN is not set
# CONFIG_RESET_LPC18XX is not set
# CONFIG_RESET_MESON is not set
# CONFIG_RESET_PISTACHIO is not set
# CONFIG_RESET_SOCFPGA is not set
# CONFIG_RESET_STM32 is not set
# CONFIG_RESET_SUNXI is not set
# CONFIG_TI_SYSCON_RESET is not set
# CONFIG_RESET_ZYNQ is not set
# CONFIG_RESET_TEGRA_BPMP is not set
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_PXA_28NM_HSIC=y
CONFIG_PHY_PXA_28NM_USB2=y
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set
CONFIG_MCB_LPC=y

#
# Performance monitor support
#
# CONFIG_RAS is not set
CONFIG_THUNDERBOLT=y

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
CONFIG_NVMEM=y
# CONFIG_STM is not set
# CONFIG_INTEL_TH is not set

#
# FPGA Configuration Support
#
CONFIG_FPGA=y
# CONFIG_FPGA_BRIDGE is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_FW_CFG_SYSFS is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
CONFIG_GOOGLE_MEMCONSOLE=y

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
# CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE is not set
# CONFIG_EFI_RUNTIME_MAP is not set
CONFIG_EFI_FAKE_MEMMAP=y
CONFIG_EFI_MAX_FAKE_MEM=8
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_EFI_BOOTLOADER_CONTROL=y
CONFIG_EFI_CAPSULE_LOADER=y
# CONFIG_EFI_TEST is not set
CONFIG_APPLE_PROPERTIES=y
CONFIG_UEFI_CPER=y
CONFIG_EFI_DEV_PATH_PARSER=y

#
# Tegra firmware driver
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_EXPORTFS_BLOCK_OPS is not set
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
# CONFIG_OVERLAY_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ORANGEFS_FS=y
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_ZLIB_COMPRESS is not set
# CONFIG_PSTORE_LZO_COMPRESS is not set
CONFIG_PSTORE_LZ4_COMPRESS=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
CONFIG_PSTORE_FTRACE=y
CONFIG_PSTORE_RAM=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
# CONFIG_NFS_V4_1 is not set
# CONFIG_ROOT_NFS is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFSD is not set
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_SUNRPC_DEBUG is not set
CONFIG_SUNRPC_XPRT_RDMA=y
CONFIG_CEPH_FS=y
CONFIG_CEPH_FS_POSIX_ACL=y
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
# CONFIG_CIFS_POSIX is not set
# CONFIG_CIFS_ACL is not set
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SMB2 is not set
CONFIG_NCP_FS=y
# CONFIG_NCPFS_PACKET_SIGNING is not set
CONFIG_NCPFS_IOCTL_LOCKING=y
# CONFIG_NCPFS_STRONG is not set
# CONFIG_NCPFS_NFS_NS is not set
CONFIG_NCPFS_OS2_NS=y
# CONFIG_NCPFS_SMALLDOS is not set
# CONFIG_NCPFS_NLS is not set
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_CODA_FS=y
CONFIG_AFS_FS=y
CONFIG_AFS_DEBUG=y
CONFIG_9P_FS=y
# CONFIG_9P_FS_POSIX_ACL is not set
CONFIG_9P_FS_SECURITY=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

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
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_PAGE_OWNER=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
# CONFIG_SECTION_MISMATCH_WARN_ONLY is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_STACK_VALIDATION is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_PAGE_POISONING=y
CONFIG_PAGE_POISONING_NO_SANITY=y
CONFIG_PAGE_POISONING_ZERO=y
CONFIG_DEBUG_PAGE_REF=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_VMACACHE=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VM_PGFLAGS is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_KASAN=y
# CONFIG_KASAN_OUTLINE is not set
CONFIG_KASAN_INLINE=y
CONFIG_ARCH_HAS_KCOV=y
CONFIG_KCOV=y
CONFIG_KCOV_INSTRUMENT_ALL=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_WQ_WATCHDOG=y
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# CONFIG_SCHED_STACK_END_CHECK is not set
# CONFIG_DEBUG_TIMEKEEPING is not set
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_PERF_TEST is not set
CONFIG_RCU_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST_SLOW_PREINIT is not set
# CONFIG_RCU_TORTURE_TEST_SLOW_INIT is not set
# CONFIG_RCU_TORTURE_TEST_SLOW_CLEANUP is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_EQS_DEBUG=y
# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_OF_RECONFIG_NOTIFIER_ERROR_INJECT=y
CONFIG_NETDEV_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_FUTEX is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
CONFIG_TRACING_MAP=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACEPOINT_BENCHMARK is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_TRACE_ENUM_MAP_FILE is not set
CONFIG_TRACING_EVENTS_GPIO=y

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_HEXDUMP=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
CONFIG_TEST_PRINTF=y
CONFIG_TEST_BITMAP=y
CONFIG_TEST_UUID=y
CONFIG_TEST_RHASHTABLE=y
CONFIG_TEST_HASH=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_FIRMWARE=y
CONFIG_TEST_UDELAY=y
CONFIG_MEMTEST=y
CONFIG_BUG_ON_DATA_CORRUPTION=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_ARCH_WANTS_UBSAN_NO_NULL is not set
CONFIG_UBSAN=y
# CONFIG_UBSAN_SANITIZE_ALL is not set
# CONFIG_UBSAN_ALIGNMENT is not set
CONFIG_UBSAN_NULL=y
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP_CORE=y
# CONFIG_X86_PTDUMP is not set
CONFIG_EFI_PGT_DUMP=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_WX is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_DEBUG=y
CONFIG_IOMMU_STRESS=y
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
# CONFIG_BIG_KEYS is not set
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEY_DH_OPERATIONS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HAVE_ARCH_HARDENED_USERCOPY=y
# CONFIG_HARDENED_USERCOPY is not set
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
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=y
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_KEYWRAP=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=y
# CONFIG_CRYPTO_POLY1305_X86_64 is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA1_MB=y
# CONFIG_CRYPTO_SHA256_MB is not set
CONFIG_CRYPTO_SHA512_MB=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
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
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_CHACHA20=y
# CONFIG_CRYPTO_CHACHA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
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
# CONFIG_CRYPTO_DRBG_CTR is not set
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_USER_API_RNG is not set
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_CRYPTO_DEV_QAT=y
CONFIG_CRYPTO_DEV_QAT_DH895xCC=y
CONFIG_CRYPTO_DEV_QAT_C3XXX=y
CONFIG_CRYPTO_DEV_QAT_C62X=y
# CONFIG_CRYPTO_DEV_QAT_DH895xCCVF is not set
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=y
CONFIG_CRYPTO_DEV_QAT_C62XVF=y
CONFIG_CRYPTO_DEV_VIRTIO=y
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS7_MESSAGE_PARSER=y

#
# Certificates for signature checking
#
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
CONFIG_SECONDARY_TRUSTED_KEYRING=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set
CONFIG_BINARY_PRINTF=y

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
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
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
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_GLOB=y
CONFIG_GLOB_SELFTEST=y
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_LIBFDT=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
# CONFIG_SG_SPLIT is not set
# CONFIG_SG_POOL is not set
CONFIG_ARCH_HAS_SG_CHAIN=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_ARCH_HAS_MMIO_FLUSH=y
CONFIG_STACKDEPOT=y

--g5zwo56l4e3vkrzx--
