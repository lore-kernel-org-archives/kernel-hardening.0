MIME-Version: 1.0
In-Reply-To: <CA+55aFxLpdfyfTqhkHQoedQuqTcLRw3bYOgyz1s0eRW6cBmFTA@mail.gmail.com>
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
 <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com> <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
 <20180316175502.GE30522@ZenIV.linux.org.uk> <CA+55aFzsrVF7W+YQye=EeF4Wk3yDOTbb_vSiM8s1zkKbE4JV4Q@mail.gmail.com>
 <CANiq72mjDQWsPG60JqfuLSY-6SDzB4goP4n35XZxc8bfFx1NDg@mail.gmail.com> <CA+55aFxLpdfyfTqhkHQoedQuqTcLRw3bYOgyz1s0eRW6cBmFTA@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 17 Mar 2018 02:49:27 +0100
Message-ID: <CANiq72kNgO7indoEsVqZX8GuM9TyyiuVaS1OgFzvTVMX=5P-XA@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] Remove false-positive VLAs when using max()
Content-Type: multipart/mixed; boundary="001a1141ff069cb848056791f084"
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Florian Weimer <fweimer@redhat.com>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a1141ff069cb848056791f084
Content-Type: text/plain; charset="UTF-8"

On Fri, Mar 16, 2018 at 9:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Mar 16, 2018 at 1:03 PM, Miguel Ojeda
> <miguel.ojeda.sandonis@gmail.com> wrote:
>>>
>>> Kees - is there some online "gcc-4.4 checker" somewhere? This does
>>> seem to work with my gcc. I actually tested some of those files you
>>> pointed at now.
>>
>> I use this one:
>>
>>   https://godbolt.org/
>
> Well, my *test* code works on that one and -Wvla -Werror.
>
> It does not work with gcc-4.1.x, but works with gcc-4.4.x.
>
> I can't seem to see the errors any way, I wonder if
> __builtin_choose_expr() simply didn't exist back then.
>
> Odd that you can't view warnings/errors with it.
>
> But it's possible that it fails on more complex stuff in the kernel.
>
> I've done a "allmodconfig" build with that patch, and the only issue
> it found was that (real) type issue in tpm_tis_core.h.

Just tested your max() with a Python script I wrote yesterday to try a
lot of combinations for this thing. Your version gives some warnings
in some cases, like:

  warning: signed and unsigned type in conditional expression [-Wsign-compare]
   #define __cmp(a,b,op) ((a)op(b)?(a):(b))

  warning: comparison between signed and unsigned integer expressions
[-Wsign-compare]
   #define const_max(a,b)              __careful_cmp(a,b,>)

  warning: comparison of distinct pointer types lacks a cast
           (!!(sizeof((typeof(a)*)1==(typeof(b)*)1)))

But it fails on something like (with warnings):

  int a[const_max(-30, 60u)];

