From: "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Subject: RE: [PATCH v5 02/12] array_idx: sanitize speculative array
 de-references
Date: Wed, 31 Jan 2018 14:13:45 +0000
Message-ID: <0575AF4FD06DD142AD198903C74E1CC87A605256@ORSMSX103.amr.corp.intel.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151703972396.26578.7326612698912543866.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180128085500.djlm5rlbhjlpfj4i@gmail.com>
 <CAPcyv4jTaskPT1qXhdCO2mWVkcaMDMBq12vUJ_hSfjOU49qvgQ@mail.gmail.com>
 <alpine.DEB.2.20.1801281931180.2126@nanos>
 <CAPcyv4hSZ7=+076s+fmJ0HQ293H4X8829-LTrbvd8ZqJygGV6A@mail.gmail.com>
 <CA+55aFxLEL+8YA4MYkeyeUH7K8rZwBmGe6Z9V8QS=TYCREWDTQ@mail.gmail.com>
 <CAPcyv4jTbH6As_SC2Po8j5mB6jKLcwMr3Yn=19aTN2yMgBR=iw@mail.gmail.com>
 <0575AF4FD06DD142AD198903C74E1CC87A6048F5@ORSMSX103.amr.corp.intel.com>
 <20180131080310.ebqtxe5p7j54wglj@gmail.com>
In-Reply-To: <20180131080310.ebqtxe5p7j54wglj@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-arch <linux-arch@vger.kernel.org>, Cyril Novikov <cnovikov@lynx.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, X86 ML <x86@kernel.org>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>

PiA+IHNob3J0IHRlcm0gdGhlcmUgd2FzIHNvbWUgZXh0cmVtZWx5IHJ1ZGltZW50YXJ5IHN0YXRp
YyBhbmFseXNpcyBkb25lLiBjbGVhcmx5DQo+ID4gdGhhdCBoYXMgZXh0cmVtZSBsaW1pdGF0aW9u
cyBib3RoIGluIGluc2FuZSByYXRlIG9mIGZhbHNlIHBvc2l0aXZlcywgYW5kIG1pc3NpbmcNCj4g
PiBjYXNlcy4NCj4gDQo+IFdoYXQgd2FzIHRoZSBvdXRwdXQgcm91Z2hseSwgaG93IG1hbnkgc3Vz
cGVjdCBwbGFjZXMgdGhhdCBuZWVkDQo+IGFycmF5X2lkeF9ub3NwZWMoKQ0KPiBoYW5kbGluZzog
YSBmZXcsIGEgZmV3IGRvemVuLCBhIGZldyBodW5kcmVkIG9yIGEgZmV3IHRob3VzYW5kPw0KPiAN
Cj4gSSdtIGd1ZXNzaW5nICdzdGF0aWMgdG9vbCBlbWl0dGVkIGh1bmRyZWRzIG9mIHNpdGVzIHdp
dGggbWFueSBmYWxzZSBwb3NpdGl2ZXMNCj4gaW5jbHVkZWQsIGJ1dCB0aGUgcmVhbCBzaXRlcyBh
cmUgcHJvYmFibHkgYSBmZXcgZG96ZW4nIC0gYnV0IHRoYXQncyByZWFsbHkganVzdCBhDQo+IHZl
cnksIHZlcnkgd2lsZCBndWVzcy4NCg0KeW91ciBndWVzcyBpcyBwcmV0dHkgYWNjdXJhdGU7IHdl
IGVuZGVkIHVwIHdpdGggc29tZSAxNSBvciBzbyBwbGFjZXMgKHRoZSBmaXJzdCBwYXRjaCBraXQg
RGFuIG1haWxlZCBvdXQpDQoNCg0KPiANCj4gLSBJZiBpdCdzIG1vcmUgdGhhbiBhIGZldyBkb3pl
biB0aGVuIGludHVpdGl2ZWx5IEknZCBhbHNvIGJlIHZlcnkgbXVjaCBpbiBmYXZvciBvZg0KPiAg
IGNvbXBpbGVyIGhlbHA6IGZvciBleGFtcGxlIHRyaWNrbGUgZG93biBfX3VzZXIgYW5ub3RhdGlv
bnMgdGhhdCBTcGFyc2UgdXNlcw0KPiBzb21lDQo+ICAgbW9yZSBhbmQgbGV0IHRoZSBjb21waWxl
ciBzYW5pdGl6ZSBpbmRpY2VzIG9yIHdhcm4gYWJvdXQgdGhlbSAtIHdpdGhvdXQgaHVydGluZw0K
PiAgIHBlcmZvcm1hbmNlIG9mIGluLWtlcm5lbCBhcnJheSBoYW5kbGluZy4NCg0Kd2UgbmVlZCB0
aGlzIGtpbmQgb2YgaGVscCBldmVuIGlmIGl0J3Mgb25seSBmb3IgdGhlIHN0YXRpYyBhbmFseXNp
cyB0b29sDQoNCg0KIA0KPiBBbHNvLCBJTUhPIGFueSB0b29saW5nIHNob3VsZCB2ZXJ5IG11Y2gg
YmUgb3BlbiBzb3VyY2U6IHRoaXMgaXNuJ3QgdGhlIGtpbmQgb2YNCj4gYnVnDQo+IHRoYXQgY2Fu
IGJlIGlkZW50aWZpZWQgdmlhIGNvZGUgcmV2aWV3LCBzbyB0aGVyZSdzIG5vIGZhbGwtYmFjayBk
ZXRlY3Rpb24gbWV0aG9kDQo+IGxpa2Ugd2UgaGF2ZSBmb3IgYnVmZmVyIG92ZXJmbG93cy4NCg0K
d2UgYWJzb2x1dGVseSBuZWVkIHNvbWUgZ29vZCBvcGVuIHNvdXJjZSB0b29saW5nOyBteSBwZXJz
b25hbCBwcmVmZXJlbmNlIHdpbGwgYmUgYSBjb21waWxlciBwbHVnaW47IHRoYXQgd2F5IHlvdSBj
YW4gdXNlIGFsbCB0aGUgZmFuY3kgbG9naWMgaW5zaWRlIHRoZSBjb21waWxlcnMgZm9yIGFuYWx5
c2lzLCBhbmQgeW91IGNhbiBtYWtlIGEgIkkgZG9uJ3QgY2FyZSBqdXN0IGZpeCBpdCIgb3B0aW9u
IGluIGFkZGl0aW9uIHRvIGZsYWdnaW5nIGZvciBodW1hbiBpbnNwZWN0aW9uIGFzIHRoZSBrZXJu
ZWwgd291bGQuDQoNCg0K
