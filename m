From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v2 4/7] arm64/modules: Add rlimit checking for arm64
 modules
Date: Fri, 12 Oct 2018 22:01:45 +0000
Message-ID: <a89e6d7bbcfba2ebaad927fac0da131ded59aa28.camel@intel.com>
References: <20181011233117.7883-1-rick.p.edgecombe@intel.com>
	 <20181011233117.7883-5-rick.p.edgecombe@intel.com>
	 <25951d99-8ba7-5c9e-938e-baf92395f9e0@intel.com>
	 <20181012143254.idy65qbvaaw5k3ge@linux-8ccs>
In-Reply-To: <20181012143254.idy65qbvaaw5k3ge@linux-8ccs>
Content-Type: text/plain; charset="utf-8"
Content-ID: <F021F4E7985B76488B10BEA1EDF2C533@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: "jeyu@kernel.org" <jeyu@kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "keescook@chromium.org" <keescook@chromium.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "arjan@linux.intel.com" <arjan@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>, "Dock, Deneen T" <deneen.t.dock@intel.com>, "x86@kernel.org" <x86@kernel.org>, "kristen@linux.intel.com" <kristen@linux.intel.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "mingo@redhat.com" <mingo@redhat.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "bp@alien8.de" <bp@alien8.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "davem@davemloft.net" <davem@davemloft.net>, "arnd@arndb.de" <arnd@arndb.de>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

T24gRnJpLCAyMDE4LTEwLTEyIGF0IDE2OjMyICswMjAwLCBKZXNzaWNhIFl1IHdyb3RlOg0KPiAr
KysgRGF2ZSBIYW5zZW4gWzExLzEwLzE4IDE2OjQ3IC0wNzAwXToNCj4gPiBPbiAxMC8xMS8yMDE4
IDA0OjMxIFBNLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToNCj4gPiA+ICsJaWYgKGNoZWNrX2luY19t
b2RfcmxpbWl0KHNpemUpKQ0KPiA+ID4gKwkJcmV0dXJuIE5VTEw7DQo+ID4gPiArDQo+ID4gPiAg
CXAgPSBfX3ZtYWxsb2Nfbm9kZV9yYW5nZShzaXplLCBNT0RVTEVfQUxJR04sIG1vZHVsZV9hbGxv
Y19iYXNlLA0KPiA+ID4gIAkJCQltb2R1bGVfYWxsb2NfYmFzZSArIE1PRFVMRVNfVlNJWkUsDQo+
ID4gPiAgCQkJCWdmcF9tYXNrLCBQQUdFX0tFUk5FTF9FWEVDLCAwLA0KPiA+ID4gQEAgLTY1LDYg
KzY4LDggQEAgdm9pZCAqbW9kdWxlX2FsbG9jKHVuc2lnbmVkIGxvbmcgc2l6ZSkNCj4gPiA+ICAJ
CXJldHVybiBOVUxMOw0KPiA+ID4gIAl9DQo+ID4gPiANCj4gPiA+ICsJdXBkYXRlX21vZF9ybGlt
aXQocCwgc2l6ZSk7DQo+ID4gDQo+ID4gSXMgdGhlcmUgYSByZWFzb24gd2UgY291bGRuJ3QganVz
dCByZW5hbWUgYWxsIG9mIHRoZSBleGlzdGluZyBwZXItYXJjaA0KPiA+IG1vZHVsZV9hbGxvYygp
IGNhbGxzIHRvIGJlIGNhbGxlZCwgc2F5LCAiYXJjaF9tb2R1bGVfYWxsb2MoKSIsIHRoZW4gcHV0
DQo+ID4gdGhpcyBuZXcgcmxpbWl0IGNvZGUgaW4gYSBnZW5lcmljIGhlbHBlciB0aGF0IGRvZXM6
DQo+ID4gDQo+ID4gDQo+ID4gCWlmIChjaGVja19pbmNfbW9kX3JsaW1pdChzaXplKSkNCj4gPiAJ
CXJldHVybiBOVUxMOw0KPiA+IA0KPiA+IAlwID0gYXJjaF9tb2R1bGVfYWxsb2MoLi4uKTsNCj4g
PiANCj4gPiAJLi4uDQo+ID4gDQo+ID4gCXVwZGF0ZV9tb2RfcmxpbWl0KHAsIHNpemUpOw0KPiA+
IA0KPiANCj4gSSBzZWNvbmQgdGhpcyBzdWdnZXN0aW9uLiBKdXN0IG1ha2UgbW9kdWxlX3thbGxv
YyxtZW1mcmVlfSBnZW5lcmljLA0KPiBub24td2VhayBmdW5jdGlvbnMgdGhhdCBjYWxsIHRoZSBy
bGltaXQgaGVscGVycyBpbiBhZGRpdGlvbiB0byB0aGUNCj4gYXJjaC1zcGVjaWZpYyBhcmNoX21v
ZHVsZV97YWxsb2MsbWVtZnJlZX0gZnVuY3Rpb25zLg0KPiANCj4gSmVzc2ljYQ0KDQpPaywgdGhh
bmtzLiBJIGFtIGdvaW5nIHRvIHRyeSBhbm90aGVyIHZlcnNpb24gb2YgdGhpcyB3aXRoIGp1c3Qg
YSBzeXN0ZW0gd2lkZQ0KQlBGIEpJVCBsaW1pdCBiYXNlZCBvbiB0aGUgcHJvYmxlbXMgSmFubiBi
cm91Z2h0IHVwLiBJIHRoaW5rIGl0IHdvdWxkIGJlIG5pY2UgdG8NCmhhdmUgYSBtb2R1bGUgc3Bh
Y2UgbGltaXQsIGJ1dCBhcyBmYXIgYXMgSSBrbm93IHRoZSBvbmx5IHdheSB0b2RheSB1bi1wcml2
bGlkZ2VkIA0KdXNlcnMgY291bGQgZmlsbCB0aGUgc3BhY2UgaXMgZnJvbSBCUEYgSklULiBVbmxl
c3MgeW91IHNlZSBhbm90aGVyIHB1cnBvc2UgbG9uZw0KdGVybT8NCg0KUmljaw0K
