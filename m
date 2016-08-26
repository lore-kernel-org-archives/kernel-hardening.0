Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 26 Aug 2016 18:24:15 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20160826172414.GE15779@e104818-lin.cambridge.arm.com>
References: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
 <20160826153904.GA19844@davidb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160826153904.GA19844@davidb.org>
Subject: Re: [kernel-hardening] [PATCH 0/7] arm64: Privileged Access Never
 using TTBR0_EL1 switching
To: David Brown <david.brown@linaro.org>
Cc: kernel-hardening@lists.openwall.com, James Morse <james.morse@arm.com>, Julien Grall <julien.grall@arm.com>, Will Deacon <will.deacon@arm.com>, Kees Cook <keescook@chromium.org>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 26, 2016 at 11:39:04AM -0400, David Brown wrote:
> On Fri, Aug 12, 2016 at 04:27:39PM +0100, Catalin Marinas wrote:
> >This is the first (public) attempt at emulating PAN by disabling
> >TTBR0_EL1 accesses on arm64. I chose to use a per-CPU saved_ttbr0_el1
> >variable to store the actual TTBR0 as, IMO, it looks better w.r.t. the
> >context switching code, to the detriment of a slightly more complex
> >uaccess_enable() implementation. The alternative was storing the saved
> >TTBR0 in thread_info but with more complex thread switching since TTBR0
> >is normally tied to switch_mm() rather than switch_to(). The latter may
> >also get more complicated if we are to decouple the kernel stack from
> >thread_info at some point (vmalloc'ed stacks).
> >
> >The code requires more testing, especially for combinations where UAO is
> >present but PAN is not.
> 
> I briefly tried to run these patches on my HiKey board and I get a
> panic on boot.  Unfortunately, I've had to head off to the Linux
> Security Summit, so I haven't been able to try to figure out what is
> going on (and I don't seem to be able to even get a capture of the log
> output).  But I ran into Mark Rutland who convinced me to at least
> state the failure on the list here.

Thanks for trying to test this series. Without more information, I can't
really say where the problem is or why it fails that early (in theory it
should only affect user space). Is it with recent/latest mainline?
defconfig? Anyway, I'll wait until you get back from the conference,
maybe you get some early console output.

-- 
Catalin
