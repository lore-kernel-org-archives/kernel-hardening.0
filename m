From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <1486014168-1279-2-git-send-email-bhsharma@redhat.com>
References: <1486014168-1279-1-git-send-email-bhsharma@redhat.com> <1486014168-1279-2-git-send-email-bhsharma@redhat.com>
Date: Thu, 02 Feb 2017 21:23:33 +1100
Message-ID: <87mve4c2my.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH 1/2] powerpc: mm: support ARCH_MMAP_RND_BITS
To: Bhupesh Sharma <bhsharma@redhat.com>, linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com
Cc: dcashman@google.com, bhupesh.linux@gmail.com, keescook@chromium.org, Alexander Graf <agraf@suse.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Anatolij Gustschin <agust@denx.de>, Alistair Popple <alistair@popple.id.au>, Matt Porter <mporter@kernel.crashing.org>, Vitaly Bordug <vitb@kernel.crashing.org>, Scott Wood <oss@buserror.net>, Kumar Gala <galak@kernel.crashing.org>, Daniel Cashman <dcashman@android.com>
List-ID: <kernel-hardening.lists.openwall.com>

Bhupesh Sharma <bhsharma@redhat.com> writes:

> powerpc: arch_mmap_rnd() uses hard-coded values, (23-PAGE_SHIFT) for
> 32-bit and (30-PAGE_SHIFT) for 64-bit, to generate the random offset
> for the mmap base address.
>
> This value represents a compromise between increased
> ASLR effectiveness and avoiding address-space fragmentation.
> Replace it with a Kconfig option, which is sensibly bounded, so that
> platform developers may choose where to place this compromise.
> Keep default values as new minimums.
>
> This patch makes sure that now powerpc mmap arch_mmap_rnd() approach
> is similar to other ARCHs like x86, arm64 and arm.

Thanks for looking at this, it's been on my TODO for a while.

I have a half completed version locally, but never got around to testing
it thoroughly.

> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index a8ee573fe610..b4a843f68705 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -22,6 +22,38 @@ config MMU
>  	bool
>  	default y
>  
> +config ARCH_MMAP_RND_BITS_MIN
> +       default 5 if PPC_256K_PAGES && 32BIT
> +       default 12 if PPC_256K_PAGES && 64BIT
> +       default 7 if PPC_64K_PAGES && 32BIT
> +       default 14 if PPC_64K_PAGES && 64BIT
> +       default 9 if PPC_16K_PAGES && 32BIT
> +       default 16 if PPC_16K_PAGES && 64BIT
> +       default 11 if PPC_4K_PAGES && 32BIT
> +       default 18 if PPC_4K_PAGES && 64BIT
> +
> +# max bits determined by the following formula:
> +#  VA_BITS - PAGE_SHIFT - 4
> +#  for e.g for 64K page and 64BIT = 48 - 16 - 4 = 28
> +config ARCH_MMAP_RND_BITS_MAX
> +       default 10 if PPC_256K_PAGES && 32BIT
> +       default 26 if PPC_256K_PAGES && 64BIT
> +       default 12 if PPC_64K_PAGES && 32BIT
> +       default 28 if PPC_64K_PAGES && 64BIT
> +       default 14 if PPC_16K_PAGES && 32BIT
> +       default 30 if PPC_16K_PAGES && 64BIT
> +       default 16 if PPC_4K_PAGES && 32BIT
> +       default 32 if PPC_4K_PAGES && 64BIT
> +
> +config ARCH_MMAP_RND_COMPAT_BITS_MIN
> +       default 5 if PPC_256K_PAGES
> +       default 7 if PPC_64K_PAGES
> +       default 9 if PPC_16K_PAGES
> +       default 11
> +
> +config ARCH_MMAP_RND_COMPAT_BITS_MAX
> +       default 16
> +

This is what I have below, which is a bit neater I think because each
value is only there once (by defaulting to the COMPAT value).

My max values are different to yours, I don't really remember why I
chose those values, so we can argue about which is right.

