MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170501163009.kbemdhpsabdrsfex@treble>
References: <1493160997-126108-1-git-send-email-keescook@chromium.org>
 <1493160997-126108-3-git-send-email-keescook@chromium.org> <20170501163009.kbemdhpsabdrsfex@treble>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 1 May 2017 10:36:59 -0700
Message-ID: <CAGXu5jKoeB7tbxfcLC03tFnjYKYt+ZHtk_jruQJ887dPHJ-Gag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 2/2] x86, refcount: Implement fast refcount overflow protection
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 1, 2017 at 9:30 AM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>> +#define __REFCOUNT_EXCEPTION(size)                   \
>> +     ".if "__stringify(size)" == 4\n\t"              \
>> +     ".pushsection .text.refcount_overflow\n"        \
>> +     ".elseif "__stringify(size)" == -4\n\t"         \
>> +     ".pushsection .text.refcount_underflow\n"       \
>> +     ".else\n"                                       \
>> +     ".error \"invalid size\"\n"                     \
>> +     ".endif\n"                                      \
>> +     "111:\tlea %[counter],%%"_ASM_CX"\n\t"          \
>> +     "int $"__stringify(X86_REFCOUNT_VECTOR)"\n"     \
>> +     "222:\n\t"                                      \
>> +     ".popsection\n"                                 \
>> +     "333:\n"                                        \
>> +     _ASM_EXTABLE(222b, 333b)
>
> The 'size' argument doesn't seem to correspond to an actual size of
> anything.  Its value '4' or '-4' only seems to indicate whether it's an
> overflow or an underflow.

This is to allow for expansion to refcount64_t if we ever move to it,
then we'll have 4 cases: 4, -4, 8, -8.

> Also there's some inconsistent use of "\n\t" on some lines, with "\n" on
> others.

It's not inconsistent, it's leaving directives at column 0, and
section and instructions at tab-stop 1.

>> +dotraplinkage void do_refcount_error(struct pt_regs *regs, long error_code)
>> +{
>> +     const char *str = NULL;
>> +
>> +     BUG_ON(!(regs->flags & X86_EFLAGS_SF));
>> +
>> +#define range_check(size, dir, type, value)                             \
>> +     do {                                                               \
>> +             if ((unsigned long)__##size##_##dir##_start <= regs->ip && \
>> +                 regs->ip < (unsigned long)__##size##_##dir##_end) {    \
>> +                     *(type *)regs->cx = (value);                       \
>> +                     str = #size " " #dir;                              \
>> +             }                                                          \
>> +     } while (0)
>
> An interrupt was used, not a faulting exception, so regs->ip refers to
> the address *after* the 'int' instruction.  So the beginning of the
> range should be exclusive, and the end of the range should be inclusive,
> like:
>
>> +             if ((unsigned long)__##size##_##dir##_start < regs->ip &&  \
>> +                 regs->ip <= (unsigned long)__##size##_##dir##_end) {   \

Ah, yes, good catch.

>> +
>> +     /*
>> +      * Reset to INT_MAX in both cases to attempt to let system
>> +      * continue operating.
>> +      */
>> +     range_check(refcount,   overflow,  int, INT_MAX);
>> +     range_check(refcount,   underflow, int, INT_MAX);
>
> I think "range_check" doesn't adequately describe the macro.  In
> addition to checking, it has a subtle side effect: it updates the
> counter value with INT_MAX.
>
> It's not clear why the 'size' argument has its name.  Also, three of the
> arguments are always called with the same value.  Anyway I suspect the
> code would be more readable if it were open coded without the macro.

Yeah, and I think I may drop the over/under distinction, since I think
I've convinced myself that we always need to reset to the same
position regardless of direction. This was originally for handling
generic atomic_t operations, not refcount_t... PeterZ may convince me
yet, but I'll send the next version without the over/under
distinction.

>> +#ifdef CONFIG_FAST_REFCOUNT
>> +static DEFINE_RATELIMIT_STATE(refcount_ratelimit, 15 * HZ, 3);
>> +
>> +void refcount_error_report(struct pt_regs *regs, const char *kind)
>> +{
>> +     do_send_sig_info(SIGKILL, SEND_SIG_FORCED, current, true);
>> +
>> +     if (!__ratelimit(&refcount_ratelimit))
>> +             return;
>> +
>> +     pr_emerg("%s detected in: %s:%d, uid/euid: %u/%u\n",
>> +             kind ? kind : "refcount error",
>> +             current->comm, task_pid_nr(current),
>> +             from_kuid_munged(&init_user_ns, current_uid()),
>> +             from_kuid_munged(&init_user_ns, current_euid()));
>> +     print_symbol(KERN_EMERG "refcount error occurred at: %s\n",
>> +             instruction_pointer(regs));
>> +     preempt_disable();
>> +     show_regs(regs);
>> +     preempt_enable();
>> +}
>
> Why is preemption disabled before calling show_regs()?

I thought it was to avoid interleaving show_regs() output (I can't
think of a way regs would be externally modified).

>> +EXPORT_SYMBOL(refcount_error_report);
>
> Why is this exported?  It looks like it's only called internally from
> traps.c.

Ah yes, good point. I'll drop this.

Thanks for the review!

-Kees

-- 
Kees Cook
Pixel Security
