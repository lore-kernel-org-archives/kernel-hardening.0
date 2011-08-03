Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 03 Aug 2011 10:05:22 +0200
From: Marc Zyngier <marc.zyngier@arm.com>
In-Reply-To: <20110802135512.b49c9de1.akpm@linux-foundation.org>
References: <20110801180151.GA26686@albatros> <20110801112021.25ec9041.akpm@linux-foundation.org> <20110801190341.GA6898@albatros> <CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com> <20110802124530.GA2543@albatros> <20110802135512.b49c9de1.akpm@linux-foundation.org>
Message-ID: <d844457bba74be419d2434c533fdb4e1@localhost>
Subject: [kernel-hardening] Re: [PATCH] shm: fix a race between =?UTF-8?Q?shm=5Fexit=28=29=20and=20sh?=
 =?UTF-8?Q?m=5Finit=28=29?=
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Manuel Lauss <manuel.lauss@googlemail.com>, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>, Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>


On Tue, 2 Aug 2011 13:55:12 -0700, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 2 Aug 2011 16:45:30 +0400
> Vasiliy Kulikov <segoon@openwall.com> wrote:
> 
>> On thread exit shm_exit() is called, it uses shm_ids(ns).rw_mutex.
>> It is initialized in shm_init(), but it is not called yet at the moment
>> of kernel threads exit.  Some kernel threads are created in
>> do_pre_smp_initcalls(), and shm_init() is called in do_initcalls().
>> 
>> Static initialization of shm_ids(init_ipc_ns).rw_mutex fixes the race.
>> 
>> It fixes a kernel oops:
>> 
>> Unable to handle kernel NULL pointer dereference at virtual address
>> 00000000
>> ...
>> [<c0320090>] (__down_write_nested+0x88/0xe0) from [<c015da08>]
>> (exit_shm+0x28/0x48)
>> [<c015da08>] (exit_shm+0x28/0x48) from [<c002e550>]
(do_exit+0x59c/0x750)
>> [<c002e550>] (do_exit+0x59c/0x750) from [<c003eaac>]
>> (____call_usermodehelper+0x13c/0x154)
>> [<c003eaac>] (____call_usermodehelper+0x13c/0x154) from [<c000f630>]
>> (kernel_thread_exit+0x0/0x8)
> 
> erm, wait.  There's no reason I can think of why a kernel thread needs
> to call shm_exit() at all?
> 
> Is that a regular kernel thread exiting, or is it a
> call_usermodehelper() worker thread?  It *looks* like
> ____call_usermodehelper()'s kernel_execve() failed, so
> ____call_usermodehelper() directly called do_exit().
>
> Something's still screwed up here - we shouldn't be trying to run
> usermode helper applications before shm_init() has been run - usermode
> helpers can use ipc!
> 
> Can someone who can reproduce this please work out if and why we're
> calling call_usermodehelper() under do_pre_smp_initcalls()?  Something
> like this...

[snip]

Got nothing. So I moved the reset of in_do_pre_smp_initcall to the
beginning of shm_init(), and here's what I found: (again sorry for the
bloody line wrapping):

[<c0014740>] (unwind_backtrace+0x0/0xf4) from [<c003ed58>]
(call_usermodehelper_exec+0x108/0x118)
[<c003ed58>] (call_usermodehelper_exec+0x108/0x118) from [<c017608c>]
(kobject_uevent_env+0x40c/0x450)
[<c017608c>] (kobject_uevent_env+0x40c/0x450) from [<c01754c8>]
(kset_register+0x3c/0x44)
[<c01754c8>] (kset_register+0x3c/0x44) from [<c01c2eb0>]
(bus_register+0xac/0x28c)
[<c01c2eb0>] (bus_register+0xac/0x28c) from [<c0422278>]
(platform_bus_init+0x20/0x40)
[<c0422278>] (platform_bus_init+0x20/0x40) from [<c04222f0>]
(driver_init+0x18/0x24)
[<c04222f0>] (driver_init+0x18/0x24) from [<c040e270>]
(kernel_init+0x84/0x13c)
[<c040e270>] (kernel_init+0x84/0x13c) from [<c000f630>]
(kernel_thread_exit+0x0/0x8)
[<c0014740>] (unwind_backtrace+0x0/0xf4) from [<c003ed58>]
(call_usermodehelper_exec+0x108/0x118)
[<c003ed58>] (call_usermodehelper_exec+0x108/0x118) from [<c017608c>]
(kobject_uevent_env+0x40c/0x450)
[<c017608c>] (kobject_uevent_env+0x40c/0x450) from [<c01754c8>]
(kset_register+0x3c/0x44)
[<c01754c8>] (kset_register+0x3c/0x44) from [<c01c1eec>]
(sysdev_class_register+0x60/0x8c)
[<c01c1eec>] (sysdev_class_register+0x60/0x8c) from [<c040e270>]
(kernel_init+0x84/0x13c)
[<c040e270>] (kernel_init+0x84/0x13c) from [<c000f630>]
(kernel_thread_exit+0x0/0x8)
NET: Registered protocol family 16
[<c0014740>] (unwind_backtrace+0x0/0xf4) from [<c003ed58>]
(call_usermodehelper_exec+0x108/0x118)
[<c003ed58>] (call_usermodehelper_exec+0x108/0x118) from [<c017608c>]
(kobject_uevent_env+0x40c/0x450)
[<c017608c>] (kobject_uevent_env+0x40c/0x450) from [<c01754c8>]
(kset_register+0x3c/0x44)
[<c01754c8>] (kset_register+0x3c/0x44) from [<c01c44fc>]
(__class_register+0xb8/0x200)
[<c01c44fc>] (__class_register+0xb8/0x200) from [<c01c4698>]
(__class_create+0x54/0x7c)
[<c01c4698>] (__class_create+0x54/0x7c) from [<c04178d8>]
(bdi_class_init+0x18/0x58)
[<c04178d8>] (bdi_class_init+0x18/0x58) from [<c0008650>]
(do_one_initcall+0x34/0x178)
[<c0008650>] (do_one_initcall+0x34/0x178) from [<c040e280>]
(kernel_init+0x94/0x13c)
[<c040e280>] (kernel_init+0x94/0x13c) from [<c000f630>]
(kernel_thread_exit+0x0/0x8)
[...]

