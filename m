MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5jJ=ZYpf=30H6hsWn-R-CEVYAgVMHxjmoLUC00QYq0r17g@mail.gmail.com>
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
 <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com> <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
 <20180316175502.GE30522@ZenIV.linux.org.uk> <CA+55aFzsrVF7W+YQye=EeF4Wk3yDOTbb_vSiM8s1zkKbE4JV4Q@mail.gmail.com>
 <CAGXu5jJmAAgaq3VCsUN2yjpHLSc7P-kNrM_4c4cqP=ysFcETXA@mail.gmail.com>
 <CA+55aFwv0VC67cx2W9yrf7qSFKf6ncVRrsVyLGqdmfSBn4yTYw@mail.gmail.com> <CAGXu5jJ=ZYpf=30H6hsWn-R-CEVYAgVMHxjmoLUC00QYq0r17g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 20 Mar 2018 16:23:54 -0700
Message-ID: <CA+55aFwxk=tUECYQkd4cog08qW4ZT=r2K7FQXzGnc-zuMc7JQA@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] Remove false-positive VLAs when using max()
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Florian Weimer <fweimer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 17, 2018 at 1:07 PM, Kees Cook <keescook@chromium.org> wrote:
>
> No luck! :( gcc 4.4 refuses to play along. And, hilariously, not only
> does it not change the complaint about __builtin_choose_expr(), it
> also thinks that's a VLA now.

Hmm. So thanks to the diseased mind of Martin Uecker, there's a better
test for "__is_constant()":

  /* Glory to Martin Uecker <Martin.Uecker@med.uni-goettingen.de> */
  #define __is_constant(a) \
        (sizeof(int) == sizeof(*(1 ? ((void*)((a) * 0l)) : (int*)1)))

that is actually *specified* by the C standard to work, and doesn't
even depend on any gcc extensions.

The reason is some really subtle pointer conversion rules, where the
type of the ternary operator will depend on whether one of the
pointers is NULL or not.

And the definition of NULL, in turn, very much depends on "integer
constant expression that has the value 0".

Are you willing to do one final try on a generic min/max? Same as my
last patch, but using the above __is_constant() test instead of
__builtin_constant_p?

               Linus
