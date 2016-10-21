Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 21 Oct 2016 16:47:23 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Message-ID: <20161021074722.GU19531@linaro.org>
References: <1476802761-24340-1-git-send-email-colin@cvidal.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476802761-24340-1-git-send-email-colin@cvidal.org>
Subject: [kernel-hardening] Re: [RFC 0/2] arm: implementation of HARDENED_ATOMIC
To: Colin Vidal <colin@cvidal.org>
Cc: kernel-hardening@lists.openwall.com, "Reshetova, Elena" <elena.reshetova@intel.com>, David Windsor <dave@progbits.org>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 18, 2016 at 04:59:19PM +0200, Colin Vidal wrote:
> Hi,
> 
> This is the first attempt of HARDENED_ATOMIC port to arm arch.
> 
> About the fault handling I have some questions (perhaps some arm
> expert are reading?):
> 
>    - As the process that made the overflow is killed, the kernel will
>      not try to go to a fixup address when the exception is raised,
>      right ? Therefore, is still mandatory to add an entry in the
>      __extable section?
> 
>    - In do_PrefetchAbort, I am unsure the code that follow the call to
>      hardened_atomic_overflow is needed: the process will be killed
>      anyways.

I don't know.
Even in x86 implementation, when an overflow is detected, say,
in atomic_add(), the operation is supported to be canceled
(ie. by reverting the atomic_t variable to the original value).

-Takahiro AKASHI

> I take some freedom compared to PaX patch, especially by adding some
> macro to expand functions in arm/include/asm/atomic.h.
> 
> The first patch is the modification I have done is generic part to
> make it work.
> 
> Otherwise, I've been stuck by ccache. When I modify do_PrefetchAbort
> in arm/mm/fault.c, ccache does not detect the update (even if the file
> is recompiled by gcc). Therefore, when I boot the new compiled kernel,
> the old version of do_PrefechAbort is called. I know do_PrefetchAbort
> is somehow special, since called by assembly code, but is still
> strange. Someone has already has this issue? The only way to solve it
> is to flush the cache...
> 
> Thanks!
> 
> Colin
> 
> Colin Vidal (2):
>   Reordering / guard definition on atomic_*_wrap function in order to   
>      avoid implicitly defined / redefined error on them, when    
>     CONFIG_HARDENED_ATOMIC is unset.
>   arm: implementation for HARDENED_ATOMIC
> 
>  arch/arm/Kconfig                  |   1 +
>  arch/arm/include/asm/atomic.h     | 434 ++++++++++++++++++++++++++------------
>  arch/arm/mm/fault.c               |  15 ++
>  include/asm-generic/atomic-long.h |  55 ++---
>  include/linux/atomic.h            |  55 +++++
>  5 files changed, 405 insertions(+), 155 deletions(-)
> 
> -- 
> 2.7.4
> 
