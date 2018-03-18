MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <38b6da49-1138-017e-7307-f39ff067d6d2@rasmusvillemoes.dk>
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
 <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com> <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
 <20180316175502.GE30522@ZenIV.linux.org.uk> <CA+55aFzsrVF7W+YQye=EeF4Wk3yDOTbb_vSiM8s1zkKbE4JV4Q@mail.gmail.com>
 <CAGXu5jJmAAgaq3VCsUN2yjpHLSc7P-kNrM_4c4cqP=ysFcETXA@mail.gmail.com>
 <CA+55aFwv0VC67cx2W9yrf7qSFKf6ncVRrsVyLGqdmfSBn4yTYw@mail.gmail.com>
 <42b4342b-aefc-a16a-0d43-9f9c0d63ba7a@rasmusvillemoes.dk> <CA+55aFwFoTapX2niPiaET5kg7K85qxhav1_PoDDxY0o_VRA5Ag@mail.gmail.com>
 <38b6da49-1138-017e-7307-f39ff067d6d2@rasmusvillemoes.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 18 Mar 2018 16:36:13 -0700
Message-ID: <CA+55aFw0WC+S3TTE6x_vkLbRV6YLeR4-1S9LsBXhE+E2KZqBuA@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] Remove false-positive VLAs when using max()
Content-Type: text/plain; charset="UTF-8"
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Florian Weimer <fweimer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Mar 18, 2018 at 3:59 PM, Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
>
> OK, I missed where this was made about side effects of x and y

We never made it explicit, since all we really cared about in the end
is the constantness.

But yes:

> but I suppose the idea was to use
>
>   no_side_effects(x) && no_side_effects(y) ? trivial_max(x, y) :
> old_max(x, y)

Exactly. Except with __builtin_choose_expr(), because we need the end
result to be seen as a integer constant expression, so that we can
then use it as an array size. So it needs that early parse-time
resolution.

>> We only really use __builtin_constant_p() as a (bad) approximation of
>> that in this case, since it's the best we can do.
>
> I don't think you should parenthesize bad, rather capitalize it. ({x++;
> 0;}) is constant in the eyes of __builtin_constant_p, but not
> side-effect free.

Hmm. Yeah, but probably don't much care for the kernel.

For example, we do things like this:

   #define __swab64(x)                             \
        (__builtin_constant_p((__u64)(x)) ?     \
        ___constant_swab64(x) :                 \
        __fswab64(x))

where that "___constant_swab64()" very much uses the same argument
over and over.

And we do that for related reasons - we really want to do the constant
folding at build time for some cases, and this was the only sane way
to do it. Eg code like

        return (addr & htonl(0xff000000)) == htonl(0x7f000000);

wants to do the right thing, and long ago gcc didn't have builtins for
byte swapping, so we had to just do nasty horribly macros that DTRT
for constants.

But since the kernel is standalone, we don't need to really worry
about the *generic* case, we just need to worry about our own macros,
and if somebody does that example you show I guess we'll just have to
shun them ;)

Of course, our own macros are often macros from hell, exactly because
they often contain a lot of type-checking and/or type-(size)-based
polymorphism. But then we actually *want* gcc to simplify things, and
avoid side effects, just have potentially very complex expressions.

But we basically never have that kind of intentionally evil macros, so
we are willing to live with a bad substitute.

But yes, it would be better to have some more control over things, and
actually have a way to say "if X is a constant integer expression, do
transformation Y, otherwise call function y()".

Actually sparse started out with the idea in the background that it
could become not just a checker, but a "transformation tool". Partly
because of long gone historical issues (ie gcc people used to be very
anti-plugin due to licensing issues).

Of course, a more integrated and powerful preprocessor language is
almost always what we *really* wanted, but traditionally "powerful
preprocessor" has always meant "completely incomprehensible and badly
integrated preprocessor".

"cpp" may be a horrid language, but it's there and it's fast (when
integrated with the front-end, like everybody does now)

But sadly, cpp is really bad for the above kind of "if argument is
constant" kind of tricks. I suspect we'd use it a lot otherwise.

>> So the real use would be to say "can we use the simple direct macro
>> that just happens to also fold into a nice integer constant
>> expression" for __builtin_choose_expr().
>>
>> I tried to find something like that, but it really doesn't exist, even
>> though I would actually have expected it to be a somewhat common
>> concern for macro writers: write a macro that works in any arbitrary
>> environment.
>
> Yeah, I think the closest is a five year old suggestion
> (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=57612) to add a
> __builtin_assert_no_side_effects, that could be used in macros that for
> some reason cannot be implemented without evaluating some argument
> multiple times. It would be more useful to have the predicate version,
> which one could always turn into a build bug version. But we have
> neither, unfortunately.

Yeah, and since we're in the situation that *new* gcc versions work
for us anyway, and we only have issues with older gcc's (that sadly
people still use), even if there was a new cool feature we couldn't
use it.

Oh well. Thanks for the background.

            Linus
