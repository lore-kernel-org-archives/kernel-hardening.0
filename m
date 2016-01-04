Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 4 Jan 2016 12:31:19 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160104123118.GB7050@leverpostej>
References: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org>
 <11016384.rorhLcDd8i@wuerfel>
 <20160103145008.GA1642@svinekod>
 <2697196.BQeEylXYbs@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2697196.BQeEylXYbs@wuerfel>
Subject: [kernel-hardening] Re: [RFC PATCH 01/10] arm64: introduce KIMAGE_VADDR as the virtual
 base of the kernel region
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Stuart Yoder <stuart.yoder@freescale.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 04, 2016 at 01:21:05PM +0100, Arnd Bergmann wrote:
> On Sunday 03 January 2016 14:50:10 Mark Rutland wrote:
> > 
> > > - once we have a random number in the bootloader, we should also pass that
> > >   through a DT property. This has been discussed multiple times in the past
> > >   and I think we had reached consensus already but don't know if we had
> > >   agreed on a specific DT property that contains the random number seed.
> > 
> > Any links for this? I don't recall spotting this discussion.
> 
> One discussion I found in the mail archives is in this thread
> https://lkml.org/lkml/2014/2/12/518, I also remember discussing it in person
> at some conference, obviously no archive of that.

Thanks for the pointer!

Mark.
