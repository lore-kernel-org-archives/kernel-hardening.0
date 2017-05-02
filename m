Message-ID: <1493683745.2530.2.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Mon, 01 May 2017 20:09:05 -0400
In-Reply-To: <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
References: 
	<CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>	
 <CAGXu5j+Oncz0SgEH4QYx_dhLhits9d8ixQxGwScYCGrNVfdjAQ@mail.gmail.com>
	 <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Mathias Krause <minipli@googlemail.com>, Kees Cook <keescook@chromium.org>
Cc: Daniel =?UTF-8?Q?Cegie=C5=82ka?= <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2017-05-02 at 00:01 +0200, Mathias Krause wrote:

> I think the intention of the KSPP is good -- making vanilla Linux
> more
> secure. But the way it does its work harms overall Linux security. It
> does hurt mine, that's for sure!

Yeah, no. The grsecurity people produced patches
that were used on maybe a few tens of thousands
of systems, while the KSPP code will end up
enhancing the security of over a billion Android
devices.

Those Android devices are more likely to require
hardening, too, since they do not receive security
updates as quickly as the systems maintained by
grsecurity users.

Integrating hardening into the upstream kernel is
a good thing for security, not a bad thing.
