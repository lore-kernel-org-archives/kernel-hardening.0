Date: Tue, 14 Nov 2017 16:33:07 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20171114163306.3pr4a4s36t7mbj2f@salmiak>
References: <1508631773-2502-1-git-send-email-alex.popov@linux.com>
 <1508631773-2502-3-git-send-email-alex.popov@linux.com>
 <d74e0d32-d794-62d1-27fa-d96f4cf37522@linux.com>
 <20171030173216.72y673m32gra4b55@hirez.programming.kicks-ass.net>
 <586ee584-df0d-3c82-a254-16ac1573255a@linux.com>
 <69522d43-f1b9-48ac-6235-a237c0298a04@linux.com>
 <CALCETrUYADqoZLYxC=uMVTvSU_R5Vg_uXzs_DUZBAC_O5Wybxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUYADqoZLYxC=uMVTvSU_R5Vg_uXzs_DUZBAC_O5Wybxg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH RFC v5 2/5] gcc-plugins: Add STACKLEAK plugin for
 tracking the kernel stack
To: Andy Lutomirski <luto@kernel.org>
Cc: Alexander Popov <alex.popov@linux.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Tycho Andersen <tycho@docker.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 14, 2017 at 08:13:43AM -0800, Andy Lutomirski wrote:
> What does the STEAKLACK plugin actually do?  I haven't followed this enough.

The plugin adds instrumentation to track the maximum stack depth, though only
functions with a sufficiently large stackframe are instrumented.

The basic idea is that this can then be used to lazily zero stack after use
(just before return to userspace), to minimize the risk of problems resulting
from uninitialized variables (either copied to userspace and leaking secrets,
or controlled by userspace and influencing the kernel).

That, and catching some stack overflows in the absence of VMAP'd stacks.

Thanks,
Mark.
