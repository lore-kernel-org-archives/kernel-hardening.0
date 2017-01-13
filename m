Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <58795E2E.429.34B2AE42@pageexec.freemail.hu>
References: <CAErMHp-W=zcX-D10dbhzRG41-mjfVcKb2_+p4dxdXsnfizZuag@mail.gmail.com>
 <CAGXu5jJt7Kc9eH+=a11=ewem1E0GDo4+tu48OWGQ67Tu7fJfLA@mail.gmail.com>
 <CAGXu5jJog1M5B9O7rO9rk-Rsfd+9avcGuAz=Tmq+CVU3n+5fzA@mail.gmail.com> <58795E2E.429.34B2AE42@pageexec.freemail.hu>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 13 Jan 2017 15:15:55 -0800
Message-ID: <CAGXu5j+yMNRQHRj8haLfNCst1C_7TDPf8axyUBatVWEvWbVmmQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Introduction
To: PaX Team <pageexec@freemail.hu>
Cc: "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, park jinbum <jinb.park7@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 13, 2017 at 3:09 PM, PaX Team <pageexec@freemail.hu> wrote:
>> fs/read_write.c: In function =E2=80=98new_sync_write=E2=80=99:
>> fs/read_write.c:490:15: note: userspace variable will be forcibly initia=
lized
>>   struct iovec iov =3D { .iov_base =3D (void __user *)buf, .iov_len =3D =
len };
>
> this is a designated initializer which doesn't match the object construct=
or
> the plugin looks for.

What would an object constructor look like? When I had it report the
times it skipped forced initialization, the code mostly looked like
designated initializers. All I found in the gimple were SSAs. Nothing
jumped out at me as being an initializer.

--=20
Kees Cook
Nexus Security
