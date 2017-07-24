MIME-Version: 1.0
In-Reply-To: <20170719175900.124074-1-thgarnie@google.com>
References: <20170719175900.124074-1-thgarnie@google.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Mon, 24 Jul 2017 10:07:09 -0700
Message-ID: <CAJcbSZFw9GhVvNfYi1oHhpintHSzGcHvGjg5LtRViNBPDzLHaA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 1/3] arm/syscalls: Move address limit check in loop
To: Russell King <linux@armlinux.org.uk>, Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dave Martin <Dave.Martin@arm.com>, Chris Metcalf <cmetcalf@mellanox.com>, Pratyush Anand <panand@redhat.com>, Leonard Crestez <leonard.crestez@nxp.com>
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 19, 2017 at 10:58 AM, Thomas Garnier <thgarnie@google.com> wrote:
> The work pending loop can call set_fs after addr_limit_user_check
> removed the _TIF_FSCHECK flag. To prevent the infinite loop, move
> the addr_limit_user_check call at the beginning of the loop.
>
> Fixes: 73ac5d6a2b6a ("arm/syscalls: Check address limit on user-mode return")
> Reported-by: Leonard Crestez <leonard.crestez@nxp.com>
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

Any comments on this patch set?

> ---
>  arch/arm/kernel/signal.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
> index 3a48b54c6405..f4574287d14b 100644
> --- a/arch/arm/kernel/signal.c
> +++ b/arch/arm/kernel/signal.c
> @@ -573,10 +573,10 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
>          */
>         trace_hardirqs_off();
>
> -       /* Check valid user FS if needed */
> -       addr_limit_user_check();
> -
>         do {
> +               /* Check valid user FS if needed */
> +               addr_limit_user_check();
> +
>                 if (likely(thread_flags & _TIF_NEED_RESCHED)) {
>                         schedule();
>                 } else {
> --
> 2.14.0.rc0.284.gd933b75aa4-goog
>



-- 
Thomas
