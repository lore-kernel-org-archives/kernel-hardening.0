Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CALCETrU6fFNJDNvKn2ZJDz+5CW22mWb5nH6AXmNbGUvC4t2RSA@mail.gmail.com>
References: <cover.1466974736.git.luto@kernel.org> <f0a81fa3f7f81422cca23c9d6c88a555d89787ab.1466974736.git.luto@kernel.org>
 <CAMzpN2gBgZbBBJ_kAT=fty7=8z3xDyv2gzz9xuGLoK7EUuHh0A@mail.gmail.com>
 <CAMzpN2ggqbwkfNjHtYg3KU5oeerU6NPa0AqzG7PFtJuWy3dyKA@mail.gmail.com>
 <CALCETrWQCpNWum5WofkApw4Ht+KB5H=tmPS5GummTFsSVfNF7g@mail.gmail.com>
 <CALCETrXVtjPQHx2g_O3HRr-DNLWRpDL3Pftt2peoVrfNGiSucA@mail.gmail.com>
 <CAMzpN2jVghmEbpx7yyOVcOa4GMw8iRUez0WeehGYnrtdm7Ad1w@mail.gmail.com> <CALCETrU6fFNJDNvKn2ZJDz+5CW22mWb5nH6AXmNbGUvC4t2RSA@mail.gmail.com>
