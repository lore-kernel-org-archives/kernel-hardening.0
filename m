MIME-Version: 1.0
In-Reply-To: <20181017121000.30240-1-mpe@ellerman.id.au>
References: <20181017121000.30240-1-mpe@ellerman.id.au>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 18 Oct 2018 17:35:30 -0700
Message-ID: <CAGXu5jLzv4Gxyote5-5jMJSbfJ-EPpRDQNaz2jyANP2yEY=tgA@mail.gmail.com>
Subject: Re: [PATCH] seq_buf: Make seq_buf_puts() NULL terminate the buffer
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 17, 2018 at 5:10 AM, Michael Ellerman <mpe@ellerman.id.au> wrot=
e:
> Currently seq_buf_puts() will happily create a non NULL terminated
> string for you in the buffer. This is particularly dangerous if the
> buffer is on the stack.
>
> For example:
>
>   char buf[8];
>   char secret =3D "secret";
>   struct seq_buf s;
>
>   seq_buf_init(&s, buf, sizeof(buf));
>   seq_buf_puts(&s, "foo");
>   printk("Message is %s\n", buf);
>
> Can result in:
>
>   Message is foo=C2=AA=C2=AA=C2=AA=C2=AA=C2=AAsecret
>
> We could require all users to memset() their buffer to NULL before
> use. But that seems likely to be forgotten and lead to bugs.
>
> Instead we can change seq_buf_puts() to always leave the buffer in a
> NULL terminated state.
>
> The only downside is that this makes the buffer 1 character smaller
> for seq_buf_puts(), but that seems like a good trade off.
>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Yes, please! :) I prefer keeping the string terminated over needing to
remember to do it later.

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  lib/seq_buf.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> I recently merged a patch which actually hit this behaviour. I worked
> around it by using seq_buf_printf(), but it would be good to fix the
> problem at the source.
>
> diff --git a/lib/seq_buf.c b/lib/seq_buf.c
> index 11f2ae0f9099..b1570204cde3 100644
> --- a/lib/seq_buf.c
> +++ b/lib/seq_buf.c
> @@ -144,9 +144,13 @@ int seq_buf_puts(struct seq_buf *s, const char *str)
>
>         WARN_ON(s->size =3D=3D 0);
>
> +       /* Add 1 to len for the trailing NULL which must be there */
> +       len +=3D 1;
> +
>         if (seq_buf_can_fit(s, len)) {
>                 memcpy(s->buffer + s->len, str, len);
> -               s->len +=3D len;
> +               /* Don't count the trailing NULL against the capacity */
> +               s->len +=3D len - 1;
>                 return 0;
>         }
>         seq_buf_set_overflow(s);
> --
> 2.17.1
>



--=20
Kees Cook
Pixel Security
