Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 12 Aug 2016 08:01:31 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
In-Reply-To: <1470952169-39061-1-git-send-email-thgarnie@google.com>
Message-ID: <alpine.LNX.2.00.1608120800100.22028@cbobk.fhfr.pm>
References: <1470952169-39061-1-git-send-email-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v1] x86/power/64: Restore processor state before using
 per-cpu variables
To: Thomas Garnier <thgarnie@google.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, keescook@chromium.org, kernel-hardening@lists.openwall.com, bpetkov@suse.de, yinghai@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 11 Aug 2016, Thomas Garnier wrote:

> Restore the processor state before calling any other function to ensure
> per-cpu variables can be used with KASLR memory randomization.
> 
> Tracing functions use per-cpu variables (gs based) and one was called
> just before restoring the processor state fully. It resulted in a double
> fault when both the tracing & the exception handler functions tried to
> use a per-cpu variable.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

Alright, this did the trick, thanks :) Feel free to add

	Reported-by: Jiri Kosina <jkosina@suse.cz>
	Tested-by: Jiri Kosina <jkosina@suse.cz>

One thing is still beyond me though ... how the heck this doesn't happen 
without DEBUG_LOCK_ALLOC? The percpu area pointer should be corrupted 
nevertheless, shouldn't it?

Thanks,

-- 
Jiri Kosina
SUSE Labs
