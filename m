MIME-Version: 1.0
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com> <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 20 Feb 2019 14:04:53 -0800
Message-ID: <CAGXu5j+OBohkiXZQ3rZENRhvQgcjBemoTvXVZK4Bc=KsS1fhpw@mail.gmail.com>
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon
 system call
Content-Type: text/plain; charset="UTF-8"
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, Alexander Popov <alex.popov@linux.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 8, 2019 at 4:16 AM Elena Reshetova
<elena.reshetova@intel.com> wrote:
> +.macro RANDOMIZE_KSTACK_NOCLOBBER
> +#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
> +       PUSH_AND_CLEAR_REGS
> +       call randomize_kstack
> +       POP_REGS
> +#endif
> +.endm
> +
> [...]
> @@ -268,6 +268,8 @@ syscall_return_via_sysret:
>          */
>         STACKLEAK_ERASE_NOCLOBBER
>
> +       RANDOMIZE_KSTACK_NOCLOBBER

Probably we could extract the PUSH_AND_CLEAR_REGS and POP_REGS out
here from both this and stackleak to avoid doing it twice?

-- 
Kees Cook
