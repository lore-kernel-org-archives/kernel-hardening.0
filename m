From: Balbir Singh <bsingharora@gmail.com>
Date: Thu, 2 Feb 2017 17:52:56 +0530
Message-ID: <20170202122256.GD5179@localhost.localdomain>
References: <1486014168-1279-1-git-send-email-bhsharma@redhat.com>
 <1486014168-1279-2-git-send-email-bhsharma@redhat.com>
 <87mve4c2my.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mve4c2my.fsf@concordia.ellerman.id.au>
Subject: [kernel-hardening] Re: [PATCH 1/2] powerpc: mm: support ARCH_MMAP_RND_BITS
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Bhupesh Sharma <bhsharma@redhat.com>, linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com, Anatolij Gustschin <agust@denx.de>, keescook@chromium.org, Daniel Cashman <dcashman@android.com>, Scott Wood <oss@buserror.net>, Paul Mackerras <paulus@samba.org>, dcashman@google.com, Alistair Popple <alistair@popple.id.au>, bhupesh.linux@gmail.com, Alexander Graf <agraf@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 02, 2017 at 09:23:33PM +1100, Michael Ellerman wrote:
> +config ARCH_MMAP_RND_BITS_MIN
> +	# On 64-bit up to 1G of address space (2^30)
> +	default 12 if 64BIT && PPC_256K_PAGES 	# 256K (2^18), = 30 - 18 = 12
> +	default 14 if 64BIT && PPC_64K_PAGES  	# 64K  (2^16), = 30 - 16 = 14
> +	default 16 if 64BIT && PPC_16K_PAGES  	# 16K  (2^14), = 30 - 14 = 16
> +	default 18 if 64BIT			# 4K   (2^12), = 30 - 12 = 18
> +	default ARCH_MMAP_RND_COMPAT_BITS_MIN
> +
> +config ARCH_MMAP_RND_BITS_MAX
> +	# On 64-bit up to 32T of address space (2^45)

I thought it was 64T, TASK_SIZE_USER64 is 2^46?

<snip>

> I also have what I think is a better hunk for that:
> 
>  unsigned long arch_mmap_rnd(void)
>  {
> -	unsigned long rnd;
> +	unsigned long shift, rnd;
>  
> -	/* 8MB for 32bit, 1GB for 64bit */
> +	shift = mmap_rnd_bits;
> +#ifdef CONFIG_COMPAT
>  	if (is_32bit_task())
> -		rnd = (unsigned long)get_random_int() % (1<<(23-PAGE_SHIFT));
> -	else
> -		rnd = (unsigned long)get_random_int() % (1<<(30-PAGE_SHIFT));
> +		shift = mmap_rnd_compat_bits;
> +#endif
> +
> +	rnd = (unsigned long)get_random_int() % (1 << shift);
> 
> But I'm just nit picking I guess :)
>

No.. the version above is nicer IMHO

Balbir 
