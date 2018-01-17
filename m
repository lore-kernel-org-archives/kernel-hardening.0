From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 17 Jan 2018 10:07:05 +0000
Message-ID: <0afda538622440fab6682c8d4bff6d9d@AcuMS.aculab.com>
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzoAR+MYX+ub0xZ32OsT7WtD5Kru2t6LhwB1buLWPResQ@mail.gmail.com>
 <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
 <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com>
 <CAPcyv4g94iysWqz64KNk=HDdx6+b2e0O-rRrnFZDqfNSR3Xrjg@mail.gmail.com>
 <20180117062800.GU13338@ZenIV.linux.org.uk>
 <CAPcyv4jn6xHNB2DevoFEzkfpnKCd7u8UdA+TmVPtbO08TjzFWA@mail.gmail.com>
In-Reply-To: <CAPcyv4jn6xHNB2DevoFEzkfpnKCd7u8UdA+TmVPtbO08TjzFWA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH v3 8/9] x86: use __uaccess_begin_nospec and ASM_IFENCE in
 get_user paths
To: 'Dan Williams' <dan.j.williams@intel.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

RnJvbTogRGFuIFdpbGxpYW1zDQo+IFNlbnQ6IDE3IEphbnVhcnkgMjAxOCAwNjo1MA0KLi4uDQo+
ID4gQW55dGhpbmcgdGhhdCBvcGVuLWNvZGVzIGNvcHlfZnJvbV91c2VyKCkgdGhhdCB3YXkgaXMg
KkFMUkVBRFkqIGZ1Y2tlZCBpZg0KPiA+IGl0IGNhcmVzIGFib3V0IHRoZSBvdmVyaGVhZCAtIHJl
Y2VudCB4ODYgYm94ZW4gd2lsbCBoYXZlIHNsb3dkb3duIGZyb20NCj4gPiBoZWxsIG9uIHN0YWMo
KS9jbGFjKCkgcGFpcnMuICBBbnl0aGluZyBsaWtlIHRoYXQgb24gYSBob3QgcGF0aCBpcyBhbHJl
YWR5DQo+ID4gZGVlcCBpbiB0cm91YmxlIGFuZCBuZWVkcyB0byBiZSBmb3VuZCBhbmQgZml4ZWQu
ICBXaGF0IGRyaXZlcnMgd291bGQgdGhvc2UNCj4gPiBiZT8NCj4gDQo+IFNvIEkgdG9vayBhIGNs
b3NlciBsb29rIGFuZCB0aGUgcGF0dGVybiBpcyBub3QgY29weV9mcm9tX3VzZXIgaXQncw0KPiBt
b3JlIGxpa2UgX19nZXRfdXNlciArIHdyaXRlLXRvLWhhcmR3YXJlIGxvb3BzLiBJZiB0aGUgcGVy
Zm9ybWFuY2UgaXMNCj4gYWxyZWFkeSBleHBlY3RlZCB0byBiZSBiYWQgZm9yIHRob3NlIHRoZW4g
cGVyaGFwcyBhbiBsZmVuY2UgZWFjaCBsb29wDQo+IGl0ZXJhdGlvbiB3b24ndCBiZSBtdWNoIHdv
cnNlLiBJdCdzIHN0aWxsIGEgd2FzdGUgYmVjYXVzZSB0aGUgbGZlbmNlDQo+IGlzIG9ubHkgbmVl
ZGVkIG9uY2UgYWZ0ZXIgdGhlIGFjY2Vzc19vay4NCg0KUGVyZm9ybWFuY2Ugb2YgUENJZSB3cml0
ZXMgaXNuJ3QgdGhhdCBiYWNrIChzaW5jZSB0aGV5IGFyZSBwb3N0ZWQpDQphZGRpbmcgYSBzeW5j
aHJvbmlzaW5nIGluc3RydWN0aW9ucyB0byBfX2dldF91c2VyKCkgY291bGQgZWFzaWx5DQpiZSBu
b3RpY2VhYmxlLg0KDQpVbmZvcnR1bmF0ZWx5IHlvdSBjYW4ndCB1c2UgY29weV9mcm9tX3VzZXIo
KSB3aXRoIGEgUENJZSBtYXBwZWQNCnRhcmdldCBtZW1vcnkgYWRkcmVzcyAob3IgZXZlbiBtZW1j
cHlfdG9faW8oKSkgYmVjYXVzZSBvbiB4ODYNCnRoZSBjb3B5IGlzIGFsaWFzZWQgdG8gbWVtY3B5
KCkgYW5kIHRoYXQgdXNlcyAncmVwIG1vdnNiJw0Kd2hpY2ggaGFzIHRvIGRvIHNpbmdsZSBieXRl
IHRyYW5zZmVycyBiZWNhdXNlIHRoZSBhZGRyZXNzIGlzDQp1bmNhY2hlZC4NCihUaGlzIGlzIHJl
YWxseSBiYWQgZm9yIFBDSWUgcmVhZHMuKQ0KDQoJRGF2aWQNCg0KDQo=
