MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170509041906.1089-1-danielmicay@gmail.com>
References: <20170509041906.1089-1-danielmicay@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 9 May 2017 14:37:19 -0700
Message-ID: <CAGXu5jKXk+DxNrtsbbZToi9ZBHOzbKhToPZnDmy2KovgRfiJOA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2] add the option of fortified string.h functions
To: Daniel Micay <danielmicay@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 8, 2017 at 9:19 PM, Daniel Micay <danielmicay@gmail.com> wrote:
> This adds support for compiling with a rough equivalent to the glibc
> _FORTIFY_SOURCE=1 feature, providing compile-time and runtime buffer
> overflow checks for string.h functions when the compiler determines the
> size of the source or destination buffer at compile-time. Unlike glibc,
> it covers buffer reads in addition to writes.

For folks doing testing of this, I've put a tree up here:
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=kspp/fortify

This includes stuff I've seen fixes for (including the two from Mark Rutland).

> GNU C __builtin_*_chk intrinsics are avoided because they would force a
> much more complex implementation. They aren't designed to detect read
> overflows and offer no real benefit when using an implementation based
> on inline checks. Inline checks don't add up to much code size and allow
> full use of the regular string intrinsics while avoiding the need for a
> bunch of _chk functions and per-arch assembly to avoid wrapper overhead.
>
> This detects various overflows at compile-time in various drivers and
> some non-x86 core kernel code. There will likely be issues caught in
> regular use at runtime too.
>
> Future improvements left out of initial implementation for simplicity,
> as it's all quite optional and can be done incrementally:
>
> * Some of the fortified string functions (strncpy, strcat), don't yet
>   place a limit on reads from the source based on __builtin_object_size of
>   the source buffer.
>
> * Extending coverage to more string functions (strlcpy, strlcat) and
>   perhaps making the memory buffer checks into something more reusable
>   for broader use.
>
> * It should be possible to optionally use __builtin_object_size(x, 1) for
>   some functions (C strings) to detect intra-object overflows (like
>   glibc's _FORTIFY_SOURCE=2), but for now this takes the conservative
>   approach to avoid likely compatibility issues.
>
> * The error reporting could be made friendlier by splitting up the
>   compile-time error for reads and writes.

I've implemented this in my tree.

> * The compile-time checks should be made available via a separate config
>   option which can be enabled by default (or always enabled) once enough
>   time has passed to get the issues it catches fixed.

Yeah, this would be nice to avoid entirely disabling it for things
like EFI stub, etc.

I suspect there will be a v3, but since this already works very nicely for me:

Acked-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
