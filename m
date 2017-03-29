Date: Wed, 29 Mar 2017 20:00:08 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Message-ID: <20170329190008.GE7909@n2100.armlinux.org.uk>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490811363-93944-1-git-send-email-keescook@chromium.org>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: [kernel-hardening] Re: [RFC v2] Introduce rare_write() infrastructure
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 29, 2017 at 11:15:52AM -0700, Kees Cook wrote:
> This is take 2 of an RFC series to demonstrate a possible infrastructure
> for the "write rarely" memory storage type in the kernel (patch 1). The
> intent is to further reduce the internal attack surface of the kernel
> by making more variables read-only while "at rest". This is heavily
> based on the "__read_only" portion of the KERNEXEC infrastructure from
> PaX/grsecurity, though I tried to adjust it to be more in line with
> the upstream discussions around the APIs.

How much data are we talking about here?

> As part of the series I've included both x86 support (patch 4), exactly
> as done in PaX, and ARM support (patches 5-7), similar to what is done in
> grsecurity but without support for earlier ARM CPUs. Both are lightly
> tested by me, though they need a bit more work, especially ARM as it is
> missing the correct domain marking for kernel modules.

The implementation as it stands on ARM is going to gobble up
multiples of 1MB of RAM as you need it to be section aligned due to
using domains, so if we're talking about a small amount of data,
this is very inefficient.  That also only works for non-LPAE as LPAE
is unable to use that method.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
