MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20171208111318.GA12346@pjb1027-Latitude-E5410>
References: <20171208111318.GA12346@pjb1027-Latitude-E5410>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 8 Dec 2017 12:59:22 -0800
Message-ID: <CAGXu5jJwkQCQ2c=2m8dposm8RC1VCTE83iuRR=4XN7wdXwjuyA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening][PATCH] arm: mm: idmap: Mark variables as ro_after_init
To: Jinbum Park <jinb.park7@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Russell King <linux@armlinux.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, kstewart@linuxfoundation.org, Ingo Molnar <mingo@kernel.org>, pombredanne@nexb.com, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 8, 2017 at 3:13 AM, Jinbum Park <jinb.park7@gmail.com> wrote:
> idmap_pgd, arch_phys_to_idmap_offset are setup once
> while init stage, and never changed after that.
> so, it is good candidate for __ro_after_init.
>
> Signed-off-by: Jinbum Park <jinb.park7@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

Does arm64 have anything like this? Just grepping for similar names,
idmap_t0sz looks like it could actually be const.

-Kees

> ---
>  arch/arm/mm/idmap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mm/idmap.c b/arch/arm/mm/idmap.c
> index 10bfba8..1d1edd0 100644
> --- a/arch/arm/mm/idmap.c
> +++ b/arch/arm/mm/idmap.c
> @@ -16,8 +16,8 @@
>   * are not supported on any CPU using the idmap tables as its current
>   * page tables.
>   */
> -pgd_t *idmap_pgd;
> -long long arch_phys_to_idmap_offset;
> +pgd_t *idmap_pgd __ro_after_init;
> +long long arch_phys_to_idmap_offset __ro_after_init;
>
>  #ifdef CONFIG_ARM_LPAE
>  static void idmap_add_pmd(pud_t *pud, unsigned long addr, unsigned long end,
> --
> 1.9.1
>



-- 
Kees Cook
Pixel Security
