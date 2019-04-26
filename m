From: Nadav Amit <namit@vmware.com>
Subject: Re: [PATCH v5 14/23] x86/mm/cpa: Add set_direct_map_ functions
Date: Fri, 26 Apr 2019 16:43:09 +0000
Message-ID: <636228FC-71D6-418F-B671-4D6A3B69342C@vmware.com>
References: <20190426001143.4983-1-namit@vmware.com>
 <20190426001143.4983-15-namit@vmware.com>
 <CAADWXX8yZJ9Z4yfqG9wQcb2r+0O7VCk2uQLcOU1=-BOnYhjnow@mail.gmail.com>
In-Reply-To: 
 <CAADWXX8yZJ9Z4yfqG9wQcb2r+0O7VCk2uQLcOU1=-BOnYhjnow@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-ID: <D1C68EF185691D48BD87873B5B102692@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, lkml <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "kristen@linux.intel.com" <kristen@linux.intel.com>, "deneen.t.dock@intel.com" <deneen.t.dock@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

PiBPbiBBcHIgMjYsIDIwMTksIGF0IDk6NDAgQU0sIExpbnVzIFRvcnZhbGRzIDx0b3J2YWxkc0Bs
aW51eC1mb3VuZGF0aW9uLm9yZz4gd3JvdGU6DQo+IA0KPiBOYWRhdiwNCj4gDQo+IEkgZ2V0DQo+
IA0KPiAgICAgICBkbWFyYz1mYWlsIChwPVFVQVJBTlRJTkUgc3A9Tk9ORSBkaXM9UVVBUkFOVElO
RSkgaGVhZGVyLmZyb209dm13YXJlLmNvbQ0KPiANCj4gZm9yIHRoZXNlIGVtYWlscywgYmVjYXVz
ZSB0aGV5IGxhY2sgdGhlIHZtd2FyZSBES0lNIHNpZ25hdHVyZS4NCj4gDQo+IEl0IGNsZWFybHkg
ZGlkIGdvIHRocm91Z2ggc29tZSB2bXdhcmUgbWFpbCBzZXJ2ZXJzLCBidXQgYXBwYXJlbnRseSBu
b3QNCj4gdGhlICpyaWdodCogZXh0ZXJuYWwgdm13YXJlIFNNVFAgZ2F0ZXdheS4NCj4gDQo+IFBs
ZWFzZSBjaGVjayB3aXRoIHZtd2FyZSBNSVMgd2hhdCB0aGUgcmlnaHQgU01UUCBzZXR1cCBmb3Ig
Z2l0LXNlbmQtZW1haWwgaXMuDQoNCkVyci4uIFNvcnJ5IGZvciB0aGF0LiBGb3IgdGhlIHRpbWUg
YmVpbmcgSeKAmWxsIHVzZSBnbWFpbCBpbnN0ZWFkLg0KDQo=
