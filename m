From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 16/17] Plug in new special vfree flag
Date: Thu, 7 Feb 2019 17:33:37 +0000
Message-ID: <16a2ac45ceef5b6f310f816d696ad2ea8df3b45c.camel@intel.com>
References: <20190117003259.23141-1-rick.p.edgecombe@intel.com>
	 <20190117003259.23141-17-rick.p.edgecombe@intel.com>
	 <20190206112356.64cc5f0d@gandalf.local.home>
In-Reply-To: <20190206112356.64cc5f0d@gandalf.local.home>
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA377F3CE86CB84DB34EDE487645D269@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "jeyu@kernel.org" <jeyu@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nadav.amit@gmail.com" <nadav.amit@gmail.com>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "kristen@linux.intel.com" <kristen@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, "linux_dti@icloud.com" <linux_dti@icloud.com>, "luto@kernel.org" <luto@kernel.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "bp@alien8.de" <bp@alien8.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "mhiramat@kernel.org" <mhiramat@kernel.org>, "ast@kernel.org" <ast@kernel.org>, "paulmck@linux.ibm.com" <paulmck@linux.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

T24gV2VkLCAyMDE5LTAyLTA2IGF0IDExOjIzIC0wNTAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gT24gV2VkLCAxNiBKYW4gMjAxOSAxNjozMjo1OCAtMDgwMA0KPiBSaWNrIEVkZ2Vjb21iZSA8
cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+IHdyb3RlOg0KPiANCj4gPiBBZGQgbmV3IGZsYWcg
Zm9yIGhhbmRsaW5nIGZyZWVpbmcgb2Ygc3BlY2lhbCBwZXJtaXNzaW9uZWQgbWVtb3J5IGluIHZt
YWxsb2MNCj4gPiBhbmQgcmVtb3ZlIHBsYWNlcyB3aGVyZSBtZW1vcnkgd2FzIHNldCBSVyBiZWZv
cmUgZnJlZWluZyB3aGljaCBpcyBubyBsb25nZXINCj4gPiBuZWVkZWQuDQo+ID4gDQo+ID4gSW4g
a3Byb2JlcywgYnBmIGFuZCBmdHJhY2UgdGhpcyBqdXN0IGFkZHMgdGhlIGZsYWcsIGFuZCByZW1v
dmVzIHRoZSBub3cNCj4gPiB1bm5lZWRlZCBzZXRfbWVtb3J5XyBjYWxscyBiZWZvcmUgY2FsbGlu
ZyB2ZnJlZS4NCj4gPiANCj4gPiBJbiBtb2R1bGVzLCB0aGUgZnJlZWluZyBvZiBpbml0IHNlY3Rp
b25zIGlzIG1vdmVkIHRvIGEgd29yayBxdWV1ZSwgc2luY2UNCj4gPiBmcmVlaW5nIG9mIFJPIG1l
bW9yeSBpcyBub3Qgc3VwcG9ydGVkIGluIGFuIGludGVycnVwdCBieSB2bWFsbG9jLg0KPiA+IElu
c3RlYWQgb2YgY2FsbF9yY3UsIGl0IG5vdyB1c2VzIHN5bmNocm9uaXplX3JjdSgpIGluIHRoZSB3
b3JrIHF1ZXVlLg0KPiA+IA0KPiA+IENjOiBSdXN0eSBSdXNzZWxsIDxydXN0eUBydXN0Y29ycC5j
b20uYXU+DQo+ID4gQ2M6IE1hc2FtaSBIaXJhbWF0c3UgPG1oaXJhbWF0QGtlcm5lbC5vcmc+DQo+
ID4gQ2M6IERhbmllbCBCb3JrbWFubiA8ZGFuaWVsQGlvZ2VhcmJveC5uZXQ+DQo+ID4gQ2M6IEFs
ZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+DQo+ID4gQ2M6IEplc3NpY2EgWXUgPGpl
eXVAa2VybmVsLm9yZz4NCj4gPiBDYzogU3RldmVuIFJvc3RlZHQgPHJvc3RlZHRAZ29vZG1pcy5v
cmc+DQo+ID4gQ2M6IFBhdWwgRS4gTWNLZW5uZXkgPHBhdWxtY2tAbGludXguaWJtLmNvbT4NCj4g
PiBTaWduZWQtb2ZmLWJ5OiBSaWNrIEVkZ2Vjb21iZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5j
b20+DQo+ID4gLS0tDQo+ID4gIGFyY2gveDg2L2tlcm5lbC9mdHJhY2UuYyAgICAgICB8ICA2ICst
LQ0KPiANCj4gRm9yIHRoZSBmdHJhY2UgY29kZS4NCj4gDQo+IEFja2VkLWJ5OiBTdGV2ZW4gUm9z
dGVkdCAoVk13YXJlKSA8cm9zdGVkdEBnb29kbWlzLm9yZz4NCj4gDQo+IC0tIFN0ZXZlDQo+IA0K
VGhhbmtzIQ0KDQpSaWNrDQo+ID4gIGFyY2gveDg2L2tlcm5lbC9rcHJvYmVzL2NvcmUuYyB8ICA3
ICstLS0NCj4gPiAgaW5jbHVkZS9saW51eC9maWx0ZXIuaCAgICAgICAgIHwgMTYgKystLS0tLQ0K
PiA+ICBrZXJuZWwvYnBmL2NvcmUuYyAgICAgICAgICAgICAgfCAgMSAtDQo+ID4gIGtlcm5lbC9t
b2R1bGUuYyAgICAgICAgICAgICAgICB8IDc3ICsrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0t
LS0tLS0NCj4gPiAgNSBmaWxlcyBjaGFuZ2VkLCA0NSBpbnNlcnRpb25zKCspLCA2MiBkZWxldGlv
bnMoLSkNCj4gPiANCg==
