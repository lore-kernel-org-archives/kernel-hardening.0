Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 7 Nov 2016 19:49:11 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161107194910.GM19796@leverpostej>
References: <1477585654-8908-1-git-send-email-labbott@redhat.com>
 <20161030150307.33vc2m7y5y6wzbqc@localhost>
 <20161107153802.GJ19796@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161107153802.GJ19796@leverpostej>
Subject: Re: [kernel-hardening] Re: [PATCHv4 0/4] WX checking for arm64
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Laura Abbott <labbott@redhat.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, linux-efi@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 07, 2016 at 03:38:02PM +0000, Mark Rutland wrote:
> On Sun, Oct 30, 2016 at 03:03:07PM +0000, Catalin Marinas wrote:
> > On Thu, Oct 27, 2016 at 09:27:30AM -0700, Laura Abbott wrote:
> > > Laura Abbott (4):
> > >   arm64: dump: Make ptdump debugfs a separate option
> > >   arm64: dump: Make the page table dumping seq_file optional
> > >   arm64: dump: Remove max_addr
> > >   arm64: dump: Add checking for writable and exectuable pages
> > 
> > Queued for 4.10. Thanks.
> 
> Catalin mentioned to me that he saw some KASAN splats when testing; it
> looks like need a fixup something like the below.

As an aside, it looks like any ptdump usage when KASAN is enabled takes
several minutes, which at boot time looks like a hang.

AFAICT, this is because KASAN allocates *huge* VA ranges (4TB+) worth of
zeroed shadow memory at pte granularity (reusing the same pmd, pud,
tables), and the ptdump code dutifully walks this with, with the added
KASAN instrumentation overhead.

I'll try to dig into that tomorrow; I suspect/hope it's not necessary to
keep all of that mapped.

Thanks,
Mark.
