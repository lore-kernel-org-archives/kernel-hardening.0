Date: Wed, 18 Apr 2018 12:38:16 +0100
From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCHv3 06/11] asm-generic: mm_hooks: allow hooks to be
 overridden individually
Message-ID: <20180418113816.sgxdnxrbg4imzxfx@lakrids.cambridge.arm.com>
References: <20180417183735.56985-1-mark.rutland@arm.com>
 <20180417183735.56985-7-mark.rutland@arm.com>
 <CAK8P3a3SVhW1ByQOtxw7JG8i3wWU5opdycfSCTbW=GCFvBJmQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3SVhW1ByQOtxw7JG8i3wWU5opdycfSCTbW=GCFvBJmQg@mail.gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, cdall@kernel.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arch <linux-arch@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Adam Wallis <awallis@codeaurora.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 17, 2018 at 09:56:02PM +0200, Arnd Bergmann wrote:
> On Tue, Apr 17, 2018 at 8:37 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> > Currently, an architecture must either implement all of the mm hooks
> > itself, or use all of those provided by the asm-generic implementation.
> > When an architecture only needs to override a single hook, it must copy
> > the stub implementations from the asm-generic version.
> >
> > To avoid this repetition, allow each hook to be overridden indiviually,
> > by placing each under an #ifndef block. As architectures providing their
> > own hooks can't include this file today, this shouldn't adversely affect
> > any existing hooks.
> >
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: linux-arch@vger.kernel.org
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Cheers!

Mark.
