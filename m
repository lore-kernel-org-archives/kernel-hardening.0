Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 26 Jul 2015 20:42:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20150726134519.GA1111@cachalot>
Message-ID: <alpine.DEB.2.11.1507262041590.18576@nanos>
References: <20150726134324.GA1068@cachalot> <20150726134519.GA1111@cachalot>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH 2/3] use POISON_POINTER_DELTA for poison pointers
To: Vasily Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 26 Jul 2015, Vasily Kulikov wrote:
> TIMER_ENTRY_STATIC and TAIL_MAPPING are defined as poison pointers which
> should point to nowhere.  Redefine them using POISON_POINTER_DELTA arithmetics
> to make sure they really point to non-mappable area declared by the
> target architecture.
> 
> Signed-off-by: Vasily Kulikov <segoon@openwall.com> 
> ---
>  include/linux/poison.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/poison.h b/include/linux/poison.h
> index ee697b9..a721bcd 100644
> --- a/include/linux/poison.h
> +++ b/include/linux/poison.h
> @@ -27,14 +27,14 @@
>   * Magic number "tsta" to indicate a static timer initializer
>   * for the object debugging code.
>   */
> -#define TIMER_ENTRY_STATIC	((void *) 0x74737461)
> +#define TIMER_ENTRY_STATIC	((void *) 0x300 + POISON_POINTER_DELTA)

Acked-by: Thomas Gleixner <tglx@linutronix.de>
