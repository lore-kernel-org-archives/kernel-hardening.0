MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1098301241.3672962.1493880428616@mail.yahoo.com>
References: <CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>
 <CAGXu5j+Oncz0SgEH4QYx_dhLhits9d8ixQxGwScYCGrNVfdjAQ@mail.gmail.com>
 <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
 <1493683745.2530.2.camel@redhat.com> <CABniQZPEfptcLgBtbd5_GO5n8P6SxxkJMpqTCFazM8RCB4qKZQ@mail.gmail.com>
 <CAGXu5jKqptmWwAgsDNtTRzN-r_JYBtVoNaPbpwN+_stfY4yrQA@mail.gmail.com>
 <CABniQZMoX6h0dQk5Xa_kwnbV5NSVpE3EDAD4+TU9CM4Hx9TjuA@mail.gmail.com>
 <CAGXu5jKpRafmuNaGMEn_N9jrvt2zkysB0TXOWs6pfCsDhYgkeA@mail.gmail.com> <1098301241.3672962.1493880428616@mail.yahoo.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 5 May 2017 12:54:24 -0700
Message-ID: <CAGXu5jLN4_eZktfa7N1vOkmXdba4=T7E5qGa8z5aL9W9awNsrg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Lionel Debroux <lionel_debroux@yahoo.fr>
Cc: Shawn <citypw@gmail.com>, Rik van Riel <riel@redhat.com>, Mathias Krause <minipli@googlemail.com>, =?UTF-8?Q?Daniel_Cegie=C5=82ka?= <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 3, 2017 at 11:47 PM, Lionel Debroux <lionel_debroux@yahoo.fr> wrote:
>> It'd be nice if I could convince you otherwise (see my reply to
>> Mathias), but upstream hasn't "created more work" for grsecurity.
>> [...]
>> (since again, upstreaming doesn't increase their work)
> Uh, do you really mean that ?
> Because on the contrary, it's a (real) _fact_ that upstreaming
> something directly taken from, or inspired by, the PaX/grsecurity

I think it would be noise compared to all the regular work needed when
doing forward porting, yes. As I said in my reply to Mathias, I think
some things make it harder, some things make it easier, and others
don't change anything. Other stuff happening in upstream can be WAY
more disruptive, like rewriting x86_64 entry code. I bet that was
terrible to do a forward port after.

> work _does_ increase their work, through at least three
> well-identified mechanisms:
> * adjusting their work to match upstream's changes. That's relatively
> simple if the changes are pure renames, but as we know, upstream
> changes are not always (not often, even, they'd probably say) that
> simple - and do not always come without drawbacks on complexity or
> protective abilities, either. spender has been posting (complaining)
> multiple times about that, giving specific examples - which you may
> have seen by yourself.

This is what I think is covered by regular upstreaming, mentioned
above. On the level, it looks like it's not a meaningfully different
amount of work. Maybe I'm wrong, but you can go look at the evidence I
linked to about how forward porting was performed in the past.

> * helping upstream perform the integration in the first place. They
> had to spend much time helping the mainlining process of some bits.
> See it indirectly in spender's posts questioning mainline's ability
> to perform _sustained_ maintenance of the integrated features (even
> if they received some minor fixes on some GCC plugins in return for
> the integration, as you mentioned).

Well, again, they get all of upstream. The hardened usercopy
upstreaming triggered a massive uaccess rewrite that means all of the
arch-specific code has gone away so there's one place for usercopy
stuff. That implies both reduction in forward porting work and
evidence of "sustained maintenance". My little typo fix patch was
something I sent because I noticed it affected things that weren't yet
upstream, so it felt silly not to send it since I was right there
looking at the code.

> Don't let spender's usual writing style (not necessarily more abrasive
> than Linus', BTW) shadow the technical reasons behind his complaints,
> some are arguably valid.

Neither of their styles excuse the other, but yes, I absolutely
understand that if I can dig through the mockery and insults, I can
almost always find very compelling technical analysis from grsecurity.

> * unapplying, one by one, the hunks mentioned earlier for improvements
> related to (mostly) CONSTIFY, RANDSTRUCT, RAP. They've been carrying
> these patches for years, with very little maintenance: the vast
> majority of these hunks didn't change from one upstream version to the
> next one. We've already discussed at length the non-technical reasons
> why nobody picked them up.

Well, again, the evidence in the recent kernel patches would indicate
that's not how things have been dealt with.

> To tell the truth, the fact that upstreaming said changes does, as a
> matter of fact, increase their work load was the second, auxiliary
> reason why, after several patches in 2010 and 2012, I didn't spend
> more of my free time mainlining some of these small, scattered changes,
> rather than on other endeavours. I find myself caring quite a bit less
> about that second reason now that the patches have become private, but
> the main reason of the dishearteningly expensive mainlining process
> largely remains valid... I do understand the need for reviews in
> general, but CONSTIFY or RANDSTRUCT-related hunks are arguably special.

Just out of curiosity, what changes did you upstream and what was
communicated to you about them being disruptive?

Constify is quite special-purpose, yes. Randstruct less so (and
linux-next now only needs a few more fix-ups, I've upstreamed the rest
I've identified).

>> And even if you still believe that, making their patches private
>> doesn't reduce the amount of work they have to do. It just forces
>> people to pay them.
> Yes, that is true. Arguably, in some ways, since making their patches
> private increases the incentive to mainline hunks thereof, it
> _increases_ their work over some areas in the short and mid-term.

I wish grsecurity had responded to my requests for guidance about how
to make their forward-porting easier. Having that kind of work myself
in the past, I'll just continue to try to organize things in ways that
seems the least disruptive to me, and make suggestions to other people
about doing the same.

-Kees

-- 
Kees Cook
Pixel Security
