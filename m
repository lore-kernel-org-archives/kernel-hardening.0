Date: Tue, 23 May 2017 15:48:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20170523154823.4c1a09171e1ce3de8740156f@linux-foundation.org>
In-Reply-To: <20170522231025.30463-1-danielmicay@gmail.com>
References: <20170522231025.30463-1-danielmicay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3] add the option of fortified string.h functions
To: Daniel Micay <danielmicay@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-kernel <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Daniel Axtens <dja@axtens.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 22 May 2017 19:10:25 -0400 Daniel Micay <danielmicay@gmail.com> wrote:

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

Confused by the final paragraph.  The patch adds CONFIG_FORTIFY_SOURCE
so isn't that to-do item completed?

Also, what does __NO_FORTIFY do?  Nothing ever defines it?
