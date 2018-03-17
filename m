MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5jJmAAgaq3VCsUN2yjpHLSc7P-kNrM_4c4cqP=ysFcETXA@mail.gmail.com>
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
 <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com> <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
 <20180316175502.GE30522@ZenIV.linux.org.uk> <CA+55aFzsrVF7W+YQye=EeF4Wk3yDOTbb_vSiM8s1zkKbE4JV4Q@mail.gmail.com>
 <CAGXu5jJmAAgaq3VCsUN2yjpHLSc7P-kNrM_4c4cqP=ysFcETXA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 17 Mar 2018 11:52:09 -0700
Message-ID: <CA+55aFwv0VC67cx2W9yrf7qSFKf6ncVRrsVyLGqdmfSBn4yTYw@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] Remove false-positive VLAs when using max()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Florian Weimer <fweimer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 17, 2018 at 12:27 AM, Kees Cook <keescook@chromium.org> wrote:
>
> Unfortunately my 4.4 test fails quickly:
>
> ./include/linux/jiffies.h: In function =E2=80=98jiffies_delta_to_clock_t=
=E2=80=99:
> ./include/linux/jiffies.h:444: error: first argument to
> =E2=80=98__builtin_choose_expr=E2=80=99 not a constant

Ok, so it really looks like that same "__builtin_constant_p() doesn't
return a constant".

Which is really odd, but there you have it.

I wonder if you can use that "sizeof()" to force evaluation of it,
because sizeof() really does end up being magical when it comes to
"integer constant expression".

So instead of this:

   #define __no_side_effects(a,b) \
          (__builtin_constant_p(a)&&__builtin_constant_p(b))

that just assumes that __builtin_constant_p() itself always counts as
a constant expression, what happens if you do

  #define __is_constant(a) \
        (sizeof(char[__builtin_constant_p(a)]))

  #define __no_side_effects(a,b) \
        (__is_constant(a) && __is_constant(b))

I realize that the above looks completely insane: the whole point is
to *not* have VLA's, and we know that __builtin_constant_p() isn't
always evaliated as a constant.

But hear me out: if the issue is that there's some evaluation ordering
between the two builtins, and the problem is that the
__builtin_choose_expr() part of the expression is expanded *before*
the __builtin_constant_p() has been expanded, then just hiding it
inside that bat-shit-crazy sizeof() will force that to be evaluated
first (because a sizeof() is defined to be a integer constant
expression.

So the above is completely insane, bit there is actually a chance that
using that completely crazy "x -> sizeof(char[x])" conversion actually
helps, because it really does have a (very odd) evaluation-time
change.  sizeof() has to be evaluated as part of the constant
expression evaluation, in ways that "__builtin_constant_p()" isn't
specified to be done.

But it is also definitely me grasping at straws. If that doesn't work
for 4.4, there's nothing else I can possibly see.

                Linus