From: Brian Gerst <brgerst@gmail.com>
Date: Mon, 27 Jun 2016 13:09:13 -0400
Message-ID: <CAMzpN2if-Nr=msVbh2MUWoasQuPdYCbd6rN21A+dqzEptrB=eA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 15/29] x86/mm/64: Enable vmapped stacks
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 27, 2016 at 12:35 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, Jun 27, 2016 at 9:17 AM, Brian Gerst <brgerst@gmail.com> wrote:
>> On Mon, Jun 27, 2016 at 11:54 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Mon, Jun 27, 2016 at 8:22 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>> On Mon, Jun 27, 2016 at 8:12 AM, Brian Gerst <brgerst@gmail.com> wrote:
>>>>> On Mon, Jun 27, 2016 at 11:01 AM, Brian Gerst <brgerst@gmail.com> wrote:
>>>>>> On Sun, Jun 26, 2016 at 5:55 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>>>>>>  #ifdef CONFIG_X86_64
>>>>>>>  /* Runs on IST stack */
>>>>>>>  dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
>>>>>>>  {
>>>>>>>         static const char str[] = "double fault";
>>>>>>>         struct task_struct *tsk = current;
>>>>>>> +#ifdef CONFIG_VMAP_STACK
>>>>>>> +       unsigned long cr2;
>>>>>>> +#endif
>>>>>>>
>>>>>>>  #ifdef CONFIG_X86_ESPFIX64
>>>>>>>         extern unsigned char native_irq_return_iret[];
>>>>>>> @@ -332,6 +350,20 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
>>>>>>>         tsk->thread.error_code = error_code;
>>>>>>>         tsk->thread.trap_nr = X86_TRAP_DF;
>>>>>>>
>>>>>>> +#ifdef CONFIG_VMAP_STACK
>>>>>>> +       /*
>>>>>>> +        * If we overflow the stack into a guard page, the CPU will fail
>>>>>>> +        * to deliver #PF and will send #DF instead.  CR2 will contain
>>>>>>> +        * the linear address of the second fault, which will be in the
>>>>>>> +        * guard page below the bottom of the stack.
>>>>>>> +        */
>>>>>>> +       cr2 = read_cr2();
>>>>>>> +       if ((unsigned long)tsk->stack - 1 - cr2 < PAGE_SIZE)
>>>>>>> +               handle_stack_overflow(
>>>>>>> +                       "kernel stack overflow (double-fault)",
>>>>>>> +                       regs, cr2);
>>>>>>> +#endif
>>>>>>
>>>>>> Is there any other way to tell if this was from a page fault?  If it
>>>>>> wasn't a page fault then CR2 is undefined.
>>>>>
>>>>> I guess it doesn't really matter, since the fault is fatal either way.
>>>>> The error message might be incorrect though.
>>>>>
>>>>
>>>> It's at least worth a comment, though.  Maybe I should check if
>>>> regs->rsp is within 40 bytes of the bottom of the stack, too, such
>>>> that delivery of an inner fault would have double-faulted assuming the
>>>> inner fault didn't use an IST vector.
>>>>
>>>
>>> How about:
>>>
>>>     /*
>>>      * If we overflow the stack into a guard page, the CPU will fail
>>>      * to deliver #PF and will send #DF instead.  CR2 will contain
>>>      * the linear address of the second fault, which will be in the
>>>      * guard page below the bottom of the stack.
>>>      *
>>>      * We're limited to using heuristics here, since the CPU does
>>>      * not tell us what type of fault failed and, if the first fault
>>>      * wasn't a page fault, CR2 may contain stale garbage.  To mostly
>>>      * rule out garbage, we check if the saved RSP is close enough to
>>>      * the bottom of the stack to cause exception delivery to fail.
>>>      * The worst case is 7 stack slots: one for alignment, five for
>>>      * SS..RIP, and one for the error code.
>>>      */
>>>     tsk_stack = (unsigned long)task_stack_page(tsk);
>>>     if (regs->rsp <= tsk_stack + 7*8 && regs->rsp > tsk_stack - PAGE_SIZE) {
>>>         /* A double-fault due to #PF delivery failure is plausible. */
>>>         cr2 = read_cr2();
>>>         if (tsk_stack - 1 - cr2 < PAGE_SIZE)
>>>             handle_stack_overflow(
>>>                 "kernel stack overflow (double-fault)",
>>>                 regs, cr2);
>>>     }
>>
>> I think RSP anywhere in the guard page would be best, since it could
>> have been decremented by a function prologue into the guard page
>> before an access that triggers the page fault.
>>
>
> I think that can miss some stack overflows.  Suppose that RSP points
> very close to the bottom of the stack and we take an unrelated fault.
> The CPU can fail to deliver that fault and we get a double fault
> instead.  But I counted wrong, too.  Do you like this version and its
> explanation?
>
>     /*
>      * If we overflow the stack into a guard page, the CPU will fail
>      * to deliver #PF and will send #DF instead.  Similarly, if we
>      * take any non-IST exception while too close to the bottom of
>      * the stack, the processor will get a page fault while
>      * delivering the exception and will generate a double fault.
>      *
>      * According to the SDM (footnote in 6.15 under "Interrupt 14 -
>      * Page-Fault Exception (#PF):
>      *
>      *   Processors update CR2 whenever a page fault is detected. If a
>      *   second page fault occurs while an earlier page fault is being
>      *   deliv- ered, the faulting linear address of the second fault will
>      *   overwrite the contents of CR2 (replacing the previous
>      *   address). These updates to CR2 occur even if the page fault
>      *   results in a double fault or occurs during the delivery of a
>      *   double fault.
>      *
>      * However, if we got here due to a non-page-fault exception while
>      * delivering a non-page-fault exception, CR2 may contain a
>      * stale value.
>      *
>      * As a heuristic: we consider this double fault to be a stack
>      * overflow if CR2 points to the guard page and RSP is either
>      * in the guard page or close enough to the bottom of the stack
>      *
>      * We're limited to using heuristics here, since the CPU does
>      * not tell us what type of fault failed and, if the first fault
>      * wasn't a page fault, CR2 may contain stale garbage.  To
>      * mostly rule out garbage, we check if the saved RSP is close
>      * enough to the bottom of the stack to cause exception delivery
>      * to fail.  If RSP == tsk_stack + 48 and we take an exception,
>      * the stack is already aligned and there will be enough room
>      * SS, RSP, RFLAGS, CS, RIP, and a possible error code.  With
>      * any less space left, exception delivery could fail.
>      */
>     tsk_stack = (unsigned long)task_stack_page(tsk);
>     if (regs->rsp < tsk_stack + 48 && regs->rsp > tsk_stack - PAGE_SIZE) {
>         /* A double-fault due to #PF delivery failure is plausible. */
>         cr2 = read_cr2();
>         if (tsk_stack - 1 - cr2 < PAGE_SIZE)
>             handle_stack_overflow(
>                 "kernel stack overflow (double-fault)",
>                 regs, cr2);
>     }

Actually I think your quote from the SDM contradicts this.  The second
#PF (when trying to invoke the page fault handler) would update CR2
with an address in the guard page.

--
Brian Gerst
