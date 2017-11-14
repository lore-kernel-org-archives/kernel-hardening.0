References: <1508631773-2502-1-git-send-email-alex.popov@linux.com>
 <1508631773-2502-3-git-send-email-alex.popov@linux.com>
 <d74e0d32-d794-62d1-27fa-d96f4cf37522@linux.com>
 <20171030173216.72y673m32gra4b55@hirez.programming.kicks-ass.net>
 <586ee584-df0d-3c82-a254-16ac1573255a@linux.com>
 <69522d43-f1b9-48ac-6235-a237c0298a04@linux.com>
 <CALCETrUYADqoZLYxC=uMVTvSU_R5Vg_uXzs_DUZBAC_O5Wybxg@mail.gmail.com>
 <20171114163306.3pr4a4s36t7mbj2f@salmiak>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <0bf24e38-c26a-baca-c54d-1bb0aa7b01e4@linux.com>
Date: Wed, 15 Nov 2017 00:09:30 +0300
MIME-Version: 1.0
In-Reply-To: <20171114163306.3pr4a4s36t7mbj2f@salmiak>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v5 2/5] gcc-plugins: Add STACKLEAK plugin for tracking
 the kernel stack
To: Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Tycho Andersen <tycho@docker.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Thanks, Mark!

Please see my comments below.

On 14.11.2017 19:33, Mark Rutland wrote:
> On Tue, Nov 14, 2017 at 08:13:43AM -0800, Andy Lutomirski wrote:
>> What does the STEAKLACK plugin actually do?  I haven't followed this enough.
> 
> The plugin adds instrumentation to track the maximum stack depth, though only
> functions with a sufficiently large stackframe are instrumented.

Yes. Functions with a big stack frame call track_stack() to update the
lowest_stack value. If CONFIG_VMAP_STACK is disabled, track_stack() is compiled
with a check for detecting stack depth overflow. This check is what I'm asking
about.

> The basic idea is that this can then be used to lazily zero stack after use
> (just before return to userspace), to minimize the risk of problems resulting
> from uninitialized variables (either copied to userspace and leaking secrets,
> or controlled by userspace and influencing the kernel).

Yes.

Actually the used part of the kernel stack is not zeroed. It is filled by
STACKLEAK_POISON (-0xBEEF) which points to the unused hole in x86_64 virtual
memory map.

> That, and catching some stack overflows in the absence of VMAP'd stacks.

The STACKLEAK plugin also adds check_alloca() call before each alloca to block
"Stack Clash" attack against kernel stack.

More details and statistics are available in the cover letter and commit
messages in this patch series.

Best regards,
Alexander
