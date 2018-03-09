MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180309033544.22509-1-tycho@tycho.ws>
References: <20180309033544.22509-1-tycho@tycho.ws>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 8 Mar 2018 20:55:50 -0800
Message-ID: <CAGXu5j+XKejfPhUcEjCeqrveaq-knTEeTiWxh5VM8wX5iQmu+A@mail.gmail.com>
Subject: Re: [PATCH] md: get rid of a VLA
Content-Type: text/plain; charset="UTF-8"
To: Tycho Andersen <tycho@tycho.ws>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Kernel Hardening <kernel-hardening@lists.openwall.com>, "Tobin C . Harding" <tobin@apporbit.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 8, 2018 at 7:35 PM, Tycho Andersen <tycho@tycho.ws> wrote:
> Ideally, we'd like to get rid of all VLAs in the kernel and add -Wvla to
> the build args: https://lkml.org/lkml/2018/3/7/621
>
> This one is a simple case, since we don't actually need the VLA at all: we
> can just iterate over the stripes twice, once to emit their names, and the
> second time to emit status (i.e. trade memory for time). Since the number
> of stripes is probably low, this is hopefully not that expensive.
>
> Signed-off-by: Tycho Andersen <tycho@tycho.ws>
> CC: Alasdair Kergon <agk@redhat.com>
> CC: Mike Snitzer <snitzer@redhat.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/md/dm-stripe.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> index b5e892149c54..cd209e8902a6 100644
> --- a/drivers/md/dm-stripe.c
> +++ b/drivers/md/dm-stripe.c
> @@ -368,7 +368,6 @@ static void stripe_status(struct dm_target *ti, status_type_t type,
>                           unsigned status_flags, char *result, unsigned maxlen)
>  {
>         struct stripe_c *sc = (struct stripe_c *) ti->private;
> -       char buffer[sc->stripes + 1];
>         unsigned int sz = 0;
>         unsigned int i;
>
> @@ -377,11 +376,12 @@ static void stripe_status(struct dm_target *ti, status_type_t type,
>                 DMEMIT("%d ", sc->stripes);
>                 for (i = 0; i < sc->stripes; i++)  {
>                         DMEMIT("%s ", sc->stripe[i].dev->name);
> -                       buffer[i] = atomic_read(&(sc->stripe[i].error_count)) ?
> -                               'D' : 'A';
>                 }
> -               buffer[i] = '\0';
> -               DMEMIT("1 %s", buffer);
> +               DMEMIT("1 ");
> +               for (i = 0; i < sc->stripes; i++) {
> +                       DMEMIT("%c", atomic_read(&(sc->stripe[i].error_count)) ?
> +                              'D' : 'A');
> +               }
>                 break;
>
>         case STATUSTYPE_TABLE:
> --
> 2.14.1
>



-- 
Kees Cook
Pixel Security
