MIME-Version: 1.0
In-Reply-To: <20170815163036.GJ6090@leverpostej>
References: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
 <1502801449-29246-3-git-send-email-mark.rutland@arm.com> <CALCETrWAYvKTcgaQgEDC-ihhSuFAw9Phq-xF6FK5AMM6ag6j4A@mail.gmail.com>
 <20170815163036.GJ6090@leverpostej>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 15 Aug 2017 09:33:18 -0700
Message-ID: <CALCETrWP-cufvhLJU2Q7BPAYw+HmyzJHVWPvmmCS+bq84Up1zQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCHv2 02/14] fork: allow arch-override of VMAP stack alignment
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Laura Abbott <labbott@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 15, 2017 at 9:30 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Tue, Aug 15, 2017 at 09:09:36AM -0700, Andy Lutomirski wrote:
>> On Tue, Aug 15, 2017 at 5:50 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>> > In some cases, an architecture might wish its stacks to be aligned to a
>> > boundary larger than THREAD_SIZE. For example, using an alignment of
>> > double THREAD_SIZE can allow for stack overflows smaller than
>> > THREAD_SIZE to be detected by checking a single bit of the stack
>> > pointer.
>> >
>> > This patch allows architectures to override the alignment of VMAP'd
>> > stacks, by defining THREAD_ALIGN. Where not defined, this defaults to
>> > THREAD_SIZE, as is the case today.
>>
>> This looks okay, but it might make sense to move that to a header file
>> so THREAD_ALIGN is always available.
>
> I was a little worried about breaking things, since arches don't define
> THREAD_SIZE in a consistent location.
>
> Looking again, it looks like those are all transitiviely included into
> each arch's <asm/thread_info.h>, so I think I can move this into
> <linux/thread_info.h>, which'll have to be added to kernel.fork.c's
> includes.
>
> Are you happy with the below fixup?

LGTM.

>
> Thanks,
> Mark.
>
> ---->8----
> diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
> index 250a276..905d769 100644
> --- a/include/linux/thread_info.h
> +++ b/include/linux/thread_info.h
> @@ -38,6 +38,10 @@ enum {
>
>  #ifdef __KERNEL__
>
> +#ifndef THREAD_ALIGN
> +#define THREAD_ALIGN   THREAD_SIZE
> +#endif
> +
>  #ifdef CONFIG_DEBUG_STACK_USAGE
>  # define THREADINFO_GFP                (GFP_KERNEL_ACCOUNT | __GFP_NOTRACK | \
>                                  __GFP_ZERO)
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 696d692..f12882a 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -88,6 +88,7 @@
>  #include <linux/sysctl.h>
>  #include <linux/kcov.h>
>  #include <linux/livepatch.h>
> +#include <linux/thread_info.h>
>
>  #include <asm/pgtable.h>
>  #include <asm/pgalloc.h>
> @@ -217,9 +218,6 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
>                 return s->addr;
>         }
>
> -#ifndef THREAD_ALIGN
> -#define THREAD_ALIGN   THREAD_SIZE
> -#endif
>         stack = __vmalloc_node_range(THREAD_SIZE, THREAD_ALIGN,
>                                      VMALLOC_START, VMALLOC_END,
>                                      THREADINFO_GFP,
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
