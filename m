Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 10 Aug 2016 16:59:40 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
In-Reply-To: <CAJcbSZHGH8G01zXSE6y9A19ZxFYY0bzeqcfHBEAYZcn8ZeX3+g@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1608101658070.22028@cbobk.fhfr.pm>
References: <2206547.eDj3RJQyE5@vostro.rjw.lan> <2010434.TyoHiO9eal@vostro.rjw.lan> <alpine.LNX.2.00.1608100948560.22028@cbobk.fhfr.pm> <1779906.DOHeuFCiDy@vostro.rjw.lan> <alpine.LNX.2.00.1608101517380.22028@cbobk.fhfr.pm>
 <CAJcbSZHGH8G01zXSE6y9A19ZxFYY0bzeqcfHBEAYZcn8ZeX3+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [Resend][PATCH] x86/power/64: Always create temporary identity
 mapping correctly
To: Thomas Garnier <thgarnie@google.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Rafael J. Wysocki" <rafael@kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bpetkov@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 10 Aug 2016, Thomas Garnier wrote:

> What type of machines are you testing it on? What is the memory size? 
> Processor generation?

Mine is Lenovo thinkpad x200s; I think Boris has been testing it on x230s, 
but not sure whether any of the latest patches didn't actually fix it for 
him.

The machine I am seeing the issue on, has 2G RAM, with this e820 map:

 BIOS-e820: [mem 0x0000000000000000-0x000000000009ebff] usable
 BIOS-e820: [mem 0x000000000009ec00-0x000000000009ffff] reserved
 BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
 BIOS-e820: [mem 0x0000000000100000-0x000000007c4a0fff] usable
 BIOS-e820: [mem 0x000000007c4a1000-0x000000007c4a6fff] reserved
 BIOS-e820: [mem 0x000000007c4a7000-0x000000007c5b6fff] usable
 BIOS-e820: [mem 0x000000007c5b7000-0x000000007c60efff] reserved
 BIOS-e820: [mem 0x000000007c60f000-0x000000007c6c5fff] usable
 BIOS-e820: [mem 0x000000007c6c6000-0x000000007c6d0fff] ACPI NVS
 BIOS-e820: [mem 0x000000007c6d1000-0x000000007c6d3fff] ACPI data
 BIOS-e820: [mem 0x000000007c6d4000-0x000000007c6d7fff] reserved
 BIOS-e820: [mem 0x000000007c6d8000-0x000000007c6dbfff] ACPI NVS
 BIOS-e820: [mem 0x000000007c6dc000-0x000000007c6defff] reserved
 BIOS-e820: [mem 0x000000007c6df000-0x000000007c705fff] ACPI NVS
 BIOS-e820: [mem 0x000000007c706000-0x000000007c707fff] ACPI data
 BIOS-e820: [mem 0x000000007c708000-0x000000007c90efff] reserved
 BIOS-e820: [mem 0x000000007c90f000-0x000000007c99efff] ACPI NVS
 BIOS-e820: [mem 0x000000007c99f000-0x000000007c9fefff] ACPI data
 BIOS-e820: [mem 0x000000007c9ff000-0x000000007c9fffff] usable
 BIOS-e820: [mem 0x000000007cc00000-0x000000007effffff] reserved
 BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
 BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
 BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
 BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
 BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
 BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
 BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
 BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
 NX (Execute Disable) protection: active
 SMBIOS 2.4 present.
 DMI: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
 e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
 e820: remove [mem 0x000a0000-0x000fffff] usable
 e820: last_pfn = 0x7ca00 max_arch_pfn = 0x400000000


CPU:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Duo CPU     L9400  @ 1.86GHz
stepping	: 6
microcode	: 0x60c
cpu MHz		: 800.000
cache size	: 6144 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts nopl aperfmperf eagerfpu pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm tpr_shadow vnmi flexpriority dtherm ida
bugs		:
bogomips	: 3723.69
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

-- 
Jiri Kosina
SUSE Labs
