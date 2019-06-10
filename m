Date: Mon, 10 Jun 2019 13:43:55 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 2/5] x86/vsyscall: Add a new vsyscall=xonly mode
Message-ID: <201906101342.B8A938BB@keescook>
References: <cover.1560198181.git.luto@kernel.org>
 <131caabf9d127db1a077525f978e1f1f74f9088f.1560198181.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <131caabf9d127db1a077525f978e1f1f74f9088f.1560198181.git.luto@kernel.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 10, 2019 at 01:25:28PM -0700, Andy Lutomirski wrote:
> With vsyscall emulation on, we still expose a readable vsyscall page
> that contains syscall instructions that validly implement the
> vsyscalls.  We need this because certain dynamic binary
> instrumentation tools attempt to read the call targets of call
> instructions in the instrumented code.  If the instrumented code
> uses vsyscalls, then the vsyscal page needs to contain readable
> code.
> 
> Unfortunately, leaving readable memory at a deterministic address
> can be used to help various ASLR bypasses, so we gain some hardening
> value if we disallow vsyscall reads.
> 
> Given how rarely the vsyscall page needs to be readable, add a
> mechanism to make the vsyscall page be execute only.

Should the commit log mention that the VVAR portion goes away under
xonly? (Since it's not executable.)

Otherwise, yay! Looks good to me and thanks for updating the selftests!

-Kees

> @@ -357,7 +368,7 @@ void __init map_vsyscall(void)
>  	extern char __vsyscall_page;
>  	unsigned long physaddr_vsyscall = __pa_symbol(&__vsyscall_page);
>  
> -	if (vsyscall_mode != NONE) {
> +	if (vsyscall_mode == EMULATE) {
>  		__set_fixmap(VSYSCALL_PAGE, physaddr_vsyscall,
>  			     PAGE_KERNEL_VVAR);
>  		set_vsyscall_pgtable_user_bits(swapper_pg_dir);
> -- 
> 2.21.0
> 

-- 
Kees Cook
