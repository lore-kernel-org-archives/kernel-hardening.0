From: Kees Cook <keescook@chromium.org>
Date: Fri, 23 Jun 2017 13:59:55 -0700
Message-Id: <1498251600-132458-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 0/5] Use ELF_ET_DYN_BASE only for PIE
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Daniel Micay <danielmicay@gmail.com>, Qualys Security Advisory <qsa@qualys.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Pratyush Anand <panand@redhat.com>, James Hogan <james.hogan@imgtec.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is v2 (to refresh the 5 patches in -mm) for moving ELF_ET_DYN_BASE
safely lower. Changes are clarifications in the commit logs (suggested
by mpe), a compat think-o fix for arm64 (thanks to Ard), and to add
Rik and mpe's Acks.

Quoting patch 1/5:

The ELF_ET_DYN_BASE position was originally intended to keep loaders
away from ET_EXEC binaries. (For example, running "/lib/ld-linux.so.2
/bin/cat" might cause the subsequent load of /bin/cat into where the
loader had been loaded.) With the advent of PIE (ET_DYN binaries with
an INTERP Program Header), ELF_ET_DYN_BASE continued to be used since
the kernel was only looking at ET_DYN. However, since ELF_ET_DYN_BASE
is traditionally set at the top 1/3rd of the TASK_SIZE, a substantial
portion of the address space is unused.

For 32-bit tasks when RLIMIT_STACK is set to RLIM_INFINITY, programs
are loaded below the mmap region. This means they can be made to collide
(CVE-2017-1000370) or nearly collide (CVE-2017-1000371) with pathological
stack regions. Lowering ELF_ET_DYN_BASE solves both by moving programs
above the mmap region in all cases, and will now additionally avoid
programs falling back to the mmap region by enforcing MAP_FIXED for
program loads (i.e. if it would have collided with the stack, now it
will fail to load instead of falling back to the mmap region).
    
To allow for a lower ELF_ET_DYN_BASE, loaders (ET_DYN without INTERP)
are loaded into the mmap region, leaving space available for either an
ET_EXEC binary with a fixed location or PIE being loaded into mmap by the
loader. Only PIE programs are loaded offset from ELF_ET_DYN_BASE, which
means architectures can now safely lower their values without risk of
loaders colliding with their subsequently loaded programs.
    
For 64-bit, ELF_ET_DYN_BASE is best set to 4GB to allow runtimes to
use the entire 32-bit address space for 32-bit pointers. For 32-bit,
4MB is used as the traditional minimum load location, likely to avoid
historically requiring a 4MB page table entry when only a portion of the
first 4MB would be used (since the NULL address is avoided).

Thanks to PaX Team, Daniel Micay, and Rik van Riel for inspiration and
suggestions on how to implement this solution.

-Kees
