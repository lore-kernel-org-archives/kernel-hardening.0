Date: Wed, 1 Mar 2017 01:04:08 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Message-ID: <20170301010408.GH21222@n2100.armlinux.org.uk>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
 <1488228186-110679-6-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488228186-110679-6-git-send-email-keescook@chromium.org>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: [kernel-hardening] Re: [RFC][PATCH 5/8] ARM: Implement __arch_rare_write_map/unmap()
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 27, 2017 at 12:43:03PM -0800, Kees Cook wrote:
> Based on grsecurity's ARM pax_{open,close}_kernel() implementation, this
> allows HAVE_ARCH_RARE_WRITE to work on ARM.

This has the effect that any memory mapped with DOMAIN_KERNEL will
loose it's NX status, and may end up being read into the I-cache.

We used to do exactly this to support set_fs(KERNEL_DS) but it was
deemed to be way too problematical (for speculative prefetching)
to use it on ARMv6+.

As vmalloc space ends up with a random mixture of DOMAIN_KERNEL and
DOMAIN_IO mappings (due to the order of ioremap() vs vmalloc()), this
means DOMAIN_KERNEL can cover devices... which with switching
DOMAIN_KERNEL to manager mode result in the NX being removed for
device mappings, which (iirc) is unpredictable.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
