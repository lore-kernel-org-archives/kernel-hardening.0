MIME-Version: 1.0
In-Reply-To: <CAG48ez3fyav-cw-PP+45UwZLy6RjoDAwVgbpziKTj-pnB3zrYg@mail.gmail.com>
References: <20180807012257.20157-1-jannh@google.com> <C6369CAA-CBB8-420F-97DB-7A242D9650A8@amacapital.net>
 <CAG48ez0c0L+WyfjDcfx=3wDwOQDOSJM-2JSVUBoWJCaKDVEfbw@mail.gmail.com>
 <CALCETrU6gUBiTkpAUKh97y2R1cSftbMcfSTnSYxhZFRKf7vGWQ@mail.gmail.com> <CAG48ez3fyav-cw-PP+45UwZLy6RjoDAwVgbpziKTj-pnB3zrYg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 22 Aug 2018 18:36:18 -0700
Message-ID: <CALCETrXDHE7CJ+vN7hcPaRfn1f5kEiY8u=hxp1TuRZn_r6A3pQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] x86: WARN() when uaccess helpers fault on kernel addresses
Content-Type: text/plain; charset="UTF-8"
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 22, 2018 at 5:55 PM, Jann Horn <jannh@google.com> wrote:
> On Thu, Aug 23, 2018 at 2:28 AM Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> On Wed, Aug 22, 2018 at 4:53 PM, Jann Horn <jannh@google.com> wrote:
>> > On Tue, Aug 7, 2018 at 4:55 AM Andy Lutomirski <luto@amacapital.net> wrote:
>> >> > On Aug 6, 2018, at 6:22 PM, Jann Horn <jannh@google.com> wrote:
>> >> > There have been multiple kernel vulnerabilities that permitted userspace to
>> >> > pass completely unchecked pointers through to userspace accessors:
>> >> >
>> >> > - the waitid() bug - commit 96ca579a1ecc ("waitid(): Add missing
>> >> >  access_ok() checks")
>> >> > - the sg/bsg read/write APIs
>> >> > - the infiniband read/write APIs
>> >> >
>> >> > These don't happen all that often, but when they do happen, it is hard to
>> >> > test for them properly; and it is probably also hard to discover them with
>> >> > fuzzing. Even when an unmapped kernel address is supplied to such buggy
>> >> > code, it just returns -EFAULT instead of doing a proper BUG() or at least
>> >> > WARN().
>> >> >
>> >> > This patch attempts to make such misbehaving code a bit more visible by
>> >> > WARN()ing in the pagefault handler code when a userspace accessor causes
>> >> > #PF on a kernel address and the current context isn't whitelisted.
>> >>
>> >> I like this a lot, and, in fact, I once wrote a patch to do something similar. It was before the fancy extable code, though, so it was a mess.  Here are some thoughts:
>> >>
>> >> - It should be three patches. One patch to add the _UA annotations, one to improve the info passes to the handlers, and one to change behavior.
>> >>
>> >> - You should pass the vector, the error code, and the address to the handler.
>> >
>> > I'm polishing the patch a bit, and I've noticed that to plumb the
>> > error code and address through properly, I might need significantly
>> > more code churn because of kprobes - I want to make sure I'm not going
>> > down the completely wrong path here.
>> >
>> > I'm extending fixup_exception() to take two extra args "unsigned long
>> > error_code, unsigned long fault_addr". Most callers of
>> > fixup_exception() are fairly straightforward, but
>> > kprobe_fault_handler() has a dozen callchains from different exception
>> > handlers, and most of them are coming via notify_die().
>>
>> KILL IT WITH FIRE!!!!!!!!
>>
>> More seriously, kill kprobe_exceptions_notify() and just fold the
>> contents into do_general_protection().  This notifier chain crap is
>> incomprehensible.  I would love to see notify_die() removed entirely,
>> and crap like this is just more reason to want it gone.
>
> This isn't just do_general_protection() though, that's just one
> example. As far as I can tell, similar stuff happens everywhere where
> notify_die() is used - #DF, #BR, #BP, #MF and so on.

True.  But there aren't actually that many places in the kernel that
use die notifiers at all.  Here's the complete list, excluding non-x86
arch-specific ones, annotated a bit:

arch/x86/kernel/kgdb.c:    retval = register_die_notifier(&kgdb_notifier);
arch/x86/kernel/kgdb.c:    unregister_die_notifier(&kgdb_notifier);
arch/x86/kernel/kgdb.c:    unregister_die_notifier(&kgdb_notifier);

OK, maybe not totally crazy for kgdb.

arch/x86/mm/kasan_init_64.c:    register_die_notifier(&kasan_die_notifier);

Should be in traps.c directly.

arch/x86/mm/kmmio.c:    return register_die_notifier(&nb_die);
arch/x86/mm/kmmio.c:    unregister_die_notifier(&nb_die);

Should probably be in traps.c directly.

drivers/bus/brcmstb_gisb.c:        register_die_notifier(&gisb_die_notifier);

I don't know WTF this is, but it is certainly garbage if anyone ever
tries to build this on x86.

drivers/dma/sh/shdmac.c:    int err =
register_die_notifier(&sh_dmae_nmi_notifier);
drivers/dma/sh/shdmac.c:    unregister_die_notifier(&sh_dmae_nmi_notifier);

SH-specific, I think.  Not really sure.

drivers/firmware/google/gsmi.c:    register_die_notifier(&gsmi_die_notifier);
drivers/firmware/google/gsmi.c:    unregister_die_notifier(&gsmi_die_notifier);

This is actually an *oops* notifier.  That's totally reasonable, but
it should be a separate OOPS notification chain.

drivers/hv/vmbus_drv.c:        register_die_notifier(&hyperv_die_block);
drivers/hv/vmbus_drv.c:        unregister_die_notifier(&hyperv_die_block);

Appears to *want* to be an OOPS notifier, but it appears to be rather
buggy and to actually catch everything.

drivers/misc/sgi-xp/xpc_main.c:
(void)unregister_die_notifier(&xpc_die_notifier);
drivers/misc/sgi-xp/xpc_main.c:    ret =
register_die_notifier(&xpc_die_notifier);
drivers/misc/sgi-xp/xpc_main.c:
(void)unregister_die_notifier(&xpc_die_notifier);

Haven't looked.

kernel/events/hw_breakpoint.c:    return
register_die_notifier(&hw_breakpoint_exceptions_nb);

This is an utter abomination and needs to be killed.  The #DB code is
gnarly enough without this particular indirection.  I want to kill it
on x86.  I have a big #DB cleanup series.  Maybe I'll do it.

kernel/events/uprobes.c:    return register_die_notifier(&uprobe_exception_nb);

For Pete's sake, the code should just call
uprobe_pre_sstep_notifier(regs)) and uprobe_post_sstep_notifier(regs)
directly.

kernel/kprobes.c:        err = register_die_notifier(&kprobe_exceptions_nb);

This is yours :)  And it is literally only hooking DIE_GPF.  Just make
the body empty, add a comment like /* XXX: the core code expects this
function to exist */ and call the hander from do_general_protection().

kernel/trace/trace.c:    register_die_notifier(&trace_die_notifier);

This is an OOPS notifier.

In any event, the particular offending kprobe notifier is literally
only checking for DIE_GPF.  So it really can be folded into
do_general_protection().  Or you could add fault_address to die_args.
