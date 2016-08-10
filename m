Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 11 Aug 2016 00:02:42 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Message-ID: <20160810230242.GO1041@n2100.armlinux.org.uk>
References: <1464979224-2085-1-git-send-email-keescook@chromium.org>
 <2342289.4RWg0SWI3A@wuerfel>
 <20160810101253.GL1041@n2100.armlinux.org.uk>
 <2096112.OBiRuggdEi@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2096112.OBiRuggdEi@wuerfel>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: [kernel-hardening] Re: [PATCH 2/2] arm: apply more __ro_after_init
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, x86@kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Mathias Krause <minipli@googlemail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 10, 2016 at 09:31:05PM +0200, Arnd Bergmann wrote:
> On Wednesday, August 10, 2016 11:12:53 AM CEST Russell King - ARM Linux wrote:
> > There's the TLS emulation too, but that writes via the vectors mapping
> > at 0xffff0ff0.
> 
> Ok, so that should be safe. Can we change the fiq code to also use the
> high mapping and then take the __ro_after_init patch on top?

We can't - if the kernel is configured without the kuser helpers in
the vectors page, it's mapped read-only.  I'm not sure what the
intersection is between platforms that can have FIQs and platforms
that can disable the kuser helpers.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
