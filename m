Date: Wed, 17 Oct 2018 10:48:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] seq_buf: Make seq_buf_puts() NULL terminate the buffer
Message-ID: <20181017104826.7f6fb605@gandalf.local.home>
In-Reply-To: <20181017121000.30240-1-mpe@ellerman.id.au>
References: <20181017121000.30240-1-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 17 Oct 2018 23:10:00 +1100
Michael Ellerman <mpe@ellerman.id.au> wrote:

> Currently seq_buf_puts() will happily create a non NULL terminated
> string for you in the buffer. This is particularly dangerous if the
> buffer is on the stack.
>=20
> For example:
>=20
>   char buf[8];
>   char secret =3D "secret";
>   struct seq_buf s;
>=20
>   seq_buf_init(&s, buf, sizeof(buf));
>   seq_buf_puts(&s, "foo");
>   printk("Message is %s\n", buf);
>=20
> Can result in:
>=20
>   Message is foo=C2=AA=C2=AA=C2=AA=C2=AA=C2=AAsecret
>=20
> We could require all users to memset() their buffer to NULL before
> use. But that seems likely to be forgotten and lead to bugs.
>=20
> Instead we can change seq_buf_puts() to always leave the buffer in a
> NULL terminated state.
>=20
> The only downside is that this makes the buffer 1 character smaller
> for seq_buf_puts(), but that seems like a good trade off.
>=20
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>

It's been on my todo list for some time, and that was to add this
(trace-cmd had this for years). Would this be useful?

Instead of always writing a nul pointer, just terminate it when you are
done.


-- Steve


diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index 11f2ae0f9099..46f2a8b3e733 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -175,6 +175,29 @@ int seq_buf_putc(struct seq_buf *s, unsigned char c)
 }
=20
 /**
+ * seq_buf_terminate - force the buffer to end in a nul character
+ * @s: seq_buf descriptor
+ *
+ * Make sure the current buffer terminates with a nul '\0' character.
+ * This does not increment the length of the buffer.
+ *
+ * Returns 0 if there was room to add the nul character.
+ *        -1 if there was not room. But a nul character was
+ *           still added, overwriting the last character in the buffer.
+ */
+int seq_buf_terminate(struct seq_buf *s)
+{
+	WARN_ON(s->size =3D=3D 0);
+
+	if (seq_buf_can_fit(s, 1)) {
+		s->buffer[s->len] =3D '\0';
+		return 0;
+	}
+	s->buffer[--s->len] =3D '\0';
+	return -1;
+}
+
+/**
  * seq_buf_putmem - write raw data into the sequenc buffer
  * @s: seq_buf descriptor
  * @mem: The raw memory to copy into the buffer
