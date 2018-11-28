From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] x86/fpu: XRSTOR is expected to raise #GP
Date: Wed, 28 Nov 2018 15:27:28 +0000
Message-ID: <52276fe27116406eb601a99704459f80@AcuMS.aculab.com>
References: <20181126172706.184008-1-jannh@google.com>
 <20181126174945.r2ubrlg2gzwog2ez@linutronix.de>
 <4d4c4f1f-72e3-0182-151e-8bd455ccd143@zytor.com>
In-Reply-To: <4d4c4f1f-72e3-0182-151e-8bd455ccd143@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
To: "'H. Peter Anvin'" <hpa@zytor.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Jann Horn <jannh@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

RnJvbTogSC4gUGV0ZXIgQW52aW4NCj4gU2VudDogMjYgTm92ZW1iZXIgMjAxOCAxOTo1MA0KPiBP
biAxMS8yNi8xOCA5OjQ5IEFNLCBTZWJhc3RpYW4gQW5kcnplaiBTaWV3aW9yIHdyb3RlOg0KPiA+
IE9uIDIwMTgtMTEtMjYgMTg6Mjc6MDYgWyswMTAwXSwgSmFubiBIb3JuIHdyb3RlOg0KPiA+PiBj
b21taXQgNzUwNDVmNzdmN2E3ICgieDg2L2V4dGFibGU6IEludHJvZHVjZSBfQVNNX0VYVEFCTEVf
VUEgZm9yIHVhY2Nlc3MNCj4gPj4gZml4dXBzIikgaW5jb3JyZWN0bHkgcmVwbGFjZWQgdGhlIGZp
eHVwIGVudHJ5IGZvciBYU1RBVEVfT1Agd2l0aCBhDQo+ID4+IHVzZXItI1BGLW9ubHkgZml4dXAu
IEhvd2V2ZXIsIFhSU1RPUiBjYW4gYWxzbyByYWlzZSAjR1Agd2hlbiB0aGUgc3VwcGxpZWQNCj4g
Pj4gYWRkcmVzcyBwb2ludHMgdG8gdXNlcnNwYWNlIG1lbW9yeS4gQ2hhbmdlIGl0IGJhY2suDQo+
ID4NCj4gPiBUaGUgI0dQIGlzIHJhaXNlZCBpZiB0aGUgeHN0YXRlIGNvbnRlbnQgaXMgaW52YWxp
ZC4gQnV0IEkgZ3Vlc3MgdGhlDQo+ID4gZGV0YWlscyBkb24ndCBtYXR0ZXIuDQo+ID4NCj4gPj4g
UmVwb3J0ZWQtYnk6IFNlYmFzdGlhbiBBbmRyemVqIFNpZXdpb3IgPGJpZ2Vhc3lAbGludXRyb25p
eC5kZT4NCj4gPj4gRml4ZXM6IDc1MDQ1Zjc3ZjdhNyAoIng4Ni9leHRhYmxlOiBJbnRyb2R1Y2Ug
X0FTTV9FWFRBQkxFX1VBIGZvciB1YWNjZXNzIGZpeHVwcyIpDQo+ID4+IFNpZ25lZC1vZmYtYnk6
IEphbm4gSG9ybiA8amFubmhAZ29vZ2xlLmNvbT4NCj4gPiBBY2tlZC1ieTogU2ViYXN0aWFuIEFu
ZHJ6ZWogU2lld2lvciA8YmlnZWFzeUBsaW51dHJvbml4LmRlPg0KPiA+DQo+IA0KPiBJdCBkb2Vz
IG1hdHRlciAtLSBwbGVhc2UgY29ycmVjdCB0aGUgcGF0Y2ggZGVzY3JpcHRpb24sIG9yIHdlIG1p
Z2h0IGhhdmUgc29tZQ0KPiBzZXJpb3VzIGNvbmZ1c2lvbiBhdCBzb21lIGFyYml0cmFyeSBwb2lu
dCBpbiB0aGUgZnV0dXJlIHdpdGggdGhlIHJlc3VsdCB0aGF0DQo+IHRoZSBidWcgZ2V0cyByZS1p
bnRyb2R1Y2VkOyBpdCB3b3VsZCBub3QgYmUgdGhlIGZpcnN0IHRpbWUuDQoNCkJldHRlciBzdGls
bCBub3RlIGl0IGluIHRoZSBjb2RlLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNz
IExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAx
UFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K
