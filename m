Date: Mon, 25 Sep 2017 11:23:23 -0600
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170925172323.zw5pgotm6b3gqoqv@smitten>
References: <1499883471-23822-1-git-send-email-alex.popov@linux.com>
 <20170815033834.2qbjj2of62udqyz3@smitten>
 <93382ef8-105f-eed4-0d97-0b1a66a047e6@linux.com>
 <20170816211636.4zwublkvpn6hbo5n@smitten>
 <CAGXu5j+qe052JAcZUe7mOBHAXNCdLT1z4U-2kRxoeJXyL6VxDQ@mail.gmail.com>
 <20170817175807.ejgsrfdgojgbtkwf@smitten>
 <1d0963e6-4a89-9859-5379-8575a925ef08@linux.com>
 <20170920211814.pq43vq3o53nh2xcn@smitten>
 <499874eb-48bb-f7f7-176a-b0b1e37cc9c6@linux.com>
 <7bf586cc-527c-eb3c-b86a-2adbbb7fdfda@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bf586cc-527c-eb3c-b86a-2adbbb7fdfda@linux.com>
Subject: [kernel-hardening] Re: [PATCH RFC v3 1/1] gcc-plugins: Add stackleak feature erasing
 the kernel stack at the end of syscalls
To: Alexander Popov <alex.popov@linux.com>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "x86@kernel.org" <x86@kernel.org>, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Alexander,

On Mon, Sep 25, 2017 at 07:17:32PM +0300, Alexander Popov wrote:
> Hello Tycho,
> 
> On 21.09.2017 22:39, Alexander Popov wrote:
> > On 21.09.2017 00:18, Tycho Andersen wrote:
> >> +	/*
> >> +	 * Check each byte, as we don't know the current stack alignment.
> >> +	 */
> > 
> > Excuse me, what do you mean by the "current stack alignment"?
> 
> I guess I got it now. For x86 and x86_64 the stack alignment is controlled by
> cc_stack_align in arch/x86/Makefile (-mpreferred-stack-boundary in case of gcc).
> The stack is 4-byte aligned for x86 and 8-byte aligned for x86_64.
> 
> > The STACKLEAK_POISON position is always 8-byte aligned for x86_64 and 4-byte
> > aligned for x86 (see the shr instruction in the asm implementation).
> 
> Eh, my statement is wrong. I've made a simple experiment: this change makes the
> poison be unaligned:
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 56bdc19..893d2e4 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1961,7 +1961,7 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
>  #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>  void __used track_stack(void)
>  {
> -       unsigned long sp = (unsigned long)&sp;
> +       unsigned long sp = (unsigned long)&sp + 1;

Yep, this is the case I was talking about with alignment.

> 
>         if (sp < current->thread.lowest_stack &&
>             sp >= (unsigned long)task_stack_page(current) +
> 
> 
> So your idea to check each byte at first should work fine.
> 
> Would you allow me to make the next version of your test and include it into the
> fourth version of the STACKLEAK patch? I'll show it to you before sending to the
> mailing list.

Sure, that works for me.

Tycho
