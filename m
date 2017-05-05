MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170505105247.GC699@leverpostej>
References: <20170504142435.10175-1-danielmicay@gmail.com> <20170504154850.GE20461@leverpostej>
 <1493920184.1596.4.camel@gmail.com> <20170504180917.GB19929@leverpostej>
 <20170505103839.GB699@leverpostej> <20170505105247.GC699@leverpostej>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 5 May 2017 06:44:01 -0700
Message-ID: <CAGXu5jJFc7DtE5jcWYA6swgmRdn1ucXuNasxaOz3q118Ej1UsA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH] add the option of fortified string.h functions
To: Mark Rutland <mark.rutland@arm.com>
Cc: Daniel Micay <danielmicay@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 5, 2017 at 3:52 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Fri, May 05, 2017 at 11:38:39AM +0100, Mark Rutland wrote:
>> On Thu, May 04, 2017 at 07:09:17PM +0100, Mark Rutland wrote:
>> From a walk up the call chain, I saw mm/kasan/kasan.c's memcpy was being
>> called recursively. Somehow the fortified memcpy() instrumentation
>> results in kasan's memcpy() calling itself rather than __memcpy().
>>
>> The resulting stack overflow ends up clobbering the vectors (adn
>> everythigg else) as this is happening early at boot when everything is
>> mapepd RW.
>>
>> That can be avoided with:
>>
>> ---->8----
>> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
>> index f742596..b5327f5 100644
>> --- a/drivers/firmware/efi/libstub/Makefile
>> +++ b/drivers/firmware/efi/libstub/Makefile
>> @@ -18,7 +18,8 @@ cflags-$(CONFIG_EFI_ARMSTUB)  += -I$(srctree)/scripts/dtc/libfdt
>>
>>  KBUILD_CFLAGS                  := $(cflags-y) -DDISABLE_BRANCH_PROFILING \
>>                                    $(call cc-option,-ffreestanding) \
>> -                                  $(call cc-option,-fno-stack-protector)
>> +                                  $(call cc-option,-fno-stack-protector) \
>> +                                  -D__NO_FORTIFY
>>
>>  GCOV_PROFILE                   := n
>>  KASAN_SANITIZE                 := n
>> ---->8----
>
> Whoops; wrong diff. That should have been:
>
> ---->8----
> diff --git a/mm/kasan/Makefile b/mm/kasan/Makefile
> index 2976a9e..747423b 100644
> --- a/mm/kasan/Makefile
> +++ b/mm/kasan/Makefile
> @@ -5,6 +5,7 @@ KCOV_INSTRUMENT := n
>  CFLAGS_REMOVE_kasan.o = -pg
>  # Function splitter causes unnecessary splits in __asan_load1/__asan_store1
>  # see: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63533
> -CFLAGS_kasan.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
> +CFLAGS_kasan.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) \
> +                 -D__NO_FORTIFY
>
>  obj-y := kasan.o report.o kasan_init.o quarantine.o

I love this protection! It would have blocked a couple exploitable
bugs I saw recently.

Seems like a v2 could include an ARCH_HAS_FORTIFY or something to note
the architectures that have been build/run tested to deal with the
corner cases?

-Kees

-- 
Kees Cook
Pixel Security
