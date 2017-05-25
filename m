Message-ID: <1495671852.10180.4.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Wed, 24 May 2017 20:24:12 -0400
In-Reply-To: <CAGXu5jKmJgH1Ez+Ps=fGPvxga0SPaZGiPMcZzagLxnrNe7Sdsg@mail.gmail.com>
References: <20170522231025.30463-1-danielmicay@gmail.com>
	 <20170523154823.4c1a09171e1ce3de8740156f@linux-foundation.org>
	 <CAGXu5jKmJgH1Ez+Ps=fGPvxga0SPaZGiPMcZzagLxnrNe7Sdsg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3] add the option of fortified string.h functions
To: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-kernel <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Daniel Axtens <dja@axtens.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2017-05-23 at 19:12 -0700, Kees Cook wrote:
> On Tue, May 23, 2017 at 3:48 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Mon, 22 May 2017 19:10:25 -0400 Daniel Micay <danielmicay@gmail.c
> > om> wrote:
> > 
> > > This adds support for compiling with a rough equivalent to the
> > > glibc
> > > _FORTIFY_SOURCE=1 feature, providing compile-time and runtime
> > > buffer
> > > overflow checks for string.h functions when the compiler
> > > determines the
> > > size of the source or destination buffer at compile-time. Unlike
> > > glibc,
> > > it covers buffer reads in addition to writes.
> > > 
> > > GNU C __builtin_*_chk intrinsics are avoided because they would
> > > force a
> > > much more complex implementation. They aren't designed to detect
> > > read
> > > overflows and offer no real benefit when using an implementation
> > > based
> > > on inline checks. Inline checks don't add up to much code size and
> > > allow
> > > full use of the regular string intrinsics while avoiding the need
> > > for a
> > > bunch of _chk functions and per-arch assembly to avoid wrapper
> > > overhead.
> > > 
> > > This detects various overflows at compile-time in various drivers
> > > and
> > > some non-x86 core kernel code. There will likely be issues caught
> > > in
> > > regular use at runtime too.
> > > 
> > > Future improvements left out of initial implementation for
> > > simplicity,
> > > as it's all quite optional and can be done incrementally:
> > > 
> > > * Some of the fortified string functions (strncpy, strcat), don't
> > > yet
> > >   place a limit on reads from the source based on
> > > __builtin_object_size of
> > >   the source buffer.
> > > 
> > > * Extending coverage to more string functions like strlcat.
> > > 
> > > * It should be possible to optionally use __builtin_object_size(x,
> > > 1) for
> > >   some functions (C strings) to detect intra-object overflows
> > > (like
> > >   glibc's _FORTIFY_SOURCE=2), but for now this takes the
> > > conservative
> > >   approach to avoid likely compatibility issues.
> > > 
> > > * The compile-time checks should be made available via a separate
> > > config
> > >   option which can be enabled by default (or always enabled) once
> > > enough
> > >   time has passed to get the issues it catches fixed.
> > 
> > Confused by the final paragraph.  The patch adds
> > CONFIG_FORTIFY_SOURCE
> > so isn't that to-do item completed?
> 
> Right now FORTIFY_SOURCE performs two checks: compile-time (when both
> sizes can be determined) and run-time (when only destination size can
> be determined). They could be split, if it ever makes sense to do so.
> For example, the compile-time checks could be made mandatory once all
> fixes everywhere else have stabilized, and split the run-time checks
> as a new CONFIG (since they technically do add a small bump to .text
> size). I think maybe the best option for the future would be to just
> make the compile-time checks mandatory and have CONFIG_FORTIFY_SOURCE
> just cover the runtime checks. But let's see how far we get as-is.

It'll add a bit of complexity and we'll need to make sure to avoid
causing any performance hit for the compile-time-only mode.

The compile-time checks might also be incredibly annoying with Clang. I
think it might currently ignore the error attribute, so instead of an
error comprehensible to a human it will instead cause a linker error
later on with no context tied to the source code. The runtime checks
should work fine with Clang already unlike the approach in glibc.

> > Also, what does __NO_FORTIFY do?  Nothing ever defines it?
> 
> It's used to disable FORTIFY coverage as needed in the build. It's
> used in this patch already to avoid collision with KASan.

KASan instruments the memcpy, memmove and memset symbols to perform the
sanitizer checking for them.

It needs to bypass that when instrumentation is supposed to be disabled
so the kernel uses a hack where it #defines memcpy as __memcpy, which
bypasses the instrumented KASan functions. So __NO_FORTIFY gets used
there to avoid the KASan hack from causing strange interactions with the
fortify code. It ends up turning the fortified memcpy into fortified
__memcpy with that define and makes it call memcpy via __builtin_memcpy
resulting in KASan false positives by instrumenting calls that it is
trying to leave uninstrumented.

Someone might be able to come up with a better solution like using the
same __RENAME trick for KASan instead of that #define hack, but it only
turns of fortify coverage for a *tiny* amount of code and only in KASan
builds, so I don't think it's worth worrying too much about.

> I've been sending fixes for things that FORTIFY detected, and most
> have been taken by various maintainers. Do you want to carry the
> remaining fixes I have in my kssp/fortify tree, or should I keep
> pestering maintainers? I can recheck -next to see which are
> outstanding and send them to you...

   1. It's also only the start of it since it's primarily the ones with
      compile-time read/write sizes which are probably all fixed now other
      than some architecture-specific ones. The runtime checks extend the
      coverage a lot, and it'll grow some more with alloc_size markers and
      some other changes.
