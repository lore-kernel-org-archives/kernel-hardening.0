Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAKv+Gu8_FHVwmerw1aMkNGGn=7NtuWnuSBCXHBsSZXCNRRU7KA@mail.gmail.com>
References: <20160216214904.GA23723@www.outflux.net>
	<56C59DC5.19217.28FA99@pageexec.freemail.hu>
	<CAKv+Gu_ABQa4L7ZzHMD+-BPLtJf_UO9TfLy0jKFLfCsyQE6dLQ@mail.gmail.com>
	<3013719.NTkGVd5eeC@wuerfel>
	<CAKv+Gu8_FHVwmerw1aMkNGGn=7NtuWnuSBCXHBsSZXCNRRU7KA@mail.gmail.com>
Date: Thu, 18 Feb 2016 12:04:15 -0800
Message-ID: <CAGXu5j+myeZWciWaSoYb6XjUGBpg7D5rYP04zEA3W8VdUfFsSA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] lkdtm: add test for executing .rodata
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Laura Abbott <labbott@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Rutland <mark.rutland@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 18, 2016 at 4:46 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On 18 February 2016 at 13:07, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Thursday 18 February 2016 12:34:50 Ard Biesheuvel wrote:
>>>
>>> We have __section() as an alias for __attribute__((__section__())), so
>>> we could use that instead.
>>>
>>> However, that does not fix the issue Kees is trying to solve, where a
>>> .rodata section is emitted with the "x" bit set, which causes the
>>> linker to complain:
>>>
>>> /tmp/cc50ffWw.s: Assembler messages:
>>> /tmp/cc50ffWw.s:2: Warning: setting incorrect section attributes for
>>> .rodata.text
>>>
>>> I wonder if we could get away with doing something like
>>>
>>> AFLAGS_lkdtm.o += -Wa,-W
>>>
>>> here? This just hides the warnings, but may result in the .rodata
>>> section in the vmlinux file to have X permissions as well. I don't
>>> think anyone uses an ELF loader to load their kernel, but who knows
>>> ...
>>
>> Don't we also get a warning when we link objects with conflicting
>> section attributes?
>>
>
> I didn't see one
>
>> Maybe a solution would be to define a separate section for this one
>> function, and then use a linker script to move it into .rodata?
>> Or maybe "objcopy --set-section-flags  --rename-section"?
>>
>
> I think objcopy is the easiest.

I came to the same conclusion while thinking about it last night. I'm
having a terrible time implementing it in kbuild, though. The
"objcopy" function expects to rename the files, and I can't find a way
to just add it on without breaking the module build.

The flags I'm using that seem to actually do what's needed are (when
using the section name ".text.rodata"):

OBJCOPYFLAGS_lkdtm.o := --set-section-flags .text.rodata=alloc,readonly \
                        --rename-section .text.rodata=.rodata

So the diff against my existing patch looks like this, and works for
CONFIG_LKDTM=y (sorry for whitespace damage...):

diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 537d7f3b78da..55ce014e6b62 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -14,7 +14,7 @@ obj-$(CONFIG_BMP085_I2C)      += bmp085-i2c.o
 obj-$(CONFIG_BMP085_SPI)       += bmp085-spi.o
 obj-$(CONFIG_DUMMY_IRQ)                += dummy-irq.o
 obj-$(CONFIG_ICS932S401)       += ics932s401.o
-obj-$(CONFIG_LKDTM)            += lkdtm.o
+obj-$(CONFIG_LKDTM)            += lkdtm_objcopy.o
 obj-$(CONFIG_TIFM_CORE)        += tifm_core.o
 obj-$(CONFIG_TIFM_7XX1)        += tifm_7xx1.o
 obj-$(CONFIG_PHANTOM)          += phantom.o
@@ -56,3 +56,8 @@ obj-$(CONFIG_GENWQE)          += genwqe/
 obj-$(CONFIG_ECHO)             += echo/
 obj-$(CONFIG_VEXPRESS_SYSCFG)  += vexpress-syscfg.o
 obj-$(CONFIG_CXL_BASE)         += cxl/
+
+OBJCOPYFLAGS_lkdtm_objcopy.o := --set-section-flags
.text.rodata=alloc,readonly \
+                       --rename-section .text.rodata=.rodata
+$(obj)/lkdtm_objcopy.o: $(obj)/lkdtm.o FORCE
+       $(call if_changed,objcopy)
diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index b15d08ff71a9..5868e5125fbe 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -317,8 +317,7 @@ static int recursive_loop(int remaining)
                return recursive_loop(remaining - 1);
 }

-static void __attribute__((__section__(".rodata,\"a\",\%progbits;//")))
-do_nothing_rodata(void)
+static void __section(.text.rodata) do_nothing_rodata(void)
 {
        return;
 }


But fails in ways I don't understand for CONFIG_LKDTM=m:

./scripts/Makefile.build:264: warning: overriding commands for target `drivers/m
isc/lkdtm_objcopy.o'
drivers/misc/Makefile:63: warning: ignoring old commands for target `drivers/mis
c/lkdtm_objcopy.o'
make[2]: *** No rule to make target `drivers/misc/lkdtm_objcopy.c', needed by `d
rivers/misc/lkdtm_objcopy.o'.  Stop.
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers/misc] Error 2
make[1]: *** Waiting for unfinished jobs....

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
