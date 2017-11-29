From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 29 Nov 2017 10:07:27 +0000
Message-ID: <324abe19f1ee4177911d2fc48899ac8a@AcuMS.aculab.com>
References: <1511921105-3647-1-git-send-email-me@tobin.cc>
 <1511921105-3647-5-git-send-email-me@tobin.cc>
 <CA+55aFxgGb13hqoNQ8bzFn4ENZM25PBSdi5pkFUBa5Hk+j-s3Q@mail.gmail.com>
In-Reply-To: <CA+55aFxgGb13hqoNQ8bzFn4ENZM25PBSdi5pkFUBa5Hk+j-s3Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH V11 4/5] vsprintf: add printk specifier %px
To: 'Linus Torvalds' <torvalds@linux-foundation.org>, "Tobin C. Harding" <me@tobin.cc>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun
 Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel
 Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?utf-8?B?UmFkaW0gS3JjbcOhcg==?= <rkrcmar@redhat.com>, Linux Kernel Mailing
 List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen
 Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

RnJvbTogTGludXMgVG9ydmFsZHMNCj4gU2VudDogMjkgTm92ZW1iZXIgMjAxNyAwMjoyOQ0KPiAN
Cj4gT24gVHVlLCBOb3YgMjgsIDIwMTcgYXQgNjowNSBQTSwgVG9iaW4gQy4gSGFyZGluZyA8bWVA
dG9iaW4uY2M+IHdyb3RlOg0KPiA+DQo+ID4gICAgTGV0J3MgYWRkIHNwZWNpZmllciAlcHggYXMg
YQ0KPiA+IGNsZWFyLCBvcHQtaW4sIHdheSB0byBwcmludCBhIHBvaW50ZXIgYW5kIG1haW50YWlu
IHNvbWUgbGV2ZWwgb2YNCj4gPiBpc29sYXRpb24gZnJvbSBhbGwgdGhlIG90aGVyIGhleCBpbnRl
Z2VyIG91dHB1dCB3aXRoaW4gdGhlIEtlcm5lbC4NCj4gDQo+IFllcywgSSBsaWtlIHRoaXMgbW9k
ZWwuIEl0J3MgZWFzeSBhbmQgaXQncyBvYnZpb3VzICgiJ3gnIGZvciBoZXgiKSwNCj4gYW5kIGl0
IGdpdmVzIHBlb3BsZSBhIGdvb2Qgd2F5IHRvIHNheSAieWVzLCBJIHJlYWxseSB3YW50IHRoZSBh
Y3R1YWwNCj4gYWRkcmVzcyBhcyBoZXgiIGZvciBpZi93aGVuIHRoZSBoYXNoZWQgcG9pbnRlciBk
b2Vzbid0IHdvcmsgZm9yIHNvbWUNCj4gcmVhc29uLg0KDQpSZW1pbmQgbWUgdG8gY2hhbmdlIGV2
ZXJ5ICVwIHRvICVweCBvbiBrZXJuZWxzIHRoYXQgc3VwcG9ydCBpdC4NCg0KQWx0aG91Z2ggdGhl
IGFic29sdXRlIHZhbHVlcyBvZiBwb2ludGVycyBtYXkgbm90IGJlIHVzZWZ1bCwga25vd2luZw0K
dGhhdCB0d28gcG9pbnRlciBkaWZmZXIgYnkgYSBzbWFsbCBhbW91bnQgaXMgdXNlZnVsLg0KSXQg
aXMgYWxzbyB1c2VmdWwgdG8ga25vdyB3aGV0aGVyIHBvaW50ZXJzIGFyZSB0byBzdGFjaywgY29k
ZSwgc3RhdGljDQpkYXRhIG9yIGhlYXAuDQoNClRoaXMgY2hhbmdlIHRvICVwIGlzIGdvaW5nIHRv
IG1ha2UgZGVidWdnaW5nIGEgbmlnaHRtYXJlLg0KDQoJRGF2aWQNCg0K
