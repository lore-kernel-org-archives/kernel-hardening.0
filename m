Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 6 Apr 2016 22:17:16 +0200
From: Pavel Machek <pavel@denx.de>
Message-ID: <20160406201716.GA14241@amd>
References: <20160406194404.GA11150@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160406194404.GA11150@www.outflux.net>
Subject: [kernel-hardening] Re: [PATCH] Prefer kASLR over Hibernation
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Yves-Alexis Perez <corsac@debian.org>, Emrah Demir <ed@abdsec.com>, Jonathan Corbet <corbet@lwn.net>, x86@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, linux-doc@vger.kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi!

> When building with both CONFIG_HIBERNATION and CONFIG_RANDOMIZE_BASE,
> one or the other must be chosen at boot-time. Until now, hibernation
> was selected when no choice was made on the command line.
> 
> To make the security benefits of kASLR more widely available to end
> users (since the use of hibernation is becoming more rare and kASLR,
> already available on x86, will be available on arm64 and MIPS soon),
> this changes the default to preferring kASLR over hibernation. Users
> wanting hibernation can turn off kASLR by adding "nokaslr" to the kernel
> command line.

I must say I don't exactly like this patch.

Why is kASLR incompatible with hibernation? We can hibernate have 
4.3 kernel resume hibernation image of 4.2 kernel (on x86-64, and I
have patches for x86). Resuming kernel with different randomization
does not look that much different...

Best regards,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
