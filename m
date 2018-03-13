From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Subject: Re: [PATCH] net: dsa: drop some VLAs in switch.c
In-Reply-To: <1520970647-19587-1-git-send-email-s.mesoraca16@gmail.com>
References: <1520970647-19587-1-git-send-email-s.mesoraca16@gmail.com>
Date: Tue, 13 Mar 2018 15:58:53 -0400
Message-ID: <87fu5321du.fsf@weeman.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>, linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Salvatore,

Salvatore Mesoraca <s.mesoraca16@gmail.com> writes:

> dsa_switch's num_ports is currently fixed to DSA_MAX_PORTS. So we avoid
> 2 VLAs[1] by using DSA_MAX_PORTS instead of ds->num_ports.
>
> [1] https://lkml.org/lkml/2018/3/7/621
>
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>

NAK.

We are in the process to remove hardcoded limits such as DSA_MAX_PORTS
and DSA_MAX_SWITCHES, so we have to stick with ds->num_ports.


Thanks,

        Vivien
