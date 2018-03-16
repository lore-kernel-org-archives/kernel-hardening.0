MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFxLpdfyfTqhkHQoedQuqTcLRw3bYOgyz1s0eRW6cBmFTA@mail.gmail.com>
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
 <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com> <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
 <20180316175502.GE30522@ZenIV.linux.org.uk> <CA+55aFzsrVF7W+YQye=EeF4Wk3yDOTbb_vSiM8s1zkKbE4JV4Q@mail.gmail.com>
 <CANiq72mjDQWsPG60JqfuLSY-6SDzB4goP4n35XZxc8bfFx1NDg@mail.gmail.com> <CA+55aFxLpdfyfTqhkHQoedQuqTcLRw3bYOgyz1s0eRW6cBmFTA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 16 Mar 2018 13:19:19 -0700
Message-ID: <CA+55aFztfTTVJG3ANetGh_9-iJg=gUeKt4wbibTy=c5DuH_udA@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] Remove false-positive VLAs when using max()
Content-Type: text/plain; charset="UTF-8"
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Florian Weimer <fweimer@redhat.com>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 16, 2018 at 1:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It does not work with gcc-4.1.x, but works with gcc-4.4.x.
>
> I can't seem to see the errors any way, I wonder if
> __builtin_choose_expr() simply didn't exist back then.

No, that goes further back.

It seems to be -Wvla itself that doesn't exist in 4.1, so the test
build failed simply because I used that flag ;)

               Linus
