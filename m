References: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <fa283afb-b611-45da-a89a-12fafe987082@redhat.com>
Date: Tue, 15 Aug 2017 10:18:20 -0700
MIME-Version: 1.0
In-Reply-To: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCHv2 00/14] arm64: VMAP_STACK support
To: Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, linux-kernel@vger.kernel.org, luto@amacapital.net, matt@codeblueprint.co.uk, will.deacon@arm.com, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On 08/15/2017 05:50 AM, Mark Rutland wrote:
> Hi,
> 
> Ard and I have worked together to implement vmap stack support for
> arm64. This supersedes our earlier vmap stack RFCs [0,1]. The git author
> stats are a little misleading, as I've teased parts out into smaller
> patches for review.
> 
> The series is based on our stack dump rework [2,3], which can be found
> in the arm64/exception-stack branch [4] of my kernel.org repo. This
> series can be found in the arm64/vmap-stack branch [5] of the same repo.
> 
> Since v1 [6]:
> * Fix typos
> * Update comments in entry assembly
> * Dump exception context (and stacks) before regs
> * Define safe adr_this_cpu for modules
> 
> On arm64, there is no double-fault exception, as software saves
> exception context to the stack. An erroneous memory access taken during
> exception handling results in a data abort, as with any other erroneous
> memory access. To avoid taking these recursively, we must detect
> overflow by checking the SP before we attempt to store any context to
> the stack. Doing this efficiently requires a couple of tricks.
> 
> For a naturally aligned stack, bits THREAD_SHIFT-1:0 of a valid SP may
> contain any arbitrary value:
> 
> 	0bXX .. 11111111111111
> 	0bXX .. 11011001011100
> 	0bXX .. 00000000000000
> 
> By aligning stacks to double their natural alignment, we know that the
> THREAD_SHIFT bit of any valid SP must be zero:
> 
> 	0bXX .. 0 11111111111111
> 	0bXX .. 0 11011001011100
> 	0bXX .. 0 00000000000000
> 
> ... while an overflow will result in this bit flipping, along with
> (some) other high-order bits:
> 
> 	0bXX .. 0 00000000000000
> 	< SP -= 1 >
> 	0bXX .. 1 11111111111111
> 
> ... and thus, we can detect overflows of up to THREAD_SIZE by testing
> the THREAD_SHIFT bit of the SP value.
> 
> Provided we can get the SP into a general purpose register, we can
> perform this test with a single TBNZ instruction. We don't have scratch
> space to store a GPR, but we can (partially) swap the SP with a GPR
> using arithmetic to perform the test:
> 
> 	add	sp, sp, x0		// sp' = sp + x0
> 	sub	x0, sp, x0		// x0' = sp' - x0 = (sp + x0) - x0 = sp
> 	tbnz	x0, #THREAD_SHIFT, overflow_handler
> 	sub	x0, sp, x0		// sp' - x0' = (sp + x0) - sp = x0
> 	sub	sp, sp, x0		// sp' - x0 = (sp + x0) - x0 = sp
> 
> This series implements this approach, along with the other requisite
> changes required to make this work.
> 
> The SP test is performed for all exceptions, after compensating for the
> size of the exception registers, allowing the original exception context
> to be preserved in entirety. The tests themselves are folded into the
> exception vectors, minimizing their impact.
> 
> To ensure that IRQ stack overflows are detected and handled, IRQ stacks
> are now dynamically allocated, with guard pages.
> 
> I've given the series some light testing with LKDTM, Syzkaller, Vince
> Weaver's perf fuzzer, and a few combinations of debug options. I haven't
> compared performance of the entire series to a baseline kernel, but from
> testing so far the cost of the SP test falls in the noise for a kernel
> build workload on Cortex-A57.
> 
> Many thanks to Ard for putting up with my meddling, and also to Laura,
> James, Catalin, and Will for comments and testing.
> 
> Thanks,
> Mark.
> 
> [0] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-July/518368.html
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-July/518434.html
> [2] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-July/520705.html
> [3] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-July/521435.html
> [4] git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git arm64/exception-stack
> [5] git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git arm64/vmap-stack
> [6] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-August/524179.html
> 
> Ard Biesheuvel (2):
>   arm64: kernel: remove {THREAD,IRQ_STACK}_START_SP
>   arm64: assembler: allow adr_this_cpu to use the stack pointer
> 
> Mark Rutland (12):
>   arm64: remove __die()'s stack dump
>   fork: allow arch-override of VMAP stack alignment
>   arm64: factor out PAGE_* and CONT_* definitions
>   arm64: clean up THREAD_* definitions
>   arm64: clean up irq stack definitions
>   arm64: move SEGMENT_ALIGN to <asm/memory.h>
>   efi/arm64: add EFI_KIMG_ALIGN
>   arm64: factor out entry stack manipulation
>   arm64: use an irq stack pointer
>   arm64: add basic VMAP_STACK support
>   arm64: add on_accessible_stack()
>   arm64: add VMAP_STACK overflow detection
> 
>  arch/arm64/Kconfig                        |   1 +
>  arch/arm64/include/asm/assembler.h        |   8 +-
>  arch/arm64/include/asm/efi.h              |   8 ++
>  arch/arm64/include/asm/irq.h              |  25 ------
>  arch/arm64/include/asm/memory.h           |  53 +++++++++++++
>  arch/arm64/include/asm/page-def.h         |  34 +++++++++
>  arch/arm64/include/asm/page.h             |  12 +--
>  arch/arm64/include/asm/processor.h        |   2 +-
>  arch/arm64/include/asm/stacktrace.h       |  60 ++++++++++++++-
>  arch/arm64/include/asm/thread_info.h      |  10 +--
>  arch/arm64/kernel/entry.S                 | 121 ++++++++++++++++++++++++------
>  arch/arm64/kernel/irq.c                   |  40 +++++++++-
>  arch/arm64/kernel/ptrace.c                |   1 +
>  arch/arm64/kernel/smp.c                   |   2 +-
>  arch/arm64/kernel/stacktrace.c            |   7 +-
>  arch/arm64/kernel/traps.c                 |  44 ++++++++++-
>  arch/arm64/kernel/vmlinux.lds.S           |  18 +----
>  drivers/firmware/efi/libstub/arm64-stub.c |   6 +-
>  kernel/fork.c                             |   5 +-
>  19 files changed, 353 insertions(+), 104 deletions(-)
>  create mode 100644 arch/arm64/include/asm/page-def.h
> 

Tested-by: Laura Abbott <labbott@redhat.com>

(I think I may be slightly late with this. Oh well.)
