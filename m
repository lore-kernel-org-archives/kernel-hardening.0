Date: Thu, 25 May 2017 23:28:39 +0200
From: Anisse Astier <anisse@astier.eu>
Message-ID: <20170525212839.GA21842@bifrost>
References: <CAFwXZv_b3hdEA4xOFKqAVfc4UZEBX=dL9DOY_mDHExsW+Qg6tQ@mail.gmail.com>
 <85inkpie9o.fsf@boum.org>
 <1495724872.20270.46.camel@redhat.com>
 <8537bt9bvj.fsf@boum.org>
 <1495727974.20270.48.camel@redhat.com>
 <CAGXu5jKY+Fc5PcZdbXEXKXsxN2xb9Ext15yrhPrg4Afd1Rq_yA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5jKY+Fc5PcZdbXEXKXsxN2xb9Ext15yrhPrg4Afd1Rq_yA@mail.gmail.com>
Subject: Re: [kernel-hardening] Patch for random mac address
To: Kees Cook <keescook@chromium.org>
Cc: HacKurx <hackurx@gmail.com>, Rik van Riel <riel@redhat.com>, intrigeri <intrigeri@boum.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Thu, May 25, 2017 at 10:28:19AM -0700, Kees Cook wrote:
> On Thu, May 25, 2017 at 8:59 AM, Rik van Riel <riel@redhat.com> wrote:
> > On Thu, 2017-05-25 at 17:47 +0200, intrigeri wrote:
> >> Rik van Riel:
> >> > That suggests maybe this kind of functionality should
> >> > be implemented in userspace, instead?
> >> > Maybe in NetworkManager, […]
> >>
> >> It's already implemented in NetworkManager :)
> >
> > So this kernel patch does not solve any problem,
> > because the solution has already been implemented
> > in userspace?
> 
> It makes sure you can never not randomize the MAC, no matter what
> userspace is doing. I'm not opposed to the idea, but it feels like
> overkill to me.
> 
> BTW, the proposed patch is slightly wrong: it still allows userspace
> to change the MAC address. The ifdef with the return 0 should be moved
> up (and "return 0" seems like a bit of a lie: maybe -EINVAL or
> -ENOTSUPPORTED?). How about sending a v2 with that fixed, inline, etc.
> And see if other people chime in?

Yes, the original grsec patch is slightly different.

> 
> It might also be nice to have it be a kernel command line option as
> well as a Kconfig, so that distros could include the Kconfig but not
> enable it by default (interested users could set the command line
> option to enable it).

Since it's still on the table, there's already a facility in the kernel
to generate a random mac in include/linux/etherdevice.h:
eth_random_addr. It's used by most network drivers when they can't fetch
the hardware address, so that there's still a functionning interface.

I'd be curious to know why this patch does not use it. The generation
looks slightly similar.

Regards,

Anisse Astier
