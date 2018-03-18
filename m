Subject: Re: [PATCH v5 0/2] Remove false-positive VLAs when using max()
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
 <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com>
 <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
 <20180316175502.GE30522@ZenIV.linux.org.uk>
 <CA+55aFzsrVF7W+YQye=EeF4Wk3yDOTbb_vSiM8s1zkKbE4JV4Q@mail.gmail.com>
 <CAGXu5jJmAAgaq3VCsUN2yjpHLSc7P-kNrM_4c4cqP=ysFcETXA@mail.gmail.com>
 <CA+55aFwv0VC67cx2W9yrf7qSFKf6ncVRrsVyLGqdmfSBn4yTYw@mail.gmail.com>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <42b4342b-aefc-a16a-0d43-9f9c0d63ba7a@rasmusvillemoes.dk>
Date: Sun, 18 Mar 2018 22:13:28 +0100
MIME-Version: 1.0
In-Reply-To: <CA+55aFwv0VC67cx2W9yrf7qSFKf6ncVRrsVyLGqdmfSBn4yTYw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Florian Weimer <fweimer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 2018-03-17 19:52, Linus Torvalds wrote:
> On Sat, Mar 17, 2018 at 12:27 AM, Kees Cook <keescook@chromium.org> wrote:
>>
>> Unfortunately my 4.4 test fails quickly:
>>
>> ./include/linux/jiffies.h: In function ‘jiffies_delta_to_clock_t’:
>> ./include/linux/jiffies.h:444: error: first argument to
>> ‘__builtin_choose_expr’ not a constant
> 
> Ok, so it really looks like that same "__builtin_constant_p() doesn't
> return a constant".
> 
> Which is really odd, but there you have it.

Not really. We do rely on builtin_constant_p not being folded too
quickly to a 0/1 answer, so that gcc still generates good code even if
the argument is only known to be constant at a late(r) optimization
stage (through inlining and all). So unlike types_compatible_p, which
can obviously be answered early during parsing, builtin_constant_p is
most of the time a yes/no/maybe/it's complicated thing. Sure, when the
argument is just a literal or perhaps even any kind of ICE, gcc can fold
it to "yes", and I think it does (though the details of when and if gcc
does that can obviously be very version-dependent, which may be some of
what we've seen). But when it's not that obvious, gcc leaves it in the
undetermined state. That's not good enough for builtin_choose_expr,
because even the type of the resulting expression depends on that first
argument, so that really must be resolved early.

So to have some kind of builtin_constant_p control a
builtin_choose_expr, it would need to be a "builtin_ice_p" or
"builtin_obviously_constant_p" that would always be folded to 0/1 as
part of evaluating ICEs.

So I don't think there's any way around creating a separate macro for
use with compile-time constants.

Rasmus
