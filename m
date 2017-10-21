References: <1507157703-14972-1-git-send-email-alex.popov@linux.com>
 <0bb962c4-92fb-156b-cee3-df48aff0552d@redhat.com>
 <53E66B61-665C-48A3-B266-863C5BAA6B6A@amacapital.net>
 <babc5b86-f625-bb28-d49e-9f34c3ca6726@linux.com>
 <CALCETrVF0-bz3A_8T-nghD_h8rs0N6NJBOM04scjMJdQq9ZLCA@mail.gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <4ec7b323-1de5-0de0-d196-4cb7f2d09ef4@linux.com>
Date: Sun, 22 Oct 2017 00:56:44 +0300
MIME-Version: 1.0
In-Reply-To: <CALCETrVF0-bz3A_8T-nghD_h8rs0N6NJBOM04scjMJdQq9ZLCA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v4 0/3] Introduce the STACKLEAK feature and a test for
 it
To: Andy Lutomirski <luto@amacapital.net>
Cc: Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Tycho Andersen <tycho@docker.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>

On 13.10.2017 20:26, Andy Lutomirski wrote:
> On Wed, Oct 11, 2017 at 9:29 AM, Alexander Popov <alex.popov@linux.com> wrote:
>> On 11.10.2017 05:31, Andy Lutomirski wrote:
>>> On Oct 10, 2017, at 6:19 PM, Laura Abbott <labbott@redhat.com> wrote:
>>>> I tried this series with CVE-2017-14954 . That particular bug
>>>> is not helped here because the poisoning has already been
>>>> overwritten by other leaf functions. Given the call stack this
>>>> may be a particularly bad case but I'm wondering how common
>>>> this might be if we're only erasing at the end of a system
>>>> call. One previous copy_to_user which has to go through the
>>>> fault path can get fairly deep.
>>
>> Laura, thanks for your observation. I've tested Brad's PoC with STACKLEAK too
>> and see similar results. There is only one STACKLEAK_POISON value in the leaked
>> data. Other leaked data is put on the stack by the current syscall.
>>
>> I don't know any statistics on infoleaks and I can't say how many of them would
>> be neutralized by STACKLEAK. But, anyway, it is be better than nothing for those
>> who accept the STACKLEAK performance penalty.
>>
>>> On x86, the bad guys can force this is using 32-bit fast syscalls for *any*
>>> syscall.  I suppose we could wipe the stack on the way out of exception
>>> handlers, too...
>>
>> Andy, excuse me, could you elaborate on that? Do you mean that there are some
>> more cases when erase_kstack() should be called?
> 
> Kinda.  I was thinking that certain exception handlers should erase
> their portion of the stack (i.e. from their entry frame to the bottom)
> when they return back to *kernel* mode. 

Andy, if we return to the kernel mode, which profit would we make out of
cleaning exception stacks?

I've spent some time learning arch/x86/entry/. But, honestly, I need help with
checking that erase_kstack() is called at the right places.

Anyway, I'll shortly send the 5-th version of the STACKLEAK patch series. And
I'll include your idea into the "further work" section in the cover letter.
Thank you.

Best regards,
Alexander
