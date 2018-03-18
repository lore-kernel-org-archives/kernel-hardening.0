Subject: Re: [PATCH v5 0/2] Remove false-positive VLAs when using max()
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
 <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com>
 <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
 <20180316175502.GE30522@ZenIV.linux.org.uk>
 <CA+55aFzsrVF7W+YQye=EeF4Wk3yDOTbb_vSiM8s1zkKbE4JV4Q@mail.gmail.com>
 <CAGXu5jJmAAgaq3VCsUN2yjpHLSc7P-kNrM_4c4cqP=ysFcETXA@mail.gmail.com>
 <CA+55aFwv0VC67cx2W9yrf7qSFKf6ncVRrsVyLGqdmfSBn4yTYw@mail.gmail.com>
 <42b4342b-aefc-a16a-0d43-9f9c0d63ba7a@rasmusvillemoes.dk>
 <CA+55aFwFoTapX2niPiaET5kg7K85qxhav1_PoDDxY0o_VRA5Ag@mail.gmail.com>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <38b6da49-1138-017e-7307-f39ff067d6d2@rasmusvillemoes.dk>
Date: Sun, 18 Mar 2018 23:59:21 +0100
MIME-Version: 1.0
In-Reply-To: <CA+55aFwFoTapX2niPiaET5kg7K85qxhav1_PoDDxY0o_VRA5Ag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Florian Weimer <fweimer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 2018-03-18 22:33, Linus Torvalds wrote:
> On Sun, Mar 18, 2018 at 2:13 PM, Rasmus Villemoes
> <linux@rasmusvillemoes.dk> wrote:
>> On 2018-03-17 19:52, Linus Torvalds wrote:
>>>
>>> Ok, so it really looks like that same "__builtin_constant_p() doesn't
>>> return a constant".
>>>
>>> Which is really odd, but there you have it.
>>
>> Not really. We do rely on builtin_constant_p not being folded too
>> quickly to a 0/1 answer, so that gcc still generates good code even if
>> the argument is only known to be constant at a late(r) optimization
>> stage (through inlining and all).
> 
> Hmm. That makes sense. It just doesn't work for our case when we
> really want to choose the expression based on side effects or not.
> 
>> So unlike types_compatible_p, which
>> can obviously be answered early during parsing, builtin_constant_p is
>> most of the time a yes/no/maybe/it's complicated thing.
> 
> The silly thing is, the thing we *really* want to know _is_ actually
> easily accessible during the early parsing, exactly like
> __builtin_compatible_p(): it's not really that we care about the
> expressions being constant, as much as the "can this have side
> effects" question.

OK, I missed where this was made about side effects of x and y, but I
suppose the idea was to use

  no_side_effects(x) && no_side_effects(y) ? trivial_max(x, y) :
old_max(x, y)

or the same thing spelled with b_c_e? Yes, I think that would work, if
we indeed had that way of checking an expression.

> We only really use __builtin_constant_p() as a (bad) approximation of
> that in this case, since it's the best we can do.

I don't think you should parenthesize bad, rather capitalize it. ({x++;
0;}) is constant in the eyes of __builtin_constant_p, but not
side-effect free. Sure, that's very contrived, but I can easily imagine
some max(f(foo), -1) call where f is sometimes an external function, but
for other .configs it's a static inline that always returns 0, but still
has some non-trivial side-effect before that. And this would all depend
on which optimizations gcc applies before it decides to evaluate
builtin_constant_p, so could be some fun debugging. Good thing that that
didn't work out...

> So the real use would be to say "can we use the simple direct macro
> that just happens to also fold into a nice integer constant
> expression" for __builtin_choose_expr().
> 
> I tried to find something like that, but it really doesn't exist, even
> though I would actually have expected it to be a somewhat common
> concern for macro writers: write a macro that works in any arbitrary
> environment.

Yeah, I think the closest is a five year old suggestion
(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=57612) to add a
__builtin_assert_no_side_effects, that could be used in macros that for
some reason cannot be implemented without evaluating some argument
multiple times. It would be more useful to have the predicate version,
which one could always turn into a build bug version. But we have
neither, unfortunately.

Rasmus
