Date: Fri, 17 Feb 2017 18:23:13 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170217182313.GB25876@leverpostej>
References: <1486427518-14819-1-git-send-email-labbott@redhat.com>
 <1486427518-14819-3-git-send-email-labbott@redhat.com>
 <20170216222529.GA7531@amd>
 <CAGXu5jJ4FD=6HLK_21T079JrO569DwWBTeiD18x3WRrYBsaAqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ4FD=6HLK_21T079JrO569DwWBTeiD18x3WRrYBsaAqw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCHv3 2/2] arch: Rename CONFIG_DEBUG_RODATA and
 CONFIG_DEBUG_MODULE_RONX
To: Kees Cook <keescook@chromium.org>
Cc: Pavel Machek <pavel@ucw.cz>, Laura Abbott <labbott@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, "H. Peter Anvin" <hpa@zytor.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Rob Herring <robh@kernel.org>, Jessica Yu <jeyu@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Helge Deller <deller@gmx.de>, "x86@kernel.org" <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Len Brown <len.brown@intel.com>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-parisc <linux-parisc@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, LKML <linux-kernel@vger.kernel.org>, Jason Wessel <jason.wessel@windriver.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Robin Murphy <robin.murphy@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 16, 2017 at 05:08:20PM -0800, Kees Cook wrote:
> On Thu, Feb 16, 2017 at 2:25 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >>
> >> -config DEBUG_RODATA
> >> +config STRICT_KERNEL_RWX
> >>       bool "Make kernel text and rodata read-only" if ARCH_OPTIONAL_KERNEL_RWX
> >>       depends on ARCH_HAS_STRICT_KERNEL_RWX
> >>       default !ARCH_OPTIONAL_KERNEL_RWX ||
> >
> > Debug features are expected to have runtime cost, so kconfig help is
> > silent about those. But there are runtime costs, right? It would be
> > nice to mention them in the help text...
> 
> It depends on the architecture. The prior help text for arm said:
> 
>          The tradeoff is that each region is padded to section-size (1MiB)
>          boundaries (because their permissions are different and splitting
>          the 1M pages into 4K ones causes TLB performance problems), which
>          can waste memory.
> 
> parisc (somewhat inaccurately) said:
> 
>          This option may have a slight performance impact because a
>          portion of the kernel code won't be covered by a TLB anymore.
> 
> IIUC, arm64 does what parisc is hinting at: mappings at the end are
> broken down to PAGE_SIZE. On x86, IIUC, there's actually no change to
> TLB performance due to how the mappings are already set up.

On arm64, we split down to page granularity if needed, but use the
largest possible mapping we can (e.g. if we can use a 2M block, we do).

Because of the way we freed the init area, we already couldn't use
larger mappings anyway. Applying the strict permissions didn't come at a
measureable overhead in any real testing.

> I'm not sure the best way to express this in the new help text. Do you
> have some suggestions on wording? Personally, I don't really think
> it's worth mentioning this in Kconfig help, which, in theory, is
> supposed to limit how technical it gets. And I think the performance
> impact is almost entirely negligible compared to the risks addressed.

I also don't see much point in describing some hypothetical architecture
specific overhead here. In most cases this can't be turned off (so there
isn't anything to comapre it to, and hence no cost). Where people want
to turn it off, they already know why they wish to do so.

Thanks,
Mark.
