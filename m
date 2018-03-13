Subject: Re: [PATCH] net: dsa: drop some VLAs in switch.c
References: <1520970647-19587-1-git-send-email-s.mesoraca16@gmail.com>
 <87fu5321du.fsf@weeman.i-did-not-set--mail-host-address--so-tickle-me>
From: Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b948ef55-8b16-fee4-b22f-4c6d09fea0cf@gmail.com>
Date: Tue, 13 Mar 2018 13:06:33 -0700
MIME-Version: 1.0
In-Reply-To: <87fu5321du.fsf@weeman.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/13/2018 12:58 PM, Vivien Didelot wrote:
> Hi Salvatore,
> 
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

Then this means that we need to allocate a bitmap from the heap, which
sounds a bit superfluous and could theoretically fail... not sure which
way is better, but bumping the size to DSA_MAX_PORTS definitively does
help people working on enabling -Wvla.
-- 
Florian
