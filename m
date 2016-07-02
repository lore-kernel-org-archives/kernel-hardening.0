Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 2 Jul 2016 19:24:41 +0200
From: Borislav Petkov <bp@alien8.de>
Message-ID: <20160702172441.GA22748@pd.tnic>
References: <cover.1466974736.git.luto@kernel.org>
 <37ac7589ff0ea147e8a21cda5eb84d3af1f6cd60.1466974736.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <37ac7589ff0ea147e8a21cda5eb84d3af1f6cd60.1466974736.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH v4 10/29] x86/die: Don't try to recover from an OOPS on a
 non-default stack
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 26, 2016 at 02:55:32PM -0700, Andy Lutomirski wrote:
> It's not going to work, because the scheduler will explode if we try
> to schedule when running on an IST stack or similar.
> 
> This will matter when we let kernel stack overflows (which are #DF)
> call die().
> 
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  arch/x86/kernel/dumpstack.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> index ef8017ca5ba9..352f022cfd5b 100644
> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -245,6 +245,9 @@ void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
>  		return;
>  	if (in_interrupt())
>  		panic("Fatal exception in interrupt");
> +	if (((current_stack_pointer() ^ (current_top_of_stack() - 1))
> +	     & ~(THREAD_SIZE - 1)) != 0)

Ugh, that's hard to parse. You could remove the "!= 0" at least to
shorten it a bit and have one less braces level.

Or maybe even do something like that to make it a bit more readable:

        if ((current_stack_pointer() ^ (current_top_of_stack() - 1))
                        &
             ~(THREAD_SIZE - 1))
                panic("Fatal exception on non-default stack");

Meh.

> +		panic("Fatal exception on special stack");

			"Fatal exception on non-default stack"

maybe?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
