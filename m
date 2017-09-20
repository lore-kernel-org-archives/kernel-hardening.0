MIME-Version: 1.0
In-Reply-To: <20170920004434.35308-4-ebiggers3@gmail.com>
References: <20170920004434.35308-1-ebiggers3@gmail.com> <20170920004434.35308-4-ebiggers3@gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 20 Sep 2017 08:41:00 -0700
Message-ID: <CALCETrWUHx7_Xo2dDXzxUUxQ=-qea2UN4yDT-hGi4CzGbr6npQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 3/3] x86/fpu: reinitialize FPU registers if restoring
 FPU state fails
To: Eric Biggers <ebiggers3@gmail.com>
Cc: X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dmitry Vyukov <dvyukov@google.com>, Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@kernel.org>, Kevin Hao <haokexin@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Wanpeng Li <wanpeng.li@hotmail.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Michael Halcrow <mhalcrow@google.com>, Eric Biggers <ebiggers@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

> On Sep 19, 2017, at 5:44 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Userspace can change the FPU state of a task using the ptrace() or
> rt_sigreturn() system calls.  Because reserved bits in the FPU state can
> cause the XRSTOR instruction to fail, the kernel has to carefully
> validate that no reserved bits or other invalid values are being set.
>
> Unfortunately, there have been bugs in this validation code.  For
> example, we were not checking that the 'xcomp_bv' field in the
> xstate_header was 0.  As-is, such bugs are exploitable to read the FPU
> registers of other processes on the system.  To do so, an attacker can
> create a task, assign to it an invalid FPU state, then spin in a loop
> and monitor the values of the FPU registers.  Because the task's FPU
> registers are not being restored, sometimes the FPU registers will have
> the values from another process.
>
> This is likely to continue to be a problem in the future because the
> validation done by the CPU instructions like XRSTOR is not immediately
> visible to kernel developers.  Nor will invalid FPU states ever be
> encountered during ordinary use --- they will only be seen during
> fuzzing or exploits.  There can even be reserved bits outside the
> xstate_header which are easy to forget about.  For example, the MXCSR
> register contains reserved bits, which were not validated by the
> KVM_SET_XSAVE ioctl until commit a575813bfe4b ("KVM: x86: Fix load
> damaged SSEx MXCSR register").
>
> Therefore, mitigate this class of vulnerability by restoring the FPU
> registers from init_fpstate if restoring from the task's state fails.
>
> We actually used to do this, but it was (perhaps unwisely) removed by
> commit 9ccc27a5d297 ("x86/fpu: Remove error return values from
> copy_kernel_to_*regs() functions").  This new patch is also a bit
> different in that it only clears the registers, not also the bad
> in-memory state.  This is simpler and makes it easier to make the
> mitigation cover all callers of __copy_kernel_to_fpregs().
>

I think this code could be cleaned up a lot in the process rather than
adding even more complexity.  What if you added an
ex_handler_fprestore() in arch/x86/mm/extable.c and changed all the
xrstor, etc users to invoke it via _ASM_HANDLE_EXTABLE?  I don't even
thing you'd need to have the C wrappers return a value --
ex_handler_fprestore() could do a WARN_ON_ONCE().

This would get rid of a few layers of wrappers and would get rid of
branches and code size in the success path.

--Andy
