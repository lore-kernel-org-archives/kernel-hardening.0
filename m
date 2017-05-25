Date: Thu, 25 May 2017 16:52:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20170525165226.a2a1064741d7a7ef66ef21b3@linux-foundation.org>
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

i386 allmodconfig, gcc-6.3.0:

In file included from ./arch/x86/include/asm/string.h:2:0,
                 from ./include/linux/string.h:18,
                 from ./arch/x86/include/asm/page_32.h:34,
                 from ./arch/x86/include/asm/page.h:13,
                 from ./arch/x86/include/asm/thread_info.h:11,
                 from ./include/linux/thread_info.h:37,
                 from ./arch/x86/include/asm/preempt.h:6,
                 from ./include/linux/preempt.h:80,
                 from ./include/linux/spinlock.h:50,
                 from ./include/linux/seqlock.h:35,
                 from ./include/linux/time.h:5,
                 from ./include/linux/stat.h:18,
                 from ./include/linux/module.h:10,
                 from drivers/acpi/ac.c:23:
./include/linux/string.h: In function 'acpi_ac_add':
./arch/x86/include/asm/string_32.h:182:25: error: inlining failed in call to always_inline '__builtin_memcpy': function body not available
 #define memcpy(t, f, n) __builtin_memcpy(t, f, n)
                         ^
./include/linux/string.h:301:24: note: in expansion of macro 'memcpy'
 __FORTIFY_INLINE void *memcpy(void *p, const void *q, __kernel_size_t size)
                        ^~~~~~
In file included from ./arch/x86/include/asm/page_32.h:34:0,
                 from ./arch/x86/include/asm/page.h:13,
                 from ./arch/x86/include/asm/thread_info.h:11,
                 from ./include/linux/thread_info.h:37,
                 from ./arch/x86/include/asm/preempt.h:6,
                 from ./include/linux/preempt.h:80,
                 from ./include/linux/spinlock.h:50,
                 from ./include/linux/seqlock.h:35,
                 from ./include/linux/time.h:5,
                 from ./include/linux/stat.h:18,
                 from ./include/linux/module.h:10,
                 from drivers/acpi/ac.c:23:
./include/linux/string.h:204:10: note: called from here
   return __builtin_strcpy(p, q);
          ^~~~~~~~~~~~~~~~~~~~~~
In file included from ./arch/x86/include/asm/string.h:2:0,
                 from ./include/linux/string.h:18,
                 from ./arch/x86/include/asm/page_32.h:34,
                 from ./arch/x86/include/asm/page.h:13,
                 from ./arch/x86/include/asm/thread_info.h:11,
                 from ./include/linux/thread_info.h:37,
                 from ./arch/x86/include/asm/preempt.h:6,
                 from ./include/linux/preempt.h:80,
                 from ./include/linux/spinlock.h:50,
                 from ./include/linux/seqlock.h:35,
                 from ./include/linux/time.h:5,
                 from ./include/linux/stat.h:18,
                 from ./include/linux/module.h:10,
                 from drivers/acpi/ac.c:23:
./arch/x86/include/asm/string_32.h:182:25: error: inlining failed in call to always_inline '__builtin_memcpy': function body not available
 #define memcpy(t, f, n) __builtin_memcpy(t, f, n)
                         ^
./include/linux/string.h:301:24: note: in expansion of macro 'memcpy'
 __FORTIFY_INLINE void *memcpy(void *p, const void *q, __kernel_size_t size)
                        ^~~~~~
In file included from ./arch/x86/include/asm/page_32.h:34:0,
                 from ./arch/x86/include/asm/page.h:13,
                 from ./arch/x86/include/asm/thread_info.h:11,
                 from ./include/linux/thread_info.h:37,
                 from ./arch/x86/include/asm/preempt.h:6,
                 from ./include/linux/preempt.h:80,
                 from ./include/linux/spinlock.h:50,
                 from ./include/linux/seqlock.h:35,
                 from ./include/linux/time.h:5,
                 from ./include/linux/stat.h:18,
                 from ./include/linux/module.h:10,
                 from drivers/acpi/ac.c:23:
./include/linux/string.h:204:10: note: called from here
   return __builtin_strcpy(p, q);
          ^~~~~~~~~~~~~~~~~~~~~~
make[1]: *** [drivers/acpi/ac.o] Error 1
make: *** [drivers/acpi/ac.o] Error 2
