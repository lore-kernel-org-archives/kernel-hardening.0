MIME-Version: 1.0
In-Reply-To: <20180827185631.163506-6-jannh@google.com>
References: <20180827185631.163506-1-jannh@google.com> <20180827185631.163506-6-jannh@google.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 27 Aug 2018 12:08:49 -0700
Message-ID: <CALCETrXSfLVcGGPM5=XJ8hxaN_sO2faS7iu8JzJdeYDaWc_rPg@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] x86: plumb error code and fault address through to
 fault handlers
Content-Type: text/plain; charset="UTF-8"
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, linux-edac <linux-edac@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 27, 2018 at 11:56 AM, Jann Horn <jannh@google.com> wrote:
> This is preparation for looking at trap number and fault address in the
> handlers for uaccess errors.
> This patch should not change any behavior.

Confused.  $SUBJECT says you're plumbing the error code through, and
you are sort of doing it:

> -int fixup_exception(struct pt_regs *regs, int trapnr)
> +int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
> +                   unsigned long fault_addr)
>  {

It's available here...

>         const struct exception_table_entry *e;
>         ex_handler_t handler;
> @@ -202,7 +212,7 @@ int fixup_exception(struct pt_regs *regs, int trapnr)
>                 return 0;
>
>         handler = ex_fixup_handler(e);
> -       return handler(e, regs, trapnr);
> +       return handler(e, regs, trapnr, fault_addr);

... but you don't pass it into the handlers.  Is this intentional?
