MIME-Version: 1.0
In-Reply-To: <CAJHCu1LB1wPErEB0xNd_9=_8dmOn=VFXmzu=-U5Eg3zTeT4b6g@mail.gmail.com>
References: <1520970647-19587-1-git-send-email-s.mesoraca16@gmail.com>
 <87fu5321du.fsf@weeman.i-did-not-set--mail-host-address--so-tickle-me>
 <CAJHCu1JCCkkoL92tL+Zpx6te1A=-B1dNbAFu4sFEHiHa4vB6BQ@mail.gmail.com>
 <9843d23677af411aa75a5fb24df3c97b@AcuMS.aculab.com> <CAJHCu1LB1wPErEB0xNd_9=_8dmOn=VFXmzu=-U5Eg3zTeT4b6g@mail.gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sun, 18 Mar 2018 15:08:01 +0100
Message-ID: <CAJHCu1LmixGLhpsp39yxcU=XEzWARZyYjYPAz5R=sG2YK=QHMg@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: drop some VLAs in switch.c
Content-Type: text/plain; charset="UTF-8"
To: David Laight <David.Laight@aculab.com>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

2018-03-14 13:48 GMT+01:00 Salvatore Mesoraca <s.mesoraca16@gmail.com>:
> 2018-03-14 12:24 GMT+01:00 David Laight <David.Laight@aculab.com>:
>> Isn't using DECLARE_BITMAP() completely OTT when the maximum size is less
>> than the number of bits in a word?
>
> It allocates ceiling(size/8) "unsigned long"s, so yes.

Actually I meant ceiling(size/8/sizeof(unsigned long))
I'm sorry for the typo.

Salvatore
