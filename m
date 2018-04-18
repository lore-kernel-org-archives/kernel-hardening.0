Subject: Re: [PATCHv2] x86/xen: Remove use of VLAs
References: <20180418170832.8798-1-labbott@redhat.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <b4a28e8b-d4ec-bbd2-cfaf-9a416ef08ef6@oracle.com>
Date: Wed, 18 Apr 2018 18:17:04 -0400
MIME-Version: 1.0
In-Reply-To: <20180418170832.8798-1-labbott@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Laura Abbott <labbott@redhat.com>, Juergen Gross <jgross@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 04/18/2018 01:08 PM, Laura Abbott wrote:
> There's an ongoing effort to remove VLAs[1] from the kernel to eventually
> turn on -Wvla. It turns out, the few VLAs in use in Xen produce only a
> single entry array that is always bounded by GDT_SIZE. Clean up the code to
> get rid of the VLA and the loop.
>
> [1] https://lkml.org/lkml/2018/3/7/621
>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> v2: Updated the code to reflect that we know size is always bounded by
> GDT_SIZE. This gets rid of the array and the loop. I can throw a few
> more comments in there if someone thinks they need to be updated.
> ---
>  arch/x86/xen/enlighten_pv.c | 84 ++++++++++++++++-----------------------------
>  1 file changed, 29 insertions(+), 55 deletions(-)
>
> diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
> index c36d23aa6c35..1254f2fa3a89 100644
> --- a/arch/x86/xen/enlighten_pv.c
> +++ b/arch/x86/xen/enlighten_pv.c
> @@ -421,45 +421,32 @@ static void xen_load_gdt(const struct desc_ptr *dtr)
>  {
>  	unsigned long va = dtr->address;
>  	unsigned int size = dtr->size + 1;
> -	unsigned pages = DIV_ROUND_UP(size, PAGE_SIZE);
> -	unsigned long frames[pages];
> -	int f;
> -
> -	/*
> -	 * A GDT can be up to 64k in size, which corresponds to 8192
> -	 * 8-byte entries, or 16 4k pages..
> -	 */
> +	unsigned long pfn, mfn;
> +	int level;
> +	pte_t *ptep;
> +	void *virt;
>  
> -	BUG_ON(size > 65536);
> +	BUG_ON(size > GDT_SIZE);


I'd probably BUG_ON(size>PAGE_SIZE) because that's what we are really
trying to avoid. Maybe with a comment that we expect GDT_SIZE at most,
and it is less than PAGE_SIZE.

I can fix it while committing if you don't object.

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
