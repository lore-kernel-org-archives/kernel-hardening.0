MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFwv0VC67cx2W9yrf7qSFKf6ncVRrsVyLGqdmfSBn4yTYw@mail.gmail.com>
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
 <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com> <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
 <20180316175502.GE30522@ZenIV.linux.org.uk> <CA+55aFzsrVF7W+YQye=EeF4Wk3yDOTbb_vSiM8s1zkKbE4JV4Q@mail.gmail.com>
 <CAGXu5jJmAAgaq3VCsUN2yjpHLSc7P-kNrM_4c4cqP=ysFcETXA@mail.gmail.com> <CA+55aFwv0VC67cx2W9yrf7qSFKf6ncVRrsVyLGqdmfSBn4yTYw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 17 Mar 2018 13:07:32 -0700
Message-ID: <CAGXu5jJ=ZYpf=30H6hsWn-R-CEVYAgVMHxjmoLUC00QYq0r17g@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] Remove false-positive VLAs when using max()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Florian Weimer <fweimer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 17, 2018 at 11:52 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> So the above is completely insane, bit there is actually a chance that
> using that completely crazy "x -> sizeof(char[x])" conversion actually
> helps, because it really does have a (very odd) evaluation-time
> change.  sizeof() has to be evaluated as part of the constant
> expression evaluation, in ways that "__builtin_constant_p()" isn't
> specified to be done.
>
> But it is also definitely me grasping at straws. If that doesn't work
> for 4.4, there's nothing else I can possibly see.

No luck! :( gcc 4.4 refuses to play along. And, hilariously, not only
does it not change the complaint about __builtin_choose_expr(), it
also thinks that's a VLA now.

./include/linux/mm.h: In function =E2=80=98get_mm_hiwater_rss=E2=80=99:
./include/linux/mm.h:1567: warning: variable length array is used
./include/linux/mm.h:1567: error: first argument to
=E2=80=98__builtin_choose_expr=E2=80=99 not a constant

6.8 is happy with it (of course).

I do think the earlier version (without the
sizeof-hiding-builting_constant_p) provides a template for a
const_max() that both you and Rasmus would be happy with, though!

-Kees

--=20
Kees Cook
Pixel Security
