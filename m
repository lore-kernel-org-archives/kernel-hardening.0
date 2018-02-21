Subject: Re: [PATCH RFC v8 0/6] Introduce the STACKLEAK feature and a test for
 it
References: <1518804657-24905-1-git-send-email-alex.popov@linux.com>
 <791341f5-4347-ba38-0710-93551a45ec38@linux.com>
 <CAGXu5jJ+dWjtjJ88ziOoyTJnSxbjdvEJd5LGY9nxWxHpVR6pug@mail.gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <fe156f80-fd91-3261-be48-591f795dda8b@linux.com>
Date: Wed, 21 Feb 2018 17:43:52 +0300
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJ+dWjtjJ88ziOoyTJnSxbjdvEJd5LGY9nxWxHpVR6pug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, X86 ML <x86@kernel.org>, Mohamed Ghannam <simo.ghannam@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hello Kees,

On 21.02.2018 02:17, Kees Cook wrote:
> On Tue, Feb 20, 2018 at 2:29 AM, Alexander Popov <alex.popov@linux.com> wrote:
>> On 16.02.2018 21:10, Alexander Popov wrote:
>>> This is the 8th version of the patch series introducing STACKLEAK to the
>>> mainline kernel. I've made some minor improvements while waiting for the
>>> next review by x86 maintainers.
> 
> If we can borrow some of luto or tglx's time, I think that'd be best:
> they've been looking at the entry code a lot lately. :) Regardless, I
> think the addition to the entry code is clean (especially now that the
> fast path is gone *sob*). :P
> 
>>> STACKLEAK is a security feature developed by Grsecurity/PaX (kudos to them),
>>> which:
>>>  - reduces the information that can be revealed through kernel stack leak bugs;
>>>  - blocks some uninitialized stack variable attacks (e.g. CVE-2010-2963);
>>>  - introduces some runtime checks for kernel stack overflow detection.
> 
> I've added this series to my kernel.org trees, which means 0-day will
> start grinding on it too now:
> https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git
> kspp/gcc-plugin/stackleak

Great, thanks!

> The LKDTM tests look great and check out for me. I think the code is
> clear, so I'd like to get it into -next, but I want to be sure I'm not
> stepping on x86 toes first.

Yes, I see. Thanks for your review anyway.

> Laura, how does arm64 look for this? Would it be possible to add it to
> this series (at least on kernel.org for build/run testing)?
> 
>> Hello! I've just tested STACKLEAK against the recent CVE-2017-17712 exploit:
>> http://openwall.com/lists/oss-security/2018/02/20/1
>>
>> This vulnerability is a race condition in raw_sendmsg() in net/ipv4/raw.c. It
>> leads to uninitialized stack pointer usage which can be used for a local
>> privilege escalation.
>>
>> CVE-2017-17712 was discovered and fixed by Mohamed Ghannam (kudos to him!). He
>> also provided a stable PoC exploit for it.
>>
>> With STACKLEAK, the uninitialized stack pointer is set to STACKLEAK_POISON
>> (-0xBEEF) and points to the unused hole in the virtual memory map. That blocks
>> the stack spraying needed for CVE-2017-17712 exploit (similar to CVE-2010-2963).
> 
> Nice check! I wonder if the the byref structleak also solves it?
> Regardless, I think stackleak has better performance and greater
> coverage.

I disabled CONFIG_GCC_PLUGIN_STACKLEAK and instead enabled
CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL. The msg pointer is now 0. So the access
to msg->msg_iter now gives the following:

[    7.324333] BUG: unable to handle kernel NULL pointer dereference at
0000000000000010
[    7.325067] IP: csum_and_copy_from_iter_full+0x1e/0x400
[    7.325067] PGD 800000007db6c067 P4D 800000007db6c067 PUD 7d34a067 PMD 0
[    7.325067] Oops: 0000 [#1] SMP PTI
[    7.325067] Dumping ftrace buffer:
[    7.325067]    (ftrace buffer empty)
[    7.325067] Modules linked in:
[    7.325067] CPU: 0 PID: 2708 Comm: poc Not tainted 4.16.0-rc1+ #5
[    7.325067] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
Ubuntu-1.8.2-1ubuntu1 04/01/2014
[    7.325067] RIP: 0010:csum_and_copy_from_iter_full+0x1e/0x400
[    7.325067] RSP: 0018:ffffc90000d839d0 EFLAGS: 00010246
[    7.325067] RAX: 0000000000000000 RBX: ffff88003d0887c0 RCX: 0000000000000010
[    7.325067] RDX: ffffc90000d83a64 RSI: 0000000000006400 RDI: ffff88003b828024
[    7.325067] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff88003d0887c0
[    7.325067] R10: ffff88003b828024 R11: 0000000000000000 R12: 0000000000006400
[    7.325067] R13: 0000000000006400 R14: ffff88003de53640 R15: ffff88007d90c110
[    7.325067] FS:  00007f52585d0700(0000) GS:ffff88003ec00000(0000)
knlGS:0000000000000000
[    7.325067] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    7.325067] CR2: 0000000000000010 CR3: 000000007db70000 CR4: 00000000000006f0
[    7.325067] Call Trace:
[    7.325067]  ? __kmalloc_reserve.isra.41+0x29/0x80
[    7.325067]  ip_generic_getfrag+0x73/0xc0
[    7.325067]  __ip_append_data.isra.48+0x68b/0x890
[    7.325067]  ? raw_destroy+0x20/0x20
[    7.325067]  ? raw_destroy+0x20/0x20
[    7.325067]  ip_append_data.part.50+0x67/0xc0
[    7.325067]  raw_sendmsg+0x486/0xa50
[    7.325067]  ? __kmalloc+0x141/0x1a0
[    7.325067]  sock_sendmsg+0x31/0x40
[    7.325067]  ___sys_sendmsg+0x277/0x2d0
[    7.325067]  ? __sys_sendmsg+0x62/0xa0
[    7.325067]  __sys_sendmsg+0x62/0xa0
[    7.325067]  do_syscall_64+0x63/0x120
[    7.325067]  entry_SYSCALL_64_after_hwframe+0x21/0x86
[    7.325067] RIP: 0033:0x7f525c186e90
[    7.325067] RSP: 002b:00007f52585cff00 EFLAGS: 00000293 ORIG_RAX:
000000000000002e
[    7.325067] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f525c186e90
[    7.325067] RDX: 0000000000000000 RSI: 00000000011bd010 RDI: 0000000000000003
[    7.325067] RBP: 00000000011bd010 R08: 0000000000000000 R09: 00007f52585d0700
[    7.325067] R10: 00007f52585cff40 R11: 0000000000000293 R12: 0000000000000000
[    7.325067] R13: 00007fffde2c70bf R14: 0000000000000000 R15: 00007f525c5b7040
[    7.325067] Code: 4c 89 c3 eb f6 49 01 d8 e9 7a ff ff ff 41 57 41 56 41 55 41
54 55 53 48 83 ec 48 65 48 8b 04 25 28 00 00 00 48 89 44 24 40 31 c0 <8b> 01 48
89 14 24 a8 08 0f 85 e5 00 00 00 48 39 71 10 49 89 f6
[    7.325067] RIP: csum_and_copy_from_iter_full+0x1e/0x400 RSP: ffffc90000d839d0
[    7.325067] CR2: 0000000000000010
[    7.382645] ---[ end trace f6927758360fb538 ]---


I think that would block the stack spraying as well.

Best regards,
Alexander
