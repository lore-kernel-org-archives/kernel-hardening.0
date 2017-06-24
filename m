MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1498251600-132458-2-git-send-email-keescook@chromium.org>
References: <1498251600-132458-1-git-send-email-keescook@chromium.org> <1498251600-132458-2-git-send-email-keescook@chromium.org>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 24 Jun 2017 12:16:42 -0700
Message-ID: <CAGXu5jL7cYJT6n8w8egOuLOH6QHAp8X=+s3B+hB_sdNb8ub=5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 1/5] binfmt_elf: Use ELF_ET_DYN_BASE only for PIE
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, "# 3.4.x" <stable@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Rik van Riel <riel@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Daniel Micay <danielmicay@gmail.com>, Qualys Security Advisory <qsa@qualys.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Pratyush Anand <panand@redhat.com>, James Hogan <james.hogan@imgtec.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 23, 2017 at 1:59 PM, Kees Cook <keescook@chromium.org> wrote:
> For 32-bit tasks when RLIMIT_STACK is set to RLIM_INFINITY, programs
> are loaded below the mmap region. This means they can be made to collide
> (CVE-2017-1000370) or nearly collide (CVE-2017-1000371) with pathological
> stack regions. Lowering ELF_ET_DYN_BASE solves both by moving programs
> above the mmap region in all cases, and will now additionally avoid
> programs falling back to the mmap region by enforcing MAP_FIXED for
> program loads (i.e. if it would have collided with the stack, now it
> will fail to load instead of falling back to the mmap region).

It was pointed out by rmk that I described this inaccurately. I mix up
my own visualization of the address space (above/below in
/proc/$pid/maps) with actual value comparisons (above/below
numerically). This paragraph should read:


For 32-bit tasks when RLIMIT_STACK is set to RLIM_INFINITY, programs
are loaded above the mmap region. This means they can be made to collide
(CVE-2017-1000370) or nearly collide (CVE-2017-1000371) with pathological
stack regions. Lowering ELF_ET_DYN_BASE solves both by moving programs
below the mmap region in all cases, and will now additionally avoid
programs falling back to the mmap region by enforcing MAP_FIXED for
program loads (i.e. if it would have collided with the stack, now it
will fail to load instead of falling back to the mmap region).


Andrew, are you able to manually adjust this commit log in -mm, or
should I resend the patch with this paragraph corrected?

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
