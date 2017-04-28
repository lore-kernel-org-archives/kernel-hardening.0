MIME-Version: 1.0
In-Reply-To: <20170428114131.GA31833@bistromath.localdomain>
References: <20170425155215.4835-1-Jason@zx2c4.com> <20170425184734.26563-1-Jason@zx2c4.com>
 <20170425184734.26563-3-Jason@zx2c4.com> <20170428114131.GA31833@bistromath.localdomain>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 28 Apr 2017 15:29:45 +0200
Message-ID: <CAHmME9oyCb5GJ6L=2fBs-eHEPjtm-_HtoA1a76_WSiw-t+Pmuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v6 3/5] rxrpc: check return value of skb_to_sgvec always
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Laight <David.Laight@aculab.com>, kernel-hardening@lists.openwall.com, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Sabrina,

Thanks for the review.

On Fri, Apr 28, 2017 at 1:41 PM, Sabrina Dubroca <sd@queasysnail.net> wrote:
> >       sg_init_table(sg, nsg);
> > -     skb_to_sgvec(skb, sg, offset, len);
> > +     if (unlikely(skb_to_sgvec(skb, sg, offset, len) < 0))
> > +             goto nomem;
>
> You're leaking sg when nsg > 4, you'll need to add this:
>
>         if (sg != _sg)
>                 kfree(sg);

Nice catch. I'll fix this up in the next revision.


>
>
>
> BTW, when you resubmit, please Cc: the maintainers of the files you're
> changing for each patch, so that they can review this stuff. And send
> patch 1 to all of them, otherwise they might be surprised that we even
> need <0 checking after calls to skb_to_sgvec.
>
> You might also want to add a cover letter.

Both good ideas. Will do.

Jason
