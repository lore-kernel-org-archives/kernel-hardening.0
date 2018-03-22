From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v5 0/2] Remove false-positive VLAs when using max()
Date: Thu, 22 Mar 2018 15:13:10 +0000
Message-ID: <6057c50c19d94174814e90503caa0aa5@AcuMS.aculab.com>
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
 <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com>
 <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
 <20180316175502.GE30522@ZenIV.linux.org.uk>
 <CA+55aFzsrVF7W+YQye=EeF4Wk3yDOTbb_vSiM8s1zkKbE4JV4Q@mail.gmail.com>
 <CAGXu5jJmAAgaq3VCsUN2yjpHLSc7P-kNrM_4c4cqP=ysFcETXA@mail.gmail.com>
 <CA+55aFwv0VC67cx2W9yrf7qSFKf6ncVRrsVyLGqdmfSBn4yTYw@mail.gmail.com>
 <CAGXu5jJ=ZYpf=30H6hsWn-R-CEVYAgVMHxjmoLUC00QYq0r17g@mail.gmail.com>
 <CA+55aFwxk=tUECYQkd4cog08qW4ZT=r2K7FQXzGnc-zuMc7JQA@mail.gmail.com>
 <CAGXu5j+5i+56R0KDLMDA=+_DRW5w9aUGCEo0dq6PZvHPBWkM1g@mail.gmail.com>
In-Reply-To: <CAGXu5j+5i+56R0KDLMDA=+_DRW5w9aUGCEo0dq6PZvHPBWkM1g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: 'Kees Cook' <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Florian Weimer <fweimer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy
 Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

RnJvbTogS2VlcyBDb29rDQo+IFNlbnQ6IDIyIE1hcmNoIDIwMTggMTU6MDENCi4uLg0KPiA+ICAg
LyogR2xvcnkgdG8gTWFydGluIFVlY2tlciA8TWFydGluLlVlY2tlckBtZWQudW5pLWdvZXR0aW5n
ZW4uZGU+ICovDQo+ID4gICAjZGVmaW5lIF9faXNfY29uc3RhbnQoYSkgXA0KPiA+ICAgICAgICAg
KHNpemVvZihpbnQpID09IHNpemVvZigqKDEgPyAoKHZvaWQqKSgoYSkgKiAwbCkpIDogKGludCop
MSkpKQ0KLi4uDQo+IFNvLCB0aGlzIHRpbWUgaXQncyBub3QgYSBjYXRhc3Ryb3BoaWMgZmFpbHVy
ZSB3aXRoIGdjYyA0LjQuIEluc3RlYWQgaXQNCj4gZmFpbHMgaW4gMTEgZGlzdGluY3QgcGxhY2Vz
Og0KLi4uDQo+IFNlZW1zIGxpa2UgaXQgZG9lc24ndCBsaWtlIHZvaWQgKiBhcmd1bWVudHM6DQo+
IA0KPiBtbS9wZXJjcHUuYzoNCj4gICAgICAgICAgICAgICAgIHZvaWQgKnB0cjsNCj4gLi4uDQo+
ICAgICAgICAgICAgICAgICBiYXNlID0gbWluKHB0ciwgYmFzZSk7DQoNClRyeSBhZGRpbmcgKHVu
c2lnbmVkIGxvbmcpIGJlZm9yZSB0aGUgKGEpLg0KDQoJRGF2aWQNCg0K
