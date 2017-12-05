MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20171204142631.GA3359@pjb1027-Latitude-E5410>
References: <20171204142631.GA3359@pjb1027-Latitude-E5410>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 5 Dec 2017 11:53:43 -0800
Message-ID: <CAGXu5jKpcQkro9O6VOLp92okMy6u9695B8bitwxum80iXi-s1Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening][PATCH v3 2/3] arm: mm: dump: make the page
 table dumping seq_file optional
To: Jinbum Park <jinb.park7@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Afzal Mohammed <afzal.mohd.ma@gmail.com>, Mark Rutland <mark.rutland@arm.com>, Laura Abbott <labbott@redhat.com>, Russell King <linux@armlinux.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Vladimir Murzin <vladimir.murzin@arm.com>, Arnd Bergmann <arnd@arndb.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 4, 2017 at 6:26 AM, Jinbum Park <jinb.park7@gmail.com> wrote:
> This patch makes the page table dumping seq_file optional.
> It makes the page table dumping code usable for other cases.
>
> This patch refers below commit of arm64.
> (ae5d1cf358a5
> ("arm64: dump: Make the page table dumping seq_file optional"))
>
> Signed-off-by: Jinbum Park <jinb.park7@gmail.com>

Looks good to me. :)

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
> v3: No changes
>
>  arch/arm/mm/dump.c | 28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
> index 8dfe7c3..43a2bee 100644
> --- a/arch/arm/mm/dump.c
> +++ b/arch/arm/mm/dump.c
> @@ -34,6 +34,18 @@
>         { -1,                   NULL },
>  };
>
> +#define pt_dump_seq_printf(m, fmt, args...) \
> +({                      \
> +       if (m)                                  \
> +               seq_printf(m, fmt, ##args);     \
> +})
> +
> +#define pt_dump_seq_puts(m, fmt)    \
> +({                                             \
> +       if (m)                                  \
> +               seq_printf(m, fmt);     \
> +})
> +
>  struct pg_state {
>         struct seq_file *seq;
>         const struct addr_marker *marker;
> @@ -210,7 +222,7 @@ static void dump_prot(struct pg_state *st, const struct prot_bits *bits, size_t
>                         s = bits->clear;
>
>                 if (s)
> -                       seq_printf(st->seq, " %s", s);
> +                       pt_dump_seq_printf(st->seq, " %s", s);
>         }
>  }
>
> @@ -224,7 +236,7 @@ static void note_page(struct pg_state *st, unsigned long addr,
>                 st->level = level;
>                 st->current_prot = prot;
>                 st->current_domain = domain;
> -               seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
> +               pt_dump_seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
>         } else if (prot != st->current_prot || level != st->level ||
>                    domain != st->current_domain ||
>                    addr >= st->marker[1].start_address) {
> @@ -232,7 +244,7 @@ static void note_page(struct pg_state *st, unsigned long addr,
>                 unsigned long delta;
>
>                 if (st->current_prot) {
> -                       seq_printf(st->seq, "0x%08lx-0x%08lx   ",
> +                       pt_dump_seq_printf(st->seq, "0x%08lx-0x%08lx   ",
>                                    st->start_address, addr);
>
>                         delta = (addr - st->start_address) >> 10;
> @@ -240,17 +252,19 @@ static void note_page(struct pg_state *st, unsigned long addr,
>                                 delta >>= 10;
>                                 unit++;
>                         }
> -                       seq_printf(st->seq, "%9lu%c", delta, *unit);
> +                       pt_dump_seq_printf(st->seq, "%9lu%c", delta, *unit);
>                         if (st->current_domain)
> -                               seq_printf(st->seq, " %s", st->current_domain);
> +                               pt_dump_seq_printf(st->seq, " %s",
> +                                                       st->current_domain);
>                         if (pg_level[st->level].bits)
>                                 dump_prot(st, pg_level[st->level].bits, pg_level[st->level].num);
> -                       seq_printf(st->seq, "\n");
> +                       pt_dump_seq_printf(st->seq, "\n");
>                 }
>
>                 if (addr >= st->marker[1].start_address) {
>                         st->marker++;
> -                       seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
> +                       pt_dump_seq_printf(st->seq, "---[ %s ]---\n",
> +                                                       st->marker->name);
>                 }
>                 st->start_address = addr;
>                 st->current_prot = prot;
> --
> 1.9.1
>



-- 
Kees Cook
Pixel Security
