Date: Fri, 5 May 2017 11:52:47 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170505105247.GC699@leverpostej>
References: <20170504142435.10175-1-danielmicay@gmail.com>
 <20170504154850.GE20461@leverpostej>
 <1493920184.1596.4.camel@gmail.com>
 <20170504180917.GB19929@leverpostej>
 <20170505103839.GB699@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170505103839.GB699@leverpostej>
Subject: Re: [kernel-hardening] [PATCH] add the option of fortified string.h
 functions
To: Daniel Micay <danielmicay@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 05, 2017 at 11:38:39AM +0100, Mark Rutland wrote:
> On Thu, May 04, 2017 at 07:09:17PM +0100, Mark Rutland wrote:
> From a walk up the call chain, I saw mm/kasan/kasan.c's memcpy was being
> called recursively. Somehow the fortified memcpy() instrumentation
> results in kasan's memcpy() calling itself rather than __memcpy().
> 
> The resulting stack overflow ends up clobbering the vectors (adn
> everythigg else) as this is happening early at boot when everything is
> mapepd RW.
> 
> That can be avoided with:
> 
> ---->8----
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index f742596..b5327f5 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -18,7 +18,8 @@ cflags-$(CONFIG_EFI_ARMSTUB)  += -I$(srctree)/scripts/dtc/libfdt
>  
>  KBUILD_CFLAGS                  := $(cflags-y) -DDISABLE_BRANCH_PROFILING \
>                                    $(call cc-option,-ffreestanding) \
> -                                  $(call cc-option,-fno-stack-protector)
> +                                  $(call cc-option,-fno-stack-protector) \
> +                                  -D__NO_FORTIFY
>  
>  GCOV_PROFILE                   := n
>  KASAN_SANITIZE                 := n
> ---->8----

Whoops; wrong diff. That should have been:

---->8----
diff --git a/mm/kasan/Makefile b/mm/kasan/Makefile
index 2976a9e..747423b 100644
--- a/mm/kasan/Makefile
+++ b/mm/kasan/Makefile
@@ -5,6 +5,7 @@ KCOV_INSTRUMENT := n
 CFLAGS_REMOVE_kasan.o = -pg
 # Function splitter causes unnecessary splits in __asan_load1/__asan_store1
 # see: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63533
-CFLAGS_kasan.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
+CFLAGS_kasan.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) \
+                 -D__NO_FORTIFY
 
 obj-y := kasan.o report.o kasan_init.o quarantine.o
---->8----

Thanks,
Mark.
