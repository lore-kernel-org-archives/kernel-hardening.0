Reply-To: kernel-hardening@lists.openwall.com
References: <1470681607-36883-1-git-send-email-thgarnie@google.com>
 <1470681607-36883-2-git-send-email-thgarnie@google.com>
From: =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
Message-ID: <68119f42-cb1b-fd3e-3820-7cf235e607e5@nextfour.com>
Date: Tue, 9 Aug 2016 08:16:46 +0300
MIME-Version: 1.0
In-Reply-To: <1470681607-36883-2-git-send-email-thgarnie@google.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v1 2/2] x86/KASLR: Increase BRK pages for KASLR memory
 randomization
To: Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lv Zheng <lv.zheng@intel.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Aleksey Makarov <aleksey.makarov@linaro.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Fabian Frederick <fabf@skynet.be>, Toshi Kani <toshi.kani@hp.com>, Dan Williams <dan.j.williams@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 08/08/2016 09:40 PM, Thomas Garnier wrote:
> Default implementation expects 6 pages maximum are needed for low page
> allocations. If KASLR memory randomization is enabled, the worse case
> of e820 layout would require 12 pages (no large pages). It is due to the
> PUD level randomization and the variable e820 memory layout.
> 
> This bug was found while doing extensive testing of KASLR memory
> randomization on different type of hardware.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
> Based on next-20160805
> ---
>  arch/x86/mm/init.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 6209289..3a27e6a 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -130,6 +130,14 @@ void  __init early_alloc_pgt_buf(void)
>  	unsigned long tables = INIT_PGT_BUF_SIZE;
>  	phys_addr_t base;
>  
> +	/*
> +	 * Depending on the machine e860 memory layout and the PUD alignement.
> +	 * We may need twice more pages when KASLR memoy randomization is
> +	 * enabled.
> +	 */
> +	if (IS_ENABLED(CONFIG_RANDOMIZE_MEMORY))
> +		tables *= 2;
> +
>  	base = __pa(extend_brk(tables, PAGE_SIZE));
>  
>  	pgt_buf_start = base >> PAGE_SHIFT;
> 

You should increase the reserve also :
RESERVE_BRK(early_pgt_alloc, INIT_PGT_BUF_SIZE);


--Mika
