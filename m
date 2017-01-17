Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <5879F900.12283.370F7409@pageexec.freemail.hu>
References: <CAErMHp-W=zcX-D10dbhzRG41-mjfVcKb2_+p4dxdXsnfizZuag@mail.gmail.com>
 <58795E2E.429.34B2AE42@pageexec.freemail.hu> <CAGXu5j+yMNRQHRj8haLfNCst1C_7TDPf8axyUBatVWEvWbVmmQ@mail.gmail.com>
 <5879F900.12283.370F7409@pageexec.freemail.hu>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 17 Jan 2017 09:32:57 -0800
Message-ID: <CAGXu5j+zTNErMW_karYg8JcEGfzf=y+SdKEMPjsyoLR0o+-s9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Introduction
To: PaX Team <pageexec@freemail.hu>
Cc: "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, park jinbum <jinb.park7@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jan 14, 2017 at 2:10 AM, PaX Team <pageexec@freemail.hu> wrote:
> On 13 Jan 2017 at 15:15, Kees Cook wrote:
>
>> On Fri, Jan 13, 2017 at 3:09 PM, PaX Team <pageexec@freemail.hu> wrote:
>> >> fs/read_write.c: In function =E2=80=98new_sync_write=E2=80=99:
>> >> fs/read_write.c:490:15: note: userspace variable will be forcibly ini=
tialized
>> >>   struct iovec iov =3D { .iov_base =3D (void __user *)buf, .iov_len =
=3D len };
>> >
>> > this is a designated initializer which doesn't match the object constr=
uctor
>> > the plugin looks for.
>>
>> What would an object constructor look like?
>
> as you can see it in the plugin source, it has a specific TREE_CODE.

Right, I meant on the C side. The gimple get produced several ways, it
seems, and it wasn't clear under which conditions it spat out a
constructor vs individual assignments.

>> When I had it report the times it skipped forced initialization, the
>> code mostly looked like designated initializers. All I found in the
>> gimple were SSAs. Nothing jumped out at me as being an initializer.
>
> while the gimple dumps are human readable, they omit lots of information
> so it's better to look at the data structures at compile time. that said,
> a constructor should appear as an assignment like this:
>
>   s1 =3D {};

Yup, saw that for the constructor that got injected.

> a designated initializer is modeled as a constructor and per-field assign=
ments
> by the compiler (both are subject to optimizations so you won't necessari=
ly see
> all of them in the dumps of later passes).

It sounds like the plugin would need to walk every field of the target
variable and check that it got an assignment.

-Kees

--=20
Kees Cook
Nexus Security
