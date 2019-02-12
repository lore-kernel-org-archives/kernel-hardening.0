From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v2 13/20] Add set_alias_ function and x86 implementation
Date: Tue, 12 Feb 2019 00:01:37 +0000
Message-ID: <3c34b566afb814ae40665916a0834cdd52d548a2.camel@intel.com>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
	 <20190129003422.9328-14-rick.p.edgecombe@intel.com>
	 <20190211190925.GQ19618@zn.tnic>
	 <CALCETrX2AOTTZOQafZgOFxiQsFgdYHVaLonXTqTa3RUs5MPVUQ@mail.gmail.com>
In-Reply-To: <CALCETrX2AOTTZOQafZgOFxiQsFgdYHVaLonXTqTa3RUs5MPVUQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-ID: <787C9EEF34D39049AB332793C711E15A@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: "luto@kernel.org" <luto@kernel.org>, "bp@alien8.de" <bp@alien8.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nadav.amit@gmail.com" <nadav.amit@gmail.com>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "kristen@linux.intel.com" <kristen@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, "linux_dti@icloud.com" <linux_dti@icloud.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

T24gTW9uLCAyMDE5LTAyLTExIGF0IDE0OjU5IC0wODAwLCBBbmR5IEx1dG9taXJza2kgd3JvdGU6
DQo+IE9uIE1vbiwgRmViIDExLCAyMDE5IGF0IDExOjA5IEFNIEJvcmlzbGF2IFBldGtvdiA8YnBA
YWxpZW44LmRlPiB3cm90ZToNCj4gPiANCj4gPiBPbiBNb24sIEphbiAyOCwgMjAxOSBhdCAwNDoz
NDoxNVBNIC0wODAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToNCj4gPiA+IFRoaXMgYWRkcyB0d28g
bmV3IGZ1bmN0aW9ucyBzZXRfYWxpYXNfZGVmYXVsdF9ub2ZsdXNoIGFuZA0KPiA+IA0KPiA+IHMv
VGhpcyBhZGRzL0FkZC8NCj4gPiANCj4gPiA+IHNldF9hbGlhc19udl9ub2ZsdXNoIGZvciBzZXR0
aW5nIHRoZSBhbGlhcyBtYXBwaW5nIGZvciB0aGUgcGFnZSB0byBpdHMNCj4gPiANCj4gPiBQbGVh
c2UgZW5kIGZ1bmN0aW9uIG5hbWVzIHdpdGggcGFyZW50aGVzZXMsIGJlbG93IHRvby4NCj4gPiAN
Cj4gPiA+IGRlZmF1bHQgdmFsaWQgcGVybWlzc2lvbnMgYW5kIHRvIGFuIGludmFsaWQgc3RhdGUg
dGhhdCBjYW5ub3QgYmUgY2FjaGVkIGluDQo+ID4gPiBhIFRMQiwgcmVzcGVjdGl2ZWx5LiBUaGVz
ZSBmdW5jdGlvbnMgdG8gbm90IGZsdXNoIHRoZSBUTEIuDQo+ID4gDQo+ID4gcy90by9kby8NCj4g
PiANCj4gPiBBbHNvLCBwbHMgcHV0IHRoYXQgZGVzY3JpcHRpb24gYXMgY29tbWVudHMgb3ZlciB0
aGUgZnVuY3Rpb25zIGluIHRoZQ0KPiA+IGNvZGUuIE90aGVyd2lzZSB0aGF0ICJudiIgYXMgcGFy
dCBvZiB0aGUgbmFtZSBkb2Vzbid0IHJlYWxseSBleHBsYWluDQo+ID4gd2hhdCBpdCBkb2VzLg0K
PiA+IA0KPiA+IEFjdHVhbGx5LCB5b3UgY291bGQganVzdCBhcyB3ZWxsIGNhbGwgdGhlIGZ1bmN0
aW9uDQo+ID4gDQo+ID4gc2V0X2FsaWFzX2ludmFsaWRfbm9mbHVzaCgpDQo+ID4gDQo+ID4gQWxs
IHRoZSBvdGhlciB3b3JkcyBhcmUgd3JpdHRlbiBpbiBmdWxsLCBubyBuZWVkIHRvIGhhdmUgIm52
IiB0aGVyZS4NCj4gDQo+IFdoeSBhcmUgeW91IGNhbGxpbmcgdGhpcyBhbiAiYWxpYXMiPyAgWW91
J3JlIG1vZGlmeWluZyB0aGUgZGlyZWN0IG1hcC4NCj4gWW91ciBwYXRjaGVzIGFyZSB0aGlua2lu
ZyBvZiB0aGUgZGlyZWN0IG1hcCBhcyBhbiBhbGlhcyBvZiB0aGUgdm1hcA0KPiBtYXBwaW5nLCBi
dXQgdGhhdCBkb2VzIHNlZW0gYSBiaXQgYmFja3dhcmRzLiAgSG93IGFib3V0DQo+IHNldF9kaXJl
Y3RfbWFwX2ludmFsaWRfbm9mbHVzaCgpLCBldGM/DQo+IA0KSSBwaWNrZWQgaXQgdXAgZnJvbSBz
b21lIG9mIHRoZSBuYW1lcyBpbiBhcmNoL3g4Ni9tbS9wYWdlYXR0ci5jOg0KQ1BBX05PX0NIRUNL
X0FMSUFTLCBzZXRfbWVtb3J5X25wX25vYWxpYXMoKSwgZXRjLiBJbiB0aGF0IGZpbGUgdGhlIGRp
cmVjdG1hcA0KYWRkcmVzcyBzZWVtcyB0byBiZSB0aGUgImFsaWFzIi4gRm9yIDMyIGJpdCB3aXRo
IGhpZ2htZW0gdGhvdWdoLCB0aGlzIHdvdWxkIGFsc28NCnNldCBwZXJtaXNzaW9ucyBmb3IgYSBr
bWFwIG1hcHBpbmcgYXMgd2VsbCAoaWYgb25lIGV4aXN0ZWQpLCBzaW5jZSB0aGF0IGFkZHJlc3MN
CndpbGwgYmUgcmV0dXJuZWQgZnJvbSBwYWdlX2FkZHJlc3MoKS4NCg0KWWVhLCBpbiB2bWFsbG9j
LCB2bV91bm1hcF9hbGlhc2VzIHRhbGtzIGFib3V0IHRoZSB2bWFwIGFkZHJlc3MgImFsaWFzIi4g
U28gSQ0KZ3Vlc3MgY2FsbGluZyBpdCAiYWxpYXMiIGlzIGFtYmlndW91cy4gQnV0IGRvZXMgc2V0
X2RpcmVjdF9tYXBfaW52YWxpZF9ub2ZsdXNoDQptYWtlIHNlbnNlIGluIHRoZSBoaWdobWVtIGNh
c2U/DQoNCkkgY291bGRuJ3QgdGhpbmsgb2YgYW55IG5hbWVzIHRoYXQgSSBsb3ZlZCwgd2hpY2gg
aXMgd2h5IEkgcmFuIHRoZQ0Kc2V0X2FsaWFzXypfbm9mbHVzaCBuYW1lcyBieSBwZW9wbGUgaW4g
YW4gZWFybGllciB2ZXJzaW9uLCBhbHRob3VnaCBsb29raW5nIGJhY2sNCm9ubHkgQXJkIGNoaW1l
ZCBpbiBvbiB0aGF0LiAic2V0X2RpcmVjdF9tYXBfaW52YWxpZF9ub2ZsdXNoIiBpcyBmaW5lIHdp
dGggbWUgaWYNCm5vYm9keSBvYmplY3RzLg0KDQpUaGFua3MsDQoNClJpY2sNCg==
