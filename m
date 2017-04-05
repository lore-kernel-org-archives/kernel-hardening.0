Message-ID: <1491371241.22446.11.camel@hellion.org.uk>
From: Ian Campbell <ijc@hellion.org.uk>
Date: Wed, 05 Apr 2017 06:47:21 +0100
In-Reply-To: <1491343938-75336-2-git-send-email-keescook@chromium.org>
References: <1491343938-75336-1-git-send-email-keescook@chromium.org>
	 <1491343938-75336-2-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] [PATCH v2 1/7] bug: Clarify help text for
 BUG_ON_DATA_CORRUPTION
To: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Kalle Valo <kvalo@codeaurora.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Viresh Kumar <viresh.kumar@linaro.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Olof Johansson <olof@lixom.net>, Chris Wilson <chris@chris-wilson.co.uk>, George Spelvin <linux@sciencehorizons.net>, Thomas Gleixner <tglx@linutronix.de>, Josh Poimboeuf <jpoimboe@redhat.com>, David Windsor <dwindsor@gmail.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 77fadface4f9..5ac4d1148385 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1998,9 +1998,12 @@ config BUG_ON_DATA_CORRUPTION
> >  	bool "Trigger a BUG when data corruption is detected"
> >  	select DEBUG_LIST
> >  	help
> > -	  Select this option if the kernel should BUG when it encounters
> > -	  data corruption in kernel memory structures when they get checked
> > -	  for validity.
> > +	  This option enables several inexpensive data corruption checks.
> > +	  Most of these checks normally just WARN and try to further avoid
> +	  the corruption. Selecting this option upgrades these to BUGs so

First it says it enables some checks, but here it says it upgrades them
to BUGs which seems inconsistent.

> +	  that the offending process is killed. Additionally, the system
> +	  owner can furhter configure the system for immediate reboots

                   "further"

> +	  (via panic_on_oops sysctl) or crash dumps.
>  
> >  	  If unsure, say N.
>  
