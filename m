Message-ID: <1493920184.1596.4.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 04 May 2017 13:49:44 -0400
In-Reply-To: <20170504154850.GE20461@leverpostej>
References: <20170504142435.10175-1-danielmicay@gmail.com>
	 <20170504154850.GE20461@leverpostej>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] [PATCH] add the option of fortified string.h
 functions
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2017-05-04 at 16:48 +0100, Mark Rutland wrote:
> Hi,
> 
> From a glance, in the arm64 vdso case, that's due to the definition of
> vdso_start as a char giving it a single byte size.
> 
> We can/should probably use char[] for vdso_{start,end} on arm/arm64 as
> we do for other linker symbols (and x86 and tile do for
> vdso_{start,end}), i.e.

Yeah, I think that's the right approach, and this also applies to
features like -fsanitize=object-size in UBSan. I worked around it by
bypassing the function with __builtin_memcmp as I did for the other
cases I ran into, but they should all be fixed properly upstream.

> ---->8----
> diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
> index 41b6e31..ae35f18 100644
> --- a/arch/arm64/kernel/vdso.c
> +++ b/arch/arm64/kernel/vdso.c
> @@ -37,7 +37,7 @@
>  #include <asm/vdso.h>
>  #include <asm/vdso_datapage.h>
>  
> -extern char vdso_start, vdso_end;
> +extern char vdso_start[], vdso_end[];
>  static unsigned long vdso_pages __ro_after_init;
>  
>  /*
> @@ -125,14 +125,14 @@ static int __init vdso_init(void)
>         struct page **vdso_pagelist;
>         unsigned long pfn;
>  
> -       if (memcmp(&vdso_start, "\177ELF", 4)) {
> +       if (memcmp(vdso_start, "\177ELF", 4)) {
>                 pr_err("vDSO is not a valid ELF object!\n");
>                 return -EINVAL;
>         }
>  
> -       vdso_pages = (&vdso_end - &vdso_start) >> PAGE_SHIFT;
> +       vdso_pages = (vdso_end - vdso_start) >> PAGE_SHIFT;
>         pr_info("vdso: %ld pages (%ld code @ %p, %ld data @ %p)\n",
> -               vdso_pages + 1, vdso_pages, &vdso_start, 1L,
> vdso_data);
> +               vdso_pages + 1, vdso_pages, vdso_start, 1L,
> vdso_data);
>  
>         /* Allocate the vDSO pagelist, plus a page for the data. */
>         vdso_pagelist = kcalloc(vdso_pages + 1, sizeof(struct page *),
> @@ -145,7 +145,7 @@ static int __init vdso_init(void)
>  
>  
>         /* Grab the vDSO code pages. */
> -       pfn = sym_to_pfn(&vdso_start);
> +       pfn = sym_to_pfn(vdso_start);
>  
>         for (i = 0; i < vdso_pages; i++)
>                 vdso_pagelist[i + 1] = pfn_to_page(pfn + i);
> ---->8----
> 
> With that fixed, I see we also need a fortify_panic() for the EFI
> stub.
> 
> I'm not sure if the x86 EFI stub gets linked with the
> boot/compressed/misc.c version below, and/or whether it's safe for the
> EFI stub to call that.
> 
> ... with an EFI stub fortify_panic() hacked in, I can build an arm64
> kernel
> with this applied. It dies at some point after exiting EFI boot
> services; i
> don't know whether it made it out of the stub and into the kernel
> proper.

Could start with #define __NO_FORTIFY above the #include sections there
instead (or -D__NO_FORTIFY as a compiler flag), which will skip
fortifying those for now. I'm successfully using this on a non-EFI ARM64
3.18 LTS kernel, so it should be close to working on other systems (but
not necessarily with messy drivers). The x86 EFI workaround works.

> > It isn't particularly bad, but there are likely some issues that
> > occur
> > during regular use at runtime (none found so far).
> 
> It might be worth seeing if anyone can throw syzkaller and friends at
> this.

It tends to find stack buffer overflows, etc. not detected by ASan, so
that'd be nice. Can expand coverage a bit to some heap allocations with these, but I expect slab debugging and ASan already found most of what these would uncover:

https://github.com/thestinger/linux-hardened/commit/6efe84cdb88f73e8b8c59b59a8ea46fa4b1bdab1.patch
https://github.com/thestinger/linux-hardened/commit/d342da362c5f852c1666dce461bc82521b6711e4.patch

Unfortunately, ksize means alloc_size on kmalloc is not 100% correct
since the extra space from size class rounding falls outside of what it
will claim to be the size of the allocation. C standard libraries with
_FORTIFY_SOURCE seem to ignore this problem for malloc_usable_size. It
doesn't have many uses though.
