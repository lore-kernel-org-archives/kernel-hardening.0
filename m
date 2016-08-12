Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 12 Aug 2016 17:24:14 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Message-ID: <20160812162414.GI1041@n2100.armlinux.org.uk>
References: <1464979224-2085-1-git-send-email-keescook@chromium.org>
 <2760702.46Rp2Juk5b@wuerfel>
 <20160810230645.GP1041@n2100.armlinux.org.uk>
 <2188666.QKZtt2vNXZ@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2188666.QKZtt2vNXZ@wuerfel>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: [kernel-hardening] Re: [PATCH 2/2] arm: apply more __ro_after_init
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Kees Cook <keescook@chromium.org>, linux-arch <linux-arch@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Mathias Krause <minipli@googlemail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 11, 2016 at 05:54:08PM +0200, Arnd Bergmann wrote:
> On Thursday, August 11, 2016 12:06:45 AM CEST Russell King - ARM Linux wrote:
> > On Wed, Aug 10, 2016 at 09:41:23PM +0200, Arnd Bergmann wrote:
> > > It might be better to start by making the fixed mapping readonly,
> > > as KASLR doesn't protect that one at all, and change the TLS
> > > code accordingly.
> > 
> > I think that's impossible, because we gave userspace permission to
> > read 0xffff0ff0 directly without using __kuser_get_tls.  You're
> > talking about potentially breaking userspace.
> > 
> > If you disable kuser helpers, then the page becomes read-only and
> > invisible to userspace anyway.  So, everything is being done there
> > which can be done - if you have kuser helpers enabled, then you
> > lose some opportunities for these security improvements.
> 
> What I meant was writing to the page through the linear mapping
> rather than the virtual mapping at 0xffff0000 so we can leave that
> one read-only (I did not consider whether that might cause cache
> aliasing problems when reading from the other address).

Kees original patch was about moving the vector pages into the
read-only area after init, so the linear mapping of them becomes
read-only as well.  So that won't work.  We need at least one
read-write mapping for FIQ, and for context switching for kuser
helpers.

> Your other point is more important though: if one really cares
> about optimizing security here, they probably should disable
> kuser helpers completely anyway.

We could probably predicate moving the vectors page into the RO
section when kuser helpers are enabled.

> Kees, is that something you have on your radar already?

I believe Android already disable kuser helpers as of a few years ago.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
