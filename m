Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 10 Aug 2016 18:35:00 +0200
From: Borislav Petkov <bp@suse.de>
Message-ID: <20160810163500.GA9424@nazgul.tnic>
References: <2206547.eDj3RJQyE5@vostro.rjw.lan>
 <2010434.TyoHiO9eal@vostro.rjw.lan>
 <alpine.LNX.2.00.1608100948560.22028@cbobk.fhfr.pm>
 <1779906.DOHeuFCiDy@vostro.rjw.lan>
 <alpine.LNX.2.00.1608101517380.22028@cbobk.fhfr.pm>
 <CAJcbSZHGH8G01zXSE6y9A19ZxFYY0bzeqcfHBEAYZcn8ZeX3+g@mail.gmail.com>
 <alpine.LNX.2.00.1608101658070.22028@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1608101658070.22028@cbobk.fhfr.pm>
Subject: [kernel-hardening] Re: [Resend][PATCH] x86/power/64: Always create temporary identity
 mapping correctly
To: Jiri Kosina <jikos@kernel.org>
Cc: Thomas Garnier <thgarnie@google.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Rafael J. Wysocki" <rafael@kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 10, 2016 at 04:59:40PM +0200, Jiri Kosina wrote:
> Mine is Lenovo thinkpad x200s; I think Boris has been testing it on x230s,

It says "X230" here under the screen.

> but not sure whether any of the latest patches didn't actually fix it for 
> him.

Haven't tested them yet. I'm waiting for you to test them first since
this is the only machine I have right now and I need it for work.

> The machine I am seeing the issue on, has 2G RAM, with this e820 map:

8G here:

e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
BIOS-e820: [mem 0x0000000040005000-0x00000000cec2ffff] usable
BIOS-e820: [mem 0x00000000cec30000-0x00000000dae9efff] reserved
BIOS-e820: [mem 0x00000000dae9f000-0x00000000daf9efff] ACPI NVS
BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
BIOS-e820: [mem 0x00000000dafff000-0x00000000df9fffff] reserved
BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
BIOS-e820: [mem 0x0000000100000000-0x000000021e5fffff] usable
BIOS-e820: [mem 0x000000021e600000-0x000000021e7fffff] reserved
debug: ignoring loglevel setting.
NX (Execute Disable) protection: active
SMBIOS 2.7 present.
DMI: LENOVO 2320CTO/2320CTO, BIOS G2ET86WW (2.06 ) 11/13/2012
e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
e820: last_pfn = 0x21e600 max_arch_pfn = 0x400000000

> CPU:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 58
model name      : Intel(R) Core(TM) i7-3520M CPU @ 2.90GHz
stepping        : 9
microcode       : 0x1c
cpu MHz         : 1257.421
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm epb tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms xsaveopt dtherm ida arat pln pts
bugs            :
bogomips        : 5786.68
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
--
