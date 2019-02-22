From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v3 18/20] x86/ftrace: Use vmalloc special flag
Date: Fri, 22 Feb 2019 00:55:49 +0000
Message-ID: <3cd659eb8c7d43cf46bebc6562c1c26bb6c51b51.camel@intel.com>
References: <20190221234451.17632-1-rick.p.edgecombe@intel.com>
	 <20190221234451.17632-19-rick.p.edgecombe@intel.com>
	 <20190221192210.3e038fc3@gandalf.local.home>
In-Reply-To: <20190221192210.3e038fc3@gandalf.local.home>
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A4A8CD00D4DF448B0BFB3995685F0A4@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nadav.amit@gmail.com" <nadav.amit@gmail.com>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "kristen@linux.intel.com" <kristen@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, "linux_dti@icloud.com" <linux_dti@icloud.com>, "luto@kernel.org" <luto@kernel.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "bp@alien8.de" <bp@alien8.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

T24gVGh1LCAyMDE5LTAyLTIxIGF0IDE5OjIyIC0wNTAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gT24gVGh1LCAyMSBGZWIgMjAxOSAxNTo0NDo0OSAtMDgwMA0KPiBSaWNrIEVkZ2Vjb21iZSA8
cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+IHdyb3RlOg0KPiANCj4gPiBVc2UgbmV3IGZsYWcg
Vk1fRkxVU0hfUkVTRVRfUEVSTVMgZm9yIGhhbmRsaW5nIGZyZWVpbmcgb2Ygc3BlY2lhbA0KPiA+
IHBlcm1pc3Npb25lZCBtZW1vcnkgaW4gdm1hbGxvYyBhbmQgcmVtb3ZlIHBsYWNlcyB3aGVyZSBt
ZW1vcnkgd2FzIHNldCBOWA0KPiA+IGFuZCBSVyBiZWZvcmUgZnJlZWluZyB3aGljaCBpcyBubyBs
b25nZXIgbmVlZGVkLg0KPiA+IA0KPiA+IENjOiBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBnb29k
bWlzLm9yZz4NCj4gPiBBY2tlZC1ieTogU3RldmVuIFJvc3RlZHQgKFZNd2FyZSkgPHJvc3RlZHRA
Z29vZG1pcy5vcmc+DQo+ID4gU2lnbmVkLW9mZi1ieTogUmljayBFZGdlY29tYmUgPHJpY2sucC5l
ZGdlY29tYmVAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBhcmNoL3g4Ni9rZXJuZWwvZnRyYWNl
LmMgfCA2ICsrLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCA0IGRl
bGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvZnRyYWNl
LmMgYi9hcmNoL3g4Ni9rZXJuZWwvZnRyYWNlLmMNCj4gPiBpbmRleCAxM2M4MjQ5YjE5N2YuLjkz
ZWZlMzk1NTMzMyAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvZnRyYWNlLmMNCj4g
PiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvZnRyYWNlLmMNCj4gPiBAQCAtNjkyLDEwICs2OTIsNiBA
QCBzdGF0aWMgaW5saW5lIHZvaWQgKmFsbG9jX3RyYW1wKHVuc2lnbmVkIGxvbmcgc2l6ZSkNCj4g
PiAgfQ0KPiA+ICBzdGF0aWMgaW5saW5lIHZvaWQgdHJhbXBfZnJlZSh2b2lkICp0cmFtcCwgaW50
IHNpemUpDQo+IA0KPiBBcyBzaXplIGlzIG5vIGxvbmdlciB1c2VkIHdpdGhpbiB0aGUgZnVuY3Rp
b24sIGNhbiB5b3UgcmVtb3ZlIHRoYXQgdG9vLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gLS0gU3Rl
dmUNCj4gDQpHb29kIHBvaW50LCBJJ2xsIHJlbW92ZSBpdC4NCg0KVGhhbmtzLA0KDQpSaWNrDQoN
CltzbmlwXQ0K
