Date: Mon, 24 Apr 2017 12:48:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170424104853.k6s2jjmcdbbghit4@hirez.programming.kicks-ass.net>
References: <20170421220939.GA65363@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170421220939.GA65363@beast>
Subject: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast refcount_t handling
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, x86@kernel.org, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, davem@davemloft.net, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 21, 2017 at 03:09:39PM -0700, Kees Cook wrote:
> diff --git a/drivers/misc/lkdtm_bugs.c b/drivers/misc/lkdtm_bugs.c
> index e3f4cd8876b5..1bdafb29b802 100644
> --- a/drivers/misc/lkdtm_bugs.c
> +++ b/drivers/misc/lkdtm_bugs.c
> @@ -135,9 +135,15 @@ void lkdtm_HUNG_TASK(void)
>  	schedule();
>  }
>  
> +#ifdef CONFIG_FAST_REFCOUNT
> +#define REFCOUNT_MAX	INT_MAX
> +#else
> +#define REFCOUNT_MAX	UINT_MAX
> +#endif

That doesn't seem like a sensible place for this.
