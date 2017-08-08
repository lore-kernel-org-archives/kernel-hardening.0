MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <59892e0f.lF0HiAP5kclsDbx0%fengguang.wu@intel.com>
References: <59892e0f.lF0HiAP5kclsDbx0%fengguang.wu@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 8 Aug 2017 00:14:22 -0700
Message-ID: <CAGXu5jLURtLSZK7==HVoFbpxjpH5=bZc6gYZ-TR1VMe-jcNGNw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: f7dd250789 ("gcc-plugins: structleak: add option to init all
 .."): kmodloader/112 is trying to release lock (module_mutex) at:
To: kernel test robot <fengguang.wu@intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, LKP <lkp@01.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, wfg@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

This appears to be something related to randstruct, not structleak
(which is entirely disabled for this build):

CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_CYC_COMPLEXITY is not set
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK is not set
CONFIG_GCC_PLUGIN_RANDSTRUCT=y
CONFIG_GCC_PLUGIN_RANDSTRUCT_PERFORMANCE=y

-Kees


On Mon, Aug 7, 2017 at 8:20 PM, kernel test robot
<fengguang.wu@intel.com> wrote:
> Greetings,
>
> 0day kernel testing robot got the below dmesg and the first bad commit is
>
> https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git for-next/gcc-plugin/structleak
>
> commit f7dd2507893cc3425d3ffc2369559619960befb0
> Author:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
> AuthorDate: Sun Aug 6 12:06:27 2017 +0100
> Commit:     Kees Cook <keescook@chromium.org>
> CommitDate: Mon Aug 7 11:20:57 2017 -0700
>
>     gcc-plugins: structleak: add option to init all vars used as byref args
>
>     In the Linux kernel, struct type variables are rarely passed by-value,
>     and so functions that initialize such variables typically take an input
>     reference to the variable rather than returning a value that can
>     subsequently be used in an assignment.
>
>     If the initalization function is not part of the same compilation unit,
>     the lack of an assignment operation defeats any analysis the compiler
>     can perform as to whether the variable may be used before having been
>     initialized. This means we may end up passing on such variables
>     uninitialized, resulting in potential information leaks.
>
>     So extend the existing structleak GCC plugin so it will [optionally]
>     apply to all struct type variables that have their address taken at any
>     point, rather than only to variables of struct types that have a __user
>     annotation.
>
>     Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>     Signed-off-by: Kees Cook <keescook@chromium.org>
>
> 520eccdfe1  Linux 4.13-rc2
> f7dd250789  gcc-plugins: structleak: add option to init all vars used as byref args
> f7dd250789  gcc-plugins: structleak: add option to init all vars used as byref args
> +-------------------------------------------+-----------+------------+------------+
> |                                           | v4.13-rc2 | f7dd250789 | f7dd250789 |
> +-------------------------------------------+-----------+------------+------------+
> | boot_successes                            | 163       | 0          | 0          |
> | boot_failures                             | 0         | 32         | 32         |
> | is_trying_to_release_lock(module_mutex)at | 0         | 32         | 32         |
> | BUG:unable_to_handle_kernel               | 0         | 32         | 32         |
> | Oops:#[##]                                | 0         | 32         | 32         |
> | EIP:m_start                               | 0         | 32         | 32         |
> | Kernel_panic-not_syncing:Fatal_exception  | 0         | 32         | 32         |
> +-------------------------------------------+-----------+------------+------------+
>
> [    7.063335]
> [    7.063494] =====================================
> [    7.063922] WARNING: bad unlock balance detected!
> [    7.064351] 4.13.0-rc2-00001-gf7dd2507 #191 Not tainted
> [    7.064830] -------------------------------------
> [    7.065259] kmodloader/112 is trying to release lock (module_mutex) at:
> [    7.065865] [<7909ed9a>] m_stop+0xd/0xf
> [    7.066216] but there are no more locks to release!
> [    7.066663]
> [    7.066663] other info that might help us debug this:
> [    7.066663]
> [    7.066663] other info that might help us debug this:
> [    7.067257] 1 lock held by kmodloader/112:
> [    7.067635]  #0:  (&p->lock){+.+.+.}, at: [<791311b2>] seq_read+0x27/0x368
> [    7.068264]
> [    7.068264] stack backtrace:
> [    7.068264]
> [    7.068264] stack backtrace:
> [    7.068668] CPU: 0 PID: 112 Comm: kmodloader Not tainted 4.13.0-rc2-00001-gf7dd2507 #191
> [    7.069408] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-20161025_171302-gandalf 04/01/2014
> [    7.070338] Call Trace:
> [    7.070569]  dump_stack+0x74/0xa7
> [    7.070874]  ? m_stop+0xd/0xf
> [    7.071149]  print_unlock_imbalance_bug+0xb1/0xbe
> [    7.071582]  ? m_stop+0xd/0xf
> [    7.071855]  ? m_stop+0xd/0xf
> [    7.072128]  lock_release+0x11c/0x24d
> [    7.072464]  ? m_stop+0xd/0xf
> [    7.072747]  __mutex_unlock_slowpath+0x27/0x1bf
> [    7.073163]  ? __kmalloc+0x5e/0x66
> [    7.073477]  mutex_unlock+0xb/0xd
> [    7.073786]  m_stop+0xd/0xf
> [    7.074044]  seq_read+0x187/0x368
> [    7.074349]  ? seq_lseek+0x13f/0x13f
> [    7.074681]  proc_reg_read+0x47/0x64
> [    7.075011]  ? proc_reg_mmap+0x54/0x54
> [    7.075356]  __vfs_read+0x22/0x109
> [    7.075673]  ? find_held_lock+0x29/0x6c
> [    7.076027]  ? __do_page_fault+0x302/0x378
> [    7.076402]  vfs_read+0x83/0xf4
> [    7.076694]  SyS_read+0x3d/0x82
> [    7.076984]  do_int80_syscall_32+0x4c/0xd9
> [    7.077359]  entry_INT80_32+0x2c/0x2c
> [    7.077697] EIP: 0x6ff5fd0e
> [    7.077954] EFLAGS: 00000246 CPU: 0
> [    7.078274] EAX: ffffffda EBX: 00000003 ECX: 094a4088 EDX: 00001000
> [    7.078846] ESI: 094a4028 EDI: 00001000 EBP: 094a5090 ESP: 77d69f4c
> [    7.079415]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
> [    7.079925] BUG: unable to handle kernel NULL pointer dereference at   (null)
> [    7.080581] IP: m_start+0x12/0x24
> [    7.080884] *pde = 00000000
> [    7.080885]
> [    7.081288] Oops: 0000 [#1] SMP
> [    7.081579] Modules linked in:
> [    7.081861] CPU: 0 PID: 112 Comm: kmodloader Not tainted 4.13.0-rc2-00001-gf7dd2507 #191
> [    7.082593] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-20161025_171302-gandalf 04/01/2014
> [    7.083513] task: 86cb4000 task.stack: 86cb6000
> [    7.083926] EIP: m_start+0x12/0x24
> [    7.084237] EFLAGS: 00010246 CPU: 0
> [    7.084560] EAX: 00000000 EBX: 00000000 ECX: 7990e72c EDX: 7909f0bc
> [    7.085126] ESI: 00000000 EDI: 00000000 EBP: 86cb7e94 ESP: 86cb7e90
> [    7.085695]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [    7.086185] CR0: 80050033 CR2: 00000000 CR3: 0ecba000 CR4: 001406d0
> [    7.086759] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [    7.087327] DR6: fffe0ff0 DR7: 00000400
> [    7.087679] Call Trace:
> [    7.087906]  seq_read+0x258/0x368
> [    7.088210]  ? seq_lseek+0x13f/0x13f
> [    7.088541]  proc_reg_read+0x47/0x64
> [    7.088868]  ? proc_reg_mmap+0x54/0x54
> [    7.089214]  __vfs_read+0x22/0x109
> [    7.089528]  ? find_held_lock+0x29/0x6c
> [    7.089879]  ? __do_page_fault+0x302/0x378
> [    7.090252]  vfs_read+0x83/0xf4
> [    7.090545]  SyS_read+0x3d/0x82
> [    7.090833]  do_int80_syscall_32+0x4c/0xd9
> [    7.091206]  entry_INT80_32+0x2c/0x2c
> [    7.091543] EIP: 0x6ff5fd0e
> [    7.091800] EFLAGS: 00000246 CPU: 0
> [    7.092118] EAX: ffffffda EBX: 00000003 ECX: 094a4088 EDX: 00001000
> [    7.092689] ESI: 094a4028 EDI: 00001000 EBP: 094a5090 ESP: 77d69f4c
> [    7.093257]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
> [    7.093752] Code: 79 e8 61 1d 09 00 5d c3 55 89 d0 89 e5 ba e8 e6 90 79 e8 01 1d 09 00 5d c3 55 b8 f0 e6 90 79 89 e5 53 89 d3 31 d2 e8 54 74 56 00 <8b> 13 b8 e8 e6 90 79 8b 4b 04 e8 b3 1c 09 00 5b 5d c3 55 85 d2
> [    7.095477] EIP: m_start+0x12/0x24 SS:ESP: 0068:86cb7e90
> [    7.095963] CR2: 0000000000000000
> [    7.096276] ---[ end trace 5d7df7bc417c7ad9 ]---
> [    7.096710] Kernel panic - not syncing: Fatal exception
>
>                                                           # HH:MM RESULT GOOD BAD GOOD_BUT_DIRTY DIRTY_NOT_BAD
> git bisect start f7dd2507893cc3425d3ffc2369559619960befb0 520eccdfe187591a51ea9ab4c1a024ae4d0f68d9 --
> # first bad commit: [f7dd2507893cc3425d3ffc2369559619960befb0] gcc-plugins: structleak: add option to init all vars used as byref args
> git bisect good 520eccdfe187591a51ea9ab4c1a024ae4d0f68d9  # 11:15  G     31     0    0   0  Linux 4.13-rc2
> # extra tests on HEAD of kees/for-next/gcc-plugin/structleak
> git bisect  bad f7dd2507893cc3425d3ffc2369559619960befb0  # 11:15  B      0    32   51   0  gcc-plugins: structleak: add option to init all vars used as byref args
> # extra tests on tree/branch kees/for-next/gcc-plugin/structleak
> git bisect  bad f7dd2507893cc3425d3ffc2369559619960befb0  # 11:15  B      0    32   51   0  gcc-plugins: structleak: add option to init all vars used as byref args
> # extra tests with first bad commit reverted
> git bisect good 39cfbbd528552f0d5733b33b52f1f2fc3ec2e117  # 11:20  G     11     0    0   0  Revert "gcc-plugins: structleak: add option to init all vars used as byref args"
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/lkp                          Intel Corporation



-- 
Kees Cook
Pixel Security
