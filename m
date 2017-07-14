Date: Fri, 14 Jul 2017 02:30:54 +0100
From: Will Deacon <will.deacon@arm.com>
Message-ID: <20170714013054.GE22336@arm.com>
References: <1499898783-25732-1-git-send-email-mark.rutland@arm.com>
 <1499898783-25732-2-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1499898783-25732-2-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] Re: [RFC PATCH 1/6] arm64: use tpidr_el1 for current, free sp_el0
To: Mark Rutland <mark.rutland@arm.com>
Cc: ard.biesheuvel@linaro.org, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, akashi.takahiro@linaro.org, catalin.marinas@arm.com, dave.martin@arm.com, james.morse@arm.com, labbott@fedoraproject.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 12, 2017 at 11:32:58PM +0100, Mark Rutland wrote:
> Today we use TPIDR_EL1 for our percpu offset, and SP_EL0 for current
> (and current::thread_info, which is at offset 0).
> 
> Using SP_EL0 in this way prevents us from using EL1 thread mode, where
> SP_EL0 is not addressable (since it's used as the active SP). It also
> means we can't use SP_EL0 for other purposes (e.g. as a
> scratch-register).
> 
> This patch frees up SP_EL0 for such usage, by storing the percpu offset
> in current::thread_info, and using TPIDR_EL1 to store current. As we no
> longer need to update SP_EL0 at EL0 exception boundaries, this allows us
> to delete some code.

Does this mean we can just use asm-generic/percpu.h?

Will
