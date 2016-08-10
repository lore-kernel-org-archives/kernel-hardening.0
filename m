Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: rjwysocki@gmail.com
In-Reply-To: <20160810163500.GA9424@nazgul.tnic>
References: <2206547.eDj3RJQyE5@vostro.rjw.lan> <2010434.TyoHiO9eal@vostro.rjw.lan>
 <alpine.LNX.2.00.1608100948560.22028@cbobk.fhfr.pm> <1779906.DOHeuFCiDy@vostro.rjw.lan>
 <alpine.LNX.2.00.1608101517380.22028@cbobk.fhfr.pm> <CAJcbSZHGH8G01zXSE6y9A19ZxFYY0bzeqcfHBEAYZcn8ZeX3+g@mail.gmail.com>
 <alpine.LNX.2.00.1608101658070.22028@cbobk.fhfr.pm> <20160810163500.GA9424@nazgul.tnic>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 10 Aug 2016 22:56:34 +0200
Message-ID: <CAJZ5v0h_N5KvjUZjDDdoXMP3UoMmyYKOrHUpyGH14EYWMbxvPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [Resend][PATCH] x86/power/64: Always create temporary identity
 mapping correctly
To: Borislav Petkov <bp@suse.de>, Thomas Garnier <thgarnie@google.com>
Cc: Jiri Kosina <jikos@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Rafael J. Wysocki" <rafael@kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 10, 2016 at 6:35 PM, Borislav Petkov <bp@suse.de> wrote:
> On Wed, Aug 10, 2016 at 04:59:40PM +0200, Jiri Kosina wrote:
>> Mine is Lenovo thinkpad x200s; I think Boris has been testing it on x230s,
>
> It says "X230" here under the screen.
>
>> but not sure whether any of the latest patches didn't actually fix it for
>> him.
>
> Haven't tested them yet. I'm waiting for you to test them first since
> this is the only machine I have right now and I need it for work.
>
>> The machine I am seeing the issue on, has 2G RAM, with this e820 map:
>
> 8G here:
>
> e820: BIOS-provided physical RAM map:
> BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
> BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
> BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
> BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
> BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
> BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
> BIOS-e820: [mem 0x0000000040005000-0x00000000cec2ffff] usable
> BIOS-e820: [mem 0x00000000cec30000-0x00000000dae9efff] reserved
> BIOS-e820: [mem 0x00000000dae9f000-0x00000000daf9efff] ACPI NVS
> BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
> BIOS-e820: [mem 0x00000000dafff000-0x00000000df9fffff] reserved
> BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
> BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
> BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
> BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
> BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
> BIOS-e820: [mem 0x0000000100000000-0x000000021e5fffff] usable
> BIOS-e820: [mem 0x000000021e600000-0x000000021e7fffff] reserved
> debug: ignoring loglevel setting.
> NX (Execute Disable) protection: active
> SMBIOS 2.7 present.
> DMI: LENOVO 2320CTO/2320CTO, BIOS G2ET86WW (2.06 ) 11/13/2012
> e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> e820: remove [mem 0x000a0000-0x000fffff] usable
> e820: last_pfn = 0x21e600 max_arch_pfn = 0x400000000

So far, I'm unable to reproduce the problem (with the $subject patch
applied) on two different Intel-base machines with 4 Gig and 8 Gig of
RAM.

One thing that's clearly different on my machines is that they both
have usable memory at the end of the e820 map (and the one where Jiri
can reproduce the problem has reserved memory at the end of it, just
like yours).

Thomas, what about the e820 map on your machine?

I'm not sure why that would matter, though.

Thanks,
Rafael
