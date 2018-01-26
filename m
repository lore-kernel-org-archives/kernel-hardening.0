From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 26 Jan 2018 11:17:29 +0000
Message-ID: <b8ea504729db4073abf82ebd5d8a53c6@AcuMS.aculab.com>
References: <503224b776b9513885453756e44bab235221124e.1516644136.git.luto@kernel.org>
 <CA+55aFwcU_hHz+S9ZDphBDRQLw6pMsd+6Yp_=mQA8kTcmTzWcQ@mail.gmail.com>
 <CA+55aFyONQeyHit6LcQz_JM5+C9pr61fcWFSpdn=7K_2mZN+oA@mail.gmail.com>
 <CALCETrVUY9p9jMNhuBgM3mWATsr1Fc_ZWc=bjidBkLw7bq5Vdg@mail.gmail.com>
 <CA+55aFwUn7+WiHxL7PBWxNrGB0--HETqUjdRwxi+DkMvCP_CaA@mail.gmail.com>
 <CALCETrV1JHK1ovjjD1vbs08K1an6tq6nbRoAj9uyrY2GUYJJBA@mail.gmail.com>
 <CA+55aFzTXVRPo7OBPMo2OB26GisY8-dg6NaC8ackVJgS9M0+4w@mail.gmail.com>
 <CALCETrU42C1S3nvSuLuamXtp2-s1xBG3q5cSNVOfGThncHxBZA@mail.gmail.com>
In-Reply-To: <CALCETrU42C1S3nvSuLuamXtp2-s1xBG3q5cSNVOfGThncHxBZA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH] x86/retpoline/entry: Disable the entire SYSCALL64 fast
 path with retpolines on
To: 'Andy Lutomirski' <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Cox <alan@linux.intel.com>, Jann Horn <jannh@google.com>, Samuel Neves <samuel.c.p.neves@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

RnJvbTogQW5keSBMdXRvbWlyc2tpDQo+IFNlbnQ6IDI1IEphbnVhcnkgMjAxOCAyMTozMQ0KLi4u
DQo+IEFub3RoZXIgcG90ZW50aWFsbHkgdXNlZnVsIGlmIHJhdGhlciBtaW5vciBvcHRpbWl6YXRp
b24gd291bGQgYmUgdG8NCj4gcmVqaWdnZXIgdGhlIFNZU0NBTExfREVGSU5FIG1hY3JvcyBhIGJp
dC4gIEN1cnJlbnRseSB3ZSB0cmVhdCBhbGwNCj4gc3lzY2FsbHMgbGlrZSB0aGlzOg0KPiANCj4g
bG9uZyBmdW5jKGxvbmcgYXJnMCwgbG9uZyBhcmcxLCBsb25nIGFyZzIsIGxvbmcgYXJnMywgbG9u
ZyBhcmc0LCBsb25nIGFyZzUpOw0KPiANCj4gSSB3b25kZXIgaWYgd2UnZCBiZSBiZXR0ZXIgb2Zm
IGRvaW5nOg0KPiANCj4gbG9uZyBmdW5jKGNvbnN0IHN0cnVjdCBwdF9yZWdzICpyZWdzKTsNCj4g
DQo+IGFuZCBhdXRvZ2VuZXJhdGluZzoNCj4gDQo+IHN0YXRpYyBsb25nIFN5U19yZWFkKGNvbnN0
IHN0cnVjdCBwdF9yZWdzICpyZWdzKQ0KPiB7DQo+ICAgIHJldHVybiBzeXNfcmVnKHJlZ3MtPmRp
LCAuLi4pOw0KPiB9DQoNCkhtbW0uLi4uDQpOZXRCU0QgKGFuZCB0aGUgb3RoZXIgQlNEPykgZGVm
aW5lcyBhIHN0cnVjdHVyZSBmb3IgdGhlIGFyZ3VtZW50cyB0byBlYWNoIHN5c2NhbGwuDQpPbiBz
eXN0ZW1zIHdoZXJlIGFsbCBmdW5jdGlvbiBhcmd1bWVudHMgYXJlIHB1dCBvbiBzdGFjayB0aGUg
dXNlciBzdGFjayB0aGF0DQpjb250YWlucyB0aGUgYXJndW1lbnRzIGlzIGNvcGllZCBpbnRvIGEg
a2VybmVsIGJ1ZmZlci4NCkZvciBhbWQ2NCBJIGNoYW5nZWQgdGhlIHJlZ2lzdGVyIHNhdmUgYXJl
YSBsYXlvdXQgc28gdGhhdCB0aGUgYXJndW1lbnRzIHdlcmUgaW4NCnRoZSByaWdodCBvcmRlciBb
MV0uIFRoZW4gYWRkZWQgYW4gZXh0cmEgYXJlYSBmb3IgdGhlIGV4dHJhIGFyZ3VtZW50cyB0aGF0
IGhhZCB0byBiZQ0KcmVhZCBmcm9tIHRoZSB1c2VyIHN0YWNrLg0KSnVzdCBwYXNzaW5nIGEgcG9p
bnRlciBpbnRvIHRoZSBzYXZlIGFyZWEgaGFzIHRvIGJlIGJldHRlciB0aGFuIHJlYWRpbmcNCmFs
bCB0aGUgdmFsdWVzIGFnYWluLg0KDQpbMV0gVGhlcmUgd2FzIHNvbWUgaG9ycmlkIGZhbGxvdXQg
ZnJvbSB0aGF0IDotKA0KDQoJRGF2aWQNCg0K
