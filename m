From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] net: dsa: drop some VLAs in switch.c
Date: Wed, 14 Mar 2018 11:24:30 +0000
Message-ID: <9843d23677af411aa75a5fb24df3c97b@AcuMS.aculab.com>
References: <1520970647-19587-1-git-send-email-s.mesoraca16@gmail.com>
 <87fu5321du.fsf@weeman.i-did-not-set--mail-host-address--so-tickle-me>
 <CAJHCu1JCCkkoL92tL+Zpx6te1A=-B1dNbAFu4sFEHiHa4vB6BQ@mail.gmail.com>
In-Reply-To: <CAJHCu1JCCkkoL92tL+Zpx6te1A=-B1dNbAFu4sFEHiHa4vB6BQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: 'Salvatore Mesoraca' <s.mesoraca16@gmail.com>, Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel
 Hardening <kernel-hardening@lists.openwall.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Andrew
 Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

RnJvbTogU2FsdmF0b3JlIE1lc29yYWNhDQo+IFNlbnQ6IDEzIE1hcmNoIDIwMTggMjI6MDENCj4g
MjAxOC0wMy0xMyAyMDo1OCBHTVQrMDE6MDAgVml2aWVuIERpZGVsb3QgPHZpdmllbi5kaWRlbG90
QHNhdm9pcmZhaXJlbGludXguY29tPjoNCj4gPiBIaSBTYWx2YXRvcmUsDQo+IA0KPiBIaSBWaXZp
ZW4sDQo+IA0KPiA+IFNhbHZhdG9yZSBNZXNvcmFjYSA8cy5tZXNvcmFjYTE2QGdtYWlsLmNvbT4g
d3JpdGVzOg0KPiA+DQo+ID4+IGRzYV9zd2l0Y2gncyBudW1fcG9ydHMgaXMgY3VycmVudGx5IGZp
eGVkIHRvIERTQV9NQVhfUE9SVFMuIFNvIHdlIGF2b2lkDQo+ID4+IDIgVkxBc1sxXSBieSB1c2lu
ZyBEU0FfTUFYX1BPUlRTIGluc3RlYWQgb2YgZHMtPm51bV9wb3J0cy4NCj4gPj4NCj4gPj4gWzFd
IGh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDE4LzMvNy82MjENCj4gPj4NCj4gPj4gU2lnbmVkLW9m
Zi1ieTogU2FsdmF0b3JlIE1lc29yYWNhIDxzLm1lc29yYWNhMTZAZ21haWwuY29tPg0KPiA+DQo+
ID4gTkFLLg0KPiA+DQo+ID4gV2UgYXJlIGluIHRoZSBwcm9jZXNzIHRvIHJlbW92ZSBoYXJkY29k
ZWQgbGltaXRzIHN1Y2ggYXMgRFNBX01BWF9QT1JUUw0KPiA+IGFuZCBEU0FfTUFYX1NXSVRDSEVT
LCBzbyB3ZSBoYXZlIHRvIHN0aWNrIHdpdGggZHMtPm51bV9wb3J0cy4NCj4gDQo+IEkgY2FuIHJl
d3JpdGUgdGhlIHBhdGNoIHVzaW5nIGttYWxsb2MuDQo+IEFsdGhvdWdoLCBpZiBkcy0+bnVtX3Bv
cnRzIHdpbGwgYWx3YXlzIGJlIGxlc3MgdGhhbiBvciBlcXVhbCB0byAxMiwgaXQNCj4gc2hvdWxk
IGJlIGJldHRlciB0bw0KPiBqdXN0IHVzZSBEU0FfTUFYX1BPUlRTLg0KDQpJc24ndCB1c2luZyBE
RUNMQVJFX0JJVE1BUCgpIGNvbXBsZXRlbHkgT1RUIHdoZW4gdGhlIG1heGltdW0gc2l6ZSBpcyBs
ZXNzDQp0aGFuIHRoZSBudW1iZXIgb2YgYml0cyBpbiBhIHdvcmQ/DQoNCglEYXZpZA0KDQo=
