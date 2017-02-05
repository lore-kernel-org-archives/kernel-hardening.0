Date: Sun, 5 Feb 2017 16:40:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170205154046.GF6515@twins.programming.kicks-ass.net>
References: <1486164412-7338-1-git-send-email-keescook@chromium.org>
 <1486164412-7338-5-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486164412-7338-5-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH 4/4] refcount: Report failures through
 CHECK_DATA_CORRUPTION
To: Kees Cook <keescook@chromium.org>
Cc: elena.reshetova@intel.com, gregkh@linuxfoundation.org, arnd@arndb.de, tglx@linutronix.de, mingo@kernel.org, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, Hans Liljestrand <ishkamiel@gmail.com>, dhowells@redhat.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 03, 2017 at 03:26:52PM -0800, Kees Cook wrote:
> This converts from WARN_ON() to CHECK_DATA_CORRUPTION() in the
> CONFIG_DEBUG_REFCOUNT case. Additionally moves refcount_t sanity check
> conditionals into regular function flow. Since CHECK_DATA_CORRUPTION()
> is marked __much_check, we override few cases where the failure has
> already been handled but we want to explicitly report it.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/linux/refcount.h | 35 ++++++++++++++++++++++-------------
>  lib/Kconfig.debug        |  2 ++
>  2 files changed, 24 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/refcount.h b/include/linux/refcount.h
> index 5b89cad62237..ef32910c7dd8 100644
> --- a/include/linux/refcount.h
> +++ b/include/linux/refcount.h
> @@ -43,10 +43,10 @@
>  #include <linux/spinlock.h>
>  
>  #if CONFIG_DEBUG_REFCOUNT
> -#define REFCOUNT_WARN(cond, str) WARN_ON(cond)
> +#define REFCOUNT_CHECK(cond, str) CHECK_DATA_CORRUPTION(cond, str)

OK, so that goes back to a full WARN() which will make the generated
code gigantic due to the whole printk() trainwreck :/
