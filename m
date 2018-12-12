From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v2 4/4] x86/vmalloc: Add TLB efficient x86 arch_vunmap
Date: Wed, 12 Dec 2018 21:05:52 +0000
Message-ID: <2604df8fb817d8f0c38f572f4fb184db36554bed.camel@intel.com>
References: <20181212000354.31955-1-rick.p.edgecombe@intel.com>
	 <20181212000354.31955-5-rick.p.edgecombe@intel.com>
	 <90B10050-0CF1-48B2-B671-508FB092C2FE@vmware.com>
In-Reply-To: <90B10050-0CF1-48B2-B671-508FB092C2FE@vmware.com>
Content-Type: text/plain; charset="utf-8"
Content-ID: <792665CDB5A0EF4E8075F61D4024023D@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: "namit@vmware.com" <namit@vmware.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "jeyu@kernel.org" <jeyu@kernel.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "ast@kernel.org" <ast@kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jannh@google.com" <jannh@google.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, "kristen@linux.intel.com" <kristen@linux.intel.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "mingo@redhat.com" <mingo@redhat.com>, "luto@kernel.org" <luto@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>, "mhiramat@kernel.org" <mhiramat@kernel.org>, "naveen.n.rao@linux.vnet.ibm.com" <naveen.n.rao@linux.vnet.ibm.com>, "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

T24gV2VkLCAyMDE4LTEyLTEyIGF0IDA2OjMwICswMDAwLCBOYWRhdiBBbWl0IHdyb3RlOg0KPiA+
IE9uIERlYyAxMSwgMjAxOCwgYXQgNDowMyBQTSwgUmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdl
Y29tYmVAaW50ZWwuY29tPg0KPiA+IHdyb3RlOg0KPiA+IA0KPiA+IFRoaXMgYWRkcyBhIG1vcmUg
ZWZmaWNpZW50IHg4NiBhcmNoaXRlY3R1cmUgc3BlY2lmaWMgaW1wbGVtZW50YXRpb24gb2YNCj4g
PiBhcmNoX3Z1bm1hcCwgdGhhdCBjYW4gZnJlZSBhbnkgdHlwZSBvZiBzcGVjaWFsIHBlcm1pc3Np
b24gbWVtb3J5IHdpdGggb25seSAxDQo+ID4gVExCDQo+ID4gZmx1c2guDQo+ID4gDQo+ID4gSW4g
b3JkZXIgdG8gZW5hYmxlIHRoaXMsIF9zZXRfcGFnZXNfcCBhbmQgX3NldF9wYWdlc19ucCBhcmUg
bWFkZSBub24tc3RhdGljDQo+ID4gYW5kDQo+ID4gcmVuYW1lZCBzZXRfcGFnZXNfcF9ub2ZsdXNo
IGFuZCBzZXRfcGFnZXNfbnBfbm9mbHVzaCB0byBiZXR0ZXIgY29tbXVuaWNhdGUNCj4gPiB0aGVp
ciBkaWZmZXJlbnQgKG5vbi1mbHVzaGluZykgYmVoYXZpb3IgZnJvbSB0aGUgcmVzdCBvZiB0aGUg
c2V0X3BhZ2VzXyoNCj4gPiBmdW5jdGlvbnMuDQo+ID4gDQo+ID4gVGhlIG1ldGhvZCBmb3IgZG9p
bmcgdGhpcyB3aXRoIG9ubHkgMSBUTEIgZmx1c2ggd2FzIHN1Z2dlc3RlZCBieSBBbmR5DQo+ID4g
THV0b21pcnNraS4NCj4gPiANCj4gDQo+IFtzbmlwXQ0KPiANCj4gPiArCS8qDQo+ID4gKwkgKiBJ
ZiB0aGUgdm0gYmVpbmcgZnJlZWQgaGFzIHNlY3VyaXR5IHNlbnNpdGl2ZSBjYXBhYmlsaXRpZXMg
c3VjaCBhcw0KPiA+ICsJICogZXhlY3V0YWJsZSB3ZSBuZWVkIHRvIG1ha2Ugc3VyZSB0aGVyZSBp
cyBubyBXIHdpbmRvdyBvbiB0aGUgZGlyZWN0bWFwDQo+ID4gKwkgKiBiZWZvcmUgcmVtb3Zpbmcg
dGhlIFggaW4gdGhlIFRMQi4gU28gd2Ugc2V0IG5vdCBwcmVzZW50IGZpcnN0IHNvIHdlDQo+ID4g
KwkgKiBjYW4gZmx1c2ggd2l0aG91dCBhbnkgb3RoZXIgQ1BVIHBpY2tpbmcgdXAgdGhlIG1hcHBp
bmcuIFRoZW4gd2UgcmVzZXQNCj4gPiArCSAqIFJXK1Agd2l0aG91dCBhIGZsdXNoLCBzaW5jZSBO
UCBwcmV2ZW50ZWQgaXQgZnJvbSBiZWluZyBjYWNoZWQgYnkNCj4gPiArCSAqIG90aGVyIGNwdXMu
DQo+ID4gKwkgKi8NCj4gPiArCXNldF9hcmVhX2RpcmVjdF9ucChhcmVhKTsNCj4gPiArCXZtX3Vu
bWFwX2FsaWFzZXMoKTsNCj4gDQo+IERvZXMgdm1fdW5tYXBfYWxpYXNlcygpIGZsdXNoIGluIHRo
ZSBUTEIgdGhlIGRpcmVjdCBtYXBwaW5nIHJhbmdlIGFzIHdlbGw/IEkNCj4gY2FuIG9ubHkgZmlu
ZCB0aGUgZmx1c2ggb2YgdGhlIHZtYWxsb2MgcmFuZ2UuDQpIbW1tLiBJdCBzaG91bGQgdXN1YWxs
eSAoSSB0ZXN0ZWQpLCBidXQgbm93IEkgd29uZGVyIGlmIHRoZXJlIGFyZSBjYXNlcyB3aGVyZSBp
dA0KZG9lc24ndCBhbmQgaXQgY291bGQgZGVwZW5kIG9uIGFyY2hpdGVjdHVyZSBhcyB3ZWxsLiBJ
J2xsIGhhdmUgdG8gdHJhY2UgdGhyb3VnaA0KdGhpcyB0byB2ZXJpZnksIHRoYW5rcy4NCg0KUmlj
aw0K
