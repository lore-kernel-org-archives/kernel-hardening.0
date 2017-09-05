MIME-Version: 1.0
In-Reply-To: <20170905164547.GA5024@atomide.com>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org> <20170905164547.GA5024@atomide.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 5 Sep 2017 17:48:58 +0100
Message-ID: <CAKv+Gu_eT_eK9Tj4JvWSsK+iW9juGG6xYDO15umu6jBkoun8ew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 00/29] implement KASLR for ARM
To: Tony Lindgren <tony@atomide.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 5 September 2017 at 17:45, Tony Lindgren <tony@atomide.com> wrote:
> Hi,
>
> * Ard Biesheuvel <ard.biesheuvel@linaro.org> [170903 05:08]:
>> This series implements randomization of the placement of the core ARM kernel
>> inside the lowmem region. It consists of the following parts:
>>
>> - changes that allow us to build vmlinux as a PIE executable which retains
>>   the metadata required to fix up all absolute symbol references at runtime
>> - changes that eliminate absolute references from low-level code that may
>>   execute with the MMU off: this removes the need to perform explicit cache
>>   maintenance after the absolute references have been fixed up at runtime with
>>   the caches enabled
>> - changes to the core kernel startup code to take the physical offset into
>>   account when creating the virtual mapping (the pa-to-va mapping remains
>>   unchanged)
>> - changes to the decompressor to collect some pseudo-entropy, and randomize
>>   the physical offset of the decompressed kernel, taking placement of DTB,
>>   initrd and reserved regions into account
>> - changes to the UEFI stub code to choose the KASLR offset and communicate
>>   it to the decompressor
>>
>> To test these changes, boot a multi_v7_defconfig+CONFIG_RANDOMIZE_BASE=y
>
> I gave a quick try using your arm-kaslr-v3 branch, hopefully that's
> the right one.
>
> The good news is that now omap3 boots with omap2plus_defconfig with
> and without CONFIG_RANDOMIZE_BASE=y and I did not see any compiler
> errors with my gcc 6.2.0 like earlier :)
>

Good! Thanks a lot for taking the time to test this stuff.

> I did see boot attempts fail with randomize enable where no output
> was produced. It seems this is happening for me maybe 1 out of 5 boots.
> Enabling DEBUG_LL did not show anything either.
>

Yes. I am looking into a couple of kernelci boot reports that look
suspicious, but it is rather difficult to reproduce, for obvious
reasons :-)

Which hardware are you testing this on?

> Then loading modules with CONFIG_RANDOMIZE_BASE=y seems to fail with:
>
> $ sudo modprobe rtc-twl
> rtc_twl: disagrees about version of symbol module_layout
> modprobe: ERROR: could not insert 'rtc_twl': Exec format error
>

Is this with CONFIG_MODVERSIONS enabled?

Thanks,
Ard.
