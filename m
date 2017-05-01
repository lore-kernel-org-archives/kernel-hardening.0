Date: Mon, 1 May 2017 17:33:50 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <20170501223350.6lxjyvkwz4fwjyqd@treble>
References: <1493160997-126108-3-git-send-email-keescook@chromium.org>
 <201704270938.I52YmjxT%fengguang.wu@intel.com>
 <CAGXu5jKyZ954aRHg_7xhXP0CJBiJ8TV7y-dH5viwzfEj8+D6_w@mail.gmail.com>
 <20170501155454.iujra24k3f65xwkq@treble>
 <CAGXu5j+OKnHB2POjyBMGc8RXWbgDzi3xiZFBa5Jz0-jNJeOpqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGXu5j+OKnHB2POjyBMGc8RXWbgDzi3xiZFBa5Jz0-jNJeOpqg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 2/2] x86, refcount: Implement fast refcount overflow
 protection
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 01, 2017 at 10:28:53AM -0700, Kees Cook wrote:
> On Mon, May 1, 2017 at 8:54 AM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > On Thu, Apr 27, 2017 at 01:22:05PM -0700, Kees Cook wrote:
> >> +#define __REFCOUNT_EXCEPTION(size)                     \
> >> +       ".if "__stringify(size)" == 4\n\t"              \
> >> +       ".pushsection .text.refcount_overflow\n"        \
> >> +       ".elseif "__stringify(size)" == -4\n\t"         \
> >> +       ".pushsection .text.refcount_underflow\n"       \
> >> +       ".else\n"                                       \
> >> +       ".error \"invalid size\"\n"                     \
> >> +       ".endif\n"                                      \
> >> +       "111:\tlea %[counter],%%"_ASM_CX"\n\t"          \
> >> +       "int $"__stringify(X86_REFCOUNT_VECTOR)"\n"     \
> >> +       "222:\n\t"                                      \
> >> +       ".popsection\n"                                 \
> >> +       "333:\n"                                        \
> >> +       _ASM_EXTABLE(222b, 333b)
> >> +
> >> +#define __REFCOUNT_CHECK(size)                         \
> >> +       "js 111f\n"                                     \
> >> +       __REFCOUNT_EXCEPTION(size)
> >> +
> >> +#define __REFCOUNT_ERROR(size)                         \
> >> +       "jmp 111f\n"                                    \
> >> +       __REFCOUNT_EXCEPTION(size)
> >>
> >> I assume it doesn't like seeing an exception split across .text and
> >> .text.refcount_overflow, but I haven't been able to figure out how
> >> that distinction would be made by the checker. :P
> >
> > This code uses the exception table a little differently than normal.
> > Usually it's used for catching page faults, where the exception table
> > points to the faulting instruction.
> >
> > But instead of a page fault, here it's doing a software interrupt.  So
> > the __ex_table entry doesn't point to the 'int 0x81' instruction, it
> > points to the instruction immediately after it.  In this case there
> > isn't actually an instruction there, which is why objtool is
> > complaining.
> 
> What would it take to adjust objtool for this case?

I still need to think about it some more. I doubt it would be
straightforward.  But I am ok with making such a change, if it makes
sense to do so.

> > Is it superfluous to use the exception table here, when a simple 'jmp
> > 333f' could be used instead after the 'int'?
> 
> I thought the exception tables were needed to have the trap handler
> notice it correctly, and do the right thing as far as continuing
> execution. (This is currently written as a survivable condition: the
> kernel can keep running even though it will kill the userspace
> process.)

Nothing needs to be done to make it continue execution, because regs->ip
will already have the address immediately after the 'int' instruction,
which is where the iret will return.  So fixup_exception() isn't needed.

Instead, along with the aforementioned 'jmp 333f',  you could move the
refcount_error_report() call to outside the fixup_exception() clause:

if (!user_mode(regs)) {
	if (fixup_exception(regs, trapnr))
		return 0;

	if (fixup_bug(regs, trapnr))
		return 0;

	if (IS_ENABLED(CONFIG_FAST_REFCOUNT) && trapnr == X86_REFCOUNT_VECTOR) {
		refcount_error_report(regs, str);
		return 0;
	}

(For better readability the refcount parts could be moved to a
fixup_refcount() function.)

Or, another way to handle it would be to use a real exception.  One idea
would be to share UD0 with WARN somehow, and handle it with fixup_bug().
At least then, IMO, the error handling code would be closer to where it
belongs, with WARN and BUG.

But stepping back a bit, why is the interrupt/exception even needed?  Is
there a reason why it can't do the stack dump from the context of the
original overflow?  i.e., instead of 'int 0x81', just call the error
handler directly.  Which could then WARN, send the self-signal, update
the refcount to INT_MAX, etc.

> > Also it looks like the handler sends a SIGKILL to the current task.  I
> > wonder if something like BUG_ON() could be used instead of implementing
> > a custom error interrupt.
> 
> It's a rate limited report, but it must always kill. BUG doesn't fit
> this usage case (I've got similar problems with other areas; my
> intention is go create something that is configurable WARN vs Oops,
> respects panic_on_oops, etc, but this doesn't exist yet).

Yeah, it would be good to make BUG and WARN flexible enough such that we
don't need these custom errors, so we can get more consistent error
handling behavior.

-- 
Josh