Sorry... :-(

Has anyone taken a look at the last one I sent? Patch attached with
the draft changes on the kernel. It compiles fine the cases Kees
cleaned up in the other patch, but also works without a explicit type,
for mixed types, and for both positive and negative values.

Cheers,
Miguel

--001a1141ff069cb848056791f084
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jeupkuuu0

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgva2VybmVsLmggYi9pbmNsdWRlL2xpbnV4L2tlcm5l
bC5oCmluZGV4IDNmZDI5MTUwMzU3Ni4uZjgzNjU4YTRmMTVkIDEwMDY0NAotLS0gYS9pbmNsdWRl
L2xpbnV4L2tlcm5lbC5oCisrKyBiL2luY2x1ZGUvbGludXgva2VybmVsLmgKQEAgLTgxOSw2ICs4
MTksNDkgQEAgc3RhdGljIGlubGluZSB2b2lkIGZ0cmFjZV9kdW1wKGVudW0gZnRyYWNlX2R1bXBf
bW9kZSBvb3BzX2R1bXBfbW9kZSkgeyB9CiAJICAgICAgX19VTklRVUVfSUQobWF4MV8pLCBfX1VO
SVFVRV9JRChtYXgyXyksCVwKIAkgICAgICB4LCB5KQogCitzaXplX3QgX19lcnJvcl9ub3RfY29u
c3RfYXJnKHZvaWQpIFwKK19fY29tcGlsZXRpbWVfZXJyb3IoImNvbnN0X21heCgpIHVzZWQgd2l0
aCBub24tY29tcGlsZS10aW1lIGNvbnN0YW50IGFyZyIpOworc2l6ZV90IF9fZXJyb3JfdG9vX2Jp
Zyh2b2lkKSBcCitfX2NvbXBpbGV0aW1lX2Vycm9yKCJjb25zdF9tYXgoKSB1c2VkIHdpdGggYW4g
YXJnIHRvbyBiaWciKTsKKworI2RlZmluZSBJTlRNQVhUX01BWCBMTE9OR19NQVgKK3R5cGVkZWYg
aW50NjRfdCBpbnRtYXhfdDsKKworI2RlZmluZSBjb25zdF9jbXAoeCwgeSwgb3ApICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwKKyAgICAgICAgX19idWlsdGluX2No
b29zZV9leHByKCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcCisgICAg
ICAgICAgICAgICAgIV9fYnVpbHRpbl9jb25zdGFudF9wKHgpIHx8ICFfX2J1aWx0aW5fY29uc3Rh
bnRfcCh5KSwgXAorICAgICAgICAgICAgICAgIF9fZXJyb3Jfbm90X2NvbnN0X2FyZygpLCAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIFwKKyAgICAgICAgICAgICAgICBfX2J1aWx0aW5fY2hv
b3NlX2V4cHIoICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcCisgICAgICAgICAgICAg
ICAgICAgICAgICAoeCkgPiBJTlRNQVhUX01BWCB8fCAoeSkgPiBJTlRNQVhUX01BWCwgICAgICAg
XAorICAgICAgICAgICAgICAgICAgICAgICAgX19lcnJvcl90b29fYmlnKCksICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIFwKKyAgICAgICAgICAgICAgICAgICAgICAgIF9fYnVpbHRpbl9jaG9v
c2VfZXhwciggICAgICAgICAgICAgICAgICAgICAgICBcCisgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIChpbnRtYXhfdCkoeCkgb3AgKGludG1heF90KSh5KSwgICAgICAgXAorICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAoeCksICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIFwKKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKHkpICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBcCisgICAgICAgICAgICAgICAgICAgICAgICApICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXAorICAgICAgICAgICAgICAg
ICkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwK
KyAgICAgICAgKQorCisvKioKKyAqIGNvbnN0X21pbiAtIHJldHVybnMgbWluaW11bSBvZiB0d28g
Y29tcGlsZS10aW1lIGNvbnN0YW50IHZhbHVlcworICogQHg6IGZpcnN0IGNvbXBpbGUtdGltZSBj
b25zdGFudCB2YWx1ZQorICogQHk6IHNlY29uZCBjb21waWxlLXRpbWUgY29uc3RhbnQgdmFsdWUK
KyAqCisgKiBUaGUgcmVzdWx0IGhhcyB0aGUgdHlwZSBvZiB0aGUgd2lubmVyIG9mIHRoZSBjb21w
YXJpc29uLiBXb3JrcyBmb3IgYW55CisgKiB2YWx1ZSB1cCB0byBMTE9OR19NQVguCisgKi8KKyNk
ZWZpbmUgY29uc3RfbWluKHgsIHkpIGNvbnN0X2NtcCgoeCksICh5KSwgPD0pCisKKy8qKgorICog
Y29uc3RfbWF4IC0gcmV0dXJucyBtYXhpbXVtIG9mIHR3byBjb21waWxlLXRpbWUgY29uc3RhbnQg
dmFsdWVzCisgKiBAeDogZmlyc3QgY29tcGlsZS10aW1lIGNvbnN0YW50IHZhbHVlCisgKiBAeTog
c2Vjb25kIGNvbXBpbGUtdGltZSBjb25zdGFudCB2YWx1ZQorICoKKyAqIFRoZSByZXN1bHQgaGFz
IHRoZSB0eXBlIG9mIHRoZSB3aW5uZXIgb2YgdGhlIGNvbXBhcmlzb24uIFdvcmtzIGZvciBhbnkK
KyAqIHZhbHVlIHVwIHRvIExMT05HX01BWC4KKyAqLworI2RlZmluZSBjb25zdF9tYXgoeCwgeSkg
Y29uc3RfY21wKCh4KSwgKHkpLCA+PSkKKwogLyoqCiAgKiBtaW4zIC0gcmV0dXJuIG1pbmltdW0g
b2YgdGhyZWUgdmFsdWVzCiAgKiBAeDogZmlyc3QgdmFsdWUKCg==
--001a1141ff069cb848056791f084--
