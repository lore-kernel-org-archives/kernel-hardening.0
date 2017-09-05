MIME-Version: 1.0
In-Reply-To: <20170905193754.GD5024@atomide.com>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
 <20170905164547.GA5024@atomide.com> <CAKv+Gu_eT_eK9Tj4JvWSsK+iW9juGG6xYDO15umu6jBkoun8ew@mail.gmail.com>
 <20170905193754.GD5024@atomide.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 5 Sep 2017 20:42:14 +0100
Message-ID: <CAKv+Gu9c_j0qriRazSTmq8eD9icCu4Wuzw1z-LF7bubLVLQd7Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 00/29] implement KASLR for ARM
To: Tony Lindgren <tony@atomide.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 5 September 2017 at 20:37, Tony Lindgren <tony@atomide.com> wrote:
> * Ard Biesheuvel <ard.biesheuvel@linaro.org> [170905 09:49]:
>> On 5 September 2017 at 17:45, Tony Lindgren <tony@atomide.com> wrote:
>> > I did see boot attempts fail with randomize enable where no output
>> > was produced. It seems this is happening for me maybe 1 out of 5 boots.
>> > Enabling DEBUG_LL did not show anything either.
>> >
>>
>> Yes. I am looking into a couple of kernelci boot reports that look
>> suspicious, but it is rather difficult to reproduce, for obvious
>> reasons :-)
>>
>> Which hardware are you testing this on?
>
> For testing on omap3, I'm mostly using logicpd torpedo devkit as
> it works out of box with PM with mainline Linux and has NFSroot
> usable too.
>

Right. Well, I will try to reproduce with the BB white I have.

Are you booting with an initrd?

>> > Then loading modules with CONFIG_RANDOMIZE_BASE=y seems to fail with:
>> >
>> > $ sudo modprobe rtc-twl
>> > rtc_twl: disagrees about version of symbol module_layout
>> > modprobe: ERROR: could not insert 'rtc_twl': Exec format error
>> >
>>
>> Is this with CONFIG_MODVERSIONS enabled?
>
> Yes, but disabling that did not seem to make any difference
> based on just one test.
>

Yeah, well, it appears I missed a couple of details :-)

This should fix the module loading issues:

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1a0304dd388d..bbefd5f32ec2 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1830,6 +1830,8 @@ config RANDOMIZE_BASE
  depends on MMU && AUTO_ZRELADDR
  depends on !XIP_KERNEL && !ZBOOT_ROM
  select RELOCATABLE
+ select ARM_MODULE_PLTS if MODULES
+ select MODULE_REL_CRCS if MODVERSIONS
  help
   Randomizes the virtual and physical address at which the kernel
   image is loaded, as a security feature that deters exploit attempts
diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
index f13ae153fb24..b56fc4dd27b6 100644
--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -50,6 +50,7 @@ typedef struct user_fp elf_fpregset_t;
 #define R_ARM_NONE 0
 #define R_ARM_PC24 1
 #define R_ARM_ABS32 2
+#define R_ARM_REL32 3
 #define R_ARM_CALL 28
 #define R_ARM_JUMP24 29
 #define R_ARM_TARGET1 38
diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index 3ff571c2c71c..aa4d72837cd5 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -175,6 +175,10 @@
  *(u32 *)loc |= offset & 0x7fffffff;
  break;

+ case R_ARM_REL32:
+ *(u32 *)loc += sym->st_value - loc;
+ break;
+
  case R_ARM_MOVW_ABS_NC:
  case R_ARM_MOVT_ABS:
  offset = tmp = __mem_to_opcode_arm(*(u32 *)loc);
