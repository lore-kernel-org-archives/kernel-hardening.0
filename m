Subject: Re: [PATCH v4 18/27] xen: Adapt assembly for PIE support
References: <20180529221625.33541-1-thgarnie@google.com>
 <20180529221625.33541-19-thgarnie@google.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <cfd5f012-4ce2-639b-9ff0-4ad627805fd4@oracle.com>
Date: Fri, 1 Jun 2018 11:44:07 -0400
MIME-Version: 1.0
In-Reply-To: <20180529221625.33541-19-thgarnie@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Thomas Garnier <thgarnie@google.com>, kernel-hardening@lists.openwall.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, "H.J. Lu" <hjl.tools@gmail.com>, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
List-ID: <kernel-hardening.lists.openwall.com>

On 05/29/2018 06:15 PM, Thomas Garnier wrote:
> diff --git a/arch/x86/xen/xen-pvh.S b/arch/x86/xen/xen-pvh.S
> index ca2d3b2bf2af..82ba89ba8bb3 100644
> --- a/arch/x86/xen/xen-pvh.S
> +++ b/arch/x86/xen/xen-pvh.S
> @@ -114,8 +114,8 @@ ENTRY(pvh_start_xen)
>  	call xen_prepare_pvh
>  
>  	/* startup_64 expects boot_params in %rsi. */
> -	mov $_pa(pvh_bootparams), %rsi
> -	mov $_pa(startup_64), %rax
> +	movabs $_pa(pvh_bootparams), %rsi
> +	movabs $_pa(startup_64), %rax
>  	jmp *%rax
>  
>  #else /* CONFIG_X86_64 */
> @@ -161,10 +161,15 @@ END(pvh_start_xen)
>  
>  	.section ".init.data","aw"
>  	.balign 8
> +	/*
> +	 * Use a quad for _pa(gdt_start) because PIE does not understand a
> +	 * long is enough. The resulting value will still be in the lower long
> +	 * part.
> +	 */
>  gdt:
>  	.word gdt_end - gdt_start
> -	.long _pa(gdt_start)
> -	.word 0
> +	.quad _pa(gdt_start)


With this becoming .quad 32-bit compilation fails:

/data/root/linux/arch/x86/xen/xen-pvh.S: Assembler messages:
/data/root/linux/arch/x86/xen/xen-pvh.S:147: Error: cannot represent
relocation type BFD_RELOC_64


-boris


> +	.balign 8
>  gdt_start:
>  	.quad 0x0000000000000000            /* NULL descriptor */
>  #ifdef CONFIG_X86_64
