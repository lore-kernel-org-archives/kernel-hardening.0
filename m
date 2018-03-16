MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <a37f7b0da04f4ede9fac2c88f7079a8a@AcuMS.aculab.com>
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
 <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com> <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
 <a37f7b0da04f4ede9fac2c88f7079a8a@AcuMS.aculab.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 16 Mar 2018 13:25:26 -0700
Message-ID: <CA+55aFwzgO9w8Dj1NoCViz6JTwVLWhWabLq_cvzJ1-woEBfJMg@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] Remove false-positive VLAs when using max()
Content-Type: text/plain; charset="UTF-8"
To: David Laight <David.Laight@aculab.com>
Cc: Florian Weimer <fweimer@redhat.com>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 16, 2018 at 10:44 AM, David Laight <David.Laight@aculab.com> wrote:
>
> I looked at the generated code for one of the constant sized VLA that
> the compiler barfed at.
> It seemed to subtract constants from %sp separately for the VLA.
> So it looks like the compiler treats them as VLA even though it
> knows the size.
> That is probably missing optimisation.

Looking at the code is definitely an option.

In fact, instead of depending on -Wvla, we could just make 'objtool'
warn about real variable-sized stack frames.

That said, if that "sizeof()" trick of Al's actually works with older
gcc versions too (it *should*, but it's not like
__builtin_choose_expr() and __builtin_constant_p() have well-defined
rules in the standard), that may just be the solution.

And if gcc ends up generating bad code for those "constant sized vlas"
anyway, then -Wvla would effectively warn about that code generation
problem.

              Linus
