MIME-Version: 1.0
In-Reply-To: <20180507192641.GD31021@lunn.ch>
References: <1525706596-13601-1-git-send-email-s.mesoraca16@gmail.com>
 <d7fa9cf7-7c7e-b01c-8925-ce6dafc8721c@gmail.com> <CAJHCu1KsvPEs9vpp5bY04OeVfMtqZzPuO=9c8e2QP-+n+VKUjQ@mail.gmail.com>
 <20180507192641.GD31021@lunn.ch>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 8 May 2018 12:27:39 +0200
Message-ID: <CAJHCu1KKEUmUnw4izSiKSULUArqPkgWkBipWioeAAjHReYCT3A@mail.gmail.com>
Subject: Re: [PATCH v2] net: dsa: drop some VLAs in switch.c
Content-Type: text/plain; charset="UTF-8"
To: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>, linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Vivien Didelot <vivien.didelot@savoirfairelinux.com>, David Laight <David.Laight@aculab.com>
List-ID: <kernel-hardening.lists.openwall.com>

2018-05-07 21:26 GMT+02:00 Andrew Lunn <andrew@lunn.ch>:
>> >> +++ b/include/net/dsa.h
>> >> @@ -256,6 +256,9 @@ struct dsa_switch {
>> >>       /* Number of switch port queues */
>> >>       unsigned int            num_tx_queues;
>> >>
>> >> +     unsigned long           *bitmap;
>> >> +     unsigned long           _bitmap;
>> >> +
>> >>       /* Dynamically allocated ports, keep last */
>> >>       size_t num_ports;
>> >>       struct dsa_port ports[];
>> >> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
>> >> index adf50fb..cebf35f0 100644
>> >> --- a/net/dsa/dsa2.c
>> >> +++ b/net/dsa/dsa2.c
>> >> @@ -748,6 +748,20 @@ struct dsa_switch *dsa_switch_alloc(struct device *dev, size_t n)
>> >>       if (!ds)
>> >>               return NULL;
>> >>
>> >> +     /* We avoid allocating memory outside dsa_switch
>> >> +      * if it is not needed.
>> >> +      */
>> >> +     if (n <= sizeof(ds->_bitmap) * 8) {
>> >> +             ds->bitmap = &ds->_bitmap;
>> >
>> > Should not this be / BITS_PER_BYTE? If the sizeof(unsigned long) is <=
>> > 8, then you don't need to allocate it, otherwise, you have to.
>
>> This optimization will save us an allocation when number of ports is
>> less than 32 or 64 (depending on arch).
>> IMHO it's useful, if you consider that, right now, DSA works only with
>> 12-ports switches.
>
> Do you have a feeling for the savings? I don't see it being very
> large, and given the extra code, it might actually be negative.

I think that a "compare" and a "jump" costs nothing compared to
devm_kmalloc, its eventual free, and, *maybe*, the cache miss you
get every time you access the bitmask.
This is not necessarily relevant if this code it's invoked rarely,
but, IMHO, it seems strange to always go for dynamic allocation for
something that will be, almost always, as big as a pointer.

Salvatore
