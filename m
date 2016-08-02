Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 2 Aug 2016 11:55:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20160802095546.GE6862@twins.programming.kicks-ass.net>
References: <1469630783-32413-1-git-send-email-jeffv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1469630783-32413-1-git-send-email-jeffv@google.com>
Subject: [kernel-hardening] Re: [PATCH 2/2] security, perf: Add config option to restrict
 perf_event_open
To: Jeff Vander Stoep <jeffv@google.com>
Cc: kernel-hardening@lists.openwall.com, mingo@redhat.com, acme@kernel.org, alexander.shishkin@linux.intel.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 27, 2016 at 07:46:23AM -0700, Jeff Vander Stoep wrote:
> +++ b/kernel/events/core.c
> @@ -355,7 +355,11 @@ static struct srcu_struct pmus_srcu;
>   *   2 - disallow kernel profiling for unpriv
>   *   3 - disallow all unpriv perf event use
>   */
> +#ifdef CONFIG_SECURITY_PERF_EVENTS_RESTRICT
> +int sysctl_perf_event_paranoid __read_mostly = 3;
> +#else
>  int sysctl_perf_event_paranoid __read_mostly = 2;
> +#endif
>  
>  /* Minimum for 512 kiB + 1 user control page */
>  int sysctl_perf_event_mlock __read_mostly = 512 + (PAGE_SIZE / 1024); /* 'free' kiB per user */
> diff --git a/security/Kconfig b/security/Kconfig
> index df28f2b..2a93551 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -18,6 +18,15 @@ config SECURITY_DMESG_RESTRICT
>  
>  	  If you are unsure how to answer this question, answer N.
>  
> +config SECURITY_PERF_EVENTS_RESTRICT
> +	bool "Restrict unprivileged use of performance events"
> +	depends on PERF_EVENTS
> +	help
> +	  If you say Y here, the kernel.perf_event_paranoid sysctl
> +	  will be set to 3 by default, and no unprivileged use of the
> +	  perf_event_open syscall will be permitted unless it is
> +	  changed.

NAK.

Apart from the fact that I hate the 3 thing this is not how you do
default CONFIG knobs for !bool state variables.

Use an "int" config not a "bool" config and allow all options to be
default.
