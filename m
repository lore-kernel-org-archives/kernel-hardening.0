References: <1484789346-21012-1-git-send-email-labbott@redhat.com>
 <1484789346-21012-3-git-send-email-labbott@redhat.com>
 <5005f110-2279-9ac7-c9c5-1894b8f6387d@arm.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <c7182933-b255-78a1-178b-798262035272@redhat.com>
Date: Wed, 25 Jan 2017 12:44:14 +0100
MIME-Version: 1.0
In-Reply-To: <5005f110-2279-9ac7-c9c5-1894b8f6387d@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 2/2] security: Change name of CONFIG_DEBUG_SET_MODULE_RONX
To: Robin Murphy <robin.murphy@arm.com>
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, linux-doc@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>, kernel-hardening@lists.openwall.com, Rob Herring <robh@kernel.org>, Jessica Yu <jeyu@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Helge Deller <deller@gmx.de>, x86@kernel.org, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Len Brown <len.brown@intel.com>, linux-s390@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 01/19/2017 12:43 PM, Robin Murphy wrote:
> Hi Laura,
>
> On 19/01/17 01:29, Laura Abbott wrote:
>>
>> Despite the word 'debug' in CONFIG_DEBUG_SET_MODULE_RONX, this kernel
>> option provides key security features that are to be expected on a
>> modern system. Change the name to CONFIG_HARDENED_MODULE_MAPPINGS which
>> more accurately describes what this option is intended to do.
>>
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>> ---
>
> [...]
>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index 09aff28..ef852e4 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -8,6 +8,7 @@ config ARM
>>  	select ARCH_HAVE_CUSTOM_GPIO_H
>>  	select ARCH_HAS_GCOV_PROFILE_ALL
>>  	select ARCH_HAS_HARDENED_MAPPINGS if MMU && !XIP_KERNEL
>> +	select ARCH_HAS_HARDENED_MODULE_MAPPINGS if MMU
>>  	select ARCH_MIGHT_HAVE_PC_PARPORT
>>  	select ARCH_SUPPORTS_ATOMIC_RMW
>>  	select ARCH_USE_BUILTIN_BSWAP
>> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
>> index d83f7c3..426d271 100644
>> --- a/arch/arm/Kconfig.debug
>> +++ b/arch/arm/Kconfig.debug
>> @@ -1738,17 +1738,6 @@ config PID_IN_CONTEXTIDR
>>  	  additional instructions during context switch. Say Y here only if you
>>  	  are planning to use hardware trace tools with this kernel.
>>
>> -config DEBUG_SET_MODULE_RONX
>> -	bool "Set loadable kernel module data as NX and text as RO"
>> -	depends on MODULES && MMU
>> -	---help---
>> -	  This option helps catch unintended modifications to loadable
>> -	  kernel module's text and read-only data. It also prevents execution
>> -	  of module data. Such protection may interfere with run-time code
>> -	  patching and dynamic kernel tracing - and they might also protect
>> -	  against certain classes of kernel exploits.
>> -	  If in doubt, say "N".
>> -
>>  source "drivers/hwtracing/coresight/Kconfig"
>>
>>  endmenu
>
> [...]
>
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -12,6 +12,7 @@ config ARM64
>>  	select ARCH_HAS_GCOV_PROFILE_ALL
>>  	select ARCH_HAS_GIGANTIC_PAGE
>>  	select ARCH_HAS_HARDENED_MAPPINGS
>> +	select ARCH_HAS_HARDENED_MODULE_MAPPINGS
>>  	select ARCH_HAS_KCOV
>>  	select ARCH_HAS_SG_CHAIN
>>  	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
>> diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
>> index a26d27f..1eebe1f 100644
>> --- a/arch/arm64/Kconfig.debug
>> +++ b/arch/arm64/Kconfig.debug
>> @@ -71,17 +71,6 @@ config DEBUG_WX
>>
>>  	  If in doubt, say "Y".
>>
>> -config DEBUG_SET_MODULE_RONX
>> -	bool "Set loadable kernel module data as NX and text as RO"
>> -	depends on MODULES
>> -	default y
>> -	help
>> -	  Is this is set, kernel module text and rodata will be made read-only.
>> -	  This is to help catch accidental or malicious attempts to change the
>> -	  kernel's executable code.
>> -
>> -	  If in doubt, say Y.
>> -
>>  config DEBUG_ALIGN_RODATA
>>  	depends on ARCH_HAS_HARDENED_MAPPINGS
>>  	bool "Align linker sections up to SECTION_SIZE"
>
> [...]
>
>> --- a/arch/s390/Kconfig
>> +++ b/arch/s390/Kconfig
>> @@ -69,6 +69,7 @@ config S390
>>  	select ARCH_HAS_GCOV_PROFILE_ALL
>>  	select ARCH_HAS_GIGANTIC_PAGE
>>  	select ARCH_HAS_HARDENED_MAPPINGS
>> +	select ARCH_HAS_HARDENED_MODULE_MAPPINGS
>>  	select ARCH_HAS_KCOV
>>  	select ARCH_HAS_SG_CHAIN
>>  	select ARCH_HAS_UBSAN_SANITIZE_ALL
>> diff --git a/arch/s390/Kconfig.debug b/arch/s390/Kconfig.debug
>> index 26c5d5be..57f8ea9 100644
>> --- a/arch/s390/Kconfig.debug
>> +++ b/arch/s390/Kconfig.debug
>> @@ -17,7 +17,4 @@ config S390_PTDUMP
>>  	  kernel.
>>  	  If in doubt, say "N"
>>
>> -config DEBUG_SET_MODULE_RONX
>> -	def_bool y
>> -	depends on MODULES
>>  endmenu
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 9d80cd8..38ce850 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -51,6 +51,7 @@ config X86
>>  	select ARCH_HAS_FAST_MULTIPLIER
>>  	select ARCH_HAS_GCOV_PROFILE_ALL
>>  	select ARCH_HAS_HARDENED_MAPPINGS
>> +	select ARCH_HAS_HARDENED_MODULE_MAPPINGS
>>  	select ARCH_HAS_KCOV			if X86_64
>>  	select ARCH_HAS_MMIO_FLUSH
>>  	select ARCH_HAS_PMEM_API		if X86_64
>> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
>> index 67eec55..69cdd0b 100644
>> --- a/arch/x86/Kconfig.debug
>> +++ b/arch/x86/Kconfig.debug
>> @@ -109,17 +109,6 @@ config DEBUG_WX
>>
>>  	  If in doubt, say "Y".
>>
>> -config DEBUG_SET_MODULE_RONX
>> -	bool "Set loadable kernel module data as NX and text as RO"
>> -	depends on MODULES
>> -	---help---
>> -	  This option helps catch unintended modifications to loadable
>> -	  kernel module's text and read-only data. It also prevents execution
>> -	  of module data. Such protection may interfere with run-time code
>> -	  patching and dynamic kernel tracing - and they might also protect
>> -	  against certain classes of kernel exploits.
>> -	  If in doubt, say "N".
>> -
>>  config DEBUG_NX_TEST
>>  	tristate "Testcase for the NX non-executable stack feature"
>>  	depends on DEBUG_KERNEL && m
>
> [...]
>
>> --- a/security/Kconfig
>> +++ b/security/Kconfig
>> @@ -174,6 +174,22 @@ config HARDENED_PAGE_MAPPINGS
>>  	  Unless your system has known restrictions or performance issues, it
>>  	  is recommended to say Y here.
>>
>> +config ARCH_HAS_HARDENED_MODULE_MAPPINGS
>> +	def_bool n
>> +
>> +config HARDENED_MODULE_MAPPINGS
>> +	bool "Mark module mappings with stricter permissions (RO/W^X)"
>> +	default y
>> +	depends on ARCH_HAS_HARDENED_MODULE_MAPPINGS
>
> It would seem that this ends up losing the previous dependency on
> MODULES - is that intentional?
>
> Robin.
>

(Apologies, my SMTP was set up incorrectly so this didn't actually
get sent out when I thought it did)

No, good catch. I missed re-adding that when doing the refactoring.

Thanks,
Laura

>>
>