A flurry of these. So pre-smp initcalls are not the "guilty" ones. It
chokes a bit further down the drain. ipc_init is called way after the
drivers are registered:

c0436b78 T __initcall_start
c0436b78 T __setup_end
c0436b7c t __initcall_spawn_ksoftirqdearly
c0436b80 t __initcall_init_workqueuesearly
c0436b84 t __initcall_cpu_stop_initearly
c0436b88 t __initcall_rcu_scheduler_really_startedearly
c0436b8c T __early_initcall_end
c0436b8c t __initcall_init_mmap_min_addr0
c0436b90 t __initcall_net_ns_init0
c0436b94 t __initcall_ptrace_break_init1
c0436b98 t __initcall_consistent_init1
c0436b9c t __initcall_v6_userpage_init1
c0436ba0 t __initcall_alloc_frozen_cpus1
c0436ba4 t __initcall_sysctl_init1
c0436ba8 t __initcall_ksysfs_init1
c0436bac t __initcall_init_jiffies_clocksource1
c0436bb0 t __initcall_pm_init1
c0436bb4 t __initcall_init_zero_pfn1
c0436bb8 t __initcall_fsnotify_init1
c0436bbc t __initcall_filelock_init1
c0436bc0 t __initcall_init_script_binfmt1
c0436bc4 t __initcall_init_elf_binfmt1
c0436bc8 t __initcall_debugfs_init1
c0436bcc t __initcall_random32_init1
c0436bd0 t __initcall_sock_init1
c0436bd4 t __initcall_netlink_proto_init1
c0436bd8 t __initcall_bdi_class_init2
c0436bdc t __initcall_kobject_uevent_init2
c0436be0 t __initcall_amba_init2
c0436be4 t __initcall_tty_class_init2
c0436be8 t __initcall_vtconsole_class_init2
c0436bec t __initcall_wakeup_sources_debugfs_init2
c0436bf0 t __initcall_customize_machine3
c0436bf4 t __initcall_arch_hw_breakpoint_init3
c0436bf8 t __initcall_exceptions_init3
c0436bfc t __initcall_realview_i2c_init3
c0436c00 t __initcall_pl011_init3
c0436c04 t __initcall_topology_init4
c0436c08 t __initcall_param_sysfs_init4
c0436c0c t __initcall_pm_sysrq_init4
c0436c10 t __initcall_default_bdi_init4
c0436c14 t __initcall_init_bio4
c0436c18 t __initcall_fsnotify_notification_init4
c0436c1c t __initcall_blk_settings_init4
c0436c20 t __initcall_blk_ioc_init4
c0436c24 t __initcall_blk_softirq_init4
c0436c28 t __initcall_blk_iopoll_setup4
c0436c2c t __initcall_genhd_device_init4
c0436c30 t __initcall_fbmem_init4
c0436c34 t __initcall_misc_init4
c0436c38 t __initcall_init_scsi4
c0436c3c t __initcall_ata_init4
c0436c40 t __initcall_phy_init4
c0436c44 t __initcall_usb_init4
c0436c48 t __initcall_serio_init4
c0436c4c t __initcall_input_init4
c0436c50 t __initcall_rtc_init4
c0436c54 t __initcall_init_soundcore4
c0436c58 t __initcall_alsa_sound_init4
c0436c5c t __initcall_ac97_bus_init4
c0436c60 t __initcall_proto_init4
c0436c64 t __initcall_net_dev_init4
c0436c68 t __initcall_neigh_init4
c0436c6c t __initcall_genl_init4
c0436c70 t __initcall_sysctl_init4
c0436c74 t __initcall_proc_cpu_init5
c0436c78 t __initcall_dma_debug_do_init5
c0436c7c t __initcall_alignment_init5
c0436c80 t __initcall_clocksource_done_booting5
c0436c84 t __initcall_init_pipe_fs5
c0436c88 t __initcall_eventpoll_init5
c0436c8c t __initcall_anon_inode_init5
c0436c90 t __initcall_blk_scsi_ioctl_init5
c0436c94 t __initcall_chr_dev_init5
c0436c98 t __initcall_firmware_class_init5
c0436c9c t __initcall_sysctl_core_init5
c0436ca0 t __initcall_inet_init5
c0436ca4 t __initcall_af_unix_init5
c0436ca8 t __initcall_init_sunrpc5
c0436cac t __initcall_populate_rootfsrootfs
c0436cb0 t __initcall_timer_init_syscore_ops6
c0436cb4 t __initcall_register_pmu_driver6
c0436cb8 t __initcall_proc_execdomains_init6
c0436cbc t __initcall_ioresources_init6
c0436cc0 t __initcall_uid_cache_init6
c0436cc4 t __initcall_init_posix_timers6
c0436cc8 t __initcall_init_posix_cpu_timers6
c0436ccc t __initcall_timekeeping_init_ops6
c0436cd0 t __initcall_init_clocksource_sysfs6
c0436cd4 t __initcall_init_timer_list_procfs6
c0436cd8 t __initcall_alarmtimer_init6
c0436cdc t __initcall_futex_init6
c0436ce0 t __initcall_proc_modules_init6
c0436ce4 t __initcall_kallsyms_init6
c0436ce8 t __initcall_ikconfig_init6
c0436cec t __initcall_hung_task_init6
c0436cf0 t __initcall_utsname_sysctl_init6
c0436cf4 t __initcall_perf_event_sysfs_init6
c0436cf8 t __initcall_init_per_zone_wmark_min6
c0436cfc t __initcall_kswapd_init6
c0436d00 t __initcall_setup_vmstat6
c0436d04 t __initcall_mm_sysfs_init6
c0436d08 t __initcall_proc_vmalloc_init6
c0436d0c t __initcall_memblock_init_debugfs6
c0436d10 t __initcall_init_emergency_pool6
c0436d14 t __initcall_procswaps_init6
c0436d18 t __initcall_slab_proc_init6
c0436d1c t __initcall_slab_sysfs_init6
c0436d20 t __initcall_fcntl_init6
c0436d24 t __initcall_proc_filesystems_init6
c0436d28 t __initcall_fsnotify_mark_init6
c0436d2c t __initcall_dnotify_init6
c0436d30 t __initcall_inotify_user_setup6
c0436d34 t __initcall_aio_setup6
c0436d38 t __initcall_proc_locks_init6
c0436d3c t __initcall_proc_cmdline_init6
c0436d40 t __initcall_proc_consoles_init6
c0436d44 t __initcall_proc_cpuinfo_init6
c0436d48 t __initcall_proc_devices_init6
c0436d4c t __initcall_proc_interrupts_init6
c0436d50 t __initcall_proc_loadavg_init6
c0436d54 t __initcall_proc_meminfo_init6
c0436d58 t __initcall_proc_stat_init6
c0436d5c t __initcall_proc_uptime_init6
c0436d60 t __initcall_proc_version_init6
c0436d64 t __initcall_proc_softirqs_init6
c0436d68 t __initcall_proc_kmsg_init6
c0436d6c t __initcall_proc_page_init6
c0436d70 t __initcall_init_devpts_fs6
c0436d74 t __initcall_init_ext3_fs6
c0436d78 t __initcall_init_ext2_fs6
c0436d7c t __initcall_journal_init6
c0436d80 t __initcall_init_cramfs_fs6
c0436d84 t __initcall_init_ramfs_fs6
c0436d88 t __initcall_init_fat_fs6
c0436d8c t __initcall_init_vfat_fs6
c0436d90 t __initcall_init_nfs_fs6
c0436d94 t __initcall_init_nlm6
c0436d98 t __initcall_init_nls_cp4376
c0436d9c t __initcall_init_nls_iso8859_16
c0436da0 t __initcall_ipc_init6

Reordering the initcalls seems the easiest solution, but it is still very
fragile...

        M.
-- 
Fast, cheap, reliable. Pick two.
