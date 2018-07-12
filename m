MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180629190553.7282-1-labbott@redhat.com>
References: <20180629190553.7282-1-labbott@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 11 Jul 2018 17:05:32 -0700
Message-ID: <CAGXu5jLwhdKy6rfSKOeN2hajP5aCnYeT3yMka5ZbJ_o02z=WTA@mail.gmail.com>
Subject: Re: [PATCH] arm64: Clear the stack
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Alexander Popov <alex.popov@linux.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 29, 2018 at 12:05 PM, Laura Abbott <labbott@redhat.com> wrote:
>  include/linux/stackleak.h             |  1 +
> [...]
> diff --git a/include/linux/stackleak.h b/include/linux/stackleak.h
> index e2da99b3a191..00d62b302efb 100644
> --- a/include/linux/stackleak.h
> +++ b/include/linux/stackleak.h
> @@ -5,6 +5,7 @@
>  #include <linux/sched.h>
>  #include <linux/sched/task_stack.h>
>
> +#include <asm/stacktrace.h>
>  /*
>   * Check that the poison value points to the unused hole in the
>   * virtual memory map for your platform.

FYI, I squashed this change into my copy of the stackleak v14 series.
(And I just sent this arm64 patch with the adjustments for it to be
stand-alone.)

-Kees

-- 
Kees Cook
Pixel Security
