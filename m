Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
From: Ho-Eun Ryu <hoeun.ryu@gmail.com>
In-Reply-To: <CAGXu5jJuuUSwS61d7Joc=6y2BUyTo6koEsrVxeqMu_u7j9Mb9w@mail.gmail.com>
Date: Thu, 30 Mar 2017 16:44:02 +0900
Content-Transfer-Encoding: quoted-printable
Message-Id: <466B31B4-0535-44EE-B0F0-F758A79A7B4F@gmail.com>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
 <1490811363-93944-2-git-send-email-keescook@chromium.org>
 <CAGXu5jJuuUSwS61d7Joc=6y2BUyTo6koEsrVxeqMu_u7j9Mb9w@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC v2][PATCH 01/11] Introduce rare_write() infrastructure
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>


> On 30 Mar 2017, at 3:23 AM, Kees Cook <keescook@chromium.org> wrote:
>=20
> On Wed, Mar 29, 2017 at 11:15 AM, Kees Cook <keescook@chromium.org> =
wrote:
>> +/*
>> + * Build "write rarely" infrastructure for flipping memory r/w
>> + * on a per-CPU basis.
>> + */
>> +#ifndef CONFIG_HAVE_ARCH_RARE_WRITE
>> +# define __wr_rare
>> +# define __wr_rare_type
>> +# define __rare_write(__var, __val)    (__var =3D (__val))
>> +# define rare_write_begin()            do { } while (0)
>> +# define rare_write_end()              do { } while (0)
>> +#else
>> +# define __wr_rare                     __ro_after_init
>> +# define __wr_rare_type                        const
>> +# ifdef CONFIG_HAVE_ARCH_RARE_WRITE_MEMCPY
>> +#  define __rare_write_n(dst, src, len)        ({                    =
  \
>> +               BUILD_BUG(!builtin_const(len));                 \
>> +               __arch_rare_write_memcpy((dst), (src), (len));  \
>> +       })
>> +#  define __rare_write(var, val)  __rare_write_n(&(var), &(val), =
sizeof(var))
>> +# else
>> +#  define __rare_write(var, val)  ((*(typeof((typeof(var))0) =
*)&(var)) =3D (val))
>> +# endif
>> +# define rare_write_begin()    __arch_rare_write_begin()
>> +# define rare_write_end()      __arch_rare_write_end()
>> +#endif
>> +#define rare_write(__var, __val) ({                    \
>> +       rare_write_begin();                             \
>> +       __rare_write(__var, __val);                     \
>> +       rare_write_end();                               \
>> +       __var;                                          \
>> +})
>> +
>=20
> Of course, only after sending this do I realize that the MEMCPY case
> will need to be further adjusted, since it currently can't take
> literals. I guess something like this needs to be done:
>=20
> #define __rare_write(var, val) ({ \
>    typeof(var) __src =3D (val);     \
>    __rare_write_n(&(var), &(__src), sizeof(var)); \
> })
>=20

Right, and it has a problem with BUILD_BUG, which causes compilation =
error when CONFIG_HABE_ARCH_RARE_WRITE_MEMCPY is true
BUILD_BUG is defined in <linux/bug.h> but <linux/bug.h> includes =
<linux/compiler.h>

Please see the following.

diff --git a/include/linux/compiler.h b/include/linux/compiler.h         =
      =20
index 3334fa9..3fa50e1 100644                                            =
      =20
--- a/include/linux/compiler.h                                           =
      =20
+++ b/include/linux/compiler.h                                           =
      =20
@@ -350,11 +350,11 @@ static __always_inline void =
__write_once_size(volatile vo\
id *p, void *res, int s
 # define __wr_rare                     __ro_after_init                  =
      =20
 # define __wr_rare_type                        const                    =
      =20
 # ifdef CONFIG_HAVE_ARCH_RARE_WRITE_MEMCPY                              =
      =20
-#  define __rare_write_n(dst, src, len)        ({                      =
\      =20
-               BUILD_BUG(!builtin_const(len));                         =
\
-               __arch_rare_write_memcpy((dst), (src), (len));   \       =
       =20
+#  define __rare_write_n(var, val, len)        ({                       =
          \                                                              =
               =20
+               typeof(val) __val =3D val;                               =
                     \
+               __arch_rare_write_memcpy(&(var), &(__val), (len));      =
\      =20
        })
-#  define __rare_write(var, val)  __rare_write_n(&(var), &(val), =
sizeof(var)) =20
+#  define __rare_write(var, val)  __rare_write_n((var), (val), =
sizeof(var))   =20
 # else                                                                  =
      =20
 #  define __rare_write(var, val)  ((*(typeof((typeof(var))0) *)&(var)) =
=3D (val)\
)                                                                        =
      =20
 # endif                                                                 =
      =20


> -Kees
>=20
> --=20
> Kees Cook
> Pixel Security