+config ARCH_MMAP_RND_BITS_MIN
+	# On 64-bit up to 1G of address space (2^30)
+	default 12 if 64BIT && PPC_256K_PAGES 	# 256K (2^18), = 30 - 18 = 12
+	default 14 if 64BIT && PPC_64K_PAGES  	# 64K  (2^16), = 30 - 16 = 14
+	default 16 if 64BIT && PPC_16K_PAGES  	# 16K  (2^14), = 30 - 14 = 16
+	default 18 if 64BIT			# 4K   (2^12), = 30 - 12 = 18
+	default ARCH_MMAP_RND_COMPAT_BITS_MIN
+
+config ARCH_MMAP_RND_BITS_MAX
+	# On 64-bit up to 32T of address space (2^45)
+	default 27 if 64BIT && PPC_256K_PAGES   # 256K (2^18), = 45 - 18 = 27
+	default 29 if 64BIT && PPC_64K_PAGES    # 64K  (2^16), = 45 - 16 = 29
+	default 31 if 64BIT && PPC_16K_PAGES    # 16K  (2^14), = 45 - 14 = 31
+	default 33 if 64BIT			# 4K   (2^12), = 45 - 12 = 33
+	default ARCH_MMAP_RND_COMPAT_BITS_MAX
+
+config ARCH_MMAP_RND_COMPAT_BITS_MIN
+	# Up to 8MB of address space (2^23)
+	default 5 if PPC_256K_PAGES             # 256K (2^18), = 23 - 18 = 5
+	default 7 if PPC_64K_PAGES              # 64K  (2^16), = 23 - 16 = 7
+	default 9 if PPC_16K_PAGES              # 16K  (2^14), = 23 - 14 = 9
+	default 11				# 4K   (2^12), = 23 - 12 = 11
+
+config ARCH_MMAP_RND_COMPAT_BITS_MAX
+	# Up to 2G of address space (2^31)
+	default 13 if PPC_256K_PAGES            # 256K (2^18), = 31 - 18 = 13
+	default 15 if PPC_64K_PAGES             # 64K  (2^16), = 31 - 16 = 15
+	default 17 if PPC_16K_PAGES             # 16K  (2^14), = 31 - 14 = 17
+	default 19				# 4K   (2^12), = 31 - 12 = 19



> diff --git a/arch/powerpc/mm/mmap.c b/arch/powerpc/mm/mmap.c
> index 2f1e44362198..babf59faab3b 100644
> --- a/arch/powerpc/mm/mmap.c
> +++ b/arch/powerpc/mm/mmap.c
> @@ -60,11 +60,12 @@ unsigned long arch_mmap_rnd(void)
>  {
>  	unsigned long rnd;
>  
> -	/* 8MB for 32bit, 1GB for 64bit */
> +#ifdef CONFIG_COMPAT
>  	if (is_32bit_task())
> -		rnd = get_random_long() % (1<<(23-PAGE_SHIFT));
> +		rnd = get_random_long() & ((1UL << mmap_rnd_compat_bits) - 1);
>  	else
> -		rnd = get_random_long() % (1UL<<(30-PAGE_SHIFT));
> +#endif
> +		rnd = get_random_long() & ((1UL << mmap_rnd_bits) - 1);

I also have what I think is a better hunk for that:

 unsigned long arch_mmap_rnd(void)
 {
-	unsigned long rnd;
+	unsigned long shift, rnd;
 
-	/* 8MB for 32bit, 1GB for 64bit */
+	shift = mmap_rnd_bits;
+#ifdef CONFIG_COMPAT
 	if (is_32bit_task())
-		rnd = (unsigned long)get_random_int() % (1<<(23-PAGE_SHIFT));
-	else
-		rnd = (unsigned long)get_random_int() % (1<<(30-PAGE_SHIFT));
+		shift = mmap_rnd_compat_bits;
+#endif
+
+	rnd = (unsigned long)get_random_int() % (1 << shift);

But I'm just nit picking I guess :)

cheers
