Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161025085109.GV19531@linaro.org>
References: <1476959131-6153-1-git-send-email-elena.reshetova@intel.com>
 <1476959131-6153-2-git-send-email-elena.reshetova@intel.com> <20161025085109.GV19531@linaro.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 25 Oct 2016 15:16:59 -0700
Message-ID: <CAGXu5jK-HeBCwon+u76pe3mqfL9Rag2me7WCG3XZCDGgBWGPWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC v2 PATCH 01/13] Add architecture
 independent hardened atomic base
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 25, 2016 at 1:51 AM, AKASHI Takahiro
<takahiro.akashi@linaro.org> wrote:
>> +void hardened_atomic_overflow(struct pt_regs *regs)
>> +{
>> +     pr_emerg(KERN_EMERG "HARDENED_ATOMIC: overflow detected in: %s:%d, uid/euid: %u/%u\n",
>> +             current->comm, task_pid_nr(current),
>> +             from_kuid_munged(&init_user_ns, current_uid()),
>> +             from_kuid_munged(&init_user_ns, current_euid()));
>> +     BUG();
>
> BUG() will print a message like "kernel BUG at kernel/panic.c:627!"
> and a stack trace dump with extra frames including hardened_atomic_overflow()
> and some exception handler routines (do_trap() on x86), which are totally
> useless. So I don't want to call BUG() here.
>
> Instead, we will fall back to a normal "BUG" handler, bug_handler() on arm64,
> which eventually calls die(), generating more *intuitive* messages:
> ===8<===
> [   29.082336] lkdtm: attempting good atomic_add_return
> [   29.082391] lkdtm: attempting bad atomic_add_return
> [   29.082830] ------------[ cut here ]------------
> [   29.082889] Kernel BUG at ffff0000008b07fc [verbose debug info unavailable]
>                             (Actually, this is lkdtm_ATOMIC_ADD_RETURN_OVERFLOW)
> [   29.082968] HARDENED_ATOMIC: overflow detected in: insmod:1152, uid/euid: 0/0
> [   29.083043] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> [   29.083098] Modules linked in: lkdtm(+)
> [   29.083189] CPU: 1 PID: 1152 Comm: insmod Not tainted 4.9.0-rc1-00024-gb757839-dirty #12
> [   29.083262] Hardware name: FVP Base (DT)
> [   29.083324] task: ffff80087aa21900 task.stack: ffff80087a36c000
> [   29.083557] PC is at lkdtm_ATOMIC_ADD_RETURN_OVERFLOW+0x6c/0xa0 [lkdtm]
> [   29.083627] LR is at 0x7fffffff
> [   29.083687] pc : [<ffff0000008b07fc>] lr : [<000000007fffffff>] pstate: 90400149
> [   29.083757] sp : ffff80087a36fbe0
> [   29.083810] x29: ffff80087a36fbe0 [   29.083858] x28: ffff000008ec3000
> [   29.083906]
>
> ...
>
> [   29.090842] [<ffff0000008b07fc>] lkdtm_ATOMIC_ADD_RETURN_OVERFLOW+0x6c/0xa0 [lkdtm]
> [   29.091090] [<ffff0000008b20a4>] lkdtm_do_action+0x1c/0x28 [lkdtm]
> [   29.091334] [<ffff0000008bb118>] lkdtm_module_init+0x118/0x210 [lkdtm]
> [   29.091422] [<ffff000008083150>] do_one_initcall+0x38/0x128
> [   29.091503] [<ffff000008166ad4>] do_init_module+0x5c/0x1c8
> [   29.091586] [<ffff00000812e1ec>] load_module+0x1b24/0x20b0
> [   29.091670] [<ffff00000812e920>] SyS_init_module+0x1a8/0x1d8
> [   29.091753] [<ffff000008082ef0>] el0_svc_naked+0x24/0x28
> [   29.091843] Code: 910063a1 b8e0003e 2b1e0010 540000c7 (d4210020)
> ===>8===

This looks much nicer, yes. Is there a similar function that can be
used on x86? I've been wanting to reorganize these hardening traps so
they're less ugly. :P

-Kees

-- 
Kees Cook
Nexus Security
