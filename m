From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v2 1/2] seq_buf: Make seq_buf_puts() null-terminate the buffer
In-Reply-To: <20181019042109.8064-1-mpe@ellerman.id.au>
References: <20181019042109.8064-1-mpe@ellerman.id.au>
Date: Wed, 12 Dec 2018 22:21:46 +1100
Message-ID: <87imzzvvlh.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, jannh@google.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Steve,

Friendly ping :)

Do you mind picking this one up for 4.21 ?

cheers

Michael Ellerman <mpe@ellerman.id.au> writes:
> Currently seq_buf_puts() will happily create a non null-terminated
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
> We could require all users to memset() their buffer to zero before
> use. But that seems likely to be forgotten and lead to bugs.
>
> Instead we can change seq_buf_puts() to always leave the buffer in a
> null-terminated state.
>
> The only downside is that this makes the buffer 1 character smaller
> for seq_buf_puts(), but that seems like a good trade off.
>
> Acked-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  lib/seq_buf.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> v2: Fix NULL/null terminology.
>
> diff --git a/lib/seq_buf.c b/lib/seq_buf.c
> index 11f2ae0f9099..6aabb609dd87 100644
> --- a/lib/seq_buf.c
> +++ b/lib/seq_buf.c
> @@ -144,9 +144,13 @@ int seq_buf_puts(struct seq_buf *s, const char *str)
>=20=20
>  	WARN_ON(s->size =3D=3D 0);
>=20=20
> +	/* Add 1 to len for the trailing null byte which must be there */
> +	len +=3D 1;
> +
>  	if (seq_buf_can_fit(s, len)) {
>  		memcpy(s->buffer + s->len, str, len);
> -		s->len +=3D len;
> +		/* Don't count the trailing null byte against the capacity */
> +		s->len +=3D len - 1;
>  		return 0;
>  	}
>  	seq_buf_set_overflow(s);
> --=20
> 2.17.2
