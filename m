Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 10 Sep 2016 10:51:55 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20160910095154.GA21444@e104818-lin.cambridge.arm.com>
References: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] Re: [PATCH v2 0/7] arm64: Privileged Access Never using TTBR0_EL1
 switching
To: linux-arm-kernel@lists.infradead.org
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Julien Grall <julien.grall@arm.com>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Sep 02, 2016 at 04:02:06PM +0100, Catalin Marinas wrote:
> This is the second version of the arm64 PAN emulation by disabling
> TTBR0_EL1 accesses. The major change from v1 is the use of a thread_info
> member to store the real TTBR0_EL1 value. The advantage is slightly
> simpler assembler macros for uaccess_enable with the downside that
> switch_mm() must always update the saved ttbr0 even if there is no mm
> switch.

FYI, I got the Juno board rebooting in a loop with defconfig +
ARM64_TTBR0_PAN enabled. It takes about 20-40 reboots to get the panic
below on the EFI run-time services. I'll look into it on Monday (and
cc'ing Ard who I forgot to add originally). Including the full log
below:

EFI stub: Booting Linux Kernel...
EFI stub: Using DTB from configuration table
EFI stub: Exiting boot services and installing virtual address map...
[    0.000000] Booting Linux on physical CPU 0x100
[    0.000000] Linux version 4.8.0-rc4-00007-g07a1ca6cb00d (cmarinas@e104818-lin) (gcc version 5.3.1 20160309 (fsf-5.264) ) #1 SMP PREEMPT Fri Sep 9 18:38:47 BST 2016
[    0.000000] Boot CPU: AArch64 Processor [410fd030]
[    0.000000] earlycon: pl11 at MMIO 0x000000007ff80000 (options '')
[    0.000000] bootconsole [pl11] enabled
[    0.000000] efi: Getting EFI parameters from FDT:
[    0.000000] efi: EFI v2.40 by ARM Juno EFI Oct  7 2014 15:05:42
[    0.000000] efi:  ACPI=0xfebdc000  ACPI 2.0=0xfebdc014 
[    0.000000] cma: Reserved 16 MiB at 0x00000000fd800000
[    0.000000] psci: probing for conduit method from DT.
[    0.000000] psci: PSCIv0.2 detected in firmware.
[    0.000000] psci: Using standard PSCI v0.2 function IDs
[    0.000000] psci: Trusted OS migration not required
[    0.000000] percpu: Embedded 21 pages/cpu @ffff80097fea6000 s47488 r8192 d30336 u86016
[    0.000000] Detected VIPT I-cache on CPU0
[    0.000000] CPU features: enabling workaround for ARM errata 826319, 827319, 824069
[    0.000000] CPU features: enabling workaround for ARM erratum 845719
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2060048
[    0.000000] Kernel command line: console=ttyAMA0,115200 earlycon=pl011,0x7ff80000 ip=dhcp root=/dev/nfs rw nfsroot=10.1.206.48:/srv/nfs/debian-arm64,tcp
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 20480 bytes
[    0.000000] log_buf_len min size: 16384 bytes
[    0.000000] log_buf_len: 65536 bytes
[    0.000000] early log buf free: 14320(87%)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] software IO TLB [mem 0xf9800000-0xfd800000] (64MB) mapped at [ffff800079800000-ffff80007d7fffff]
[    0.000000] Memory: 8129516K/8371264K available (8636K kernel code, 796K rwdata, 3532K rodata, 960K init, 275K bss, 225364K reserved, 16384K cma-reserved)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     modules : 0xffff000000000000 - 0xffff000008000000   (   128 MB)
[    0.000000]     vmalloc : 0xffff000008000000 - 0xffff7dffbfff0000   (129022 GB)
[    0.000000]       .text : 0xffff000008080000 - 0xffff0000088f0000   (  8640 KB)
[    0.000000]     .rodata : 0xffff0000088f0000 - 0xffff000008c70000   (  3584 KB)
[    0.000000]       .init : 0xffff000008c70000 - 0xffff000008d60000   (   960 KB)
[    0.000000]       .data : 0xffff000008d60000 - 0xffff000008e27200   (   797 KB)
[    0.000000]        .bss : 0xffff000008e27200 - 0xffff000008e6c138   (   276 KB)
[    0.000000]     fixed   : 0xffff7dfffe7fd000 - 0xffff7dfffec00000   (  4108 KB)
[    0.000000]     PCI I/O : 0xffff7dfffee00000 - 0xffff7dffffe00000   (    16 MB)
[    0.000000]     vmemmap : 0xffff7e0000000000 - 0xffff800000000000   (  2048 GB maximum)
[    0.000000]               0xffff7e0000000000 - 0xffff7e0026000000   (   608 MB actual)
[    0.000000]     memory  : 0xffff800000000000 - 0xffff800980000000   ( 38912 MB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=6.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=6
[    0.000000] NR_IRQS:64 nr_irqs:64 0
[    0.000000] GIC: Using split EOI/Deactivate mode
[    0.000000] GICv2m: range[mem 0x2c1c0000-0x2c1c0fff], SPI[224:255]
[    0.000000] arm_arch_timer: Architected cp15 timer(s) running at 50.00MHz (phys).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0xb8812736b, max_idle_ns: 440795202655 ns
[    0.000005] sched_clock: 56 bits at 50MHz, resolution 20ns, wraps every 4398046511100ns
[    0.008439] clocksource: arm,sp804: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275 ns
[    0.018257] Failed to initialize '/smb/motherboard/iofpga@3,00000000/timer@120000': -22
[    0.026339] Console: colour dummy device 80x25
[    0.031047] Calibrating delay loop (skipped), value calculated using timer frequency.. 100.00 BogoMIPS (lpj=200000)
[    0.041642] pid_max: default: 32768 minimum: 301
[    0.046406] Security Framework initialized
[    0.050607] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.057587] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.066233] ASID allocator initialised with 65536 entries
[    0.096367] Remapping and enabling EFI services.
[    0.101091]   EFI remap 0x0000000008000000 => 0000000020000000
[    0.107016]   EFI remap 0x000000001c170000 => 0000000024000000
[    0.112941]   EFI remap 0x00000009faf6f000 => 000000002401f000
[    0.118865]   EFI remap 0x00000009fff6e000 => 000000002406e000
[    0.124789]   EFI remap 0x00000009fffaf000 => 00000000240af000
[    0.155087] Detected PIPT I-cache on CPU1
[    0.155092] CPU features: enabling workaround for ARM erratum 832075
[    0.155094] CPU features: enabling workaround for ARM erratum 834220
[    0.155129] CPU1: Booted secondary processor [410fd070]
[    0.171085] Detected PIPT I-cache on CPU2
[    0.171110] CPU2: Booted secondary processor [410fd070]
[    0.187086] Detected VIPT I-cache on CPU3
[    0.187127] CPU3: Booted secondary processor [410fd030]
[    0.203127] Detected VIPT I-cache on CPU4
[    0.203157] CPU4: Booted secondary processor [410fd030]
[    0.219170] Detected VIPT I-cache on CPU5
[    0.219200] CPU5: Booted secondary processor [410fd030]
[    0.219264] Brought up 6 CPUs
[    0.281960] SMP: Total of 6 processors activated.
[    0.286735] CPU features: detected feature: 32-bit EL0 Support
[    0.292670] CPU: All CPU(s) started at EL2
[    0.296856] alternatives: patching kernel code
[    0.307334] devtmpfs: initialized
[    0.314498] DMI not present or invalid.
[    0.318621] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.329272] pinctrl core: initialized pinctrl subsystem
[    0.335640] NET: Registered protocol family 16
[    0.364205] cpuidle: using governor menu
[    0.368387] vdso: 2 pages (1 code @ ffff0000088f6000, 1 data @ ffff000008d64000)
[    0.375906] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
[    0.383492] DMA: preallocated 256 KiB pool for atomic allocations
[    0.389926] Serial: AMBA PL011 UART driver
[    0.396607] 7ff80000.uart: ttyAMA0 at MMIO 0x7ff80000 (irq = 24, base_baud = 0) is a PL011 rev3
[    0.405455] console [ttyAMA0] enabled
[    0.405455] console [ttyAMA0] enabled
[    0.412747] bootconsole [pl11] disabled
[    0.412747] bootconsole [pl11] disabled
[    0.448879] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.456038] ACPI: Interpreter disabled.
[    0.460736] vgaarb: loaded
[    0.463676] SCSI subsystem initialized
[    0.467861] usbcore: registered new interface driver usbfs
[    0.473364] usbcore: registered new interface driver hub
[    0.478725] usbcore: registered new device driver usb
[    0.484678] pps_core: LinuxPPS API ver. 1 registered
[    0.489606] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.498694] PTP clock support registered
[    0.502752] dmi: Firmware registration failed.
[    0.507965] Advanced Linux Sound Architecture Driver Initialized.
[    0.514808] clocksource: Switched to clocksource arch_sys_counter
[    0.520983] VFS: Disk quotas dquot_6.6.0
[    0.524930] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.531982] pnp: PnP ACPI: disabled
[    0.543951] NET: Registered protocol family 2
[    0.548779] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.556814] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.565070] TCP: Hash tables configured (established 65536 bind 65536)
[    0.571619] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.577902] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.584771] NET: Registered protocol family 1
[    0.589467] RPC: Registered named UNIX socket transport module.
[    0.595355] RPC: Registered udp transport module.
[    0.600021] RPC: Registered tcp transport module.
[    0.604685] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.611740] hw perfevents: enabled with armv8_cortex_a57 PMU driver, 7 counters available
[    0.619970] hw perfevents: enabled with armv8_cortex_a53 PMU driver, 7 counters available
[    0.628262] kvm [1]: IDMAP page: 808d8000
[    0.632250] kvm [1]: HYP VA range: 800000000000:ffffffffffff
[    0.638698] kvm [1]: 8-bit VMID
[    0.641816] kvm [1]: Hyp mode initialized successfully
[    0.646947] kvm [1]: vgic-v2@2c04f000
[    0.650721] kvm [1]: vgic interrupt IRQ1
[    0.654720] kvm [1]: virtual timer IRQ4
[    0.661194] futex hash table entries: 2048 (order: 6, 262144 bytes)
[    0.667506] audit: initializing netlink subsys (disabled)
[    0.672915] audit: type=2000 audit(0.536:1): initialized
[    0.678965] workingset: timestamp_bits=46 max_order=21 bucket_order=0
[    0.696868] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.703578] NFS: Registering the id_resolver key type
[    0.708612] Key type id_resolver registered
[    0.712766] Key type id_legacy registered
[    0.716752] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    0.723546] SGI XFS with security attributes, no debug enabled
[    0.730934] 9p: Installing v9fs 9p2000 file system support
[    0.738565] io scheduler noop registered
[    0.742480] io scheduler cfq registered (default)
[    0.747923] libphy: mdio_driver_register: phy-bcm-ns2-pci
[    0.754326] pl061_gpio 1c1d0000.gpio: PL061 GPIO chip @0x000000001c1d0000 registered
[    0.763984] dma-pl330 7ff00000.dma: Loaded driver for PL330 DMAC-341330
[    0.770560] dma-pl330 7ff00000.dma: 	DBUFF-1024x16bytes Num_Chans-8 Num_Peri-8 Num_Events-8
[    0.779809] xenfs: not registering filesystem on non-xen platform
[    0.788999] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.796505] SuperH (H)SCI(F) driver initialized
[    0.801247] msm_serial: driver initialized
[    0.811254] loop: module loaded
[    0.815840] libphy: Fixed MDIO Bus: probed
[    0.820328] tun: Universal TUN/TAP device driver, 1.6
[    0.825338] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.831905] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[    0.837692] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    0.843605] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.3.0-k
[    0.850507] igb: Copyright (c) 2007-2014 Intel Corporation.
[    0.856072] igbvf: Intel(R) Gigabit Virtual Function Network Driver - version 2.0.2-k
[    0.863833] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    0.869799] sky2: driver version 1.30
[    0.895685] libphy: smsc911x-mdio: probed
[    0.970934] Generic PHY 18000000.etherne:01: attached PHY driver [Generic PHY] (mii_bus:phy_addr=18000000.etherne:01, irq=-1)
[    0.982316] smsc911x 18000000.ethernet eth0: MAC Address: 00:02:f7:00:58:bb
[    0.989404] VFIO - User Level meta-driver version: 0.3
[    0.995517] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.001993] ehci-pci: EHCI PCI platform driver
[    1.006432] ehci-platform: EHCI generic platform driver
[    1.011718] ehci-platform 7ffc0000.ehci: EHCI Host Controller
[    1.017428] ehci-platform 7ffc0000.ehci: new USB bus registered, assigned bus number 1
[    1.025419] ehci-platform 7ffc0000.ehci: irq 27, io mem 0x7ffc0000
[    1.046826] ehci-platform 7ffc0000.ehci: USB 2.0 started, EHCI 1.00
[    1.053541] hub 1-0:1.0: USB hub found
[    1.057279] hub 1-0:1.0: 1 port detected
[    1.061448] ehci-exynos: EHCI EXYNOS driver
[    1.065666] ehci-msm: Qualcomm On-Chip EHCI Host Controller
[    1.071254] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.077401] ohci-pci: OHCI PCI platform driver
[    1.081845] ohci-platform: OHCI generic platform driver
[    1.087113] ohci-platform 7ffb0000.ohci: Generic Platform OHCI controller
[    1.093855] ohci-platform 7ffb0000.ohci: new USB bus registered, assigned bus number 2
[    1.101791] ohci-platform 7ffb0000.ohci: irq 26, io mem 0x7ffb0000
[    1.187263] hub 2-0:1.0: USB hub found
[    1.191003] hub 2-0:1.0: 1 port detected
[    1.195133] ohci-exynos: OHCI EXYNOS driver
[    1.199619] usbcore: registered new interface driver usb-storage
[    1.206575] mousedev: PS/2 mouse device common for all mice
[    1.212778] rtc-efi rtc-efi: rtc core: registered rtc-efi as rtc0
[    1.219087] rtc-pl031 1c170000.rtc: rtc core: registered pl031 as rtc1
[    1.225912] i2c /dev entries driver
[    1.231598] mmci-pl18x 1c050000.mmci: mmc0: PL180 manf 41 rev0 at 0x1c050000 irq 32,0 (pio)
[    1.239880] mmci-pl18x 1c050000.mmci: DMA channels RX none, TX none
[    1.283106] sdhci: Secure Digital Host Controller Interface driver
[    1.289269] sdhci: Copyright(c) Pierre Ossman
[    1.293646] Synopsys Designware Multimedia Card Interface Driver
[    1.300985] sdhci-pltfm: SDHCI platform and OF driver helper
[    1.309245] leds-syscon 1c010000.apbregs:led@08.0: registered LED vexpress:0
[    1.316358] leds-syscon 1c010000.apbregs:led@08.1: registered LED vexpress:1
[    1.323550] leds-syscon 1c010000.apbregs:led@08.2: registered LED vexpress:2
[    1.330953] leds-syscon 1c010000.apbregs:led@08.3: registered LED vexpress:3
[    1.338043] leds-syscon 1c010000.apbregs:led@08.4: registered LED vexpress:4
[    1.345139] leds-syscon 1c010000.apbregs:led@08.5: registered LED vexpress:5
[    1.352224] leds-syscon 1c010000.apbregs:led@08.6: registered LED vexpress:6
[    1.359553] leds-syscon 1c010000.apbregs:led@08.7: registered LED vexpress:7
[    1.368522] ledtrig-cpu: registered to indicate activity on CPUs
[    1.375694] usbcore: registered new interface driver usbhid
[    1.381223] usbhid: USB HID core driver
[    1.385921] mhu 2b1f0000.mhu: ARM MHU Mailbox registered
[    1.392777] NET: Registered protocol family 17
[    1.394826] usb 1-1: new high-speed USB device number 2 using ehci-platform
[    1.404224] 9pnet: Installing 9P2000 support
[    1.408545] Key type dns_resolver registered
[    1.413706] registered taskstats version 1
[    1.455390] scpi_protocol scpi: incorrect or no SCP firmware found
[    1.461595] scpi_protocol: probe of scpi failed with error -110
[    1.468487] input: smb:motherboard:gpio_keys as /devices/platform/smb/smb:motherboard/smb:motherboard:gpio_keys/input/input1
[    1.480518] Unable to handle kernel paging request at virtual address 240ab2f8
[    1.487693] pgd = ffff000008e70000
[    1.491084] [240ab2f8] *pgd=00000009fff6d003, *pud=00000009fff6c003, *pmd=0000000000000000
[    1.499336] Internal error: Oops: 86000004 [#1] PREEMPT SMP
[    1.504849] Modules linked in:
[    1.507877] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.8.0-rc4-00007-g07a1ca6cb00d #1
[    1.515711] Hardware name: ARM Juno development board (r0) (DT)
[    1.521569] task: ffff8009768a8000 task.stack: ffff8009768b0000
[    1.527427] PC is at 0x240ab2f8
[    1.530531] LR is at 0x240aaac0
[    1.533637] pc : [<00000000240ab2f8>] lr : [<00000000240aaac0>] pstate: 60400145
[    1.540954] sp : ffff8009768b3c50
[    1.544230] x29: ffff8009768b3ca0 x28: 0000000000000000 
[    1.549492] x27: ffff000008d279c0 x26: ffff000008c70470 
[    1.554754] x25: ffff000008cbf230 x24: ffff000008c5fd70 
[    1.560016] x23: ffff000008e2c000 x22: ffff8009768b3cf0 
[    1.565278] x21: ffff8009768b3cf0 x20: ffff8009768b3d00 
[    1.570540] x19: 8000000000000003 x18: ffffffffffffffff 
[    1.575801] x17: 0000000000000000 x16: 0000000000000000 
[    1.581063] x15: ffff80097612f16b x14: 0000000000000000 
[    1.586323] x13: 0000000000000000 x12: 0000000000000038 
[    1.591584] x11: 0000000000000020 x10: 0101010101010101 
[    1.596846] x9 : 0000000000000000 x8 : ffffff7f7f7f7f7f 
[    1.602107] x7 : fefe7eff2f627371 x6 : 000000008080ffff 
[    1.607368] x5 : ffff8009768b3c98 x4 : 0000000000010001 
[    1.612629] x3 : 00000000ff000001 x2 : 00000000240aa3e4 
[    1.617890] x1 : ffff8009768b3c98 x0 : 0000000057d752e6 
[    1.623150] 
[    1.624622] Process swapper/0 (pid: 1, stack limit = 0xffff8009768b0028)
[    1.631253] Stack: (0xffff8009768b3c50 to 0xffff8009768b4000)
[    1.636941] 3c40:                                   ffff000008e5dcd8 ffff8009768b3d00
[    1.644694] 3c60: 0000000000000140 ffff8009768b3cf0 ffff000008e2c000 ffff000008c5fd70
[    1.652447] 3c80: ffff00000876236c ffff8009768b3d00 ffff8009768b3da8 ffff00000855d1b4
[    1.660201] 3ca0: ffff8009768b3cd0 ffff000008703de8 ffff8009768b3da8 ffff000008dd9ff0
[    1.667954] 3cc0: ffff8009768b3da8 0000000000000007 ffff8009768b3d10 ffff000008700964
[    1.675707] 3ce0: ffff8009768b3da8 ffff800976a752e8 ffff8009768b3d40 ffff0000087006a8
[    1.683461] 3d00: ffff000008bbe958 ffff000008ca081c ffff8009768b3d30 ffff0000087009c8
[    1.691214] 3d20: ffff800976a75000 ffff0000087006b8 ffff8009768b3d70 ffff000008ca0878
[    1.698974] 3d40: ffff000008bbe958 ffff800976a75000 0000000000000000 0000000000000000
[    1.706727] 3d60: ffff000008dd94b0 ffff0000083f4820 ffff8009768b3dd0 ffff000008083b40
[    1.714480] 3d80: ffff8009768b0000 ffff000008ca081c ffff8009768b3db0 0000000000000000
[    1.722232] 3da0: 000000001dcd6500 0000000000000000 0000000000000000 0000000000000000
[    1.729984] 3dc0: 0000000000000000 ffff000000000000 ffff8009768b3e40 ffff000008c70d14
[    1.737737] 3de0: 0000000000000110 ffff000008e2c000 ffff000008cbf2c0 0000000000000007
[    1.745490] 3e00: ffff000008d27900 0000000000000000 ffff000008e2c000 ffff000008b48ac8
[    1.753242] 3e20: 0000000700000007 0000000000000000 0000000000000000 ffff000008c5fd70
[    1.760995] 3e40: ffff8009768b3ea0 ffff0000088d15d0 ffff0000088d15c0 0000000000000000
[    1.768747] 3e60: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[    1.776499] 3e80: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[    1.784252] 3ea0: 0000000000000000 ffff0000080830a0 ffff0000088d15c0 0000000000000000
[    1.792004] 3ec0: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[    1.799756] 3ee0: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[    1.807508] 3f00: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[    1.815260] 3f20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[    1.823023] 3f40: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[    1.830775] 3f60: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[    1.838527] 3f80: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[    1.846279] 3fa0: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[    1.854031] 3fc0: 0000000000000000 0000000000000005 0000000000000000 0000000000000000
[    1.861783] 3fe0: 0000000000000000 0000000000000000 035b4d0700426040 000f000200440000
[    1.869531] Call trace:
[    1.871950] Exception stack(0xffff8009768b3a80 to 0xffff8009768b3bb0)
[    1.878327] 3a80: 8000000000000003 0001000000000000 0000000080e2b000 00000000240ab2f8
[    1.886080] 3aa0: ffff8009768b3b00 ffff00000818bb68 ffff800976015f80 00000000024000c0
[    1.893832] 3ac0: ffff00000818bbe4 000000000000001a ffff80097608dc10 ffff800976bd1218
[    1.901585] 3ae0: ffff8009768b3af0 ffff0000083f2670 ffff8009768b3b70 ffff0000083f2b40
[    1.909338] 3b00: 0000000000000000 ffff800976811b00 0000000000000000 ffff800976811a90
[    1.917091] 3b20: 0000000057d752e6 ffff8009768b3c98 00000000240aa3e4 00000000ff000001
[    1.924844] 3b40: 0000000000010001 ffff8009768b3c98 000000008080ffff fefe7eff2f627371
[    1.932596] 3b60: ffffff7f7f7f7f7f 0000000000000000 0101010101010101 0000000000000020
[    1.940349] 3b80: 0000000000000038 0000000000000000 0000000000000000 ffff80097612f16b
[    1.948098] 3ba0: 0000000000000000 0000000000000000
[    1.952925] [<00000000240ab2f8>] 0x240ab2f8
[    1.957069] [<ffff000008703de8>] efi_read_time+0x28/0x78
[    1.962329] [<ffff000008700964>] __rtc_read_time.isra.1+0x44/0x70
[    1.968360] [<ffff0000087009c8>] rtc_read_time+0x38/0x58
[    1.973620] [<ffff000008ca0878>] rtc_hctosys+0x5c/0xe4
[    1.978708] [<ffff000008083b40>] do_one_initcall+0x38/0x128
[    1.984227] [<ffff000008c70d14>] kernel_init_freeable+0x1ac/0x250
[    1.990261] [<ffff0000088d15d0>] kernel_init+0x10/0x100
[    1.995433] [<ffff0000080830a0>] ret_from_fork+0x10/0x30
[    2.000691] Code: bad PC value

-- 
Catalin
