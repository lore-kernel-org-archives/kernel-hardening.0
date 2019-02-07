From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 16/17] Plug in new special vfree flag
Date: Thu, 7 Feb 2019 18:20:45 +0000
Message-ID: <e71683c86dbe1b32fcec5cc708e8773e72242519.camel@intel.com>
References: <20190117003259.23141-1-rick.p.edgecombe@intel.com>
	 <20190117003259.23141-17-rick.p.edgecombe@intel.com>
	 <20190206112356.64cc5f0d@gandalf.local.home>
	 <16a2ac45ceef5b6f310f816d696ad2ea8df3b45c.camel@intel.com>
	 <20190207124949.0ea219a7@gandalf.local.home>
In-Reply-To: <20190207124949.0ea219a7@gandalf.local.home>
Content-Type: text/plain; charset="utf-8"
Content-ID: <04CF8A361999FE4C8001D62D362CA687@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "peterz@infradead.org" <peterz@infradead.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, "jeyu@kernel.org" <jeyu@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "nadav.amit@gmail.com" <nadav.amit@gmail.com>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "kristen@linux.intel.com" <kristen@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, "linux_dti@icloud.com" <linux_dti@icloud.com>, "luto@kernel.org" <luto@kernel.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "bp@alien8.de" <bp@alien8.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "mhiramat@kernel.org" <mhiramat@kernel.org>, "ast@kernel.org" <ast@kernel.org>, "paulmck@linux.ibm.com" <paulmck@linux.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

T24gVGh1LCAyMDE5LTAyLTA3IGF0IDEyOjQ5IC0wNTAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gT24gVGh1LCA3IEZlYiAyMDE5IDE3OjMzOjM3ICswMDAwDQo+ICJFZGdlY29tYmUsIFJpY2sg
UCIgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+IA0KPiA+ID4gPiAt
LS0NCj4gPiA+ID4gIGFyY2gveDg2L2tlcm5lbC9mdHJhY2UuYyAgICAgICB8ICA2ICstLSAgDQo+
ID4gPiANCj4gPiA+IEZvciB0aGUgZnRyYWNlIGNvZGUuDQo+ID4gPiANCj4gPiA+IEFja2VkLWJ5
OiBTdGV2ZW4gUm9zdGVkdCAoVk13YXJlKSA8cm9zdGVkdEBnb29kbWlzLm9yZz4NCj4gPiA+IA0K
PiA+ID4gLS0gU3RldmUNCj4gPiA+ICAgDQo+ID4gDQo+ID4gVGhhbmtzIQ0KPiANCj4gSSBqdXN0
IG5vdGljZWQgdGhhdCB0aGUgc3ViamVjdCBpcyBpbmNvcnJlY3Q7IEl0IGlzIG1pc3NpbmcgdGhl
DQo+ICJzdWJzeXN0ZW06IiBwYXJ0LiBTZWUgRG9jdW1lbnRhdGlvbi9wcm9jZXNzL3N1Ym1pdHRp
bmctcGF0Y2hlcy5yc3QNCj4gDQo+IC0tIFN0ZXZlDQpTb3JyeSBhYm91dCB0aGF0LiBUaGVyZSBp
cyBhY3R1YWxseSB2MiBvZiB0aGlzIHBhdGNoc2V0IG91dCB0aGVyZSwgd2hlcmUgdGhlcmUNCmFy
ZSBubyBjb2RlIGNoYW5nZXMgZm9yIHRoaXMgcGF0Y2gsIGJ1dCBpdCBpcyBzcGxpdCBpbnRvIHNl
cGFyYXRlIHBhdGNoZXMgZm9yDQplYWNoIHN1YnN5c3RlbS4gSXQgaGFzICJ4ODYvZnRyYWNlOiAi
IGZvciB0aGUgZnRyYWNlIHBhdGNoLg0KDQpSaWNrDQo=
