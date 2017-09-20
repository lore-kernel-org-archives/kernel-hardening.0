Date: Tue, 19 Sep 2017 20:18:28 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20170920031828.GA537@zzz.localdomain>
References: <20170920004434.35308-1-ebiggers3@gmail.com>
 <20170920004434.35308-4-ebiggers3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170920004434.35308-4-ebiggers3@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 3/3] x86/fpu: reinitialize FPU registers if restoring
 FPU state fails
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dmitry Vyukov <dvyukov@google.com>, Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@kernel.org>, Kevin Hao <haokexin@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Wanpeng Li <wanpeng.li@hotmail.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Michael Halcrow <mhalcrow@google.com>, Eric Biggers <ebiggers@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Sep 19, 2017 at 05:44:34PM -0700, Eric Biggers wrote:
> +/*
> + * We should never get here because the fpregs_state stored in 'struct fpu'
> + * should always be readable and contain a valid FPU state.  However, past bugs
> + * have allowed userspace to set reserved bits in the XSAVE area using
> + * PTRACE_SETREGSET or sys_rt_sigreturn().  These caused XRSTOR to fail when
> + * switching to the task, leaking the FPU registers of the task previously
> + * executing on the CPU.  Mitigate this class of vulnerability by restoring from
> + * the initial state (essentially, zeroing out all the FPU registers) if we
> + * can't restore from the task's FPU state.
> + */
> +void __handle_bad_fpstate(union fpregs_state *fpstate, u64 mask)
> +{
> +	WARN_ONCE(1, "Bad FPU state detected, reinitializing FPU registers");
> +	____copy_kernel_to_fpregs(&init_fpstate, mask);
> +}

Sorry, a small oversight here --- this needs to be exported to modules, since
kvm can be built as a module, and kvm uses __copy_kernel_to_fpregs().

Eric
