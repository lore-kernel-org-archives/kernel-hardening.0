MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170619024259.6560-1-danielmicay@gmail.com>
References: <20170619024259.6560-1-danielmicay@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Jun 2017 14:02:42 -0700
Message-ID: <CAGXu5j+eyVvedBxBHhMLCx7G5V9b5T+GD4t7KXGiL03iR11z1w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5] add the option of fortified string.h functions
To: Daniel Micay <danielmicay@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-kernel <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Daniel Axtens <dja@axtens.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 18, 2017 at 7:42 PM, Daniel Micay <danielmicay@gmail.com> wrote:
> This adds support for compiling with a rough equivalent to the glibc
> _FORTIFY_SOURCE=1 feature, providing compile-time and runtime buffer
> overflow checks for string.h functions when the compiler determines the
> size of the source or destination buffer at compile-time. Unlike glibc,
> it covers buffer reads in addition to writes.
>
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
> * Extending coverage to more string functions like strlcat.
>
> * It should be possible to optionally use __builtin_object_size(x, 1) for
>   some functions (C strings) to detect intra-object overflows (like
>   glibc's _FORTIFY_SOURCE=2), but for now this takes the conservative
>   approach to avoid likely compatibility issues.
>
> * The compile-time checks should be made available via a separate config
>   option which can be enabled by default (or always enabled) once enough
>   time has passed to get the issues it catches fixed.
>
> Signed-off-by: Daniel Micay <danielmicay@gmail.com>
> ---
> Changes since v4:
> - avoid overly aggressive strnlen check for non-null-terminated strings

Thanks! I've resent this (with my addition of ARCH_HAS_FORTIFY_SOURCE)
and the remaining tree fixes for inclusion into -mm. I also have it
here:
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=for-next/fortify

-Kees

-- 
Kees Cook
Pixel Security
