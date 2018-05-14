Date: Mon, 14 May 2018 15:07:15 +0100
From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 2/2] arm64: Clear the stack
Message-ID: <20180514140714.sfmvfpwco63eomor@lakrids.cambridge.arm.com>
References: <dd6ad26c-1d2c-88f3-8f01-e68d2b31d6ea@linux.com>
 <20180504110907.c2dw33kjmyybso6t@lakrids.cambridge.arm.com>
 <4badae50-be9b-2c6d-854b-57ab48664800@linux.com>
 <71199506-b46b-5f91-e489-e6450b6d1067@linux.com>
 <20180511161317.57k6prl54xjmsit3@lakrids.cambridge.arm.com>
 <f180b312-d1cf-3992-4e89-9632c1674cd6@linux.com>
 <20180514051555.bpbydgr56hyffjch@salmiak>
 <6c311899-7131-d21b-10f6-d2ba7380a392@linux.com>
 <20180514100639.v3erlzbuv2e4awfh@lakrids.cambridge.arm.com>
 <c5bebf0b-9667-5725-2800-97c5a85635c4@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5bebf0b-9667-5725-2800-97c5a85635c4@linux.com>
To: Alexander Popov <alex.popov@linux.com>
Cc: Andy Lutomirski <luto@kernel.org>, Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 14, 2018 at 04:53:12PM +0300, Alexander Popov wrote:
> On 14.05.2018 13:06, Mark Rutland wrote:
> > I think it is reasonable to panic() here even with CONFIG_VMAP_STACK
> > selected.
> 
> It's too tough for CONFIG_VMAP_STACK on x86 - the system can proceed to live.
> Anyway, the check_alloca() code will not be shared between x86 and arm64, I've
> described the reasons in this thread. So I can have BUG() for CONFIG_VMAP_STACK
> on x86 and Laura can consistently use panic() on arm64.

If we need arch-specific implementations anyway, then that's fine by me.

> >> So we should not do it in check_alloca() as well, just use BUG() and
> >> hope for the best.
> > 
> > Regardless of whether we BUG() or panic(), we're hoping for the best.
> > 
> > Consistently using panic() here will keep things simpler, so any failure
> > reported will be easier to reason about, and easier to debug.
> 
> Let me keep BUG() for !CONFIG_SCHED_STACK_END_CHECK. I beware of using panic()
> by default, let distro/user decide this. I remember very well how I was shouted
> at, when this one was merged:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ce6fa91b93630396ca220c33dd38ffc62686d499

Sure; my comments needn't hold up your patches.

Thanks,
Mark.
