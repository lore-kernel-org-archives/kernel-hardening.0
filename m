From: "Perla, Enrico" <enrico.perla@intel.com>
Subject: RE: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon
 system call
Date: Thu, 21 Feb 2019 09:35:43 +0000
Message-ID: <5E269FBC3009974381A340959F3135C95C8FE7E1@hasmsx108.ger.corp.intel.com>
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com>
 <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
 <20190208130544.GI32511@hirez.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612BA4BB7580@IRSMSX102.ger.corp.intel.com>
 <20190208142642.GJ32511@hirez.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612BA4BB96C5@IRSMSX102.ger.corp.intel.com>
 <CALCETrXA8PBtu6B5z5gjJV4X_pe16f4DE7T5o5AspgMckBRWKA@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612BA4BBA73C@IRSMSX102.ger.corp.intel.com>
 <EBF96DB2-B25D-437B-A067-F187E031BC3E@amacapital.net>
 <5E269FBC3009974381A340959F3135C95C8F78E5@hasmsx108.ger.corp.intel.com>
 <CAGXu5jJSWf=CAij3_dxA9+n6+fWtt1MOT3dWD07vdkhrfC8bpQ@mail.gmail.com>
In-Reply-To: <CAGXu5jJSWf=CAij3_dxA9+n6+fWtt1MOT3dWD07vdkhrfC8bpQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, "Reshetova, Elena" <elena.reshetova@intel.com>, Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "tytso@mit.edu" <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>

DQo+IA0KPiBJdCBkb2VzIHNlZW0gdGhhdCB1c2luZyBhIGZsYXcgdG8gYXR0YWNrIG9uZSdzIG93
biByZWdpc3RlcnMgaXMgcmF0aGVyDQo+IHBvaW50bGVzcy4gTWF5YmUgd2UnbGwgZWF0IG91ciB3
b3JkcywgYnV0IGZvciBub3csIEknZCBhZ3JlZS4NCj4gDQoNCllvdSBkb24ndCBhdHRhY2sgeW91
ciBvd24gcmVnaXN0ZXJzLCB5b3UgdXNlIHRoZW0gdG8gbG9hZCBjb250cm9sbGVkIGRhdGEgdG8g
dGhlIGtlcm5lbCBhbmQgZW11bGF0ZSBzdHJ1Y3R1cmVzIG9yIHNpbWlsYXIgYXQgYW55IHN0YWdl
IG9mIGFuIGV4cGxvaXQsIGJ5cGFzc2luZyBTTUFQIGFuZCBjby4NCi0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpJTlRF
TCBDT1JQT1JBVElPTiBJVEFMSUEgUy5wLkEuIGNvbiB1bmljbyBzb2NpbwpTZWRlOiBNaWxhbm9m
aW9yaSBQYWxhenpvIEUgNCAKQ0FQIDIwMDk0IEFzc2FnbyAoTUkpCkNhcGl0YWxlIFNvY2lhbGUg
RXVybyAxMDQuMDAwLDAwIGludGVyYW1lbnRlIHZlcnNhdG8KUGFydGl0YSBJLlYuQS4gZSBDb2Rp
Y2UgRmlzY2FsZSAgMDQyMzY3NjAxNTUKUmVwZXJ0b3JpbyBFY29ub21pY28gQW1taW5pc3RyYXRp
dm8gbi4gOTk3MTI0IApSZWdpc3RybyBkZWxsZSBJbXByZXNlIGRpIE1pbGFubyBuci4gMTgzOTgz
LzUyODEvMzMKU29nZ2V0dGEgYWQgYXR0aXZpdGEnIGRpIGRpcmV6aW9uZSBlIGNvb3JkaW5hbWVu
dG8gZGkgCklOVEVMIENPUlBPUkFUSU9OLCBVU0EKClRoaXMgZS1tYWlsIGFuZCBhbnkgYXR0YWNo
bWVudHMgbWF5IGNvbnRhaW4gY29uZmlkZW50aWFsIG1hdGVyaWFsIGZvcgp0aGUgc29sZSB1c2Ug
b2YgdGhlIGludGVuZGVkIHJlY2lwaWVudChzKS4gQW55IHJldmlldyBvciBkaXN0cmlidXRpb24K
Ynkgb3RoZXJzIGlzIHN0cmljdGx5IHByb2hpYml0ZWQuIElmIHlvdSBhcmUgbm90IHRoZSBpbnRl
bmRlZApyZWNpcGllbnQsIHBsZWFzZSBjb250YWN0IHRoZSBzZW5kZXIgYW5kIGRlbGV0ZSBhbGwg
Y29waWVzLgo=
