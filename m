Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sat, 23 Sep 2017 11:09:07 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170923090907.kk6hgbmupkeftae2@gmail.com>
References: <20170922174156.16780-1-ebiggers3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170922174156.16780-1-ebiggers3@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v4 0/3] x86/fpu: prevent leaking FPU registers via
 invalid FPU state
To: Eric Biggers <ebiggers3@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dmitry Vyukov <dvyukov@google.com>, Fenghua Yu <fenghua.yu@intel.com>, Kevin Hao <haokexin@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Wanpeng Li <wanpeng.li@hotmail.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Michael Halcrow <mhalcrow@google.com>, Eric Biggers <ebiggers@google.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Eric Biggers <ebiggers3@gmail.com> wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> This series fixes the bug found by syzkaller where the ptrace syscall
> can be used to set invalid bits in a task's FPU state.  I also found
> that an equivalent bug was reachable using the sigreturn syscall, so the
> first patch fixes the bug in both cases.
> 
> The other two patches start validating the other parts of the
> xstate_header and make it so that invalid FPU states can no longer be
> abused to leak the FPU registers of other processes.
> 
> Changes since v3:
>     - Rebase onto tip/master
> 
> Changes since v2:
>     - Use an exception handler to handle invalid FPU states
>       (suggested by Andy Lutomirski)
>     - Check the size of xstate_header.reserved at build time
>       (suggested by Dave Hansen)
> 
> Eric Biggers (3):
>   x86/fpu: don't let userspace set bogus xcomp_bv
>   x86/fpu: tighten validation of user-supplied xstate_header
>   x86/fpu: reinitialize FPU registers if restoring FPU state fails
> 
>  arch/x86/include/asm/fpu/internal.h | 51 +++++++++++-------------------------
>  arch/x86/include/asm/fpu/xstate.h   | 25 ++++++++++++++++++
>  arch/x86/kernel/fpu/regset.c        | 17 +++++-------
>  arch/x86/kernel/fpu/signal.c        | 18 ++++++++-----
>  arch/x86/kernel/fpu/xstate.c        | 52 ++++++++++++++-----------------------
>  arch/x86/mm/extable.c               | 24 +++++++++++++++++
>  6 files changed, 102 insertions(+), 85 deletions(-)

Thank you Eric - I've applied them and will push it all out together with the 
other pending bits in WIP.x86/fpu.

	Ingo
