Date: Mon, 1 May 2017 10:54:54 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <20170501155454.iujra24k3f65xwkq@treble>
References: <1493160997-126108-3-git-send-email-keescook@chromium.org>
 <201704270938.I52YmjxT%fengguang.wu@intel.com>
 <CAGXu5jKyZ954aRHg_7xhXP0CJBiJ8TV7y-dH5viwzfEj8+D6_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGXu5jKyZ954aRHg_7xhXP0CJBiJ8TV7y-dH5viwzfEj8+D6_w@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 2/2] x86, refcount: Implement fast refcount overflow
 protection
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 27, 2017 at 01:22:05PM -0700, Kees Cook wrote:
> On Wed, Apr 26, 2017 at 6:31 PM, kbuild test robot <lkp@intel.com> wrote:
> > Hi Kees,
> >
> > [auto build test WARNING on next-20170424]
> > [cannot apply to tip/x86/core linus/master linux/master v4.9-rc8 v4.9-rc7 v4.9-rc6 v4.11-rc8]
> > [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> >
> > url:    https://github.com/0day-ci/linux/commits/Kees-Cook/x86-refcount-Implement-fast-refcount-overflow/20170426-210530
> > config: x86_64-allmodconfig (attached as .config)
> > compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> > reproduce:
> >         # save the attached .config to linux build tree
> >         make ARCH=x86_64
> >
> > All warnings (new ones prefixed by >>):
> >
> >>> drivers//scsi/scsi_scan.o: warning: objtool: .text.refcount_overflow+0x5: special: can't find orig instruction
> 
> Hi Josh,
> 
> I'm seeing this error being generated on areas that are using a
> cross-section exception handler. I can't quite see why the .o checker
> is unhappy, so I figured I'd ask you first. :)
> 
> The code is generated with calls to __REFCOUNT_CHECK() which is
> defined like this:
> 
> +#define __REFCOUNT_EXCEPTION(size)                     \
> +       ".if "__stringify(size)" == 4\n\t"              \
> +       ".pushsection .text.refcount_overflow\n"        \
> +       ".elseif "__stringify(size)" == -4\n\t"         \
> +       ".pushsection .text.refcount_underflow\n"       \
> +       ".else\n"                                       \
> +       ".error \"invalid size\"\n"                     \
> +       ".endif\n"                                      \
> +       "111:\tlea %[counter],%%"_ASM_CX"\n\t"          \
> +       "int $"__stringify(X86_REFCOUNT_VECTOR)"\n"     \
> +       "222:\n\t"                                      \
> +       ".popsection\n"                                 \
> +       "333:\n"                                        \
> +       _ASM_EXTABLE(222b, 333b)
> +
> +#define __REFCOUNT_CHECK(size)                         \
> +       "js 111f\n"                                     \
> +       __REFCOUNT_EXCEPTION(size)
> +
> +#define __REFCOUNT_ERROR(size)                         \
> +       "jmp 111f\n"                                    \
> +       __REFCOUNT_EXCEPTION(size)
> 
> I assume it doesn't like seeing an exception split across .text and
> .text.refcount_overflow, but I haven't been able to figure out how
> that distinction would be made by the checker. :P

This code uses the exception table a little differently than normal.
Usually it's used for catching page faults, where the exception table
points to the faulting instruction.

But instead of a page fault, here it's doing a software interrupt.  So
the __ex_table entry doesn't point to the 'int 0x81' instruction, it
points to the instruction immediately after it.  In this case there
isn't actually an instruction there, which is why objtool is
complaining.

Is it superfluous to use the exception table here, when a simple 'jmp
333f' could be used instead after the 'int'?

Also it looks like the handler sends a SIGKILL to the current task.  I
wonder if something like BUG_ON() could be used instead of implementing
a custom error interrupt.

-- 
Josh
