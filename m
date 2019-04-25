From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v4 19/23] x86/ftrace: Use vmalloc special flag
Date: Thu, 25 Apr 2019 19:19:14 +0000
Message-ID: <e07ed452377e9c48fc50c08fc80b6893d2b26ead.camel@intel.com>
References: <20190422185805.1169-1-rick.p.edgecombe@intel.com>
	 <20190422185805.1169-20-rick.p.edgecombe@intel.com>
	 <20190425142803.4f2e354a@gandalf.local.home>
In-Reply-To: <20190425142803.4f2e354a@gandalf.local.home>
Content-Type: text/plain; charset="utf-8"
Content-ID: <B35D9A494A9B654C884ED7C35585F23C@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nadav.amit@gmail.com" <nadav.amit@gmail.com>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "kristen@linux.intel.com" <kristen@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, "linux_dti@icloud.com" <linux_dti@icloud.com>, "luto@kernel.org" <luto@kernel.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "bp@alien8.de" <bp@alien8.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

T24gVGh1LCAyMDE5LTA0LTI1IGF0IDE0OjI4IC0wNDAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gT24gTW9uLCAyMiBBcHIgMjAxOSAxMTo1ODowMSAtMDcwMA0KPiBSaWNrIEVkZ2Vjb21iZSA8
cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+IHdyb3RlOg0KPiANCj4gPiBVc2UgbmV3IGZsYWcg
Vk1fRkxVU0hfUkVTRVRfUEVSTVMgZm9yIGhhbmRsaW5nIGZyZWVpbmcgb2Ygc3BlY2lhbA0KPiA+
IHBlcm1pc3Npb25lZCBtZW1vcnkgaW4gdm1hbGxvYyBhbmQgcmVtb3ZlIHBsYWNlcyB3aGVyZSBt
ZW1vcnkgd2FzIHNldCBOWA0KPiA+IGFuZCBSVyBiZWZvcmUgZnJlZWluZyB3aGljaCBpcyBubyBs
b25nZXIgbmVlZGVkLg0KPiA+IA0KPiA+IENjOiBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBnb29k
bWlzLm9yZz4NCj4gPiBBY2tlZC1ieTogU3RldmVuIFJvc3RlZHQgKFZNd2FyZSkgPHJvc3RlZHRA
Z29vZG1pcy5vcmc+DQo+ID4gU2lnbmVkLW9mZi1ieTogUmljayBFZGdlY29tYmUgPHJpY2sucC5l
ZGdlY29tYmVAaW50ZWwuY29tPg0KPiANCj4gVGVzdGVkLWJ5OiBTdGV2ZW4gUm9zdGVkdCAoVk13
YXJlKSA8cm9zdGVkdEBnb29kbWlzLm9yZz4NCj4gQWNrZWQtYnk6IFN0ZXZlbiBSb3N0ZWR0IChW
TXdhcmUpIDxyb3N0ZWR0QGdvZG9taXMub3JnPg0KPiANCj4gLS0gU3RldmUNCg0KVGhhbmtzIQ0K
DQpSaWNrDQo=
