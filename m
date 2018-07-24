Subject: Re: [PATCHv3 2/2] arm64: Add support for STACKLEAK gcc plugin
References: <20180720214154.2940-1-labbott@redhat.com>
 <20180720214154.2940-3-labbott@redhat.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <ee7335aa-d536-7aef-a25e-224462e065b0@linux.com>
Date: Tue, 24 Jul 2018 15:44:24 +0300
MIME-Version: 1.0
In-Reply-To: <20180720214154.2940-3-labbott@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 21.07.2018 00:41, Laura Abbott wrote:
> This adds support for the STACKLEAK gcc plugin to arm64 by implementing
> stackleak_check_alloca(), based heavily on the x86 version, and adding the
> two helpers used by the stackleak common code: current_top_of_stack() and
> on_thread_stack(). The stack erasure calls are made at syscall returns.
> Additionally, this disables the plugin in hypervisor and EFI stub code,
> which are out of scope for the protection.
> 
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> v3: Actual commit text courtesy of Kees. A comment explaining why we
> panic
> ---
>  arch/arm64/Kconfig                    |  1 +
>  arch/arm64/include/asm/processor.h    | 15 +++++++++++++++
>  arch/arm64/kernel/entry.S             |  7 +++++++
>  arch/arm64/kernel/process.c           | 22 ++++++++++++++++++++++
>  arch/arm64/kvm/hyp/Makefile           |  3 ++-
>  drivers/firmware/efi/libstub/Makefile |  3 ++-
>  6 files changed, 49 insertions(+), 2 deletions(-)

Laura, thanks for your work!

I've reviewed and tested this patch on my LeMaker HiKey board (HiSilicon Kirin
620 SoC). The lkdtm tests for STACKLEAK work fine.

Acked-by: Alexander Popov <alex.popov@linux.com>

For testing I applied your patches above Kees' for-next/kspp:
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=for-next/kspp

I've had one trouble with building CONFIG_STACKLEAK_RUNTIME_DISABLE on arm64.
Kees, could you please fold this into the 7th patch of the series?

---- >8 ----

diff --git a/kernel/stackleak.c b/kernel/stackleak.c
index f731c9a..03031f7a 100644
--- a/kernel/stackleak.c
+++ b/kernel/stackleak.c
@@ -16,6 +16,7 @@

 #ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
 #include <linux/jump_label.h>
+#include <linux/sysctl.h>

 static DEFINE_STATIC_KEY_FALSE(stack_erasing_bypass);
