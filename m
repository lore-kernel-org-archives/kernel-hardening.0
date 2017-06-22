From: Kees Cook <keescook@chromium.org>
Date: Thu, 22 Jun 2017 11:06:28 -0700
Message-Id: <1498154792-49952-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 0/4] Reduce ELF_ET_DYN_BASE
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, Pratyush Anand <panand@redhat.com>, Ingo Molnar <mingo@kernel.org>, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is a follow-up to "binfmt_elf: Use ELF_ET_DYN_BASE only for PIE"[1],
which allow ELF_ET_DYN_BASE to be reduced from high in the address space.
That patch only changed x86, and this series changes arm, arm64, powerpc,
and s390.

Since these depend on the mentioned patch (which I'm hoping akpm will
pick up), I'm hoping to get arch-maintainer Acks for these (so they can
be carried all together).

Thanks!

-Kees

[1] https://patchwork.kernel.org/patch/9802387/
