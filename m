MIME-Version: 1.0
In-Reply-To: <CA+55aFzsrVF7W+YQye=EeF4Wk3yDOTbb_vSiM8s1zkKbE4JV4Q@mail.gmail.com>
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
 <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com> <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
 <20180316175502.GE30522@ZenIV.linux.org.uk> <CA+55aFzsrVF7W+YQye=EeF4Wk3yDOTbb_vSiM8s1zkKbE4JV4Q@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 16 Mar 2018 21:03:13 +0100
Message-ID: <CANiq72mjDQWsPG60JqfuLSY-6SDzB4goP4n35XZxc8bfFx1NDg@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] Remove false-positive VLAs when using max()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Florian Weimer <fweimer@redhat.com>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 16, 2018 at 8:27 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Mar 16, 2018 at 10:55 AM, Al Viro <viro@zeniv.linux.org.uk> wrote=
:
>>
>> That's not them, that's C standard regarding ICE.
>
> Yes. The C standard talks about "integer constant expression". I know.
> It's come up in this very thread before.
>
> The C standard at no point talks about - or forbids - "variable length
> arrays". That never comes up in the whole standard, I checked.
>
> So we are right now hindered by a _syntactic_ check, without any way
> to have a _semantic_ check.
>
> That's my problem. The warnings are misleading and imply semantics.
>
> And apparently there is no way to actually check semantics.
>
>> 1,100 is *not* a constant expression as far as the standard is concerned=
,
>
> I very much know.
>
> But it sure isn't "variable" either as far as the standard is
> concerned, because the standard doesn't even have that concept (it
> uses "variable" for argument numbers and for variables).
>
> So being pedantic doesn't really change anything.
>
>> Would you argue that in
>> void foo(char c)
>> {
>>         int a[(c<<1) + 10 - c + 2 - c];
>
> Yeah, I don't think that even counts as a constant value, even if it
> can be optimized to one. I would not at all be unhppy to see
> __builtin_constant_p() to return zero.
>
> But that is very much different from the syntax issue.
>
> So I would like to get some way to get both type-checking and constant
> checking without the annoying syntax issue.
>
>> expr, constant_expression is not a constant_expression.  And in
>> this particular case the standard is not insane - the only reason
>> for using that is typechecking and _that_ can be achieved without
>> violating 6.6p6:
>>         sizeof(expr,0) * 0 + ICE
>> *is* an integer constant expression, and it gives you exact same
>> typechecking.  So if somebody wants to play odd games, they can
>> do that just fine, without complicating the logics for compilers...
>
> Now that actually looks like a good trick. Maybe we can use that
> instead of the comma expression that causes problems.
>
> And using sizeof() to make sure that __builtin_choose_expression()
> really gets an integer constant expression and that there should be no
> ambiguity looks good.
>
> Hmm.
>
> This works for me, and I'm being *very* careful (those casts to
> pointer types are inside that sizeof, because it's not an integral
> type, and non-integral casts are not valid in an ICE either) but
> somebody needs to check gcc-4.4:
>
>   #define __typecheck(a,b) \
>         (!!(sizeof((typeof(a)*)1=3D=3D(typeof(b)*)1)))
>
>   #define __no_side_effects(a,b) \
>         (__builtin_constant_p(a)&&__builtin_constant_p(b))
>
>   #define __safe_cmp(a,b) \
>         (__typecheck(a,b) && __no_side_effects(a,b))
>
>   #define __cmp(a,b,op) ((a)op(b)?(a):(b))
>
>   #define __cmp_once(a,b,op) ({ \
>         typeof(a) __a =3D (a);            \
>         typeof(b) __b =3D (b);            \
>         __cmp(__a,__b,op); })
>
>   #define __careful_cmp(a,b,op) \
>         __builtin_choose_expr(__safe_cmp(a,b), __cmp(a,b,op),
> __cmp_once(a,b,op))
>
>   #define min(a,b)              __careful_cmp(a,b,<)
>   #define max(a,b)              __careful_cmp(a,b,>)
>   #define min_t(t,a,b)  __careful_cmp((t)(a),(t)(b),<)
>   #define max_t(t,a,b)  __careful_cmp((t)(a),(t)(b),>)
>
> and yes, it does cause new warnings for that
>
>     comparison between =E2=80=98enum tis_defaults=E2=80=99 and =E2=80=98e=
num tpm2_const=E2=80=99
>
> in drivers/char/tpm/tpm_tis_core.h due to
>
>    #define TIS_TIMEOUT_A_MAX       max(TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_A)
>
> but technically that warning is actually correct, I'm just confused
> why gcc cares about the cast placement or something.
>
> That warning is easy to fix by turning it into a "max_t(int, enum1,
> enum2)' and that is technically the right thing to do, it's just not
> warned about for some odd reason with the current code.
>
> Kees - is there some online "gcc-4.4 checker" somewhere? This does
> seem to work with my gcc. I actually tested some of those files you
> pointed at now.

I use this one:

  https://godbolt.org/

Cheers,
Miguel
