Reply-To: kernel-hardening@lists.openwall.com
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Date: Fri, 05 Aug 2016 16:44:07 +0200
Message-ID: <1601227.1rWnhT6gJp@vostro.rjw.lan>
In-Reply-To: <20160805103713.GA8106@amd>
References: <1470071280-78706-1-git-send-email-thgarnie@google.com> <2464745.UmGP58NeXC@vostro.rjw.lan> <20160805103713.GA8106@amd>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Subject: [kernel-hardening] Re: [PATCH] x86/power/64: Do not refer to __PAGE_OFFSET from assembly code
To: Pavel Machek <pavel@denx.de>
Cc: the arch/x86 maintainers <x86@kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Friday, August 05, 2016 12:37:13 PM Pavel Machek wrote:
> On Wed 2016-08-03 01:19:26, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > When CONFIG_RANDOMIZE_MEMORY is set on x86-64, __PAGE_OFFSET becomes
> > a variable and using it as a symbol in the image memory restoration
> > assembly code under core_restore_code is not correct any more.
> 
> On a related note... we should really have page_offset variable in
> such case, and use that -- having __FOO_BAR not being a constant is
> ugly/confusing/dangerous.
> 
> > To avoid that problem, modify set_up_temporary_mappings() to compute
> > the physical address of the temporary page tables and store it in
> > temp_level4_pgt, so that the value of that variable is ready to be
> > written into CR3.  Then, the assembly code doesn't have to worry
> > about converting that value into a physical address and things work
> > regardless of whether or not CONFIG_RANDOMIZE_MEMORY is set.
> > 
> > Reported-and-tested-by: Thomas Garnier <thgarnie@google.com>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>
> 
> Is similar patch needed for i386?

Yes, it is, in general, for i386 hibernation to work with ASLR.

But it doesn't work with it for other reasons ATM, AFAICS.

Unfortunately, I won't really have the time to take care of this any time
soon.

Thanks,
Rafael
