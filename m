Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 20 Oct 2017 10:26:46 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20171020082646.bkxrps35sb3gq2nr@gmail.com>
References: <20171011203027.11248-1-thgarnie@google.com>
 <20171011203027.11248-7-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171011203027.11248-7-thgarnie@google.com>
Subject: [kernel-hardening] Re: [PATCH v1 06/27] x86/entry/64: Adapt assembly for PIE support
To: Thomas Garnier <thgarnie@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Matthias Kaehlcke <mka@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Borislav Petkov <bp@alien8.de>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christopher Li <sparse@chrisli.org>, Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Peter Foley <pefoley2@pefoley.com>, Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Jan H =?iso-8859-1?Q?=2E_Sch=F6nherr?= <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>, x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


* Thomas Garnier <thgarnie@google.com> wrote:

> Change the assembly code to use only relative references of symbols for the
> kernel to be PIE compatible.
> 
> Position Independent Executable (PIE) support will allow to extended the
> KASLR randomization range below the -2G memory limit.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
>  arch/x86/entry/entry_64.S | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index 49167258d587..15bd5530d2ae 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -194,12 +194,15 @@ entry_SYSCALL_64_fastpath:
>  	ja	1f				/* return -ENOSYS (already in pt_regs->ax) */
>  	movq	%r10, %rcx
>  
> +	/* Ensures the call is position independent */
> +	leaq	sys_call_table(%rip), %r11
> +
>  	/*
>  	 * This call instruction is handled specially in stub_ptregs_64.
>  	 * It might end up jumping to the slow path.  If it jumps, RAX
>  	 * and all argument registers are clobbered.
>  	 */
> -	call	*sys_call_table(, %rax, 8)
> +	call	*(%r11, %rax, 8)
>  .Lentry_SYSCALL_64_after_fastpath_call:
>  
>  	movq	%rax, RAX(%rsp)
> @@ -334,7 +337,8 @@ ENTRY(stub_ptregs_64)
>  	 * RAX stores a pointer to the C function implementing the syscall.
>  	 * IRQs are on.
>  	 */
> -	cmpq	$.Lentry_SYSCALL_64_after_fastpath_call, (%rsp)
> +	leaq	.Lentry_SYSCALL_64_after_fastpath_call(%rip), %r11
> +	cmpq	%r11, (%rsp)
>  	jne	1f
>  
>  	/*
> @@ -1172,7 +1176,8 @@ ENTRY(error_entry)
>  	movl	%ecx, %eax			/* zero extend */
>  	cmpq	%rax, RIP+8(%rsp)
>  	je	.Lbstep_iret
> -	cmpq	$.Lgs_change, RIP+8(%rsp)
> +	leaq	.Lgs_change(%rip), %rcx
> +	cmpq	%rcx, RIP+8(%rsp)
>  	jne	.Lerror_entry_done
>  
>  	/*
> @@ -1383,10 +1388,10 @@ ENTRY(nmi)
>  	 * resume the outer NMI.
>  	 */
>  
> -	movq	$repeat_nmi, %rdx
> +	leaq	repeat_nmi(%rip), %rdx
>  	cmpq	8(%rsp), %rdx
>  	ja	1f
> -	movq	$end_repeat_nmi, %rdx
> +	leaq	end_repeat_nmi(%rip), %rdx
>  	cmpq	8(%rsp), %rdx
>  	ja	nested_nmi_out
>  1:
> @@ -1440,7 +1445,8 @@ nested_nmi:
>  	pushq	%rdx
>  	pushfq
>  	pushq	$__KERNEL_CS
> -	pushq	$repeat_nmi
> +	leaq	repeat_nmi(%rip), %rdx
> +	pushq	%rdx
>  
>  	/* Put stack back */
>  	addq	$(6*8), %rsp
> @@ -1479,7 +1485,9 @@ first_nmi:
>  	addq	$8, (%rsp)	/* Fix up RSP */
>  	pushfq			/* RFLAGS */
>  	pushq	$__KERNEL_CS	/* CS */
> -	pushq	$1f		/* RIP */
> +	pushq	%rax		/* Support Position Independent Code */
> +	leaq	1f(%rip), %rax	/* RIP */
> +	xchgq	%rax, (%rsp)	/* Restore RAX, put 1f */
>  	INTERRUPT_RETURN	/* continues at repeat_nmi below */
>  	UNWIND_HINT_IRET_REGS

This patch seems to add extra overhead to the syscall fast-path even when PIE is 
disabled, right?

Thanks,

	Ingo
