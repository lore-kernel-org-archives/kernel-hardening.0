From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v2 13/20] Add set_alias_ function and x86 implementation
Date: Mon, 11 Feb 2019 19:27:03 +0000
Message-ID: <468a81ee8983a7dfc3e5ab5c269fc89ff16b6b21.camel@intel.com>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
	 <20190129003422.9328-14-rick.p.edgecombe@intel.com>
	 <20190211190925.GQ19618@zn.tnic>
In-Reply-To: <20190211190925.GQ19618@zn.tnic>
Content-Type: text/plain; charset="utf-8"
Content-ID: <112F179FA06F5143B572137122F136C3@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: "bp@alien8.de" <bp@alien8.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "nadav.amit@gmail.com" <nadav.amit@gmail.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "kristen@linux.intel.com" <kristen@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, "linux_dti@icloud.com" <linux_dti@icloud.com>, "luto@kernel.org" <luto@kernel.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

T24gTW9uLCAyMDE5LTAyLTExIGF0IDIwOjA5ICswMTAwLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6
DQo+IE9uIE1vbiwgSmFuIDI4LCAyMDE5IGF0IDA0OjM0OjE1UE0gLTA4MDAsIFJpY2sgRWRnZWNv
bWJlIHdyb3RlOg0KPiA+IFRoaXMgYWRkcyB0d28gbmV3IGZ1bmN0aW9ucyBzZXRfYWxpYXNfZGVm
YXVsdF9ub2ZsdXNoIGFuZA0KPiANCj4gcy9UaGlzIGFkZHMvQWRkLw0KPiANCj4gPiBzZXRfYWxp
YXNfbnZfbm9mbHVzaCBmb3Igc2V0dGluZyB0aGUgYWxpYXMgbWFwcGluZyBmb3IgdGhlIHBhZ2Ug
dG8gaXRzDQo+IA0KPiBQbGVhc2UgZW5kIGZ1bmN0aW9uIG5hbWVzIHdpdGggcGFyZW50aGVzZXMs
IGJlbG93IHRvby4NCk9rLg0KPiA+IGRlZmF1bHQgdmFsaWQgcGVybWlzc2lvbnMgYW5kIHRvIGFu
IGludmFsaWQgc3RhdGUgdGhhdCBjYW5ub3QgYmUgY2FjaGVkIGluDQo+ID4gYSBUTEIsIHJlc3Bl
Y3RpdmVseS4gVGhlc2UgZnVuY3Rpb25zIHRvIG5vdCBmbHVzaCB0aGUgVExCLg0KPiANCj4gcy90
by9kby8NCj4gDQpBcmdoLCB0aGFua3MuDQo+IEFsc28sIHBscyBwdXQgdGhhdCBkZXNjcmlwdGlv
biBhcyBjb21tZW50cyBvdmVyIHRoZSBmdW5jdGlvbnMgaW4gdGhlDQo+IGNvZGUuIE90aGVyd2lz
ZSB0aGF0ICJudiIgYXMgcGFydCBvZiB0aGUgbmFtZSBkb2Vzbid0IHJlYWxseSBleHBsYWluDQo+
IHdoYXQgaXQgZG9lcy4NCj4gDQo+IEFjdHVhbGx5LCB5b3UgY291bGQganVzdCBhcyB3ZWxsIGNh
bGwgdGhlIGZ1bmN0aW9uDQo+IA0KPiBzZXRfYWxpYXNfaW52YWxpZF9ub2ZsdXNoKCkNCj4gDQo+
IEFsbCB0aGUgb3RoZXIgd29yZHMgYXJlIHdyaXR0ZW4gaW4gZnVsbCwgbm8gbmVlZCB0byBoYXZl
ICJudiIgdGhlcmUuDQo+IA0KPiBUaHguDQpZZXMsIHRoYXQgc2VlbXMgYmV0dGVyLg0KDQpUaGFu
a3MsDQoNClJpY2sNCg==
