Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 23 Dec 2015 20:01:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Message-ID: <20151223200132.GW8644@n2100.arm.linux.org.uk>
References: <20151202202725.GA794@www.outflux.net>
 <20151223195129.GP2793@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151223195129.GP2793@atomide.com>
Sender: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [kernel-hardening] Re: [PATCH v2] ARM: mm: flip priority of CONFIG_DEBUG_RODATA
To: Tony Lindgren <tony@atomide.com>
Cc: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 23, 2015 at 11:51:29AM -0800, Tony Lindgren wrote:
> Also all omap3 boards are now oopsing in Linux next if PM is enabled:

I'm not sure that's entirely true.  My LDP3430 works fine with this
change in place, and that has CONFIG_PM=y.  See my nightly build/boot
results, which includes an attempt to enter hibernation.  Remember
that last night's results are from my tree plus arm-soc's for-next.

Maybe there's some other change in linux-next which, when combined
with this change, is provoking it?

-- 
RMK's Patch system: http://www.arm.linux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
