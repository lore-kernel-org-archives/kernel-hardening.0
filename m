MIME-Version: 1.0
In-Reply-To: <1502801449-29246-3-git-send-email-mark.rutland@arm.com>
References: <1502801449-29246-1-git-send-email-mark.rutland@arm.com> <1502801449-29246-3-git-send-email-mark.rutland@arm.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 15 Aug 2017 09:09:36 -0700
Message-ID: <CALCETrWAYvKTcgaQgEDC-ihhSuFAw9Phq-xF6FK5AMM6ag6j4A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCHv2 02/14] fork: allow arch-override of VMAP stack alignment
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Laura Abbott <labbott@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 15, 2017 at 5:50 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> In some cases, an architecture might wish its stacks to be aligned to a
> boundary larger than THREAD_SIZE. For example, using an alignment of
> double THREAD_SIZE can allow for stack overflows smaller than
> THREAD_SIZE to be detected by checking a single bit of the stack
> pointer.
>
> This patch allows architectures to override the alignment of VMAP'd
> stacks, by defining THREAD_ALIGN. Where not defined, this defaults to
> THREAD_SIZE, as is the case today.

This looks okay, but it might make sense to move that to a header file
so THREAD_ALIGN is always available.

>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Laura Abbott <labbott@redhat.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: linux-kernel@vger.kernel.org
> ---
>  kernel/fork.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 17921b0..696d692 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -217,7 +217,10 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
>                 return s->addr;
>         }
>
> -       stack = __vmalloc_node_range(THREAD_SIZE, THREAD_SIZE,
> +#ifndef THREAD_ALIGN
> +#define THREAD_ALIGN   THREAD_SIZE
> +#endif
> +       stack = __vmalloc_node_range(THREAD_SIZE, THREAD_ALIGN,
>                                      VMALLOC_START, VMALLOC_END,
>                                      THREADINFO_GFP,
>                                      PAGE_KERNEL,
> --
> 1.9.1
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
