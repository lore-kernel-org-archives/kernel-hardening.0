MIME-Version: 1.0
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com> <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 8 Feb 2019 13:28:02 -0800
Message-ID: <CAGXu5jKctN4SQr4H-jPywEw4Te+ObVZSV0bUR5MLqu1ZrgNEBA@mail.gmail.com>
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon
 system call
Content-Type: text/plain; charset="UTF-8"
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 8, 2019 at 4:16 AM Elena Reshetova
<elena.reshetova@intel.com> wrote:
> --- a/mm/usercopy.c
> +++ b/mm/usercopy.c
> @@ -37,7 +37,7 @@
>  static noinline int check_stack_object(const void *obj, unsigned long len)
>  {
>         const void * const stack = task_stack_page(current);
> -       const void * const stackend = stack + THREAD_SIZE;
> +       const void * const stackend = (void *)task_top_of_stack(current);
>         int ret;
>
>         /* Object is not on the stack at all. */

It seems like having task_top_of_stack() would be a nice refactoring
to have regardless of this feature (and splitting out would make this
patch a bit easier to read too).

-- 
Kees Cook
