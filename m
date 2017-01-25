References: <1484789346-21012-1-git-send-email-labbott@redhat.com>
 <1484789346-21012-2-git-send-email-labbott@redhat.com>
 <20170119105646.GA11176@leverpostej> <20170119113305.GB5110@osiris>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <fe23dcb6-196b-96bc-f801-c3bb7db6d708@redhat.com>
Date: Wed, 25 Jan 2017 12:37:14 +0100
MIME-Version: 1.0
In-Reply-To: <20170119113305.GB5110@osiris>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 1/2] security: Change name of CONFIG_DEBUG_RODATA
To: Heiko Carstens <heiko.carstens@de.ibm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, Jason Wessel <jason.wessel@windriver.com>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jessica Yu <jeyu@redhat.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 01/19/2017 12:33 PM, Heiko Carstens wrote:
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
>
> This works since ages and I don't see a reason why this should be
> changed. Also trying to disable this with the "rodata=" command line option
> does not work at least on s390, and I guess this is true for parisc as
> well.
>
> The only thing implemented with CONFIG_DEBUG_RODATA on both architectures
> is to emit a message that states memory has been protected
> (mark_rodata_ro).
> This just avoids a wrong "Kernel memory protection disabled." message.
>
> So yes, I'd really like to keep this option mandatory.
>

(Apologies, my SMTP server was set up incorrectly so this didn't get
sent out when I thought it did)

Okay, that's useful to know. I think I'm going to add a
'select HARDENED_MAPPINGS' (or whatever it gets changed to) to arches
that were previously def_bool. This is a slight Kconfig semantic change
but as has been pointed out we now have the command line option.

Thanks,
Laura
