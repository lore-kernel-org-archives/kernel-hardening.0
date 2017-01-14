Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Sat, 14 Jan 2017 11:10:08 +0100
MIME-Version: 1.0
Message-ID: <5879F900.12283.370F7409@pageexec.freemail.hu>
In-reply-to: <CAGXu5j+yMNRQHRj8haLfNCst1C_7TDPf8axyUBatVWEvWbVmmQ@mail.gmail.com>
References: <CAErMHp-W=zcX-D10dbhzRG41-mjfVcKb2_+p4dxdXsnfizZuag@mail.gmail.com>, <58795E2E.429.34B2AE42@pageexec.freemail.hu>, <CAGXu5j+yMNRQHRj8haLfNCst1C_7TDPf8axyUBatVWEvWbVmmQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: Quoted-printable
Content-description: Mail message body
Subject: Re: [kernel-hardening] Introduction
To: Kees Cook <keescook@chromium.org>
Cc: "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, park jinbum <jinb.park7@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 13 Jan 2017 at 15:15, Kees Cook wrote:

> On Fri, Jan 13, 2017 at 3:09 PM, PaX Team <pageexec@freemail.hu> wrote:
> >> fs/read_write.c: In function =E2=80=98new_sync_write=E2=80=99:
> >> fs/read_write.c:490:15: note: userspace variable will be forcibly ini=
tialized
> >>   struct iovec iov =3D { .iov_base =3D (void __user *)buf, .iov_len =3D=
 len };
> >
> > this is a designated initializer which doesn't match the object constr=
uctor
> > the plugin looks for.
> 
> What would an object constructor look like?

as you can see it in the plugin source, it has a specific TREE_CODE.

> When I had it report the times it skipped forced initialization, the
> code mostly looked like designated initializers. All I found in the
> gimple were SSAs. Nothing jumped out at me as being an initializer. 

while the gimple dumps are human readable, they omit lots of information
so it's better to look at the data structures at compile time. that said,
a constructor should appear as an assignment like this:

  s1 =3D {};

a designated initializer is modeled as a constructor and per-field assignm=
ents
by the compiler (both are subject to optimizations so you won't necessaril=
y see
all of them in the dumps of later passes).
