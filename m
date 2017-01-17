Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Tue, 17 Jan 2017 19:43:53 +0100
MIME-Version: 1.0
Message-ID: <587E65E9.17691.D9E2212@pageexec.freemail.hu>
In-reply-to: <CAGXu5j+zTNErMW_karYg8JcEGfzf=y+SdKEMPjsyoLR0o+-s9g@mail.gmail.com>
References: <CAErMHp-W=zcX-D10dbhzRG41-mjfVcKb2_+p4dxdXsnfizZuag@mail.gmail.com>, <5879F900.12283.370F7409@pageexec.freemail.hu>, <CAGXu5j+zTNErMW_karYg8JcEGfzf=y+SdKEMPjsyoLR0o+-s9g@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: Quoted-printable
Content-description: Mail message body
Subject: Re: [kernel-hardening] Introduction
To: Kees Cook <keescook@chromium.org>
Cc: "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, park jinbum <jinb.park7@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 17 Jan 2017 at 9:32, Kees Cook wrote:

> On Sat, Jan 14, 2017 at 2:10 AM, PaX Team <pageexec@freemail.hu> wrote:
> > On 13 Jan 2017 at 15:15, Kees Cook wrote:
> >
> >> On Fri, Jan 13, 2017 at 3:09 PM, PaX Team <pageexec@freemail.hu> wrot=
e:
> >> >> fs/read_write.c: In function =E2=80=98new_sync_write=E2=80=99:
> >> >> fs/read_write.c:490:15: note: userspace variable will be forcibly =
initialized
> >> >>   struct iovec iov =3D { .iov_base =3D (void __user *)buf, .iov_le=
n =3D len };
> >> >
> >> > this is a designated initializer which doesn't match the object con=
structor
> >> > the plugin looks for.
> >>
> >> What would an object constructor look like?
> >
> > as you can see it in the plugin source, it has a specific TREE_CODE.
> 
> Right, I meant on the C side. The gimple get produced several ways, it
> seems, and it wasn't clear under which conditions it spat out a
> constructor vs individual assignments.

it's what your example shows, a normal variable initialization. the reason
it's not a constructor in gcc is due to the C rule that we've been discuss=
ing
in another sub-thread: a full object initializer doesn't have to care abou=
t
padding and thus gcc in such cases omits the "=3D {}" constructor and only=
 does
per-field assignments as described by the initializer. you could say that =
the
plugin could detect this case but then it'd also have to take into account
whether the type in question has padding, etc. like i said, there're many =
ways
to refine the pattern matching.

> > a designated initializer is modeled as a constructor and per-field ass=
ignments
> > by the compiler (both are subject to optimizations so you won't necess=
arily see
> > all of them in the dumps of later passes).
> 
> It sounds like the plugin would need to walk every field of the target
> variable and check that it got an assignment.

yes, that's the kind of data flow analysis that can discover these assignm=
ents
and take them into account when deciding about forced initialization.
