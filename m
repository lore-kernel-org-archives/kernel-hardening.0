From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v4 0/2] Remove false-positive VLAs when using max()
Date: Thu, 15 Mar 2018 12:47:44 -0700
Message-Id: <1521143266-31350-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input@vger.kernel.org, linux-btrfs@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

I'm calling this "v4" since the last effort at this was v3, even
if it's a different approach. Patch 1 adds const_max(), patch 2
uses it in all the places max() was used for stack arrays. Commit
log from patch 1:

---snip---
kernel.h: Introduce const_max() for VLA removal

In the effort to remove all VLAs from the kernel[1], it is desirable to
build with -Wvla. However, this warning is overly pessimistic, in that
it is only happy with stack array sizes that are declared as constant
expressions, and not constant values. One case of this is the evaluation
of the max() macro which, due to its construction, ends up converting
constant expression arguments into a constant value result. Attempts
to adjust the behavior of max() ran afoul of version-dependent compiler
behavior[2].

To work around this and still gain -Wvla coverage, this patch introduces
a new macro, const_max(), for use in these cases of stack array size
declaration, where the constant expressions are retained. Since this means
losing the double-evaluation protections of the max() macro, this macro is
designed to explicitly fail if used on non-constant arguments.

Older compilers will fail with the unhelpful message:

    error: first argument to ‘__builtin_choose_expr’ not a constant

Newer compilers will fail with a hopefully more helpful message:

    error: call to ‘__error_not_const_arg’ declared with attribute error: const_max() used with non-compile-time constant arg

To gain the ability to compare differing types, the arguments are
explicitly cast to size_t. Without this, some compiler versions will
fail when comparing different enum types or similar constant expression
cases. With the casting, it's possible to do things like:

int foo[const_max(6, sizeof(something))];

[1] https://lkml.org/lkml/2018/3/7/621
[2] https://lkml.org/lkml/2018/3/10/170
---eol---

Hopefully this reads well as a summary from all the things that got tried.
I've tested this on allmodconfig builds with gcc 4.4.4 and 6.3.0, with and
without -Wvla.

-Kees
