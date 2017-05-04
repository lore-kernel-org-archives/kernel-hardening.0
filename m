Date: Thu, 4 May 2017 06:47:08 +0000 (UTC)
From: Lionel Debroux <lionel_debroux@yahoo.fr>
Message-ID: <1098301241.3672962.1493880428616@mail.yahoo.com>
In-Reply-To: <CAGXu5jKpRafmuNaGMEn_N9jrvt2zkysB0TXOWs6pfCsDhYgkeA@mail.gmail.com>
References: <CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com> <CAGXu5j+Oncz0SgEH4QYx_dhLhits9d8ixQxGwScYCGrNVfdjAQ@mail.gmail.com> <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com> <1493683745.2530.2.camel@redhat.com> <CABniQZPEfptcLgBtbd5_GO5n8P6SxxkJMpqTCFazM8RCB4qKZQ@mail.gmail.com> <CAGXu5jKqptmWwAgsDNtTRzN-r_JYBtVoNaPbpwN+_stfY4yrQA@mail.gmail.com> <CABniQZMoX6h0dQk5Xa_kwnbV5NSVpE3EDAD4+TU9CM4Hx9TjuA@mail.gmail.com> <CAGXu5jKpRafmuNaGMEn_N9jrvt2zkysB0TXOWs6pfCsDhYgkeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Kees Cook <keescook@chromium.org>, Shawn <citypw@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Mathias Krause <minipli@googlemail.com>, =?UTF-8?Q?Daniel_Cegie=C5=82ka?= <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

(I hope that silly webmail is not going to butcher my e-mail's
layout, this time...)

> It'd be nice if I could convince you otherwise (see my reply to
> Mathias), but upstream hasn't "created more work" for grsecurity.
> [...]
> (since again, upstreaming doesn't increase their work)
Uh, do you really mean that ?
Because on the contrary, it's a (real) _fact_ that upstreaming
something directly taken from, or inspired by, the PaX/grsecurity
work _does_ increase their work, through at least three
well-identified mechanisms:
* adjusting their work to match upstream's changes. That's relatively
simple if the changes are pure renames, but as we know, upstream
changes are not always (not often, even, they'd probably say) that
simple - and do not always come without drawbacks on complexity or
protective abilities, either. spender has been posting (complaining)
multiple times about that, giving specific examples - which you may
have seen by yourself.

* helping upstream perform the integration in the first place. They
had to spend much time helping the mainlining process of some bits.
See it indirectly in spender's posts questioning mainline's ability
to perform _sustained_ maintenance of the integrated features (even
if they received some minor fixes on some GCC plugins in return for
the integration, as you mentioned).

Don't let spender's usual writing style (not necessarily more abrasive
than Linus', BTW) shadow the technical reasons behind his complaints,
some are arguably valid.

* unapplying, one by one, the hunks mentioned earlier for improvements
related to (mostly) CONSTIFY, RANDSTRUCT, RAP. They've been carrying
these patches for years, with very little maintenance: the vast
majority of these hunks didn't change from one upstream version to the
next one. We've already discussed at length the non-technical reasons
why nobody picked them up.

To tell the truth, the fact that upstreaming said changes does, as a
matter of fact, increase their work load was the second, auxiliary
reason why, after several patches in 2010 and 2012, I didn't spend
more of my free time mainlining some of these small, scattered changes,
rather than on other endeavours. I find myself caring quite a bit less
about that second reason now that the patches have become private, but
the main reason of the dishearteningly expensive mainlining process
largely remains valid... I do understand the need for reviews in
general, but CONSTIFY or RANDSTRUCT-related hunks are arguably special.


> And even if you still believe that, making their patches private
> doesn't reduce the amount of work they have to do. It just forces
> people to pay them.
Yes, that is true. Arguably, in some ways, since making their patches
private increases the incentive to mainline hunks thereof, it
_increases_ their work over some areas in the short and mid-term.


Bye,
Lionel.
