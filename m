MIME-Version: 1.0
In-Reply-To: <b948ef55-8b16-fee4-b22f-4c6d09fea0cf@gmail.com>
References: <1520970647-19587-1-git-send-email-s.mesoraca16@gmail.com>
 <87fu5321du.fsf@weeman.i-did-not-set--mail-host-address--so-tickle-me> <b948ef55-8b16-fee4-b22f-4c6d09fea0cf@gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sat, 5 May 2018 12:36:36 +0200
Message-ID: <CAJHCu1+V+khxvzhQdG=mo960b5ayiQcSaoMnm9A__51JdWkdig@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: drop some VLAs in switch.c
Content-Type: text/plain; charset="UTF-8"
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>, linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

2018-03-13 21:06 GMT+01:00 Florian Fainelli <f.fainelli@gmail.com>:
> On 03/13/2018 12:58 PM, Vivien Didelot wrote:
>> Hi Salvatore,
>>
>> Salvatore Mesoraca <s.mesoraca16@gmail.com> writes:
>>
>>> dsa_switch's num_ports is currently fixed to DSA_MAX_PORTS. So we avoid
>>> 2 VLAs[1] by using DSA_MAX_PORTS instead of ds->num_ports.
>>>
>>> [1] https://lkml.org/lkml/2018/3/7/621
>>>
>>> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
>>
>> NAK.
>>
>> We are in the process to remove hardcoded limits such as DSA_MAX_PORTS
>> and DSA_MAX_SWITCHES, so we have to stick with ds->num_ports.
>
> Then this means that we need to allocate a bitmap from the heap, which
> sounds a bit superfluous and could theoretically fail... not sure which
> way is better, but bumping the size to DSA_MAX_PORTS definitively does
> help people working on enabling -Wvla.

Hi Florian,

Should I consider this patch still NAKed or not?
Should I resend the patch with some modifications?

Thank you,

Salvatore
