MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1495727974.20270.48.camel@redhat.com>
References: <CAFwXZv_b3hdEA4xOFKqAVfc4UZEBX=dL9DOY_mDHExsW+Qg6tQ@mail.gmail.com>
 <85inkpie9o.fsf@boum.org> <1495724872.20270.46.camel@redhat.com>
 <8537bt9bvj.fsf@boum.org> <1495727974.20270.48.camel@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 25 May 2017 10:28:19 -0700
Message-ID: <CAGXu5jKY+Fc5PcZdbXEXKXsxN2xb9Ext15yrhPrg4Afd1Rq_yA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Patch for random mac address
To: HacKurx <hackurx@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, intrigeri <intrigeri@boum.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 25, 2017 at 8:59 AM, Rik van Riel <riel@redhat.com> wrote:
> On Thu, 2017-05-25 at 17:47 +0200, intrigeri wrote:
>> Rik van Riel:
>> > That suggests maybe this kind of functionality should
>> > be implemented in userspace, instead?
>> > Maybe in NetworkManager, [=E2=80=A6]
>>
>> It's already implemented in NetworkManager :)
>
> So this kernel patch does not solve any problem,
> because the solution has already been implemented
> in userspace?

It makes sure you can never not randomize the MAC, no matter what
userspace is doing. I'm not opposed to the idea, but it feels like
overkill to me.

BTW, the proposed patch is slightly wrong: it still allows userspace
to change the MAC address. The ifdef with the return 0 should be moved
up (and "return 0" seems like a bit of a lie: maybe -EINVAL or
-ENOTSUPPORTED?). How about sending a v2 with that fixed, inline, etc.
And see if other people chime in?

It might also be nice to have it be a kernel command line option as
well as a Kconfig, so that distros could include the Kconfig but not
enable it by default (interested users could set the command line
option to enable it).

Thanks!

-Kees

--=20
Kees Cook
Pixel Security
