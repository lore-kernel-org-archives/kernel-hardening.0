Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Wed, 13 Jul 2016 09:53:31 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160713075314.GA32700@gmail.com>
References: <cover.1468270393.git.luto@kernel.org>
 <8d36dd9b2430b61db64333af7b911d0bca7d5d2f.1468270393.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d36dd9b2430b61db64333af7b911d0bca7d5d2f.1468270393.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH v5 14/32] x86/mm/64: Enable vmapped stacks
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Andy Lutomirski <luto@kernel.org> wrote:

> This allows x86_64 kernels to enable vmapped stacks.  There are a
> couple of interesting bits.

> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -92,6 +92,7 @@ config X86
>  	select HAVE_ARCH_TRACEHOOK
>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
>  	select HAVE_EBPF_JIT			if X86_64
> +	select HAVE_ARCH_VMAP_STACK		if X86_64

So what is the performance impact?

Because I think we should consider enabling this feature by default on x86 - but 
the way it's selected here it will be default-off.

On the plus side: the debuggability and reliability improvements are real and 
making it harder for exploits to use kernel stack overflows is a nice bonus as 
well. There's two performance effects:

 - vmalloc now potentially moves into the thread pool create/destroy hot path.

 - we use 4K TLBs for kernel stacks instead of 2MB TLBs.

The TLB effect should be relatively modest on modern CPUs, given that the kernel 
stack size is limited and 4K TLBs are plenty. The vmalloc() part should be 
measured I suspect.

Thanks,

	Ingo
