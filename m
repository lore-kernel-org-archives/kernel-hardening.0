MIME-Version: 1.0
In-Reply-To: <1493683745.2530.2.camel@redhat.com>
References: <CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>
 <CAGXu5j+Oncz0SgEH4QYx_dhLhits9d8ixQxGwScYCGrNVfdjAQ@mail.gmail.com>
 <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com> <1493683745.2530.2.camel@redhat.com>
From: Mathias Krause <minipli@googlemail.com>
Date: Tue, 2 May 2017 23:16:14 +0200
Message-ID: <CA+rthh_JNuXHmVBE8vz-CxQZwJsW=NR8DUfGq5aMHj42VFkpog@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Rik van Riel <riel@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, =?UTF-8?Q?Daniel_Cegie=C5=82ka?= <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 2 May 2017 at 02:09, Rik van Riel <riel@redhat.com> wrote:
> On Tue, 2017-05-02 at 00:01 +0200, Mathias Krause wrote:
>
>> I think the intention of the KSPP is good -- making vanilla Linux
>> more
>> secure. But the way it does its work harms overall Linux security. It
>> does hurt mine, that's for sure!
>
> Yeah, no.

Well, yes, it does! Losing access to the grsecurity patch makes the
systems I do care about much less secure.

> The grsecurity people produced patches
> that were used on maybe a few tens of thousands
> of systems,

Where did you pull that number from? Out of thin air, I guess. I know,
for sure, there are many more installations.

> while the KSPP code will end up
> enhancing the security of over a billion Android
> devices.

Or making them more easily to DoS because features like VMAP_STACK and
HARDENED_USERCOPY will likely fail hard when hitting a vendor's diver
code base. Probably making them disable the problematic config
options. Even upstream still has to fix related fallout.

> Those Android devices are more likely to require
> hardening, too, since they do not receive security
> updates as quickly as the systems maintained by
> grsecurity users.

Why couldn't those devices benefit from grsecurity as well? Couldn't
google or Samsung just integrate grsecurity into their Android
kernels? They're far away from vanilla Linux anyway, so why not add
just another patch to provide some matured security code base to
protect those billion of Android devices? I'd guess, if a big player
like google would sponsor / pay grsecurity to provide a patch for the
relevant Android kernels, all sides would be happy: grsecurity for
getting wider adoption, Android users for having secured systems.

> Integrating hardening into the upstream kernel is
> a good thing for security, not a bad thing.

I never said it's a bad thing. Indeed I'm all for making vanilla Linux
more secure. Just how KSPP tries to do it is IMHO wrong. Ripping hunks
out of grsecurity and trying to integrate them into vanilla Linux
without understanding all the interdependencies or even the features
themselves, how would that provide security? By chance, maybe. But not
intentional, as that requires having thought of every corner case and
boundary condition.


Regards,
Mathias
