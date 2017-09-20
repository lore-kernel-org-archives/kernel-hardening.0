MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170920004434.35308-1-ebiggers3@gmail.com>
References: <20170920004434.35308-1-ebiggers3@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 19 Sep 2017 20:03:05 -0700
Message-ID: <CAGXu5jJsA-y1yDre5cQ9j8S4i0ftt=Rk5GaXP8wunmm09rrUNg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 0/3] x86/fpu: prevent leaking FPU registers via invalid
 FPU state
To: Eric Biggers <ebiggers3@gmail.com>, Ingo Molnar <mingo@kernel.org>
Cc: "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dmitry Vyukov <dvyukov@google.com>, Fenghua Yu <fenghua.yu@intel.com>, Kevin Hao <haokexin@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Wanpeng Li <wanpeng.li@hotmail.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Michael Halcrow <mhalcrow@google.com>, Eric Biggers <ebiggers@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Sep 19, 2017 at 5:44 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> This is a second attempt to fix the bug found by syzkaller where the
> ptrace syscall can be used to set invalid bits in a task's FPU state.
> I also found that an equivalent bug was reachable using the sigreturn
> syscall, so the first patch fixes the bug in both cases.
>
> The other two patches start validating the other parts of the
> xstate_header and make it so that invalid FPU states can no longer be
> abused to leak the FPU registers of other processes.
>
> Eric Biggers (3):
>   x86/fpu: don't let userspace set bogus xcomp_bv
>   x86/fpu: tighten validation of user-supplied xstate_header
>   x86/fpu: reinitialize FPU registers if restoring FPU state fails

This series looks sensible to me! Thanks for getting this fixed up.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

>
>  arch/x86/include/asm/fpu/internal.h | 29 ++++++++++++++++++++---------
>  arch/x86/include/asm/fpu/xstate.h   | 19 +++++++++++++++++++
>  arch/x86/kernel/fpu/core.c          | 16 ++++++++++++++++
>  arch/x86/kernel/fpu/regset.c        | 20 +++++++++-----------
>  arch/x86/kernel/fpu/signal.c        | 15 +++++++++++----
>  arch/x86/kernel/fpu/xstate.c        | 27 ++++++++++-----------------
>  6 files changed, 85 insertions(+), 41 deletions(-)
>
> --
> 2.14.1.690.gbb1197296e-goog
>



-- 
Kees Cook
Pixel Security
