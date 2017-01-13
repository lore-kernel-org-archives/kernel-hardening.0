Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jJt7Kc9eH+=a11=ewem1E0GDo4+tu48OWGQ67Tu7fJfLA@mail.gmail.com>
References: <CAErMHp-W=zcX-D10dbhzRG41-mjfVcKb2_+p4dxdXsnfizZuag@mail.gmail.com>
 <20170113082347.GJ20972@linaro.org> <CAGXu5jLUCH9S98YFV3Db4q4r1aTsxbF_v0JeivH01pBYWM-Qzg@mail.gmail.com>
 <5879219B.26854.33C60FDB@pageexec.freemail.hu> <CAGXu5jJt7Kc9eH+=a11=ewem1E0GDo4+tu48OWGQ67Tu7fJfLA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 13 Jan 2017 11:26:42 -0800
Message-ID: <CAGXu5jJog1M5B9O7rO9rk-Rsfd+9avcGuAz=Tmq+CVU3n+5fzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Introduction
To: PaX Team <pageexec@freemail.hu>
Cc: "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, park jinbum <jinb.park7@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 13, 2017 at 11:06 AM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Jan 13, 2017 at 10:51 AM, PaX Team <pageexec@freemail.hu> wrote:
>> On 13 Jan 2017 at 9:54, Kees Cook wrote:
>>
>>> PaX Team, the heuristic for STRUCTLEAK appears to be "does the struct
>>> contain anything marked __user". Is this actually a meaningful
>>> information exposure case? It seems like there are a lot more cases
>>> for exposures where there is nothing marked __user. Is that the
>>> meaning of "much smaller coverage" compared to STACKLEAK in the
>>> Kconfig?
>>
>> STRUCTLEAK was written in response to a particular bug a few years ago
>> where we didn't want to give the bug away but still wanted to fix it
>> during the embargo. the struct in question could be matched by this
>> heuristics, matching everything else (however little of it) is really
>> just a free side effect. could coverage be improved? of course but that
>> would take a whole lot more work (manual markups and/or data flow analys=
is
>> in LTO mode).
>
> Out of curiosity, do you remember which bug? I'd be curious to compare
> it against others. It seems like adding structleak to upstream still
> has value, even if the coverage isn't as complete as stackleak.
>
> I wanted to do some simple performance checks with it too. I imagine
> it wouldn't have much impact given its coverage isn't very wide.

I did notice too that it seems like it doesn't notice static initializers:

security/tomoyo/common.c: In function =E2=80=98tomoyo_load_builtin_policy=
=E2=80=99:
security/tomoyo/common.c:2745:27: note: userspace variable will be
forcibly initialized
   struct tomoyo_io_buffer head =3D { };
                           ^

fs/read_write.c: In function =E2=80=98new_sync_write=E2=80=99:
fs/read_write.c:490:15: note: userspace variable will be forcibly initializ=
ed
  struct iovec iov =3D { .iov_base =3D (void __user *)buf, .iov_len =3D len=
 };
               ^

-Kees

--=20
Kees Cook
Nexus Security
