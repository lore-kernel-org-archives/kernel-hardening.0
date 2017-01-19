Reply-To: kernel-hardening@lists.openwall.com
References: <1484789346-21012-1-git-send-email-labbott@redhat.com>
 <1484789346-21012-2-git-send-email-labbott@redhat.com>
 <20170119105646.GA11176@leverpostej> <20170119113305.GB5110@osiris>
From: Helge Deller <deller@gmx.de>
Message-ID: <a3c9b67f-9b10-15d5-c00f-7b8a98d11001@gmx.de>
Date: Thu, 19 Jan 2017 22:17:12 +0100
MIME-Version: 1.0
In-Reply-To: <20170119113305.GB5110@osiris>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 1/2] security: Change name of CONFIG_DEBUG_RODATA
To: Heiko Carstens <heiko.carstens@de.ibm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Jason Wessel <jason.wessel@windriver.com>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jessica Yu <jeyu@redhat.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 19.01.2017 12:33, Heiko Carstens wrote:
> On Thu, Jan 19, 2017 at 10:56:46AM +0000, Mark Rutland wrote:
>>> +config HARDENED_PAGE_MAPPINGS
>>> +	bool "Mark kernel mappings with stricter permissions (RO/W^X)"
>>> +	default y
>>> +	depends on ARCH_HAS_HARDENED_MAPPINGS
>>> +	help
>>> +          If this is set, kernel text and rodata memory will be made read-only,
>>> +	  and non-text memory will be made non-executable. This provides
>>> +	  protection against certain security attacks (e.g. executing the heap
>>> +	  or modifying text).
>>> +
>>> +	  Unless your system has known restrictions or performance issues, it
>>> +	  is recommended to say Y here.
>>
>> It's somewhat unfortunate that this means the feature is no longer
>> mandatory on arm64 (and s390+x86). We have a boot-time switch to turn
>> the protections off, so I was hoping we could make this mandatory on all
>> architectures with support.
>>
>> It would be good to see if we could make this mandatory for arm and
>> parisc, or if it really needs to be optional for either of those.
> 
> Looks like the config option is a no-op on parisc just like it is on
> s390. Irrelavant of the config option at least on s390 the page tables for
> kernel text and rodata will be read-only anyway.

Right, that's true at the moment for parisc as well.
I do have unfinished patches which will add runtime kernel patching
for ftrace to parisc, and those patches will need to add code to 
enable/disable ro text/data like x86.
 
> This works since ages and I don't see a reason why this should be
> changed. Also trying to disable this with the "rodata=" command line option
> does not work at least on s390, and I guess this is true for parisc as
> well.

I never tried the option itself, but it should work on parisc to disable
the ro protection by this option.
 
> The only thing implemented with CONFIG_DEBUG_RODATA on both architectures
> is to emit a message that states memory has been protected
> (mark_rodata_ro).
> This just avoids a wrong "Kernel memory protection disabled." message.
> 
> So yes, I'd really like to keep this option mandatory.
 
I'd be fine with a rename of the config option to ARCH_HAS_HARDENED_MAPPINGS
and keeping the "rodata=" command line.

Helge
