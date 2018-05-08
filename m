From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v2] net: dsa: drop some VLAs in switch.c
Date: Tue, 8 May 2018 09:39:58 +0000
Message-ID: <f733e4630e424e0aaf402d5d840cb6e2@AcuMS.aculab.com>
References: <1525706596-13601-1-git-send-email-s.mesoraca16@gmail.com>
 <d7fa9cf7-7c7e-b01c-8925-ce6dafc8721c@gmail.com>
 <CAJHCu1KsvPEs9vpp5bY04OeVfMtqZzPuO=9c8e2QP-+n+VKUjQ@mail.gmail.com>
In-Reply-To: <CAJHCu1KsvPEs9vpp5bY04OeVfMtqZzPuO=9c8e2QP-+n+VKUjQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: 'Salvatore Mesoraca' <s.mesoraca16@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Vivien Didelot <vivien.didelot@savoirfairelinux.com>
List-ID: <kernel-hardening.lists.openwall.com>

RnJvbTogU2FsdmF0b3JlIE1lc29yYWNhDQo+IFNlbnQ6IDA3IE1heSAyMDE4IDIwOjAzDQouLi4N
Cj4gVGhpcyBvcHRpbWl6YXRpb24gd2lsbCBzYXZlIHVzIGFuIGFsbG9jYXRpb24gd2hlbiBudW1i
ZXIgb2YgcG9ydHMgaXMNCj4gbGVzcyB0aGFuIDMyIG9yIDY0IChkZXBlbmRpbmcgb24gYXJjaCku
DQo+IElNSE8gaXQncyB1c2VmdWwsIGlmIHlvdSBjb25zaWRlciB0aGF0LCByaWdodCBub3csIERT
QSB3b3JrcyBvbmx5IHdpdGgNCj4gMTItcG9ydHMgc3dpdGNoZXMuDQoNCldoeSBub3QganVzdCBl
cnJvciBvdXQgaWYgdGhlIG51bWJlciBvZiBwb3J0cyBpcyBncmVhdGVyIHRoYW4gdGhlIGNvbXBp
bGUtdGltZQ0KbGltaXQ/DQoNCldvcnJ5IGFib3V0IGR5bmFtaWMgYWxsb2NhdGlvbiBpZiB5b3Ug
bmVlZCBhIGxvdCBtb3JlIHRoYW4gNjQgcG9ydHMuDQoNCglEYXZpZA0KDQo=
