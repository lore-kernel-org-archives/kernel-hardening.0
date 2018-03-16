Date: Fri, 16 Mar 2018 17:55:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v5 0/2] Remove false-positive VLAs when using max()
Message-ID: <20180316175502.GE30522@ZenIV.linux.org.uk>
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
 <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com>
 <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Florian Weimer <fweimer@redhat.com>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 16, 2018 at 10:29:16AM -0700, Linus Torvalds wrote:
>    t.c: In function ‘test’:
>    t.c:6:6: error: argument to variable-length array is too large
> [-Werror=vla-larger-than=]
>      int array[(1,100)];
> 
> Gcc people are crazy.

That's not them, that's C standard regarding ICE.  1,100 is *not* a
constant expression as far as the standard is concerned, and that
type is actually a VLA with the size that can be optimized into
a compiler-calculated value.

Would you argue that in
void foo(char c)
{
	int a[(c<<1) + 10 - c + 2 - c];

a is not a VLA?  Sure, compiler probably would be able to reduce
that expression to 12, but demanding that to be recognized means
that compiler must do a bunch of optimizations in the middle of
typechecking.

expr, constant_expression is not a constant_expression.  And in
this particular case the standard is not insane - the only reason
for using that is typechecking and _that_ can be achieved without
violating 6.6p6:
	sizeof(expr,0) * 0 + ICE
*is* an integer constant expression, and it gives you exact same
typechecking.  So if somebody wants to play odd games, they can
do that just fine, without complicating the logics for compilers...
