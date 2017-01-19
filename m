Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 19 Jan 2017 12:34:06 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
References: <1484789346-21012-1-git-send-email-labbott@redhat.com>
 <1484789346-21012-3-git-send-email-labbott@redhat.com>
 <20170119111117.GB11176@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170119111117.GB11176@leverpostej>
Message-Id: <20170119113406.GC5110@osiris>
Subject: [kernel-hardening] Re: [PATCH 2/2] security: Change name of CONFIG_DEBUG_SET_MODULE_RONX
To: Mark Rutland <mark.rutland@arm.com>
Cc: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Jason Wessel <jason.wessel@windriver.com>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jessica Yu <jeyu@redhat.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 19, 2017 at 11:11:18AM +0000, Mark Rutland wrote:
> > +config HARDENED_MODULE_MAPPINGS
> > +	bool "Mark module mappings with stricter permissions (RO/W^X)"
> > +	default y
> > +	depends on ARCH_HAS_HARDENED_MODULE_MAPPINGS
> > +	help
> > +	  If this is set, module text and rodata memory will be made read-only,
> > +	  and non-text memory will be made non-executable. This provides
> > +	  protection against certain security vulnerabilities (e.g. modifying
> > +	  code)
> > +
> > +	  Unless your system has known restrictions or performance issues, it
> > +	  is recommended to say Y here.
> > +
> 
> I was hoping that we'd make this mandatory, as we'd already done for
> DEBUG_RODATA.

Same for s390: would be good to make this mandatory.
