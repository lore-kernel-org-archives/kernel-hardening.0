Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110803113033.1c3c6960@taxman.wild-wind.fr.eu.org>
References: <20110801180151.GA26686@albatros> <20110801112021.25ec9041.akpm@linux-foundation.org>
 <20110801190341.GA6898@albatros> <CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
 <20110802124530.GA2543@albatros> <20110802135512.b49c9de1.akpm@linux-foundation.org>
 <d844457bba74be419d2434c533fdb4e1@localhost> <CA+55aFx+JOeDoNzs+1wfdK3kpNPyS9wpU1OT=VAwvWPXfMVuDQ@mail.gmail.com>
 <20110803113033.1c3c6960@taxman.wild-wind.fr.eu.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Aug 2011 14:35:09 -1000
Message-ID: <CA+55aFzw-K6XvDzTwHRyqQWdkDO8Zqz8Ak1qgNTzf6a3L9=80A@mail.gmail.com>
Content-Type: multipart/mixed; boundary=0016363ba58e618a9904a9a3282a
Subject: [kernel-hardening] Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vasiliy Kulikov <segoon@openwall.com>, Manuel Lauss <manuel.lauss@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Richard Weinberger <richard@nod.at>, Ingo Molnar <mingo@elte.hu>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Paul E. McKenney" <paul.mckenney@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

--0016363ba58e618a9904a9a3282a
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Aug 3, 2011 at 12:30 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>
> driver_init() is called from do_basic_setup(), before any initcall...

Ok, thanks everybody. I think the proper fix is the attached patch.
It's crazy to have usermode helpers enabled early during boot when
init etc haven't even been set up.

So does this finally fix the problem (I realize that there are other
patches floating around that *also* fix it, so please test this
without those other patches).

I'm planning on also applying the patch that optimizes the case of no
shm attaches, which would also hide the oops, but I think this
attached patch is the RightThing(tm).

                   Linus

--0016363ba58e618a9904a9a3282a
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqwzt7ba0

IGluaXQvbWFpbi5jICAgfCAgICA1ICsrKystCiBrZXJuZWwva21vZC5jIHwgICAgMiArLQogMiBm
aWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvaW5pdC9tYWluLmMgYi9pbml0L21haW4uYwppbmRleCAxOTUyZDM3ZTRlY2IuLjljNTFlZTdh
ZGYzZCAxMDA2NDQKLS0tIGEvaW5pdC9tYWluLmMKKysrIGIvaW5pdC9tYWluLmMKQEAgLTM2OSw5
ICszNjksMTIgQEAgc3RhdGljIG5vaW5saW5lIHZvaWQgX19pbml0X3JlZm9rIHJlc3RfaW5pdCh2
b2lkKQogCWluaXRfaWRsZV9ib290dXBfdGFzayhjdXJyZW50KTsKIAlwcmVlbXB0X2VuYWJsZV9u
b19yZXNjaGVkKCk7CiAJc2NoZWR1bGUoKTsKLQlwcmVlbXB0X2Rpc2FibGUoKTsKKworCS8qIEF0
IHRoaXMgcG9pbnQsIHdlIGNhbiBlbmFibGUgdXNlciBtb2RlIGhlbHBlciBmdW5jdGlvbmFsaXR5
ICovCisJdXNlcm1vZGVoZWxwZXJfZW5hYmxlKCk7CiAKIAkvKiBDYWxsIGludG8gY3B1X2lkbGUg
d2l0aCBwcmVlbXB0IGRpc2FibGVkICovCisJcHJlZW1wdF9kaXNhYmxlKCk7CiAJY3B1X2lkbGUo
KTsKIH0KIApkaWZmIC0tZ2l0IGEva2VybmVsL2ttb2QuYyBiL2tlcm5lbC9rbW9kLmMKaW5kZXgg
NDc2MTNkZmI3YjI4Li5kZGM3NjQ0YzEzMDUgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9rbW9kLmMKKysr
IGIva2VybmVsL2ttb2QuYwpAQCAtMjc0LDcgKzI3NCw3IEBAIHN0YXRpYyB2b2lkIF9fY2FsbF91
c2VybW9kZWhlbHBlcihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAgKiAodXNlZCBmb3IgcHJl
dmVudGluZyB1c2VyIGxhbmQgcHJvY2Vzc2VzIGZyb20gYmVpbmcgY3JlYXRlZCBhZnRlciB0aGUg
dXNlcgogICogbGFuZCBoYXMgYmVlbiBmcm96ZW4gZHVyaW5nIGEgc3lzdGVtLXdpZGUgaGliZXJu
YXRpb24gb3Igc3VzcGVuZCBvcGVyYXRpb24pLgogICovCi1zdGF0aWMgaW50IHVzZXJtb2RlaGVs
cGVyX2Rpc2FibGVkOworc3RhdGljIGludCB1c2VybW9kZWhlbHBlcl9kaXNhYmxlZCA9IDE7CiAK
IC8qIE51bWJlciBvZiBoZWxwZXJzIHJ1bm5pbmcgKi8KIHN0YXRpYyBhdG9taWNfdCBydW5uaW5n
X2hlbHBlcnMgPSBBVE9NSUNfSU5JVCgwKTsK
--0016363ba58e618a9904a9a3282a--
