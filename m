Date: Fri, 9 Jun 2017 15:01:38 +0200
From: Anisse Astier <anisse@astier.eu>
Message-ID: <20170609130138.GA8257@bifrost>
References: <CAFwXZv_b3hdEA4xOFKqAVfc4UZEBX=dL9DOY_mDHExsW+Qg6tQ@mail.gmail.com>
 <85inkpie9o.fsf@boum.org>
 <1495724872.20270.46.camel@redhat.com>
 <8537bt9bvj.fsf@boum.org>
 <1495727974.20270.48.camel@redhat.com>
 <CAGXu5jKY+Fc5PcZdbXEXKXsxN2xb9Ext15yrhPrg4Afd1Rq_yA@mail.gmail.com>
 <CAFwXZv_Nb5Q8n1kobbxz7+3w4r6pt-fD5YR4jw6_ZeXk1__9+A@mail.gmail.com>
 <20170526123416.GA26899@bifrost>
 <c3ae85ab-539f-daa1-e318-3175b674d4a2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c3ae85ab-539f-daa1-e318-3175b674d4a2@gmail.com>
Subject: Re: [kernel-hardening] Patch for random mac address
To: HacKurx <hackurx@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, intrigeri <intrigeri@boum.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 09, 2017 at 02:00:37PM +0200, HacKurx wrote:
> Le 26/05/2017 à 14:34, Anisse Astier a écrit :
> > You didn't answer my question regarding why this is different from the
> > function eth_random_addr.
> What do you think by replacing the whole by that?
> 
> +#ifdef CONFIG_RANDOM_MAC_ADDRESS
> +    /* randomize MAC whenever interface is brought up */
> +    if ((changes & IFF_UP) && !(old_flags & IFF_UP)) {
> +        struct sockaddr sa;
> +        eth_random_addr(sa.sa_data);
> +        sa.sa_family = dev->type;
> +        dev_set_mac_address(dev, &sa);

Yes, I meant something like that.

> 
> The network doesn't work with "eth_hw_addr_random(dev);" (the change of MAC addresses works well). Do you know why ?

I think that's because eth_hw_addr_random() is meant to be called by the
driver. Your solution is simpler, although it doesn't set
addr_assign_type to NET_ADDR_RANDOM, athough this field seems to be used
erratically (some use it as bitfield, but it does not look like one).

> Because the eth_hw_addr_randomfunction works better on all types of network cards.

You mean eth_random_addr, correct ?

Regards,

Anisse
