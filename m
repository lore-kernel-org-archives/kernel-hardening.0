MIME-Version: 1.0
References: <20181017121000.30240-1-mpe@ellerman.id.au>
In-Reply-To: <20181017121000.30240-1-mpe@ellerman.id.au>
From: Jann Horn <jannh@google.com>
Date: Wed, 17 Oct 2018 14:26:37 +0200
Message-ID: <CAG48ez2W8HeJcuPwA25vSqTco3B=CRzycSA0=--pG=7jWi3pPw@mail.gmail.com>
Subject: Re: [PATCH] seq_buf: Make seq_buf_puts() NULL terminate the buffer
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 17, 2018 at 2:10 PM Michael Ellerman <mpe@ellerman.id.au> wrote=
:
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

After this, you can also simplify rdt_last_cmd_status_show(), right?

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

Nit: In the comments, I would prefer either "null byte" or "NUL"
instead of "NULL" when talking about something that is not a pointer.

> +       len +=3D 1;

It looks like you're using an "unsigned int" for the length, meaning
that this can in theory (e.g. when operating on a string from a big
vmalloc buffer) overflow. You should be using size_t here.

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
