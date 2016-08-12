Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 12 Aug 2016 07:49:13 +0200
From: Borislav Petkov <bp@suse.de>
Message-ID: <20160812054913.GA24303@nazgul.tnic>
References: <1470952169-39061-1-git-send-email-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1470952169-39061-1-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] Re: [PATCH v1] x86/power/64: Restore processor state before using
 per-cpu variables
To: Thomas Garnier <thgarnie@google.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, keescook@chromium.org, kernel-hardening@lists.openwall.com, jikos@kernel.org, yinghai@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 11, 2016 at 02:49:29PM -0700, Thomas Garnier wrote:
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

Ok, I believe before I test this, I need to apply another patch from
Rafael. I think it is the "Always create temporary identity mapping
correctly" thing.

Yes, no?

Rafael, can you please apply everything on a test branch for us to run?

Thanks.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
--
