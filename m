MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170321045559.GD23490@yexl-desktop>
References: <20170321045559.GD23490@yexl-desktop>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 22 Mar 2017 17:35:28 -0700
Message-ID: <CAGXu5j+2FzkU=J0vh7K2uZqo+NRPJq8k29O4e2cHeTA1nYSbPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [lkp-robot] [refcount] 2bf8784489: kernel_BUG_at_lib/refcount.c
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: LKP <lkp@01.org>, kernel test robot <xiaolong.ye@intel.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 20, 2017 at 9:55 PM, kernel test robot
<xiaolong.ye@intel.com> wrote:
>
> FYI, we noticed the following commit:
>
> commit: 2bf87844891065ac06ae3cc7e5b1bff826841a49 ("refcount: Check bad states with CHECK_DATA_CORRUPTION")
> https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git kspp/corruption
>
> in testcase: trinity
> with following parameters:
>
>         runtime: 300s
>
> test-description: Trinity is a linux system call fuzz tester.
> test-url: http://codemonkey.org.uk/projects/trinity/
>
>
> on test machine: qemu-system-i386 -enable-kvm -smp 2 -m 320M
>
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
>
>
> +-----------------------------------------------------------------------------+------------+------------+
> |                                                                             | 095e6d1bf9 | 2bf8784489 |
> +-----------------------------------------------------------------------------+------------+------------+
> | boot_successes                                                              | 0          | 0          |
> | boot_failures                                                               | 18         | 47         |
> | kobject(#):tried_to_init_an_initialized_object,something_is_seriously_wrong | 18         | 47         |
> | WARNING:at_lib/refcount.c:#refcount_inc                                     | 17         |            |
> | WARNING:at_drivers/usb/core/urb.c:#usb_submit_urb                           | 3          | 1          |
> | kernel_BUG_at_lib/list_debug.c                                              | 2          | 1          |
> | invalid_opcode:#[##]                                                        | 2          | 46         |
> | EIP:__list_add_valid                                                        | 2          | 1          |
> | Kernel_panic-not_syncing:Fatal_exception                                    | 2          | 46         |
> | kernel_BUG_at_lib/refcount.c                                                | 0          | 45         |
> | EIP:refcount_inc                                                            | 0          | 45         |
> | BUG:unable_to_handle_kernel                                                 | 0          | 1          |
> | Oops:#[##]                                                                  | 0          | 1          |
> | EIP:console_unlock                                                          | 0          | 1          |
> | Kernel_panic-not_syncing:Fatal_exception_in_interrupt                       | 0          | 1          |
> +-----------------------------------------------------------------------------+------------+------------+
>
>
>

In the full dmesg, the trigger is:

[   13.324130] refcount_t: increment on 0; use-after-free.
[   13.324130] refcount_t: increment on 0; use-after-free.

Prior to this BUGing with my suggested change, this was just WARNing
and doing something "odd" that wasn't getting noticed by 0-day. I
assume this is something in the kref implementation, but I haven't dug
in yet. Anyone got some spare cycles to track this down? Something in
the debugfs code for block devices getting added?

-Kees

> [   13.324150] kernel BUG at lib/refcount.c:125!
> [   13.324150] kernel BUG at lib/refcount.c:125!
> [   13.324153] invalid opcode: 0000 [#1]
> [   13.324153] invalid opcode: 0000 [#1]
> [   13.324156] CPU: 0 PID: 115 Comm: kworker/u2:1 Not tainted 4.11.0-rc1-00006-g2bf8784 #1
> [   13.324156] CPU: 0 PID: 115 Comm: kworker/u2:1 Not tainted 4.11.0-rc1-00006-g2bf8784 #1
> [   13.324160] Workqueue: events_unbound async_run_entry_fn
> [   13.324160] Workqueue: events_unbound async_run_entry_fn
> [   13.324162] task: 8e8a1a00 task.stack: 8e408000
> [   13.324162] task: 8e8a1a00 task.stack: 8e408000
> [   13.324166] EIP: refcount_inc+0x7c/0x80
> [   13.324166] EIP: refcount_inc+0x7c/0x80
> [   13.324168] EFLAGS: 00210296 CPU: 0
> [   13.324168] EFLAGS: 00210296 CPU: 0
> [   13.324170] EAX: 0000002b EBX: 00000001 ECX: 00000000 EDX: 00000037
> [   13.324170] EAX: 0000002b EBX: 00000001 ECX: 00000000 EDX: 00000037
> [   13.324171] ESI: 00000001 EDI: 00000691 EBP: 8e409d70 ESP: 8e409d64
> [   13.324171] ESI: 00000001 EDI: 00000691 EBP: 8e409d70 ESP: 8e409d64
> [   13.324173]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> [   13.324173]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> [   13.324175] CR0: 80050033 CR2: 00000000 CR3: 11327000 CR4: 000006b0
> [   13.324175] CR0: 80050033 CR2: 00000000 CR3: 11327000 CR4: 000006b0
> [   13.324180] Call Trace:
> [   13.324180] Call Trace:
> [   13.324183]  kobject_get+0x51/0xc0
> [   13.324183]  kobject_get+0x51/0xc0
> [   13.324187]  ? kfree+0x24d/0x410
> [   13.324187]  ? kfree+0x24d/0x410
> [   13.324190]  kobject_add_internal+0x60/0x6b0
> [   13.324190]  kobject_add_internal+0x60/0x6b0
> [   13.324194]  ? kfree_const+0x2c/0x30
> [   13.324194]  ? kfree_const+0x2c/0x30
> [   13.324197]  ? kobject_set_name_vargs+0xd3/0x100
> [   13.324197]  ? kobject_set_name_vargs+0xd3/0x100
> [   13.324200]  kobject_add_varg+0x3f/0x60
> [   13.324200]  kobject_add_varg+0x3f/0x60
> [   13.324203]  kobject_add+0x5b/0xa0
> [   13.324203]  kobject_add+0x5b/0xa0
> [   13.324206]  ? debugfs_create_dir+0x100/0x130
> [   13.324206]  ? debugfs_create_dir+0x100/0x130
> [   13.324209]  blk_mq_register_hctx+0xbf/0xf0
> [   13.324209]  blk_mq_register_hctx+0xbf/0xf0
> [   13.324212]  blk_mq_register_dev+0xd1/0x150
> [   13.324212]  blk_mq_register_dev+0xd1/0x150
> [   13.324215]  blk_register_queue+0x15a/0x280
> [   13.324215]  blk_register_queue+0x15a/0x280
> [   13.324217]  ? disk_part_iter_next+0x4c/0x310
> [   13.324217]  ? disk_part_iter_next+0x4c/0x310
> [   13.324220]  device_add_disk+0x1de/0x7e0
> [   13.324220]  device_add_disk+0x1de/0x7e0
> [   13.324224]  sd_probe_async+0x10f/0x220
> [   13.324224]  sd_probe_async+0x10f/0x220
> [   13.324227]  ? __lock_is_held+0x48/0x90
> [   13.324227]  ? __lock_is_held+0x48/0x90
> [   13.324230]  async_run_entry_fn+0x38/0x130
> [   13.324230]  async_run_entry_fn+0x38/0x130
> [   13.324232]  process_one_work+0x2e4/0xad0
> [   13.324232]  process_one_work+0x2e4/0xad0
> [   13.324235]  ? process_one_work+0x224/0xad0
> [   13.324235]  ? process_one_work+0x224/0xad0
> [   13.324237]  worker_thread+0x317/0x9a0
> [   13.324237]  worker_thread+0x317/0x9a0
> [   13.324240]  kthread+0x14c/0x150
> [   13.324240]  kthread+0x14c/0x150
> [   13.324242]  ? process_one_work+0xad0/0xad0
> [   13.324242]  ? process_one_work+0xad0/0xad0
> [   13.324245]  ? __kthread_create_on_node+0x260/0x260
> [   13.324245]  ? __kthread_create_on_node+0x260/0x260
> [   13.324248]  ret_from_fork+0x21/0x2c
> [   13.324248]  ret_from_fork+0x21/0x2c
> [   13.324250] Code: 00 00 00 89 da 31 c9 b8 70 cc f5 90 e8 3e c9 af ff 83 c4 04 5b 5e 5d c3 8d b4 26 00 00 00 00 c7 04 24 d4 5c cf 90 e8 51 68 b5 ff <0f> 0b 66 90 55 89 e5 57 56 53 83 ec 0c 8b 1a 89 45 f0 89 55 ec
> [   13.324250] Code: 00 00 00 89 da 31 c9 b8 70 cc f5 90 e8 3e c9 af ff 83 c4 04 5b 5e 5d c3 8d b4 26 00 00 00 00 c7 04 24 d4 5c cf 90 e8 51 68 b5 ff <0f> 0b 66 90 55 89 e5 57 56 53 83 ec 0c 8b 1a 89 45 f0 89 55 ec
> [   13.324304] EIP: refcount_inc+0x7c/0x80 SS:ESP: 0068:8e409d64
> [   13.324304] EIP: refcount_inc+0x7c/0x80 SS:ESP: 0068:8e409d64
> [   13.324310] ---[ end trace 7c85e1262bf7be37 ]---
>
>
> To reproduce:
>
>         git clone https://github.com/01org/lkp-tests.git
>         cd lkp-tests
>         bin/lkp qemu -k <bzImage> job-script  # job-script is attached in this email
>
>
>
> Thanks,
> Xiaolong



-- 
Kees Cook
Pixel Security
