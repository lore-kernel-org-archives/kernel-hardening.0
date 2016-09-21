Reply-To: kernel-hardening@lists.openwall.com
References: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <f954c330-fb58-5f8f-1d66-5bbcd0d9dadb@redhat.com>
Date: Tue, 20 Sep 2016 18:26:54 -0700
MIME-Version: 1.0
In-Reply-To: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC PATCH 0/8] arm64: move thread_info off of the task stack
To: Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, keescook@chromium.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, luto@kernel.org, suzuki.poulose@arm.com, takahiro.akashi@linaro.org, will.deacon@arm.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 09/15/2016 06:49 AM, Mark Rutland wrote:
> Building atop of Andy's work on x86 and generic code, these patches move
> arm64's thread_info off of the stack and into task_struct. This protects
> thread_info from corruption in the face of stack overflow, and serves as
> a step towards fully robust stack overflow handling will be addressed by
> subsequent patches.
>
> In contrast to x86, we can't place some critical data such as
> preempt_count in percpu variables, and we must store these in some
> per-task location. This, compounded with the way headers are organised
> conspires to require us to still define our own thread_info. I
> understand that the longer term plan is to kill off thread_info
> entirely, hence I'm sending this as an RFC so we can figure out if/how
> we can achieve that.
>
> These patches are based on Andy's x86/vmap_stack branch [1,2], and I've
> pushed a copy to me arm64/ti-stack-split branch [3,4]. The result of
> these patches boots happily on platforms within reach of my desk, but
> has not seen much stressing so far.
>

FWIW, I used your ti-stack-split branch while running some kernel builds
and it seems to work well enough. You can take that as a Tested-by or I
can re-test with a non-RFC version.

> Thanks,
> Mark.
>
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git x86/vmap_stack
> [2] https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=x86/vmap_stack
> [3] git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git arm64/ti-stack-split
> [4] https://git.kernel.org/cgit/linux/kernel/git/mark/linux.git/log/?h=arm64/ti-stack-split
>
> Mark Rutland (8):
>   thread_info: include <current.h> for THREAD_INFO_IN_TASK
>   thread_info: allow custom in-task thread_info
>   arm64: thread_info remove stale items
>   arm64: asm-offsets: remove unused definitions
>   arm64: assembler: introduce ldr_this_cpu
>   arm64: traps: use task_struct instead of thread_info
>   arm64: move sp_el0 and tpidr_el1 into cpu_suspend_ctx
>   arm64: split thread_info from task stack
>
>  arch/arm64/Kconfig                   |  2 ++
>  arch/arm64/include/asm/Kbuild        |  1 -
>  arch/arm64/include/asm/assembler.h   | 19 +++++++++++++++----
>  arch/arm64/include/asm/current.h     | 22 ++++++++++++++++++++++
>  arch/arm64/include/asm/smp.h         |  1 +
>  arch/arm64/include/asm/suspend.h     |  2 +-
>  arch/arm64/include/asm/thread_info.h | 21 ---------------------
>  arch/arm64/kernel/asm-offsets.c      |  3 +--
>  arch/arm64/kernel/entry.S            |  6 +++---
>  arch/arm64/kernel/head.S             | 11 +++++------
>  arch/arm64/kernel/process.c          | 31 ++++++++++++++++++++++++++-----
>  arch/arm64/kernel/sleep.S            |  3 ---
>  arch/arm64/kernel/smp.c              |  2 ++
>  arch/arm64/kernel/stacktrace.c       |  5 +++++
>  arch/arm64/kernel/suspend.c          |  6 ------
>  arch/arm64/kernel/traps.c            | 12 ++++++------
>  arch/arm64/mm/proc.S                 |  6 ++++++
>  include/linux/thread_info.h          |  4 +++-
>  init/Kconfig                         |  3 +++
>  19 files changed, 101 insertions(+), 59 deletions(-)
>  create mode 100644 arch/arm64/include/asm/current.h
>
