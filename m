MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20180316175502.GE30522@ZenIV.linux.org.uk>
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
 <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com> <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
 <20180316175502.GE30522@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 16 Mar 2018 12:27:23 -0700
Message-ID: <CA+55aFzsrVF7W+YQye=EeF4Wk3yDOTbb_vSiM8s1zkKbE4JV4Q@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] Remove false-positive VLAs when using max()
Content-Type: multipart/mixed; boundary="0000000000000f128e05678c999d"
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Florian Weimer <fweimer@redhat.com>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--0000000000000f128e05678c999d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 16, 2018 at 10:55 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> That's not them, that's C standard regarding ICE.

Yes. The C standard talks about "integer constant expression". I know.
It's come up in this very thread before.

The C standard at no point talks about - or forbids - "variable length
arrays". That never comes up in the whole standard, I checked.

So we are right now hindered by a _syntactic_ check, without any way
to have a _semantic_ check.

That's my problem. The warnings are misleading and imply semantics.

And apparently there is no way to actually check semantics.

> 1,100 is *not* a constant expression as far as the standard is concerned,

I very much know.

But it sure isn't "variable" either as far as the standard is
concerned, because the standard doesn't even have that concept (it
uses "variable" for argument numbers and for variables).

So being pedantic doesn't really change anything.

> Would you argue that in
> void foo(char c)
> {
>         int a[(c<<1) + 10 - c + 2 - c];

Yeah, I don't think that even counts as a constant value, even if it
can be optimized to one. I would not at all be unhppy to see
__builtin_constant_p() to return zero.

But that is very much different from the syntax issue.

So I would like to get some way to get both type-checking and constant
checking without the annoying syntax issue.

> expr, constant_expression is not a constant_expression.  And in
> this particular case the standard is not insane - the only reason
> for using that is typechecking and _that_ can be achieved without
> violating 6.6p6:
>         sizeof(expr,0) * 0 + ICE
> *is* an integer constant expression, and it gives you exact same
> typechecking.  So if somebody wants to play odd games, they can
> do that just fine, without complicating the logics for compilers...

Now that actually looks like a good trick. Maybe we can use that
instead of the comma expression that causes problems.

And using sizeof() to make sure that __builtin_choose_expression()
really gets an integer constant expression and that there should be no
ambiguity looks good.

Hmm.

This works for me, and I'm being *very* careful (those casts to
pointer types are inside that sizeof, because it's not an integral
type, and non-integral casts are not valid in an ICE either) but
somebody needs to check gcc-4.4:

  #define __typecheck(a,b) \
        (!!(sizeof((typeof(a)*)1=3D=3D(typeof(b)*)1)))

  #define __no_side_effects(a,b) \
        (__builtin_constant_p(a)&&__builtin_constant_p(b))

  #define __safe_cmp(a,b) \
        (__typecheck(a,b) && __no_side_effects(a,b))

  #define __cmp(a,b,op) ((a)op(b)?(a):(b))

  #define __cmp_once(a,b,op) ({ \
        typeof(a) __a =3D (a);            \
        typeof(b) __b =3D (b);            \
        __cmp(__a,__b,op); })

  #define __careful_cmp(a,b,op) \
        __builtin_choose_expr(__safe_cmp(a,b), __cmp(a,b,op),
__cmp_once(a,b,op))

  #define min(a,b)              __careful_cmp(a,b,<)
  #define max(a,b)              __careful_cmp(a,b,>)
  #define min_t(t,a,b)  __careful_cmp((t)(a),(t)(b),<)
  #define max_t(t,a,b)  __careful_cmp((t)(a),(t)(b),>)

and yes, it does cause new warnings for that

    comparison between =E2=80=98enum tis_defaults=E2=80=99 and =E2=80=98enu=
m tpm2_const=E2=80=99

in drivers/char/tpm/tpm_tis_core.h due to

   #define TIS_TIMEOUT_A_MAX       max(TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_A)

but technically that warning is actually correct, I'm just confused
why gcc cares about the cast placement or something.

That warning is easy to fix by turning it into a "max_t(int, enum1,
enum2)' and that is technically the right thing to do, it's just not
warned about for some odd reason with the current code.

Kees - is there some online "gcc-4.4 checker" somewhere? This does
seem to work with my gcc. I actually tested some of those files you
pointed at now.

                  Linus

--0000000000000f128e05678c999d
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jeubye0x0

