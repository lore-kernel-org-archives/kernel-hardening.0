Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 24 Dec 2015 00:34:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Message-ID: <20151224003406.GA8644@n2100.arm.linux.org.uk>
References: <20151202202725.GA794@www.outflux.net>
 <20151223195129.GP2793@atomide.com>
 <567B04AB.6010906@redhat.com>
 <20151223212911.GR2793@atomide.com>
 <alpine.LFD.2.20.1512231637110.3603@knanqh.ubzr>
 <20151224001121.GS2793@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151224001121.GS2793@atomide.com>
Sender: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [kernel-hardening] Re: [PATCH v2] ARM: mm: flip priority of CONFIG_DEBUG_RODATA
To: Tony Lindgren <tony@atomide.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 23, 2015 at 04:11:22PM -0800, Tony Lindgren wrote:
> * Nicolas Pitre <nicolas.pitre@linaro.org> [151223 13:45]:
> > We fixed a bunch of similar issues where code was located in the .data 
> > section for ease of use from assembly code.  See commit b4e61537 and 
> > d0776aff for example.
> 
> Thanks hey some assembly fun for the holidays :) I also need to check what
> all gets relocated to SRAM here.
> 
> In any case, seems like the $subject patch is too intrusive for v4.5 at
> this point.

Given Christmas and an unknown time between that and the merge window
actually opening, I decided Tuesday would be the last day I take any
patches into my tree - and today would be the day that I drop anything
that causes problems.

So, I've already dropped this, so tomorrow's linux-next should not have
this change.

You'll still see breakage if people enable RODATA though, but that's no
different from previous kernels.

-- 
RMK's Patch system: http://www.arm.linux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
