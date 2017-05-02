MIME-Version: 1.0
In-Reply-To: <1493683745.2530.2.camel@redhat.com>
References: <CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>
 <CAGXu5j+Oncz0SgEH4QYx_dhLhits9d8ixQxGwScYCGrNVfdjAQ@mail.gmail.com>
 <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com> <1493683745.2530.2.camel@redhat.com>
From: Shawn <citypw@gmail.com>
Date: Tue, 2 May 2017 22:46:57 +0800
Message-ID: <CABniQZPEfptcLgBtbd5_GO5n8P6SxxkJMpqTCFazM8RCB4qKZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Rik van Riel <riel@redhat.com>
Cc: Mathias Krause <minipli@googlemail.com>, Kees Cook <keescook@chromium.org>, =?UTF-8?Q?Daniel_Cegie=C5=82ka?= <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 2, 2017 at 8:09 AM, Rik van Riel <riel@redhat.com> wrote:
> On Tue, 2017-05-02 at 00:01 +0200, Mathias Krause wrote:
>
>> I think the intention of the KSPP is good -- making vanilla Linux
>> more
>> secure. But the way it does its work harms overall Linux security. It
>> does hurt mine, that's for sure!
>
> Yeah, no. The grsecurity people produced patches
> that were used on maybe a few tens of thousands
> of systems, while the KSPP code will end up
> enhancing the security of over a billion Android
> devices.
>
Are you serious think KSPP can solve Android security issue without
changing the current Android eco-system? It's about one billion
Android device( most are old armv7 based) can be exploited and being
used by criminal and BIGBROs( NSA/CIA/PLA/whatever-A*/etc) with low
cost. I made hardened PoC( based on PaX + PXN + some code hardening)
for Nexus 7 2013 back in 2015. It proved that it can defeat "massive"
exp without much perf impact. But I don't see any sign those cellphone
vendors would port any KSPP features into the old devices. How about
new phone? I ported a couple of KSPP features( all originally done or
inspired by PaX/Grsecurity) to Pixel XL:

https://github.com/hardenedlinux/armv7-nexus7-grsec

Google's Pixel/Pixel2 may be the one of few cellphones can getting
benefit from KSPP. Otherwise, my own phone is running with much more
hardening features than Android O( released in Oct?) but it's still
not secure enough to defeat customized exploit.

> Those Android devices are more likely to require
> hardening, too, since they do not receive security
> updates as quickly as the systems maintained by
> grsecurity users.
>
Don't worry about it. PaX/Grsecurity can defeat multiple public
exploits without any fix. Maybe some ppl will go to maintain 4.9 LTS.

> Integrating hardening into the upstream kernel is
> a good thing for security, not a bad thing.
>
It depends how much security you need.

-- 
GNU powered it...
GPL protect it...
God blessing it...

regards
Shawn
