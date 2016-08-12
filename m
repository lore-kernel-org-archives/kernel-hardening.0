Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 12 Aug 2016 08:29:19 +0200
From: Pavel Machek <pavel@denx.de>
Message-ID: <20160812062919.GC30992@amd>
References: <1470952169-39061-1-git-send-email-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1470952169-39061-1-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] Re: [PATCH v1] x86/power/64: Restore processor state before using
 per-cpu variables
To: Thomas Garnier <thgarnie@google.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, keescook@chromium.org, kernel-hardening@lists.openwall.com, jikos@kernel.org, bpetkov@suse.de, yinghai@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi!

> Restore the processor state before calling any other function to ensure
> per-cpu variables can be used with KASLR memory randomization.
> 
> Tracing functions use per-cpu variables (gs based) and one was called
> just before restoring the processor state fully. It resulted in a double
> fault when both the tracing & the exception handler functions tried to
> use a per-cpu variable.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
> Based on next-20160808
> 
> Thanks to Rafael, Jiri & Borislav in tracking down this bug.
> ---
>  kernel/power/hibernate.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index a881c6a..33c79b6 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -300,12 +300,12 @@ static int create_image(int platform_mode)
>  	save_processor_state();
>  	trace_suspend_resume(TPS("machine_suspend"), PM_EVENT_HIBERNATE, true);
>  	error = swsusp_arch_suspend();
> +	/* Restore control flow magically appears here */
> +	restore_processor_state();
>  	trace_suspend_resume(TPS("machine_suspend"), PM_EVENT_HIBERNATE, false);
>  	if (error)
>  		printk(KERN_ERR "PM: Error %d creating hibernation image\n",
>  			error);
> -	/* Restore control flow magically appears here */
> -	restore_processor_state();
>  	if (!in_suspend)
>  		events_check_enabled = false;
>  

Ugh. Plus it also fixes very confusing situation where /* Restore
control flow magically appears here */ comment was 4 lines away from
where it _actually_ magically appeared. Good catch.

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
