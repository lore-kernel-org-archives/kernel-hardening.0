References: <1484789346-21012-1-git-send-email-labbott@redhat.com>
 <1484789346-21012-2-git-send-email-labbott@redhat.com>
 <20170119075341.GA14530@amd>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <fca01775-9640-8783-a657-a9e6cf0c3e0a@redhat.com>
Date: Wed, 25 Jan 2017 12:21:05 +0100
MIME-Version: 1.0
In-Reply-To: <20170119075341.GA14530@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 1/2] security: Change name of CONFIG_DEBUG_RODATA
To: Pavel Machek <pavel@ucw.cz>
Cc: Kees Cook <keescook@chromium.org>, Jason Wessel <jason.wessel@windriver.com>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Mark Rutland <mark.rutland@arm.com>, Jessica Yu <jeyu@redhat.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 01/19/2017 08:53 AM, Pavel Machek wrote:
> On Wed 2017-01-18 17:29:05, Laura Abbott wrote:
>>
>> Despite the word 'debug' in CONFIG_DEBUG_RODATA, this kernel option
>> provides key security features that are to be expected on a modern
>> system. Change the name to CONFIG_HARDENED_PAGE_MAPPINGS which more
>> accurately describes what this option is intended to do.
>
> I think this is bad change. CONFIG_DEBUG_RODATA is describing what it
> does, CONFIG_HARDENED_PAGE_MAPPINGS is advertising.
>
> We don't do advertising, and we don't force people to re-answer the
> config questions without good reason.
>
> CONFIG_HARDENED_RODATA might fix the first problem, but not the second
> one.
>
> 								Pavel
> 								

(Apologies, my SMTP was set up incorrectly so my response didn't
actually get sent out)

CONFIG_DEBUG_RODATA isn't describing what it does though. It misses
that this config may handle much more than just rodata. I think
Mark Rutland's suggestion of STRICT_KERNEL_RWX might be more
descriptive.

Thanks,
Laura
