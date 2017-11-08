MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <ec5a3690-a8c2-0329-66c0-ed7dda5db958@redhat.com>
References: <1510050731-32446-1-git-send-email-me@tobin.cc> <ec5a3690-a8c2-0329-66c0-ed7dda5db958@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Nov 2017 16:59:56 -0800
Message-ID: <CA+55aFwiaQezaPi2nzmyuFZNgR3PFcsWjjBTHJYBesKrh-Q_pQ@mail.gmail.com>
Content-Type: multipart/mixed; boundary="001a1142249ccdcbf1055d6e3441"
Subject: Re: [kernel-hardening] [PATCH v4] scripts: add leaking_addresses.pl
To: Laura Abbott <labbott@redhat.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

--001a1142249ccdcbf1055d6e3441
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 7, 2017 at 3:36 PM, Laura Abbott <labbott@redhat.com> wrote:
>
> I'd probably put /proc/kallsyms and /proc/modules on the omit list
> since those are designed to leak addresses to userspace.

Well, they are indeed designed to leak addresses, but not a lot of
people should care.

So I think we could tighten them up.

For example, maybe /proc/kallsyms could just default to not showing
values to non-root users.

We *did* originally try to use "kptr_restrict" with a default value of
1, it's just that it was never fixable on a case-by-case basis as
people started saying "that breaks my flow, because xyz".

But if we do it for one file at a time, we probably *can* try to fix complaints.

Something like the attached TOTALLY UNTESTED patch. It's meant more as
an RFC, not for application, but it's also meant to show how we can
tailor the behavior for specific workflow issues.

So take that "kallsyms_for_perf()" thing as an example of how we can
say "hey, if you already have access to kernel profiling anyway,
there's no point in hiding kallsyms".

And there may be other similar things we can do.

The situation with /proc/modules should be similar. Using
kptr_restrict was a big hammer and might have broken something
unrelated, but did anybody actually care about the particular case of
/proc/modules not showing the module address to normal users? probably
not. "lsmod" certainly doesn't care, and that's what people really
want.

Both /proc/kallsyms and /proc/modules _used_ to be really important
for oops reporting, but that was long ago when the kernel didn't
report symbol information of its own. So we have historical reasons
for people to be able to read those files, but those are mainly things
that aren't relevant (or even possible) on modern kernels anyway.

So I don'r think we should omit /proc/kallsyms and /proc/modules - we
should just fix them.

The attached patch may not be good enough as is, but maybe something
_like_ it will work well enough that people won't care?

(And do note the "TOTALLY UNTESTED". It seems to compile. But maybe I
got some test exactly the wrong way around and it doesn't actually
_work_. Caveat testor).

                     Linus

--001a1142249ccdcbf1055d6e3441
Content-Type: text/plain; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j9qc6x920

