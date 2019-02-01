From: Nadav Amit <namit@vmware.com>
Subject: Re: [PATCH v2 03/20] x86/mm: temporary mm struct
Date: Fri, 1 Feb 2019 00:25:43 +0000
Message-ID: <D0AE47D2-F4B7-4938-A002-BBEEA3A5AB49@vmware.com>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-4-rick.p.edgecombe@intel.com>
 <20190131112948.GE6749@zn.tnic>
 <C481E605-E19A-4EA6-AB9A-6FF4229789E0@vmware.com>
 <20190201000812.GP6749@zn.tnic>
In-Reply-To: <20190201000812.GP6749@zn.tnic>
Content-Type: text/plain; charset="utf-8"
Content-ID: <A873F991F428B14CAEEB63AA4CB8EBCD@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

PiBPbiBKYW4gMzEsIDIwMTksIGF0IDQ6MDggUE0sIEJvcmlzbGF2IFBldGtvdiA8YnBAYWxpZW44
LmRlPiB3cm90ZToNCj4gDQo+IE9uIFRodSwgSmFuIDMxLCAyMDE5IGF0IDEwOjE5OjU0UE0gKzAw
MDAsIE5hZGF2IEFtaXQgd3JvdGU6DQo+PiBNZXRhLXF1ZXN0aW9uOiBjb3VsZCB5b3UgcGxlYXNl
IHJldmlldyB0aGUgZW50aXJlIHBhdGNoLXNldD8gVGhpcyBpcw0KPj4gYWN0dWFsbHkgdjkgb2Yg
dGhpcyBwYXJ0aWN1bGFyIHBhdGNoIC0gaXQgd2FzIHBhcnQgb2YgYSBzZXBhcmF0ZSBwYXRjaC1z
ZXQNCj4+IGJlZm9yZS4gSSBkb27igJl0IHRoaW5rIHRoYXQgdGhlIHBhdGNoIGhhcyBjaGFuZ2Vk
IHNpbmNlICh0aGUgcmVhbCkgdjEuDQo+PiANCj4+IFRoZXNlIHNwb3JhZGljIGNvbW1lbnRzIGFm
dGVyIGVhY2ggdmVyc2lvbiByZWFsbHkgbWFrZXMgaXQgaGFyZCB0byBnZXQgdGhpcw0KPj4gd29y
ayBjb21wbGV0ZWQuDQo+IA0KPiBTb3JyeSBidXQgd2hlcmUgSSBhbSB0aGUgZGF5IGhhcyBvbmx5
IDI0IGhvdXJzIGFuZCB0aGlzIHBhdGNoc2V0IGlzIG5vdA0KPiB0aGUgb25seSBvbmUgaW4gbXkg
b3ZlcmZsb3dpbmcgbWJveC4gSWYgbXkgc3BvcmFkaWMgY29tbWVudHMgYXJlIG1ha2luZw0KPiBp
dCBoYXJkIHRvIGZpbmlzaCB5b3VyIHdvcmssIEkgYmV0dGVyIG5vdCBpbnRlcmZlcmUgdGhlbi4N
Cg0KSSBjZXJ0YWlubHkgZGlkIG5vdCBpbnRlbmQgZm9yIGl0IHRvIHNvdW5kIHRoaXMgd2F5LCBh
bmQgeW91ciBmZWVkYmFjayBpcw0Kb2J2aW91c2x5IHZhbHVhYmxlLg0KDQpKdXN0IGxldCBtZSBr
bm93IHdoZW4geW91IGFyZSBkb25lIHJldmlld2luZyB0aGUgcGF0Y2gtc2V0LCBzbyBJIHdpbGwg
bm90DQpvdmVyZmxvdyB5b3VyIG1haWxib3ggd2l0aCBldmVuIHVubmVjZXNzYXJ5IHZlcnNpb25z
IG9mIHRoZXNlIHBhdGNoZXMuIDopDQoNCg==
