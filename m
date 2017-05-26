MIME-Version: 1.0
In-Reply-To: <20170526123416.GA26899@bifrost>
References: <CAFwXZv_b3hdEA4xOFKqAVfc4UZEBX=dL9DOY_mDHExsW+Qg6tQ@mail.gmail.com>
 <85inkpie9o.fsf@boum.org> <1495724872.20270.46.camel@redhat.com>
 <8537bt9bvj.fsf@boum.org> <1495727974.20270.48.camel@redhat.com>
 <CAGXu5jKY+Fc5PcZdbXEXKXsxN2xb9Ext15yrhPrg4Afd1Rq_yA@mail.gmail.com>
 <CAFwXZv_Nb5Q8n1kobbxz7+3w4r6pt-fD5YR4jw6_ZeXk1__9+A@mail.gmail.com> <20170526123416.GA26899@bifrost>
From: HacKurx <hackurx@gmail.com>
Date: Fri, 26 May 2017 16:41:18 +0200
Message-ID: <CAFwXZv9uYF0Z0t=Omu+Fu40PZgqPaf_BLnGbB2jnzAv0TN5OvA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Patch for random mac address
To: Anisse Astier <anisse@astier.eu>
Cc: Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, intrigeri <intrigeri@boum.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

2017-05-26 14:34 GMT+02:00 Anisse Astier <anisse@astier.eu>:
> On Fri, May 26, 2017 at 09:55:37AM +0200, HacKurx wrote:
>> 2017-05-25 19:28 GMT+02:00 Kees Cook <keescook@chromium.org>:
>> > How about sending a v2 with that fixed, inline, etc.
>>
>> Agree with the V2. I'm not a developer, what do you mean by inline? Send by GIT?
>> If someone can make him grow in my place I will pay him a beer ^^
>
> What he meant, is to follow the kernel process for sending patches.
> Lukas already sent a link to the documentation, but you may be
> interested in these parts:
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html#no-mime-no-links-no-compression-no-attachments-just-plain-text
> Yes, you can use git as a client (with git send-email), but it's not
> mandatory. You should use your real name though:
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin
>
> And add a Signed-off-by line.

I didn't understand it all that well. English is not my native language.

In your link I could see:
"Gmail (Web GUI)
Does not work for sending patches.
Gmail web client converts tabs to spaces automatically.
At the same time it wraps lines every 78 chars with CRLF style line
breaks although tab2space problem can be solved with external editor.
Another problem is that Gmail will base64-encode any message that has
a non-ASCII character. That includes things like European names."

So here is my error ^^

>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index fca407b..3eeb42b 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -6669,6 +6669,26 @@ int dev_change_flags(struct net_device *dev, unsigned int flags)
>>
>>       changes = (old_flags ^ dev->flags) | (old_gflags ^ dev->gflags);
>>       __dev_notify_flags(dev, old_flags, changes);
>> +
>> +#ifdef CONFIG_RANDOM_MAC_ADDRESS
>> +     if ((changes & IFF_UP) && !(old_flags & IFF_UP)) {
>> +             /* randomize MAC whenever interface is brought up */
>> +             struct sockaddr sa;
>> +             unsigned int mac4;
>> +             unsigned short mac2;
>> +
>> +             mac4 = prandom_u32();
>> +             mac2 = prandom_u32();
>> +             memcpy(sa.sa_data, &mac4, sizeof(mac4));
>> +             memcpy((char *)sa.sa_data + sizeof(mac4), &mac2, sizeof(mac2));
>> +             if (!is_valid_ether_addr(sa.sa_data))
>> +                     sa.sa_data[5] = 1;
>> +             sa.sa_data[0] &= 0xFC;
>> +             sa.sa_family = dev->type;
>> +             dev_set_mac_address(dev, &sa);
>
> You didn't answer my question regarding why this is different from the
> function eth_random_addr.

Because it's been working for years and I'm not a developer / kernel expert.
"Keep it stupidly simple" Might be a reason?

-- 
Best regards,

HacKurx (Loic)
blog.opensec.fr
