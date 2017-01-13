Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Sat, 14 Jan 2017 00:09:34 +0100
MIME-Version: 1.0
Message-ID: <58795E2E.429.34B2AE42@pageexec.freemail.hu>
In-reply-to: <CAGXu5jJog1M5B9O7rO9rk-Rsfd+9avcGuAz=Tmq+CVU3n+5fzA@mail.gmail.com>
References: <CAErMHp-W=zcX-D10dbhzRG41-mjfVcKb2_+p4dxdXsnfizZuag@mail.gmail.com>, <CAGXu5jJt7Kc9eH+=a11=ewem1E0GDo4+tu48OWGQ67Tu7fJfLA@mail.gmail.com>, <CAGXu5jJog1M5B9O7rO9rk-Rsfd+9avcGuAz=Tmq+CVU3n+5fzA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: Quoted-printable
Content-description: Mail message body
Subject: Re: [kernel-hardening] Introduction
To: Kees Cook <keescook@chromium.org>
Cc: "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, park jinbum <jinb.park7@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 13 Jan 2017 at 11:26, Kees Cook wrote:

> I did notice too that it seems like it doesn't notice static initializer=
s:
> 
> security/tomoyo/common.c: In function =E2=80=98tomoyo_load_builtin_polic=
y=E2=80=99:
> security/tomoyo/common.c:2745:27: note: userspace variable will be
> forcibly initialized
>    struct tomoyo_io_buffer head =3D { };

in this case the variable (and its initializer) is in a loop scope (not
the function scope), so it's not matched. as i said, the plugin was writte=
n
to match a specific situation, not everything under the sun ;). now it's
possible to extend the coverage to loops as well, but then you'll have to
be careful with performance impact as more and more code will match and
inside a loop the impact can quickly add up...

> fs/read_write.c: In function =E2=80=98new_sync_write=E2=80=99:
> fs/read_write.c:490:15: note: userspace variable will be forcibly initia=
lized
>   struct iovec iov =3D { .iov_base =3D (void __user *)buf, .iov_len =3D =
len };

this is a designated initializer which doesn't match the object constructo=
r
the plugin looks for.
