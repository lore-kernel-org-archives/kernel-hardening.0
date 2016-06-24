Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 24 Jun 2016 10:48:29 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <20160624154829.mfh7e5it22rssupm@treble>
References: <cover.1466741835.git.luto@kernel.org>
 <2bae70091dd75abc881259747987979156f2f789.1466741835.git.luto@kernel.org>
 <20160624153001.b5urlxdpvliqqqji@treble>
 <CAMzpN2jYQq2shQpn6J9ptHBFikYNiFErraW0=T_hiLkemmaPSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMzpN2jYQq2shQpn6J9ptHBFikYNiFErraW0=T_hiLkemmaPSg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v4 11/16] x86/dumpstack: When OOPSing, rewind the stack
 before do_exit
To: Brian Gerst <brgerst@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 24, 2016 at 11:35:13AM -0400, Brian Gerst wrote:
> On Fri, Jun 24, 2016 at 11:30 AM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > On Thu, Jun 23, 2016 at 09:23:06PM -0700, Andy Lutomirski wrote:
> >> If we call do_exit with a clean stack, we greatly reduce the risk of
> >> recursive oopses due to stack overflow in do_exit, and we allow
> >> do_exit to work even if we OOPS from an IST stack.  The latter gives
> >> us a much better chance of surviving long enough after we detect a
> >> stack overflow to write out our logs.
> >>
> >> I intentionally separated this from the preceding patch that
> >> disables do_exit-on-OOPS on IST stacks.  This way, if we need to
> >> revert this patch, we still end up in an acceptable state wrt stack
> >> overflow handling.
> >>
> >> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> >> ---
> >>  arch/x86/entry/entry_32.S   | 11 +++++++++++
> >>  arch/x86/entry/entry_64.S   | 11 +++++++++++
> >>  arch/x86/kernel/dumpstack.c | 13 +++++++++----
> >>  3 files changed, 31 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
> >> index 983e5d3a0d27..0b56666e6039 100644
> >> --- a/arch/x86/entry/entry_32.S
> >> +++ b/arch/x86/entry/entry_32.S
> >> @@ -1153,3 +1153,14 @@ ENTRY(async_page_fault)
> >>       jmp     error_code
> >>  END(async_page_fault)
> >>  #endif
> >> +
> >> +ENTRY(rewind_stack_do_exit)
> >> +     /* Prevent any naive code from trying to unwind to our caller. */
> >> +     xorl    %ebp, %ebp
> >> +
> >> +     movl    PER_CPU_VAR(cpu_current_top_of_stack), %esi
> >> +     leal    -TOP_OF_KERNEL_STACK_PADDING-PTREGS_SIZE(%esi), %esp
> >> +
> >> +     call    do_exit
> >> +1:   jmp 1b
> >> +END(rewind_stack_do_exit)
> >> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> >> index 9ee0da1807ed..b846875aeea6 100644
> >> --- a/arch/x86/entry/entry_64.S
> >> +++ b/arch/x86/entry/entry_64.S
> >> @@ -1423,3 +1423,14 @@ ENTRY(ignore_sysret)
> >>       mov     $-ENOSYS, %eax
> >>       sysret
> >>  END(ignore_sysret)
> >> +
> >> +ENTRY(rewind_stack_do_exit)
> >> +     /* Prevent any naive code from trying to unwind to our caller. */
> >> +     xorl    %ebp, %ebp
> >
> > s/ebp/rbp/g/ ?
> 
> No, this quirk of the x86-64 instruction set will zero-extend to
> 64-bits without needing a REX prefix.

Ah, so it makes the instruction smaller.  And I see that gcc also does
the same.  In that case:

Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh
