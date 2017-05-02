MIME-Version: 1.0
In-Reply-To: <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
References: <CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>
 <CAGXu5j+Oncz0SgEH4QYx_dhLhits9d8ixQxGwScYCGrNVfdjAQ@mail.gmail.com> <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
From: Olof Johansson <olof@lixom.net>
Date: Mon, 1 May 2017 17:39:55 -0700
Message-ID: <CAOesGMhn+ETGF4Q-ka5UU35D8pv-JeHozKnh_+eXD+evtpa5OA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Mathias Krause <minipli@googlemail.com>
Cc: Kees Cook <keescook@chromium.org>, =?UTF-8?Q?Daniel_Cegie=C5=82ka?= <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 1, 2017 at 3:01 PM, Mathias Krause <minipli@googlemail.com> wrote:

> The first point directly forces them to think through the upstream
> incarnation of a feature, how it differs from their original one and,
> for those parts, how to fix them up to work properly to fit their
> needs, to fit their security requirements. Those changes generate a
> lot of conflicts with their version of the code which takes time to
> fiddle out. As happened for __ro_after_init, MEMORY_SANITIZE,
> USERCOPY,... which only went in in reduced and modified form,
> generating needless work on their side -- from their point of view.

This is the classic pain point of initial upstreaming when you have
been out-of-tree for a long time. We see this all the time for
hardware support as well.

It's a hump to climb, and once you're over it, things settle down
again. The quicker you can get past it, the better off you are.

> The second point, the loose of control over the code, is even worse.
> Not getting any more conflicts when porting the grsecurity/PaX patch
> to a new kernel release makes changes to code that used to live in
> grsecurity/PaX probably go unnoticed. And, as it seem to be the case,
> upstream developers are not always familiar with all the gory details
> and might introduce weaknesses and bugs. This not only makes upstream
> Linux less secure, it makes grsecurity and PaX less secure, too.

The solution to this is to get involved and review code and educate
your peers when they're doing the wrong thing. Linux is developed and
managed based on influence, not control. Influence requires
participation and interaction.


-Olof
