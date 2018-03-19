From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v5 0/2] Remove false-positive VLAs when using max()
Date: Mon, 19 Mar 2018 09:43:13 +0000
Message-ID: <0e94e9582bec4373b5e21c612be179ac@AcuMS.aculab.com>
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
 <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com>
 <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
 <20180316175502.GE30522@ZenIV.linux.org.uk>
 <CA+55aFzsrVF7W+YQye=EeF4Wk3yDOTbb_vSiM8s1zkKbE4JV4Q@mail.gmail.com>
 <CAGXu5jJmAAgaq3VCsUN2yjpHLSc7P-kNrM_4c4cqP=ysFcETXA@mail.gmail.com>
 <CA+55aFwv0VC67cx2W9yrf7qSFKf6ncVRrsVyLGqdmfSBn4yTYw@mail.gmail.com>
 <42b4342b-aefc-a16a-0d43-9f9c0d63ba7a@rasmusvillemoes.dk>
 <CA+55aFwFoTapX2niPiaET5kg7K85qxhav1_PoDDxY0o_VRA5Ag@mail.gmail.com>
 <38b6da49-1138-017e-7307-f39ff067d6d2@rasmusvillemoes.dk>
 <CA+55aFw0WC+S3TTE6x_vkLbRV6YLeR4-1S9LsBXhE+E2KZqBuA@mail.gmail.com>
In-Reply-To: <CA+55aFw0WC+S3TTE6x_vkLbRV6YLeR4-1S9LsBXhE+E2KZqBuA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: 'Linus Torvalds' <torvalds@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Florian Weimer <fweimer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Randy
 Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

RnJvbTogbGludXM5NzFAZ21haWwuY29tIFttYWlsdG86bGludXM5NzFAZ21haWwuY29tXSBPbiBC
ZWhhbGYgT2YgTGludXMgVG9ydmFsZHMNCj4gU2VudDogMTggTWFyY2ggMjAxOCAyMzozNg0KLi4u
DQo+IA0KPiBZZWFoLCBhbmQgc2luY2Ugd2UncmUgaW4gdGhlIHNpdHVhdGlvbiB0aGF0ICpuZXcq
IGdjYyB2ZXJzaW9ucyB3b3JrDQo+IGZvciB1cyBhbnl3YXksIGFuZCB3ZSBvbmx5IGhhdmUgaXNz
dWVzIHdpdGggb2xkZXIgZ2NjJ3MgKHRoYXQgc2FkbHkNCj4gcGVvcGxlIHN0aWxsIHVzZSksIGV2
ZW4gaWYgdGhlcmUgd2FzIGEgbmV3IGNvb2wgZmVhdHVyZSB3ZSBjb3VsZG4ndA0KPiB1c2UgaXQu
DQoNCklzIGl0IG5lY2Vzc2FyeSB0byBoYXZlIHRoZSBmdWxsIGNoZWNrcyBmb3Igb2xkIHZlcnNp
b25zIG9mIGdjYz8NCg0KRXZlbiAtV3ZsYSBjb3VsZCBiZSBwcmVkaWNhdGVkIG9uIHZlcnkgcmVj
ZW50IGdjYyAtIHNpbmNlIHdlIGFyZW4ndA0Kd29ycmllZCBhYm91dCB3aGV0aGVyIGdjYyBkZWNp
ZGVzIHRvIGdlbmVyYXRlIGEgdmxhLCBidXQgd2hldGhlcg0KdGhlIHNvdXJjZSByZXF1ZXN0cyBv
bmUuDQoNCglEYXZpZA0KDQo=
