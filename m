Date: Tue, 25 Jul 2017 17:01:16 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170725160116.GB12749@leverpostej>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
 <bb507ee1-c7ba-4c73-0d0f-058c4821793c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb507ee1-c7ba-4c73-0d0f-058c4821793c@arm.com>
Subject: [kernel-hardening] Re: [PATCH 00/11] ARMv8.3 pointer authentication userspace support
To: Yao Qi <yao.qi@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, catalin.marinas@arm.com, christoffer.dall@linaro.org, Dave.Martin@arm.com, jiong.wang@arm.com, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Tue, Jul 25, 2017 at 12:32:10PM +0100, Yao Qi wrote:
> On 19/07/17 17:01, Mark Rutland wrote:
> > If authentication fails, bits are set in the pointer such that it is
> > guaranteed to cause a fault if used.
> 
> How does user space know the fault is caused by authentication fail?

Strictly speaking, it does not, and neither does the kernel.

In general, it cannot know whether this is the case, as an
authentication failure does not result in an immediate exception.

> When GDB is debugging a program, and it failed in pointer
> authentication, I assume GDB only knows that the program receives signal
> SIGSEGV, but how does GDB or user know why does the program get SIGSEGV?

I think in practice, the user has to determine this for themselves. I do
not believe that it is possible to reliably determine whether a given
fault was caused by an authentication failure.

For example, consider an authentication failure in a function epilogue:

	ldp	x29, x30, [sp], #FRAME_SIZE
	autiasp
	ret

When AUTIASP fails to authenticate the x30 value, it ensures that x30 is
a faulting value, by forcing some of the high bits to particular values,
but that's all. A user can set those bits in the same way.

The RET loads the LR value into the PC, which subsequently triggers an
instruction abort for the PC value (i.e. we branch to the bogus address
*then* take a fault at that address).

At that point, we have no information to determine what the CPU was
executing before it branched to the bogus address. So we cannot know how
the address was generated, and therefore cannot know if it was an
authentication failure.

For data pointers, you could generate bogus pointers with a large
out-of-bounds array index, whereby the bogus pointer looked like the
result of a pointer authentication failure.

Thanks,
Mark.
