MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170510174441.26163-1-danielmicay@gmail.com>
References: <20170510174441.26163-1-danielmicay@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 10 May 2017 11:20:47 -0700
Message-ID: <CAGXu5j+avp7VAEAhRCH2fyQdqJo_yM2xkwxVbcO0eXeSscNNLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] mark protection_map as __ro_after_init
To: Daniel Micay <danielmicay@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 10, 2017 at 10:44 AM, Daniel Micay <danielmicay@gmail.com> wrote:
> The protection map is only modified by per-arch init code so it can be
> protected from writes after the init code runs.
>
> This change was extracted from PaX where it's part of KERNEXEC.
>
> Signed-off-by: Daniel Micay <danielmicay@gmail.com>

Thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  mm/mmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index f82741e199c0..3bd5ecd20d4d 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -94,7 +94,7 @@ static void unmap_region(struct mm_struct *mm,
>   *                                                             w: (no) no
>   *                                                             x: (yes) yes
>   */
> -pgprot_t protection_map[16] = {
> +pgprot_t protection_map[16] __ro_after_init = {
>         __P000, __P001, __P010, __P011, __P100, __P101, __P110, __P111,
>         __S000, __S001, __S010, __S011, __S100, __S101, __S110, __S111
>  };
> --
> 2.12.2
>



-- 
Kees Cook
Pixel Security
