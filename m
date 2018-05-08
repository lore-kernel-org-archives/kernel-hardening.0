MIME-Version: 1.0
In-Reply-To: <f733e4630e424e0aaf402d5d840cb6e2@AcuMS.aculab.com>
References: <1525706596-13601-1-git-send-email-s.mesoraca16@gmail.com>
 <d7fa9cf7-7c7e-b01c-8925-ce6dafc8721c@gmail.com> <CAJHCu1KsvPEs9vpp5bY04OeVfMtqZzPuO=9c8e2QP-+n+VKUjQ@mail.gmail.com>
 <f733e4630e424e0aaf402d5d840cb6e2@AcuMS.aculab.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 8 May 2018 12:32:49 +0200
Message-ID: <CAJHCu1L_hRWpo2pjyEiHdbmD18GHao1bevVDCJ84z10Ch1Cb1g@mail.gmail.com>
Subject: Re: [PATCH v2] net: dsa: drop some VLAs in switch.c
Content-Type: text/plain; charset="UTF-8"
To: David Laight <David.Laight@aculab.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Vivien Didelot <vivien.didelot@savoirfairelinux.com>
List-ID: <kernel-hardening.lists.openwall.com>

2018-05-08 11:39 GMT+02:00 David Laight <David.Laight@aculab.com>:
> From: Salvatore Mesoraca
>> Sent: 07 May 2018 20:03
> ...
>> This optimization will save us an allocation when number of ports is
>> less than 32 or 64 (depending on arch).
>> IMHO it's useful, if you consider that, right now, DSA works only with
>> 12-ports switches.
>
> Why not just error out if the number of ports is greater than the compile-time
> limit?
>
> Worry about dynamic allocation if you need a lot more than 64 ports.

v1 has been NAK-ed by maintainers because they don't want limits on how
many ports a switch can have.

Salvatore
