Return-Path: <kernel-hardening-return-21548-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id C1AF9C433F5
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Mar 2022 19:35:58 +0000 (UTC)
Received: (qmail 22263 invoked by uid 550); 9 Mar 2022 19:35:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22225 invoked from network); 9 Mar 2022 19:35:46 -0000
X-Virus-Scanned: amavisd-new at c-s.fr
X-Virus-Scanned: amavisd-new at c-s.fr
Message-ID: <d83ff309-faf4-499c-7e97-4b3258ed5723@csgroup.eu>
Date: Wed, 9 Mar 2022 20:35:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] powerpc/32: Stop printing the virtual memory layout
Content-Language: fr-FR
To: Arvind Sankar <nivedita@alum.mit.edu>, Kees Cook <keescook@chromium.org>
Cc: Tycho Andersen <tycho@tycho.ws>, kernel-hardening@lists.openwall.com,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
 linuxppc-dev@lists.ozlabs.org, "Tobin C . Harding" <me@tobin.cc>
References: <202003021038.8F0369D907@keescook>
 <20200305150837.835083-1-nivedita@alum.mit.edu>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <20200305150837.835083-1-nivedita@alum.mit.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 05/03/2020 à 16:08, Arvind Sankar a écrit :
> For security, don't display the kernel's virtual memory layout.
> 
> Kees Cook points out:
> "These have been entirely removed on other architectures, so let's
> just do the same for ia32 and remove it unconditionally."
> 
> 071929dbdd86 ("arm64: Stop printing the virtual memory layout")
> 1c31d4e96b8c ("ARM: 8820/1: mm: Stop printing the virtual memory layout")
> 31833332f798 ("m68k/mm: Stop printing the virtual memory layout")
> fd8d0ca25631 ("parisc: Hide virtual kernel memory layout")
> adb1fe9ae2ee ("mm/page_alloc: Remove kernel address exposure in free_reserved_area()")
> 
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>

This patch doesn't apply anymore.

This patch is referenced in https://github.com/linuxppc/issues/issues/390

> ---
>   arch/powerpc/mm/mem.c | 17 -----------------
>   1 file changed, 17 deletions(-)
> 
> diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
> index ef7b1119b2e2..df2c143b6bf7 100644
> --- a/arch/powerpc/mm/mem.c
> +++ b/arch/powerpc/mm/mem.c
> @@ -331,23 +331,6 @@ void __init mem_init(void)
>   #endif
>   
>   	mem_init_print_info(NULL);
> -#ifdef CONFIG_PPC32
> -	pr_info("Kernel virtual memory layout:\n");
> -#ifdef CONFIG_KASAN
> -	pr_info("  * 0x%08lx..0x%08lx  : kasan shadow mem\n",
> -		KASAN_SHADOW_START, KASAN_SHADOW_END);
> -#endif
> -	pr_info("  * 0x%08lx..0x%08lx  : fixmap\n", FIXADDR_START, FIXADDR_TOP);
> -#ifdef CONFIG_HIGHMEM
> -	pr_info("  * 0x%08lx..0x%08lx  : highmem PTEs\n",
> -		PKMAP_BASE, PKMAP_ADDR(LAST_PKMAP));
> -#endif /* CONFIG_HIGHMEM */
> -	if (ioremap_bot != IOREMAP_TOP)
> -		pr_info("  * 0x%08lx..0x%08lx  : early ioremap\n",
> -			ioremap_bot, IOREMAP_TOP);
> -	pr_info("  * 0x%08lx..0x%08lx  : vmalloc & ioremap\n",
> -		VMALLOC_START, VMALLOC_END);
> -#endif /* CONFIG_PPC32 */
>   }
>   
>   void free_initmem(void)
