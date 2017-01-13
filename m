Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jJog1M5B9O7rO9rk-Rsfd+9avcGuAz=Tmq+CVU3n+5fzA@mail.gmail.com>
References: <CAErMHp-W=zcX-D10dbhzRG41-mjfVcKb2_+p4dxdXsnfizZuag@mail.gmail.com>
 <20170113082347.GJ20972@linaro.org> <CAGXu5jLUCH9S98YFV3Db4q4r1aTsxbF_v0JeivH01pBYWM-Qzg@mail.gmail.com>
 <5879219B.26854.33C60FDB@pageexec.freemail.hu> <CAGXu5jJt7Kc9eH+=a11=ewem1E0GDo4+tu48OWGQ67Tu7fJfLA@mail.gmail.com>
 <CAGXu5jJog1M5B9O7rO9rk-Rsfd+9avcGuAz=Tmq+CVU3n+5fzA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 13 Jan 2017 12:38:54 -0800
Message-ID: <CAGXu5jJj2of7te2bFXe5gQjv0_yPXaGyAKCJ6+uXpOMH2weCdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Introduction
To: PaX Team <pageexec@freemail.hu>
Cc: "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, park jinbum <jinb.park7@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 13, 2017 at 11:26 AM, Kees Cook <keescook@chromium.org> wrote:
> I did notice too that it seems like it doesn't notice static initializers=
:
>
> security/tomoyo/common.c: In function =E2=80=98tomoyo_load_builtin_policy=
=E2=80=99:
> security/tomoyo/common.c:2745:27: note: userspace variable will be
> forcibly initialized
>    struct tomoyo_io_buffer head =3D { };
>                            ^
>
> fs/read_write.c: In function =E2=80=98new_sync_write=E2=80=99:
> fs/read_write.c:490:15: note: userspace variable will be forcibly initial=
ized
>   struct iovec iov =3D { .iov_base =3D (void __user *)buf, .iov_len =3D l=
en };
>                ^

If I dump the gimple, it looks like the assignments aren't being
marked as CONSTRUTOR?

fs/read_write.c: In function =E2=80=98new_sync_read=E2=80=99:
fs/read_write.c:433:15: note: userspace variable will be forcibly initializ=
ed
  struct iovec iov =3D { .iov_base =3D buf, .iov_len =3D len };
               ^
# .MEM_3 =3D VDEF <.MEM_1(D)>
iov.iov_base =3D buf_2(D);
# .MEM_5 =3D VDEF <.MEM_3>
iov.iov_len =3D len_4(D);
...

Hmmm

-Kees

--=20
Kees Cook
Nexus Security
