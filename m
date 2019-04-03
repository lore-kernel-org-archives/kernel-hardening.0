MIME-Version: 1.0
References: <20190329081358.30497-1-elena.reshetova@intel.com>
In-Reply-To: <20190329081358.30497-1-elena.reshetova@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 3 Apr 2019 14:17:26 -0700
Message-ID: <CAGXu5jKH3js8pOv726jQ84rycd04OcwosN9-OkJg7UnsMMiuxA@mail.gmail.com>
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon syscall
Content-Type: text/plain; charset="UTF-8"
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@amacapital.net>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jannh@google.com>, "Perla, Enrico" <enrico.perla@intel.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 29, 2019 at 1:14 AM Elena Reshetova
<elena.reshetova@intel.com> wrote:
> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
> index 7bc105f47d21..28cb3687bf82 100644
> --- a/arch/x86/entry/common.c
> +++ b/arch/x86/entry/common.c
> @@ -32,6 +32,10 @@
>  #include <linux/uaccess.h>
>  #include <asm/cpufeature.h>
>
> +#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
> +#include <linux/random.h>
> +#endif
> +
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/syscalls.h>
>
> @@ -269,10 +273,22 @@ __visible inline void syscall_return_slowpath(struct pt_regs *regs)
>  }
>
>  #ifdef CONFIG_X86_64
> +
> +#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
> +void *alloca(size_t size);
> +#endif
> +
>  __visible void do_syscall_64(unsigned long nr, struct pt_regs *regs)
>  {
>         struct thread_info *ti;
>
> +#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
> +       size_t offset = ((size_t)prandom_u32()) % 256;
> +       char *ptr = alloca(offset);
> +
> +       asm volatile("":"=m"(*ptr));
> +#endif
> +
>         enter_from_user_mode();
>         local_irq_enable();
>         ti = current_thread_info();

Well this is delightfully short! The alloca() definition could even be
moved up after the #include of random.h, just to reduce the number of
#ifdef lines, too. I patched getpid() to report stack locations for a
given pid, just to get a sense of the entropy. On 10,000 getpid()
calls I see counts like:

    229  ffffa58240697dbc
    294  ffffa58240697dc4
    315  ffffa58240697dcc
    298  ffffa58240697dd4
    335  ffffa58240697ddc
    311  ffffa58240697de4
    295  ffffa58240697dec
    303  ffffa58240697df4
    334  ffffa58240697dfc
    331  ffffa58240697e04
    321  ffffa58240697e0c
    298  ffffa58240697e14
    290  ffffa58240697e1c
    306  ffffa58240697e24
    308  ffffa58240697e2c
    325  ffffa58240697e34
    301  ffffa58240697e3c
    336  ffffa58240697e44
    328  ffffa58240697e4c
    326  ffffa58240697e54
    314  ffffa58240697e5c
    305  ffffa58240697e64
    315  ffffa58240697e6c
    325  ffffa58240697e74
    287  ffffa58240697e7c
    319  ffffa58240697e84
    309  ffffa58240697e8c
    329  ffffa58240697e94
    311  ffffa58240697e9c
    306  ffffa58240697ea4
    313  ffffa58240697eac
    289  ffffa58240697eb4
     94  ffffa58240697ebc

So it looks more like 5 bits of entropy in practice (here are 33
unique stack locations), but that still looks good to me.

Can you send the next version with a CC to lkml too?

Andy, Thomas, how does this look to you?

-- 
Kees Cook
