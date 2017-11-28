From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 28 Nov 2017 17:44:54 +0000
Message-ID: <e08761e892c94bedb9778fd760958e07@AcuMS.aculab.com>
References: <1511826058-2563-1-git-send-email-me@tobin.cc>
 <CA+55aFyO6sKuE16z6hgocRA8Azd6E7sO4CO=AogxF1m6vaTh4A@mail.gmail.com>
 <CA+55aFzDh7GpkKniTgQp29-6TObR8NpOKczbAW-85qux=ek0Tw@mail.gmail.com>
 <874lpelxzh.fsf@xmission.com>
 <CA+55aFx+bMOT-DDp3EYuio0aJDGzWa3PzQxVbM3Rz+GdZKaaFQ@mail.gmail.com>
In-Reply-To: <CA+55aFx+bMOT-DDp3EYuio0aJDGzWa3PzQxVbM3Rz+GdZKaaFQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH 0/5] add printk specifier %px, unique identifier
To: 'Linus Torvalds' <torvalds@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo
 Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan
 Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?utf-8?B?UmFkaW0gS3JjbcOhcg==?= <rkrcmar@redhat.com>, Linux Kernel Mailing
 List <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

RnJvbTogTGludXMgVG9ydmFsZHMNCj4gU2VudDogMjggTm92ZW1iZXIgMjAxNyAxNzozMw0KPiAN
Cj4gT24gTW9uLCBOb3YgMjcsIDIwMTcgYXQgMTA6MjYgUE0sIEVyaWMgVy4gQmllZGVybWFuDQo+
IDxlYmllZGVybUB4bWlzc2lvbi5jb20+IHdyb3RlOg0KPiA+Pg0KPiA+PiBPaCB3ZWxsLCBJIGp1
c3QgZGlkIC9wcm9jLzxwaWQ+L3N0YWNrIGJ5IG1ha2luZyBpdCBqdXN0IHByaW50IDANCj4gPj4g
dW5jb25kaXRpb25hbGx5IHJhdGhlciB0aGFuIHRoZSBoZXggbnVtYmVyLg0KPiA+DQo+ID4gUGF0
Y2g/DQo+IA0KPiBPaCwgYXBwYXJlbnRseSBJIG5ldmVyIHB1c2hlZCBvdXQgeWVzdGVyZGF5Lg0K
PiANCj4gVGhlIHBhdGNoIGxpdGVyYWxseSBqdXN0IGFmZmVjdHMgdGhlICh1c2VsZXNzKSBoZXgg
bnVtYmVyLiBTbzoNCj4gDQo+ICAgICBjYXQgL3Byb2Mvc2VsZi9zdGFjaw0KPiANCj4gbm93IHBy
aW50cyBvdXQNCj4gDQo+ICAgICBbPDA+XSBwcm9jX3BpZF9zdGFjaysweGFhLzB4MTAwDQo+ICAg
ICBbPDA+XSBwcm9jX3NpbmdsZV9zaG93KzB4NDgvMHg4MA0KPiAgICAgWzwwPl0gc2VxX3JlYWQr
MHhkMi8weDQxMA0KPiAgICAgLi4uDQo+IA0KPiBpbnN0ZWFkIG9mIHB1dHRpbmcgc29tZSByYW5k
b21pemVkIGtlcm5lbCBhZGRyZXNzIHRoZXJlLg0KDQpOb3Qgc3VyZSBJJ3ZlIGRvbmUgaXQgb24g
TGludXggLSBnZXR0aW5nIGEgaGV4ZHVtcCBvZiB0aGUgc3RhY2sgaXMgaGFyZC4NCkJ1dCBJIGtu
b3cgSSd2ZSB1c2VkIHRoZSBhYnNvbHV0ZSByZXR1cm4gYWRkcmVzc2VzIHRvIGhlbHAgaGFuZC1k
ZWNvZGUNCnRoZSBzdGFjay4NClVzdWFsbHkgbmVlZGVkIHRvIHdvcmsgb3V0IHdoaWNoIHN0YWNr
IGZyYW1lIGlzIHdoaWNoIC0gZXNwZWNpYWxseSB3aGVuIHRoZQ0Kc3RhY2sgZGVjb2RlIGRvZXNu
J3QgYWN0dWFsbHkgKG9idmlvdXNseSkgY29udGFpbiB0aGUgYWRkcmVzc2VzIG9mIGVhY2ggZnJh
bWUuDQoNCkkgZG9uJ3Qga25vdyBob3cgdGhlc2UgbmV3IHN0YWNrIHRyYWNlYmFjayBtZXRob2Rz
IHdvcmssIGJ1dCB0aGUgYmVzdCBvbmUNCkkndmUgc2VlbiBpbiB0aGUgcGFzdCBkaXNhc3NlbWJs
ZWQgZm9yd2FyZHMgcmVtZW1iZXJpbmcgdGhlIHN0YWNrIG9mZnNldA0KYW5kIHVucHJvY2Vzc2Vk
IGJyYW5jaCB0YXJnZXRzIHVudGlsIGl0IGZvdW5kIGEgcmV0dXJuIGFkZHJlc3MuDQpJdCBvbmx5
IGhhZCB0byB0cmFjayAlc3AgYW5kICVicC4NCg0KCURhdmlkDQoNCg==
