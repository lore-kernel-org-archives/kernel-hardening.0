From: Nadav Amit <namit@vmware.com>
Subject: Re: [PATCH 01/17] Fix "x86/alternatives: Lockdep-enforce text_mutex
 in text_poke*()"
Date: Fri, 25 Jan 2019 18:28:04 +0000
Message-ID: <BEFCBDFB-F08F-441D-8BCC-07E5F448D9D2@vmware.com>
References: <20190117003259.23141-1-rick.p.edgecombe@intel.com>
 <20190117003259.23141-2-rick.p.edgecombe@intel.com>
 <20190125093052.GA27998@zn.tnic>
In-Reply-To: <20190125093052.GA27998@zn.tnic>
Content-Type: text/plain; charset="utf-8"
Content-ID: <40B2A33442F0754AA96DF64BE91FBD02@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "kristen@linux.intel.com" <kristen@linux.intel.com>, "deneen.t.dock@intel.com" <deneen.t.dock@intel.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

PiBPbiBKYW4gMjUsIDIwMTksIGF0IDE6MzAgQU0sIEJvcmlzbGF2IFBldGtvdiA8YnBAYWxpZW44
LmRlPiB3cm90ZToNCj4gDQo+IE9uIFdlZCwgSmFuIDE2LCAyMDE5IGF0IDA0OjMyOjQzUE0gLTA4
MDAsIFJpY2sgRWRnZWNvbWJlIHdyb3RlOg0KPj4gRnJvbTogTmFkYXYgQW1pdCA8bmFtaXRAdm13
YXJlLmNvbT4NCj4+IA0KPj4gdGV4dF9tdXRleCBpcyBjdXJyZW50bHkgZXhwZWN0ZWQgdG8gYmUg
aGVsZCBiZWZvcmUgdGV4dF9wb2tlKCkgaXMNCj4+IGNhbGxlZCwgYnV0IHdlIGtnZGIgZG9lcyBu
b3QgdGFrZSB0aGUgbXV0ZXgsIGFuZCBpbnN0ZWFkICpzdXBwb3NlZGx5Kg0KPj4gZW5zdXJlcyB0
aGUgbG9jayBpcyBub3QgdGFrZW4gYW5kIHdpbGwgbm90IGJlIGFjcXVpcmVkIGJ5IGFueSBvdGhl
ciBjb3JlDQo+PiB3aGlsZSB0ZXh0X3Bva2UoKSBpcyBydW5uaW5nLg0KPj4gDQo+PiBUaGUgcmVh
c29uIGZvciB0aGUgInN1cHBvc2VkbHkiIGNvbW1lbnQgaXMgdGhhdCBpdCBpcyBub3QgZW50aXJl
bHkgY2xlYXINCj4+IHRoYXQgdGhpcyB3b3VsZCBiZSB0aGUgY2FzZSBpZiBnZGJfZG9fcm91bmR1
cCBpcyB6ZXJvLg0KPiANCj4gSSBndWVzcyB0aGF0IHZhcmlhYmxlIG5hbWUgaXMgImtnZGJfZG9f
cm91bmR1cOKAnSA/DQoNClllcy4gV2lsbCBmaXguDQoNCj4gDQo+PiBUaGlzIHBhdGNoIGNyZWF0
ZXMgdHdvIHdyYXBwZXIgZnVuY3Rpb25zLCB0ZXh0X3Bva2UoKSBhbmQNCj4gDQo+IEF2b2lkIGhh
dmluZyAiVGhpcyBwYXRjaCIgb3IgIlRoaXMgY29tbWl0IiBpbiB0aGUgY29tbWl0IG1lc3NhZ2Uu
IEl0IGlzDQo+IHRhdXRvbG9naWNhbGx5IHVzZWxlc3MuDQo+IA0KPiBBbHNvLCBkbw0KPiANCj4g
JCBnaXQgZ3JlcCAnVGhpcyBwYXRjaCcgRG9jdW1lbnRhdGlvbi9wcm9jZXNzDQo+IA0KPiBmb3Ig
bW9yZSBkZXRhaWxzLg0KDQpPay4NCg0KPj4gDQo+PiArdm9pZCAqdGV4dF9wb2tlX2tnZGIodm9p
ZCAqYWRkciwgY29uc3Qgdm9pZCAqb3Bjb2RlLCBzaXplX3QgbGVuKQ0KPiANCj4gdGV4dF9wb2tl
X3VubG9ja2VkKCkgSSBndWVzcy4gSSBkb24ndCB0aGluayBrZ2RiIGlzIHRoYXQgc3BlY2lhbCB0
aGF0IGl0DQo+IG5lZWRzIGl0cyBvd24gZnVuY3Rpb24gZmxhdm9yLg0KDQpUZ2x4IHN1Z2dlc3Rl
ZCB0aGlzIG5hbWluZyB0byBwcmV2ZW50IGFueW9uZSBmcm9tIG1pc3VzaW5nIHRleHRfcG9rZV9r
ZGdiKCkuDQpUaGlzIGlzIGEgdmVyeSBzcGVjaWZpYyB1c2UtY2FzZSB0aGF0IG5vYm9keSBlbHNl
IHNob3VsZCBuZWVkLg0KDQpSZWdhcmRzLA0KTmFkYXY=
