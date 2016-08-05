Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 5 Aug 2016 12:37:13 +0200
From: Pavel Machek <pavel@denx.de>
Message-ID: <20160805103713.GA8106@amd>
References: <1470071280-78706-1-git-send-email-thgarnie@google.com>
 <CAJcbSZFC-qeEySJYO9DFs=HfE087QHROW=opDRCmZo2WXB1gqw@mail.gmail.com>
 <CAJZ5v0hiZwugdV6OjA7hAHAv5jhjgJM1vPAW-RHUHud0F=5KsQ@mail.gmail.com>
 <2464745.UmGP58NeXC@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2464745.UmGP58NeXC@vostro.rjw.lan>
Subject: [kernel-hardening] Re: [PATCH] x86/power/64: Do not refer to __PAGE_OFFSET from
 assembly code
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: the arch/x86 maintainers <x86@kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed 2016-08-03 01:19:26, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> When CONFIG_RANDOMIZE_MEMORY is set on x86-64, __PAGE_OFFSET becomes
> a variable and using it as a symbol in the image memory restoration
> assembly code under core_restore_code is not correct any more.

On a related note... we should really have page_offset variable in
such case, and use that -- having __FOO_BAR not being a constant is
ugly/confusing/dangerous.

> To avoid that problem, modify set_up_temporary_mappings() to compute
> the physical address of the temporary page tables and store it in
> temp_level4_pgt, so that the value of that variable is ready to be
> written into CR3.  Then, the assembly code doesn't have to worry
> about converting that value into a physical address and things work
> regardless of whether or not CONFIG_RANDOMIZE_MEMORY is set.
> 
> Reported-and-tested-by: Thomas Garnier <thgarnie@google.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

Is similar patch needed for i386?

Best regards,
								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
