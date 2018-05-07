MIME-Version: 1.0
In-Reply-To: <d7fa9cf7-7c7e-b01c-8925-ce6dafc8721c@gmail.com>
References: <1525706596-13601-1-git-send-email-s.mesoraca16@gmail.com> <d7fa9cf7-7c7e-b01c-8925-ce6dafc8721c@gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Mon, 7 May 2018 21:02:32 +0200
Message-ID: <CAJHCu1KsvPEs9vpp5bY04OeVfMtqZzPuO=9c8e2QP-+n+VKUjQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: dsa: drop some VLAs in switch.c
Content-Type: text/plain; charset="UTF-8"
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Vivien Didelot <vivien.didelot@savoirfairelinux.com>, David Laight <David.Laight@aculab.com>
List-ID: <kernel-hardening.lists.openwall.com>

2018-05-07 20:14 GMT+02:00 Florian Fainelli <f.fainelli@gmail.com>:
> On 05/07/2018 08:23 AM, Salvatore Mesoraca wrote:
>> We avoid 2 VLAs by using a pre-allocated field in dsa_switch.
>> We also try to avoid dynamic allocation whenever possible.
>>
>> Link: http://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>> Link: http://lkml.kernel.org/r/20180505185145.GB32630@lunn.ch
>>
>> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
>> ---
>>  include/net/dsa.h |  3 +++
>>  net/dsa/dsa2.c    | 14 ++++++++++++++
>>  net/dsa/switch.c  | 22 ++++++++++------------
>>  3 files changed, 27 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/net/dsa.h b/include/net/dsa.h
>> index 60fb4ec..576791d 100644
>> --- a/include/net/dsa.h
>> +++ b/include/net/dsa.h
>> @@ -256,6 +256,9 @@ struct dsa_switch {
>>       /* Number of switch port queues */
>>       unsigned int            num_tx_queues;
>>
>> +     unsigned long           *bitmap;
>> +     unsigned long           _bitmap;
>> +
>>       /* Dynamically allocated ports, keep last */
>>       size_t num_ports;
>>       struct dsa_port ports[];
>> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
>> index adf50fb..cebf35f0 100644
>> --- a/net/dsa/dsa2.c
>> +++ b/net/dsa/dsa2.c
>> @@ -748,6 +748,20 @@ struct dsa_switch *dsa_switch_alloc(struct device *dev, size_t n)
>>       if (!ds)
>>               return NULL;
>>
>> +     /* We avoid allocating memory outside dsa_switch
>> +      * if it is not needed.
>> +      */
>> +     if (n <= sizeof(ds->_bitmap) * 8) {
>> +             ds->bitmap = &ds->_bitmap;
>
> Should not this be / BITS_PER_BYTE? If the sizeof(unsigned long) is <=
> 8, then you don't need to allocate it, otherwise, you have to.

No.
We need one 1 bit per port, of course sizeof() returns size in bytes,
hence the multiplication to get the number of bits.
I might multiply per BITS_PER_BYTE instead of 8, but I doubt that
Linux supports implementations where a byte is not an octet.

> I would actually just always dynamically allocate the bitmap, optimizing
> for the case where we have fewer than or 8 ports is not worth IMHO.

This optimization will save us an allocation when number of ports is
less than 32 or 64 (depending on arch).
IMHO it's useful, if you consider that, right now, DSA works only with
12-ports switches.

Thank you for your time,

Salvatore
