Date: Fri, 5 May 2017 11:38:39 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170505103839.GB699@leverpostej>
References: <20170504142435.10175-1-danielmicay@gmail.com>
 <20170504154850.GE20461@leverpostej>
 <1493920184.1596.4.camel@gmail.com>
 <20170504180917.GB19929@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170504180917.GB19929@leverpostej>
Subject: Re: [kernel-hardening] [PATCH] add the option of fortified string.h
 functions
To: Daniel Micay <danielmicay@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 04, 2017 at 07:09:17PM +0100, Mark Rutland wrote:
> On Thu, May 04, 2017 at 01:49:44PM -0400, Daniel Micay wrote:
> > On Thu, 2017-05-04 at 16:48 +0100, Mark Rutland wrote:

> > > ... with an EFI stub fortify_panic() hacked in, I can build an arm64
> > > kernel with this applied. It dies at some point after exiting EFI
> > > boot services; i don't know whether it made it out of the stub and
> > > into the kernel proper.
> > 
> > Could start with #define __NO_FORTIFY above the #include sections there
> > instead (or -D__NO_FORTIFY as a compiler flag), which will skip
> > fortifying those for now.
> 
> Neat. Given there are a few files, doing the latter for the stub is the
> simplest option.
> 
> > I'm successfully using this on a non-EFI ARM64 3.18 LTS kernel, so it
> > should be close to working on other systems (but not necessarily with
> > messy drivers). The x86 EFI workaround works.
> 
> FWIW, I've been playing atop of next-20170504, with a tonne of other
> debug options enabled (including KASAN_INLINE).
> 
> From a quick look with a JTAG debugger, the CPU got out of the stub and
> into the kernel. It looks like it's dying initialising KASAN, where the
> vectors appear to have been corrupted.

>From a walk up the call chain, I saw mm/kasan/kasan.c's memcpy was being
called recursively. Somehow the fortified memcpy() instrumentation
results in kasan's memcpy() calling itself rather than __memcpy().

The resulting stack overflow ends up clobbering the vectors (adn
everythigg else) as this is happening early at boot when everything is
mapepd RW.

That can be avoided with:

---->8----
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index f742596..b5327f5 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -18,7 +18,8 @@ cflags-$(CONFIG_EFI_ARMSTUB)  += -I$(srctree)/scripts/dtc/libfdt
 
 KBUILD_CFLAGS                  := $(cflags-y) -DDISABLE_BRANCH_PROFILING \
                                   $(call cc-option,-ffreestanding) \
-                                  $(call cc-option,-fno-stack-protector)
+                                  $(call cc-option,-fno-stack-protector) \
+                                  -D__NO_FORTIFY
 
 GCOV_PROFILE                   := n
 KASAN_SANITIZE                 := n
---->8----

... though it's a worring that __memcpy() is overridden. I think we need
to be more careful with the way we instrument the string functions.

FWIW, with that, and the previous bits, I can boot a next-20170504
kernel with this applied.

However, I get a KASAN splat from the SLUB init code, even though that's
deliberately not instrumented by KASAN:

[    0.000000] ==================================================================
[    0.000000] BUG: KASAN: slab-out-of-bounds in kmem_cache_alloc+0x2ec/0x438
[    0.000000] Write of size 352 at addr ffff800936802000 by task swapper/0
[    0.000000] 
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.11.0-next-20170504-00002-g760cfdb-dirty #15
[    0.000000] Hardware name: ARM Juno development board (r1) (DT)
[    0.000000] Call trace:
[    0.000000] [<ffff2000080949c8>] dump_backtrace+0x0/0x538
[    0.000000] [<ffff2000080951a0>] show_stack+0x20/0x30
[    0.000000] [<ffff200008c125a0>] dump_stack+0x120/0x188
[    0.000000] [<ffff20000857ac04>] print_address_description+0x10c/0x380
[    0.000000] [<ffff20000857b354>] kasan_report+0x12c/0x3b8
[    0.000000] [<ffff200008579d54>] check_memory_region+0x144/0x1a0
[    0.000000] [<ffff20000857a1f4>] memset+0x2c/0x50
[    0.000000] [<ffff2000085730bc>] kmem_cache_alloc+0x2ec/0x438
[    0.000000] [<ffff20000a937528>] bootstrap+0x34/0x28c
[    0.000000] [<ffff20000a937804>] kmem_cache_init+0x84/0x118
[    0.000000] [<ffff20000a9014bc>] start_kernel+0x2f8/0x644
[    0.000000] [<ffff20000a9001e8>] __primary_switched+0x6c/0x74
[    0.000000] 
[    0.000000] Allocated by task 0:
[    0.000000] (stack is not available)
[    0.000000] 
[    0.000000] Freed by task 0:
[    0.000000] (stack is not available)
[    0.000000] 
[    0.000000] The buggy address belongs to the object at ffff800936802000
[    0.000000]  which belongs to the cache kmem_cache of size 352
[    0.000000] The buggy address is located 0 bytes inside of
[    0.000000]  352-byte region [ffff800936802000, ffff800936802160)
[    0.000000] The buggy address belongs to the page:
[    0.000000] page:ffff7e0024da0080 count:1 mapcount:0 mapping:          (null) index:0x0 compound_mapcount: 0
[    0.000000] flags: 0x1fffc00000008100(slab|head)
[    0.000000] raw: 1fffc00000008100 0000000000000000 0000000000000000 0000000180100010
[    0.000000] raw: dead000000000100 dead000000000200 ffff20000aa2c068 0000000000000000
[    0.000000] page dumped because: kasan: bad access detected
[    0.000000] 
[    0.000000] Memory state around the buggy address:
[    0.000000]  ffff800936801f00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    0.000000]  ffff800936801f80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    0.000000] >ffff800936802000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    0.000000]                    ^
[    0.000000]  ffff800936802080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    0.000000]  ffff800936802100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    0.000000] ==================================================================

Thanks,
Mark.
