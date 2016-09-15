Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1473947349-14521-3-git-send-email-mark.rutland@arm.com>
References: <1473947349-14521-1-git-send-email-mark.rutland@arm.com> <1473947349-14521-3-git-send-email-mark.rutland@arm.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 15 Sep 2016 11:37:47 -0700
Message-ID: <CALCETrWni0aZ71r-R6oYG98kZvZA8a184UR0YURk_=tXu8HXMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC PATCH 2/8] thread_info: allow custom in-task thread_info
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, james.morse@arm.com, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, lorenzo.pieralisi@arm.com, Andrew Lutomirski <luto@kernel.org>, suzuki.poulose@arm.com, Takahiro Akashi <takahiro.akashi@linaro.org>, Will Deacon <will.deacon@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 15, 2016 at 6:49 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> Currently, task_struct is defined in <linux/sched.h>, which (indirectly)
> pulls in a number of low-level arch headers such as <asm/preempt.h>
> through a number of other headers. Thus, code and structures in these
> headers can't rely on the definition of task_struct. Some of these
> headers are necessary for the definition of task_struct, so moving
> task_struct into its own header is insufficient tio avoid circular
> includes.

The flippant answer is to fix the headers, but I tried that myself and
gave up :(

But how about this slightly less duplicative alternative:

struct thread_info {
#ifdef arch_thread_info
  struct arch_thread_info arch_ti;
#endif
};