IGluY2x1ZGUvbGludXgva2VybmVsLmggfCA3NyArKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKyks
IDU3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgva2VybmVsLmggYi9p
bmNsdWRlL2xpbnV4L2tlcm5lbC5oCmluZGV4IDNmZDI5MTUwMzU3Ni4uMjNjMzFiZjFkN2ZiIDEw
MDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2tlcm5lbC5oCisrKyBiL2luY2x1ZGUvbGludXgva2Vy
bmVsLmgKQEAgLTc4NywzNyArNzg3LDI5IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBmdHJhY2VfZHVt
cChlbnVtIGZ0cmFjZV9kdW1wX21vZGUgb29wc19kdW1wX21vZGUpIHsgfQogICogc3RyaWN0IHR5
cGUtY2hlY2tpbmcuLiBTZWUgdGhlCiAgKiAidW5uZWNlc3NhcnkiIHBvaW50ZXIgY29tcGFyaXNv
bi4KICAqLwotI2RlZmluZSBfX21pbih0MSwgdDIsIG1pbjEsIG1pbjIsIHgsIHkpICh7CQlcCi0J
dDEgbWluMSA9ICh4KTsJCQkJCVwKLQl0MiBtaW4yID0gKHkpOwkJCQkJXAotCSh2b2lkKSAoJm1p
bjEgPT0gJm1pbjIpOwkJCVwKLQltaW4xIDwgbWluMiA/IG1pbjEgOiBtaW4yOyB9KQorI2RlZmlu
ZSBfX3R5cGVjaGVjayhhLGIpIFwKKwkoISEoc2l6ZW9mKCh0eXBlb2YoYSkqKTE9PSh0eXBlb2Yo
YikqKTEpKSkKIAotLyoqCi0gKiBtaW4gLSByZXR1cm4gbWluaW11bSBvZiB0d28gdmFsdWVzIG9m
IHRoZSBzYW1lIG9yIGNvbXBhdGlibGUgdHlwZXMKLSAqIEB4OiBmaXJzdCB2YWx1ZQotICogQHk6
IHNlY29uZCB2YWx1ZQotICovCi0jZGVmaW5lIG1pbih4LCB5KQkJCQkJXAotCV9fbWluKHR5cGVv
Zih4KSwgdHlwZW9mKHkpLAkJCVwKLQkgICAgICBfX1VOSVFVRV9JRChtaW4xXyksIF9fVU5JUVVF
X0lEKG1pbjJfKSwJXAotCSAgICAgIHgsIHkpCisjZGVmaW5lIF9fbm9fc2lkZV9lZmZlY3RzKGEs
YikgXAorCShfX2J1aWx0aW5fY29uc3RhbnRfcChhKSYmX19idWlsdGluX2NvbnN0YW50X3AoYikp
CiAKLSNkZWZpbmUgX19tYXgodDEsIHQyLCBtYXgxLCBtYXgyLCB4LCB5KSAoewkJXAotCXQxIG1h
eDEgPSAoeCk7CQkJCQlcCi0JdDIgbWF4MiA9ICh5KTsJCQkJCVwKLQkodm9pZCkgKCZtYXgxID09
ICZtYXgyKTsJCQlcCi0JbWF4MSA+IG1heDIgPyBtYXgxIDogbWF4MjsgfSkKKyNkZWZpbmUgX19z
YWZlX2NtcChhLGIpIFwKKwkoX190eXBlY2hlY2soYSxiKSAmJiBfX25vX3NpZGVfZWZmZWN0cyhh
LGIpKQogCi0vKioKLSAqIG1heCAtIHJldHVybiBtYXhpbXVtIG9mIHR3byB2YWx1ZXMgb2YgdGhl
IHNhbWUgb3IgY29tcGF0aWJsZSB0eXBlcwotICogQHg6IGZpcnN0IHZhbHVlCi0gKiBAeTogc2Vj
b25kIHZhbHVlCi0gKi8KLSNkZWZpbmUgbWF4KHgsIHkpCQkJCQlcCi0JX19tYXgodHlwZW9mKHgp
LCB0eXBlb2YoeSksCQkJXAotCSAgICAgIF9fVU5JUVVFX0lEKG1heDFfKSwgX19VTklRVUVfSUQo
bWF4Ml8pLAlcCi0JICAgICAgeCwgeSkKKyNkZWZpbmUgX19jbXAoYSxiLG9wKSAoKGEpb3AoYik/
KGEpOihiKSkKKworI2RlZmluZSBfX2NtcF9vbmNlKGEsYixvcCkgKHsJXAorCXR5cGVvZihhKSBf
X2EgPSAoYSk7CVwKKwl0eXBlb2YoYikgX19iID0gKGIpOwlcCisJX19jbXAoX19hLF9fYixvcCk7
IH0pCisKKyNkZWZpbmUgX19jYXJlZnVsX2NtcChhLGIsb3ApIFwKKwlfX2J1aWx0aW5fY2hvb3Nl
X2V4cHIoX19zYWZlX2NtcChhLGIpLCBfX2NtcChhLGIsb3ApLCBfX2NtcF9vbmNlKGEsYixvcCkp
CisKKyNkZWZpbmUgbWluKGEsYikJX19jYXJlZnVsX2NtcChhLGIsPCkKKyNkZWZpbmUgbWF4KGEs
YikJX19jYXJlZnVsX2NtcChhLGIsPikKKyNkZWZpbmUgbWluX3QodCxhLGIpCV9fY2FyZWZ1bF9j
bXAoKHQpKGEpLCh0KShiKSw8KQorI2RlZmluZSBtYXhfdCh0LGEsYikJX19jYXJlZnVsX2NtcCgo
dCkoYSksKHQpKGIpLD4pCiAKIC8qKgogICogbWluMyAtIHJldHVybiBtaW5pbXVtIG9mIHRocmVl
IHZhbHVlcwpAQCAtODU2LDM1ICs4NDgsNiBAQCBzdGF0aWMgaW5saW5lIHZvaWQgZnRyYWNlX2R1
bXAoZW51bSBmdHJhY2VfZHVtcF9tb2RlIG9vcHNfZHVtcF9tb2RlKSB7IH0KICAqLwogI2RlZmlu
ZSBjbGFtcCh2YWwsIGxvLCBoaSkgbWluKCh0eXBlb2YodmFsKSltYXgodmFsLCBsbyksIGhpKQog
Ci0vKgotICogLi5hbmQgaWYgeW91IGNhbid0IHRha2UgdGhlIHN0cmljdAotICogdHlwZXMsIHlv
dSBjYW4gc3BlY2lmeSBvbmUgeW91cnNlbGYuCi0gKgotICogT3Igbm90IHVzZSBtaW4vbWF4L2Ns
YW1wIGF0IGFsbCwgb2YgY291cnNlLgotICovCi0KLS8qKgotICogbWluX3QgLSByZXR1cm4gbWlu
aW11bSBvZiB0d28gdmFsdWVzLCB1c2luZyB0aGUgc3BlY2lmaWVkIHR5cGUKLSAqIEB0eXBlOiBk
YXRhIHR5cGUgdG8gdXNlCi0gKiBAeDogZmlyc3QgdmFsdWUKLSAqIEB5OiBzZWNvbmQgdmFsdWUK
LSAqLwotI2RlZmluZSBtaW5fdCh0eXBlLCB4LCB5KQkJCQlcCi0JX19taW4odHlwZSwgdHlwZSwJ
CQkJXAotCSAgICAgIF9fVU5JUVVFX0lEKG1pbjFfKSwgX19VTklRVUVfSUQobWluMl8pLAlcCi0J
ICAgICAgeCwgeSkKLQotLyoqCi0gKiBtYXhfdCAtIHJldHVybiBtYXhpbXVtIG9mIHR3byB2YWx1
ZXMsIHVzaW5nIHRoZSBzcGVjaWZpZWQgdHlwZQotICogQHR5cGU6IGRhdGEgdHlwZSB0byB1c2UK
LSAqIEB4OiBmaXJzdCB2YWx1ZQotICogQHk6IHNlY29uZCB2YWx1ZQotICovCi0jZGVmaW5lIG1h
eF90KHR5cGUsIHgsIHkpCQkJCVwKLQlfX21heCh0eXBlLCB0eXBlLAkJCQlcCi0JICAgICAgX19V
TklRVUVfSUQobWluMV8pLCBfX1VOSVFVRV9JRChtaW4yXyksCVwKLQkgICAgICB4LCB5KQotCiAv
KioKICAqIGNsYW1wX3QgLSByZXR1cm4gYSB2YWx1ZSBjbGFtcGVkIHRvIGEgZ2l2ZW4gcmFuZ2Ug
dXNpbmcgYSBnaXZlbiB0eXBlCiAgKiBAdHlwZTogdGhlIHR5cGUgb2YgdmFyaWFibGUgdG8gdXNl
Cg==
--0000000000000f128e05678c999d--
