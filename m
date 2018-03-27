From: "Uecker, Martin" <Martin.Uecker@med.uni-goettingen.de>
Subject: Re: [PATCH v6] kernel.h: Retain constant expression output for
 max()/min()
Date: Tue, 27 Mar 2018 12:00:55 +0000
Message-ID: <1522152055.3889.4.camel@med.uni-goettingen.de>
References: <20180326221554.GA45166@beast>
	 <CA+55aFw2Jn=ispuj1Xzj_RwPPMR3-1eYTi+BFo+2-d07AJBQJw@mail.gmail.com>
In-Reply-To: <CA+55aFw2Jn=ispuj1Xzj_RwPPMR3-1eYTi+BFo+2-d07AJBQJw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC226295E504114E82616A96029D541D@ads.local.med.uni-goettingen.de>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "keescook@chromium.org" <keescook@chromium.org>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "abbotti@mev.co.uk" <abbotti@mev.co.uk>, "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>, "miguel.ojeda.sandonis@gmail.com" <miguel.ojeda.sandonis@gmail.com>, "jpoimboe@redhat.com" <jpoimboe@redhat.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "David.Laight@aculab.com" <David.Laight@aculab.com>
List-ID: <kernel-hardening.lists.openwall.com>

DQpUbyBnaXZlIGNyZWRpdCB3aGVyZSBjcmVkaXQgaXMgZHVlLCB0aGlzIGhhY2sgd2FzIGluc3Bp
cmVkIGJ5wqANCmFuIGVxdWFsbHkgaW5zYW5lIChidXQgZGlmZmVyZW50KSB1c2Ugb2YgdGhlID86
IG9wZXJhdG9yIHRvIGNob29zZcKgDQp0aGUgcmlnaHQgcmV0dXJuIHR5cGUgZm9yIHR5cGUtZ2Vu
ZXJpYyBtYWNyb3MgaW4gdGdtYXRoLmguDQoNCmh0dHBzOi8vc291cmNld2FyZS5vcmcvZ2l0Lz9w
PWdsaWJjLmdpdDthPWJsb2I7Zj1tYXRoL3RnbWF0aC5oO2g9YTcwOWE1DQo5ZDBmYTExNjhlZjAz
MzQ5NTYxMTY5ZmM1YmQyN2Q2NWFhO2hiPWQ4NzQyZGQ4MmY2YTAwNjAxMTU1YzY5YmFkMzAxMmU5
MA0KNTU5MWUxZg0KDQoocmVjb21tZW5kYXRpb246IGRvbid0IGxvb2spDQoNCk1hcnRpbg0KDQoN
CkFtIE1vbnRhZywgZGVuIDI2LjAzLjIwMTgsIDE0OjUyIC0xMDAwIHNjaHJpZWIgTGludXMgVG9y
dmFsZHM6DQo+IE9uIE1vbiwgTWFyIDI2LCAyMDE4IGF0IDEyOjE1IFBNLCBLZWVzIENvb2sgPGtl
ZXNjb29rQGNocm9taXVtLm9yZz4NCj4gd3JvdGU6DQo+ID4gDQo+ID4gVGhpcyBwYXRjaCB1cGRh
dGVzIHRoZSBtaW4oKS9tYXgoKSBtYWNyb3MgdG8gZXZhbHVhdGUgdG8gYSBjb25zdGFudA0KPiA+
IGV4cHJlc3Npb24gd2hlbiBjYWxsZWQgb24gY29uc3RhbnQgZXhwcmVzc2lvbiBhcmd1bWVudHMu
DQo+IA0KPiBBY2suDQo+IA0KPiBJJ20gb2YgdHdvIG1pbmRzIHdoZXRoZXIgdGhhdCAiX19pc19j
b25zdGFudCgpIiBtYWNybyBzaG91bGQgYmUNCj4gZXhwbGFpbmVkIG9yIG5vdC4NCj4gDQo+IEEg
c21hbGwgdm9pY2UgaW4gbXkgaGVhZCBzYXlzICJ0aGF0IHdhbnRzIGEgY29tbWVudCIuDQo+IA0K
PiBCdXQgYSBiaWdnZXIgdm9pY2UgZGlzYWdyZWVzLg0KPiANCj4gSXQgaXMgYSB3b3JrIG9mIGFy
dCwgYW5kIG1heWJlIHRoZSBiZXN0IGRvY3VtZW50YXRpb24gaXMganVzdCB0aGUNCj4gbmFtZS4g
SXQgZG9lcyB3aGF0IGl0IHNheXMgaXQgZG9lcy4NCj4gDQo+IEFydCBzaG91bGRuJ3QgYmUgZXhw
bGFpbmVkLiBJdCBzaG91bGQgYmUgYXBwcmVjaWF0ZWQuDQo+IA0KPiBOb2JvZHkgc2FuZSByZWFs
bHkgc2hvdWxkIGNhcmUgYWJvdXQgaG93IGl0IHdvcmtzLCBhbmQgaWYgc29tZWJvZHkNCj4gY2Fy
ZXMgaXQgaXMgImxlZnQgYXMgYW4gZXhlcmNpc2UgdG8gdGhlIHJlYWRlciIuDQo+IA0KPiDCoMKg
wqDCoMKgwqBMaW51cw==
