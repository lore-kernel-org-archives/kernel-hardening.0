Date: Fri, 17 Aug 2018 10:28:40 +0100
From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v15 7/7] arm64: Drop unneeded stackleak_check_alloca()
Message-ID: <20180817092839.GB8540@arm.com>
References: <1534457824-7211-1-git-send-email-alex.popov@linux.com>
 <1534457824-7211-8-git-send-email-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1534457824-7211-8-git-send-email-alex.popov@linux.com>
To: Alexander Popov <alex.popov@linux.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 17, 2018 at 01:17:04AM +0300, Alexander Popov wrote:
> Drop stackleak_check_alloca() for arm64 since the STACKLEAK gcc plugin now
> doesn't track stack depth overflow caused by alloca().
> 
> Signed-off-by: Alexander Popov <alex.popov@linux.com>
> ---
>  arch/arm64/kernel/process.c | 22 ----------------------
>  1 file changed, 22 deletions(-)

Acked-by: Will Deacon <will.deacon@arm.com>

Thanks,

Will

> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 7f1628e..740b31f 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -493,25 +493,3 @@ void arch_setup_new_exec(void)
>  {
>  	current->mm->context.flags = is_compat_task() ? MMCF_AARCH32 : 0;
>  }
> -
> -#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> -void __used stackleak_check_alloca(unsigned long size)
> -{
> -	unsigned long stack_left;
> -	unsigned long current_sp = current_stack_pointer;
> -	struct stack_info info;
> -
> -	BUG_ON(!on_accessible_stack(current, current_sp, &info));
> -
> -	stack_left = current_sp - info.low;
> -
> -	/*
> -	 * There's a good chance we're almost out of stack space if this
> -	 * is true. Using panic() over BUG() is more likely to give
> -	 * reliable debugging output.
> -	 */
> -	if (size >= stack_left)
> -		panic("alloca() over the kernel stack boundary\n");
> -}
> -EXPORT_SYMBOL(stackleak_check_alloca);
> -#endif
> -- 
> 2.7.4
> 
