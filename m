Date: Tue, 6 Mar 2018 11:28:02 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH] arm: mm: Kconfig: Disable KUSER_HELPERS in ARMv6 or
 later as default
Message-ID: <20180306112802.GI9418@n2100.armlinux.org.uk>
References: <20180306112241.GA5938@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180306112241.GA5938@pjb1027-Latitude-E5410>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Jinbum Park <jinb.park7@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, mark.rutland@arm.com, vladimir.murzin@arm.com, keescook@chromium.org, gregkh@linuxfoundation.org, will.deacon@arm.com, catalin.marinas@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 06, 2018 at 08:22:41PM +0900, Jinbum Park wrote:
> Codes for KUSER_HELPERS can be abused as ROP gadaget,
> So that It's better to disable that as if possible.
> 
> Since over ARMv6 has ldrex/strex at user-space,
> NEED_KUSER_HELPERS is not selected for over ARMv6.
> 
> But, Even though NEED_KUSER_HELPERS is not selected,
> current configuration enable KUSER_HELPERS as default.
> 
> * as-is
> 
> - Enable KUSER_HELPERS as default even though over ARMv6.
> - User can disable KUSER_HELPERS.
> 
> * to-be
> 
> - Disable KUSER_HELPERS in ARMv6 or later as default.
> - User can enable KUSER_HELPERS for compatibility.
> 
> This change removes the unnecessary configuration that has security-risk.

NAK.

It is not this trivial or easy to make this change - you are assuming
that userspace does not use these, which is in incorrect assumption -
there are armhf distros out there that make use of the kuser helpers,
which means we can't disable it by default without causing userspace
regressions.

Therefore, it defaults to being enabled, unless someone decides to
disable it and knows for certain that their userspace does not depend
on this - it's a choice that distros have to make when building their
kernels with the knowledge of how their distro userspace is configured.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
