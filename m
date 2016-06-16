Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160616183303.puhiggbbxza2bxcv@treble>
References: <cover.1466036668.git.luto@kernel.org> <f3202c855a2a61ae4c37d8b3835e00fb384c56b9.1466036668.git.luto@kernel.org>
 <20160616181642.r2bpceuvvffttp7r@treble> <CALCETrVK0f8FPJvuV_Tv8wfw8GpoDExDB66+jy=X44TmxCA6vw@mail.gmail.com>
 <20160616183303.puhiggbbxza2bxcv@treble>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 16 Jun 2016 11:37:07 -0700
Message-ID: <CALCETrWhDiOR_4b5PrJHrVDVVBUwq9sw2SW0XxzYybVUMXwA2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 10/13] x86/dumpstack: Try harder to get a call trace on
 stack overflow
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 16, 2016 at 11:33 AM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> On Thu, Jun 16, 2016 at 11:22:14AM -0700, Andy Lutomirski wrote:
>> On Thu, Jun 16, 2016 at 11:16 AM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>> > On Wed, Jun 15, 2016 at 05:28:32PM -0700, Andy Lutomirski wrote:
>> >> If we overflow the stack, print_context_stack will abort.  Detect
>> >> this case and rewind back into the valid part of the stack so that
>> >> we can trace it.
>> >>
>> >> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>> >> ---
>> >>  arch/x86/kernel/dumpstack.c | 7 +++++++
>> >>  1 file changed, 7 insertions(+)
>> >>
>> >> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
>> >> index d4d085e27d04..400a2e17c1d1 100644
>> >> --- a/arch/x86/kernel/dumpstack.c
>> >> +++ b/arch/x86/kernel/dumpstack.c
>> >> @@ -100,6 +100,13 @@ print_context_stack(struct thread_info *tinfo,
>> >>  {
>> >>       struct stack_frame *frame = (struct stack_frame *)bp;
>> >>
>> >> +     /*
>> >> +      * If we overflowed the stack into a guard page, jump back to the
>> >> +      * bottom of the usable stack.
>> >> +      */
>> >> +     if ((unsigned long)tinfo - (unsigned long)stack < PAGE_SIZE)
>> >> +             stack = (unsigned long *)tinfo + 1;
>> >
>> > That will start walking the stack in the middle of the thread_info
>> > struct.
>> >
>> > I think you meant:
>> >
>> >                 stack = (unsigned long *)(tinfo + 1)
>> >
>> > However, thread_info will have been overwritten anyway.  So maybe it
>> > should just be:
>> >
>> >                 stack = tinfo;
>> >
>> > (Though that still wouldn't quite work because the valid_stack_ptr()
>> > check would fail...)
>>
>> I did mean what I wrote, because I wanted to start at the bottom of
>> the validly allocated area.  IOW I wanted to do the minimum possible
>> backward jump to make the code display something.
>
> But why the "+ 1"?  Is that a hack to make it pass the valid_stack_ptr()
> check?

Yes.

But hmm.  Maybe the right fix is to drop the + 1 and to change the
last line of valid_stck_ptr from:

    return p > t && p < t + THREAD_SIZE - size;

to:

    return p >= t && p < t + THREAD_SIZE - size;

The current definition of valid_stack_ptr is certainly nonsensical.
It should either be p >= t or p >= t + 1.

--Andy
