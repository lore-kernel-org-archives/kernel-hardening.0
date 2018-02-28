MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180228142951.GA3136@pjb1027-Latitude-E5410>
References: <20180228142951.GA3136@pjb1027-Latitude-E5410>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 28 Feb 2018 08:54:31 -0800
Message-ID: <CAGXu5jKkHAHpzEpmHNJ6iPhXJKXoZH9Wy4mnCnE1=TEgTcHSRw@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH 1/2] arm: mm: Define vdso_start,
 vdso_end as array
Content-Type: text/plain; charset="UTF-8"
To: Jinbum Park <jinb.park7@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Philippe Ombredanne <pombredanne@nexb.co>, Greg KH <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, Andy Lutomirski <luto@amacapital.net>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 28, 2018 at 6:29 AM, Jinbum Park <jinb.park7@gmail.com> wrote:
> Define vdso_start, vdso_end as array to avoid compile-time analysis error
> for the case of built with CONFIG_FORTIFY_SOURCE.
>
> and, since vdso_start, vdso_end are used in vdso.c only,
> move extern-declaration from vdso.h to vdso.c.
>
> If kernel is built with CONFIG_FORTIFY_SOURCE,
> compile-time error happens at this code.
> - if (memcmp(&vdso_start, "\177ELF", 4))
>
> The size of "&vdso_start" is recognized as 1 byte, but n is 4,
> So that compile-time error is reported.
>
> Signed-off-by: Jinbum Park <jinb.park7@gmail.com>

Thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/arm/include/asm/vdso.h |  2 --
>  arch/arm/kernel/vdso.c      | 12 +++++++-----
>  2 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm/include/asm/vdso.h b/arch/arm/include/asm/vdso.h
> index 9c99e81..5b85889 100644
> --- a/arch/arm/include/asm/vdso.h
> +++ b/arch/arm/include/asm/vdso.h
> @@ -12,8 +12,6 @@
>
>  void arm_install_vdso(struct mm_struct *mm, unsigned long addr);
>
> -extern char vdso_start, vdso_end;
> -
>  extern unsigned int vdso_total_pages;
>
>  #else /* CONFIG_VDSO */
> diff --git a/arch/arm/kernel/vdso.c b/arch/arm/kernel/vdso.c
> index a4d6dc0..f4dd7f9 100644
> --- a/arch/arm/kernel/vdso.c
> +++ b/arch/arm/kernel/vdso.c
> @@ -39,6 +39,8 @@
>
>  static struct page **vdso_text_pagelist;
>
> +extern char vdso_start[], vdso_end[];
> +
>  /* Total number of pages needed for the data and text portions of the VDSO. */
>  unsigned int vdso_total_pages __ro_after_init;
>
> @@ -197,13 +199,13 @@ static int __init vdso_init(void)
>         unsigned int text_pages;
>         int i;
>
> -       if (memcmp(&vdso_start, "\177ELF", 4)) {
> +       if (memcmp(vdso_start, "\177ELF", 4)) {
>                 pr_err("VDSO is not a valid ELF object!\n");
>                 return -ENOEXEC;
>         }
>
> -       text_pages = (&vdso_end - &vdso_start) >> PAGE_SHIFT;
> -       pr_debug("vdso: %i text pages at base %p\n", text_pages, &vdso_start);
> +       text_pages = (vdso_end - vdso_start) >> PAGE_SHIFT;
> +       pr_debug("vdso: %i text pages at base %p\n", text_pages, vdso_start);
>
>         /* Allocate the VDSO text pagelist */
>         vdso_text_pagelist = kcalloc(text_pages, sizeof(struct page *),
> @@ -218,7 +220,7 @@ static int __init vdso_init(void)
>         for (i = 0; i < text_pages; i++) {
>                 struct page *page;
>
> -               page = virt_to_page(&vdso_start + i * PAGE_SIZE);
> +               page = virt_to_page(vdso_start + i * PAGE_SIZE);
>                 vdso_text_pagelist[i] = page;
>         }
>
> @@ -229,7 +231,7 @@ static int __init vdso_init(void)
>
>         cntvct_ok = cntvct_functional();
>
> -       patch_vdso(&vdso_start);
> +       patch_vdso(vdso_start);
>
>         return 0;
>  }
> --
> 1.9.1
>



-- 
Kees Cook
Pixel Security