IGtlcm5lbC9rYWxsc3ltcy5jIHwgNDkgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKystLQogMSBmaWxlIGNoYW5nZWQsIDQ3IGluc2VydGlvbnMoKyksIDIgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL2thbGxzeW1zLmMgYi9rZXJuZWwva2FsbHN5
bXMuYwppbmRleCAxMjdlN2NmYWZhNTUuLjViMTI5OWMxZTRiMCAxMDA2NDQKLS0tIGEva2VybmVs
L2thbGxzeW1zLmMKKysrIGIva2VybmVsL2thbGxzeW1zLmMKQEAgLTQ4MCw2ICs0ODAsNyBAQCBz
dHJ1Y3Qga2FsbHN5bV9pdGVyIHsKIAljaGFyIG5hbWVbS1NZTV9OQU1FX0xFTl07CiAJY2hhciBt
b2R1bGVfbmFtZVtNT0RVTEVfTkFNRV9MRU5dOwogCWludCBleHBvcnRlZDsKKwlpbnQgc2hvd192
YWx1ZTsKIH07CiAKIHN0YXRpYyBpbnQgZ2V0X2tzeW1ib2xfbW9kKHN0cnVjdCBrYWxsc3ltX2l0
ZXIgKml0ZXIpCkBAIC01ODAsMTQgKzU4MSwyMyBAQCBzdGF0aWMgdm9pZCBzX3N0b3Aoc3RydWN0
IHNlcV9maWxlICptLCB2b2lkICpwKQogewogfQogCisjaWZuZGVmIENPTkZJR182NEJJVAorIyBk
ZWZpbmUgS0FMTFNZTV9GTVQgIiUwOGx4IgorI2Vsc2UKKyMgZGVmaW5lIEtBTExTWU1fRk1UICIl
MDE2bHgiCisjZW5kaWYKKwogc3RhdGljIGludCBzX3Nob3coc3RydWN0IHNlcV9maWxlICptLCB2
b2lkICpwKQogeworCXVuc2lnbmVkIGxvbmcgdmFsdWU7CiAJc3RydWN0IGthbGxzeW1faXRlciAq
aXRlciA9IG0tPnByaXZhdGU7CiAKIAkvKiBTb21lIGRlYnVnZ2luZyBzeW1ib2xzIGhhdmUgbm8g
bmFtZS4gIElnbm9yZSB0aGVtLiAqLwogCWlmICghaXRlci0+bmFtZVswXSkKIAkJcmV0dXJuIDA7
CiAKKwl2YWx1ZSA9IGl0ZXItPnNob3dfdmFsdWUgPyBpdGVyLT52YWx1ZSA6IDA7CisKIAlpZiAo
aXRlci0+bW9kdWxlX25hbWVbMF0pIHsKIAkJY2hhciB0eXBlOwogCkBAIC01OTcsMTAgKzYwNywx
MCBAQCBzdGF0aWMgaW50IHNfc2hvdyhzdHJ1Y3Qgc2VxX2ZpbGUgKm0sIHZvaWQgKnApCiAJCSAq
LwogCQl0eXBlID0gaXRlci0+ZXhwb3J0ZWQgPyB0b3VwcGVyKGl0ZXItPnR5cGUpIDoKIAkJCQkJ
dG9sb3dlcihpdGVyLT50eXBlKTsKLQkJc2VxX3ByaW50ZihtLCAiJXBLICVjICVzXHRbJXNdXG4i
LCAodm9pZCAqKWl0ZXItPnZhbHVlLAorCQlzZXFfcHJpbnRmKG0sIEtBTExTWU1fRk1UICIgJWMg
JXNcdFslc11cbiIsIHZhbHVlLAogCQkJICAgdHlwZSwgaXRlci0+bmFtZSwgaXRlci0+bW9kdWxl
X25hbWUpOwogCX0gZWxzZQotCQlzZXFfcHJpbnRmKG0sICIlcEsgJWMgJXNcbiIsICh2b2lkICop
aXRlci0+dmFsdWUsCisJCXNlcV9wcmludGYobSwgS0FMTFNZTV9GTVQgIiAlYyAlc1xuIiwgdmFs
dWUsCiAJCQkgICBpdGVyLT50eXBlLCBpdGVyLT5uYW1lKTsKIAlyZXR1cm4gMDsKIH0KQEAgLTYx
Miw2ICs2MjIsNDAgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBzZXFfb3BlcmF0aW9ucyBrYWxsc3lt
c19vcCA9IHsKIAkuc2hvdyA9IHNfc2hvdwogfTsKIAorc3RhdGljIGlubGluZSBpbnQga2FsbHN5
bXNfZm9yX3BlcmYodm9pZCkKK3sKKyNpZmRlZiBDT05GSUdfUEVSRl9FVkVOVFMKKwlleHRlcm4g
aW50IHN5c2N0bF9wZXJmX2V2ZW50X3BhcmFub2lkOworCWlmIChzeXNjdGxfcGVyZl9ldmVudF9w
YXJhbm9pZCA8PSAwKQorCQlyZXR1cm4gMTsKKyNlbmRpZgorCXJldHVybiAwOworfQorCisvKgor
ICogV2Ugc2hvdyBrYWxsc3ltcyBpbmZvcm1hdGlvbiBldmVuIHRvIG5vcm1hbCB1c2VycyBpZiB3
ZSd2ZSBlbmFibGVkCisgKiBrZXJuZWwgcHJvZmlsaW5nIGFuZCBhcmUgZXhwbGljaXRseSBub3Qg
cGFyYW5vaWQgKHNvIGtwdHJfcmVzdHJpY3QKKyAqIGlzIGNsZWFyLCBhbmQgc3lzY3RsX3BlcmZf
ZXZlbnRfcGFyYW5vaWQgaXNuJ3Qgc2V0KS4KKyAqCisgKiBPdGhlcndpc2UsIHJlcXVpcmUgQ0FQ
X1NZU0xPRyAoYXNzdW1pbmcga3B0cl9yZXN0cmljdCBpc24ndCBzZXQgdG8KKyAqIGJsb2NrIGV2
ZW4gdGhhdCkuCisgKi8KK3N0YXRpYyBpbnQga2FsbHN5bXNfc2hvd192YWx1ZSh2b2lkKQorewor
CXN3aXRjaCAoa3B0cl9yZXN0cmljdCkgeworCWNhc2UgMDoKKwkJaWYgKGthbGxzeW1zX2Zvcl9w
ZXJmKCkpCisJCQlyZXR1cm4gMTsKKwkvKiBmYWxsdGhyb3VnaCAqLworCWNhc2UgMToKKwkJaWYg
KGhhc19jYXBhYmlsaXR5X25vYXVkaXQoY3VycmVudCwgQ0FQX1NZU0xPRykpCisJCQlyZXR1cm4g
MTsKKwkvKiBmYWxsdGhyb3VnaCAqLworCWRlZmF1bHQ6CisJCXJldHVybiAwOworCX0KK30KKwog
c3RhdGljIGludCBrYWxsc3ltc19vcGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxl
ICpmaWxlKQogewogCS8qCkBAIC02MjUsNiArNjY5LDcgQEAgc3RhdGljIGludCBrYWxsc3ltc19v
cGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQogCQlyZXR1cm4gLUVO
T01FTTsKIAlyZXNldF9pdGVyKGl0ZXIsIDApOwogCisJaXRlci0+c2hvd192YWx1ZSA9IGthbGxz
eW1zX3Nob3dfdmFsdWUoKTsKIAlyZXR1cm4gMDsKIH0KIAo=
--001a1142249ccdcbf1055d6e3441--
