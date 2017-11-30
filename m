From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 30 Nov 2017 10:38:03 +0000
Message-ID: <c47f7659676246d6bbeb5230b952a5ad@AcuMS.aculab.com>
References: <1511921105-3647-1-git-send-email-me@tobin.cc>
 <1511921105-3647-5-git-send-email-me@tobin.cc>
 <CA+55aFxgGb13hqoNQ8bzFn4ENZM25PBSdi5pkFUBa5Hk+j-s3Q@mail.gmail.com>
 <324abe19f1ee4177911d2fc48899ac8a@AcuMS.aculab.com>
 <CAGXu5j+xUt+coLCKg9qeCrTzc7HEM7KP=1Z-xTiDXWSRYibJQg@mail.gmail.com>
In-Reply-To: <CAGXu5j+xUt+coLCKg9qeCrTzc7HEM7KP=1Z-xTiDXWSRYibJQg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH V11 4/5] vsprintf: add printk specifier %px
To: 'Kees Cook' <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr
 Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?utf-8?B?UmFkaW0gS3JjbcOhcg==?= <rkrcmar@redhat.com>, Linux Kernel Mailing
 List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen
 Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

RnJvbTogS2VlcyBDb29rDQo+IFNlbnQ6IDI5IE5vdmVtYmVyIDIwMTcgMjI6MjgNCj4gT24gV2Vk
LCBOb3YgMjksIDIwMTcgYXQgMjowNyBBTSwgRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWlnaHRAYWN1
bGFiLmNvbT4gd3JvdGU6DQo+ID4gRnJvbTogTGludXMgVG9ydmFsZHMNCj4gPj4gU2VudDogMjkg
Tm92ZW1iZXIgMjAxNyAwMjoyOQ0KPiA+Pg0KPiA+PiBPbiBUdWUsIE5vdiAyOCwgMjAxNyBhdCA2
OjA1IFBNLCBUb2JpbiBDLiBIYXJkaW5nIDxtZUB0b2Jpbi5jYz4gd3JvdGU6DQo+ID4+ID4NCj4g
Pj4gPiAgICBMZXQncyBhZGQgc3BlY2lmaWVyICVweCBhcyBhDQo+ID4+ID4gY2xlYXIsIG9wdC1p
biwgd2F5IHRvIHByaW50IGEgcG9pbnRlciBhbmQgbWFpbnRhaW4gc29tZSBsZXZlbCBvZg0KPiA+
PiA+IGlzb2xhdGlvbiBmcm9tIGFsbCB0aGUgb3RoZXIgaGV4IGludGVnZXIgb3V0cHV0IHdpdGhp
biB0aGUgS2VybmVsLg0KPiA+Pg0KPiA+PiBZZXMsIEkgbGlrZSB0aGlzIG1vZGVsLiBJdCdzIGVh
c3kgYW5kIGl0J3Mgb2J2aW91cyAoIid4JyBmb3IgaGV4IiksDQo+ID4+IGFuZCBpdCBnaXZlcyBw
ZW9wbGUgYSBnb29kIHdheSB0byBzYXkgInllcywgSSByZWFsbHkgd2FudCB0aGUgYWN0dWFsDQo+
ID4+IGFkZHJlc3MgYXMgaGV4IiBmb3IgaWYvd2hlbiB0aGUgaGFzaGVkIHBvaW50ZXIgZG9lc24n
dCB3b3JrIGZvciBzb21lDQo+ID4+IHJlYXNvbi4NCj4gPg0KPiA+IFJlbWluZCBtZSB0byBjaGFu
Z2UgZXZlcnkgJXAgdG8gJXB4IG9uIGtlcm5lbHMgdGhhdCBzdXBwb3J0IGl0Lg0KPiA+DQo+ID4g
QWx0aG91Z2ggdGhlIGFic29sdXRlIHZhbHVlcyBvZiBwb2ludGVycyBtYXkgbm90IGJlIHVzZWZ1
bCwga25vd2luZw0KPiA+IHRoYXQgdHdvIHBvaW50ZXIgZGlmZmVyIGJ5IGEgc21hbGwgYW1vdW50
IGlzIHVzZWZ1bC4NCj4gPiBJdCBpcyBhbHNvIHVzZWZ1bCB0byBrbm93IHdoZXRoZXIgcG9pbnRl
cnMgYXJlIHRvIHN0YWNrLCBjb2RlLCBzdGF0aWMNCj4gPiBkYXRhIG9yIGhlYXAuDQo+ID4NCj4g
PiBUaGlzIGNoYW5nZSB0byAlcCBpcyBnb2luZyB0byBtYWtlIGRlYnVnZ2luZyBhIG5pZ2h0bWFy
ZS4NCj4gDQo+IEluIHRoZSBmdXR1cmUsIG1heWJlIHdlIGNvdWxkIGhhdmUgYSBrbm9iOiB1bmhh
c2hlZCwgaGFzaGVkIChkZWZhdWx0KSwNCj4gb3IgemVyb2VkLg0KDQpBZGQgYSA0dGgsIGhhc2hl
ZF9wYWdlK29mZnNldC4NCg0KSXNuJ3QgdGhlcmUgYWxyZWFkeSBhIGtub2IgZm9yICVwSywgYml0
cyBpbiB0aGUgc2FtZSB2YWx1ZSBjb3VsZCBiZSB1c2VkLg0KVGhhdCB3b3VsZCBtYWtlIGl0IGVh
c3kgdG8gZW5zdXJlIHRoYXQgJXBLIGlzIG1vcmUgcmVzdHJ1Y3RpdmUgdGhhbiAlcC4NCg0KCURh
dmlkDQoNCg==
