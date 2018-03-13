MIME-Version: 1.0
In-Reply-To: <87fu5321du.fsf@weeman.i-did-not-set--mail-host-address--so-tickle-me>
References: <1520970647-19587-1-git-send-email-s.mesoraca16@gmail.com> <87fu5321du.fsf@weeman.i-did-not-set--mail-host-address--so-tickle-me>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 13 Mar 2018 23:01:05 +0100
Message-ID: <CAJHCu1JCCkkoL92tL+Zpx6te1A=-B1dNbAFu4sFEHiHa4vB6BQ@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: drop some VLAs in switch.c
Content-Type: text/plain; charset="UTF-8"
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

2018-03-13 20:58 GMT+01:00 Vivien Didelot <vivien.didelot@savoirfairelinux.com>:
> Hi Salvatore,

Hi Vivien,

> Salvatore Mesoraca <s.mesoraca16@gmail.com> writes:
>
>> dsa_switch's num_ports is currently fixed to DSA_MAX_PORTS. So we avoid
>> 2 VLAs[1] by using DSA_MAX_PORTS instead of ds->num_ports.
>>
>> [1] https://lkml.org/lkml/2018/3/7/621
>>
>> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
>
> NAK.
>
> We are in the process to remove hardcoded limits such as DSA_MAX_PORTS
> and DSA_MAX_SWITCHES, so we have to stick with ds->num_ports.

I can rewrite the patch using kmalloc.
Although, if ds->num_ports will always be less than or equal to 12, it
should be better to
just use DSA_MAX_PORTS.

Thank you,

Salvatore
