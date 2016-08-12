Reply-To: kernel-hardening@lists.openwall.com
References: <1464979224-2085-1-git-send-email-keescook@chromium.org>
 <2096112.OBiRuggdEi@wuerfel> <20160810230242.GO1041@n2100.armlinux.org.uk>
 <28485373.pjx0rukqdF@wuerfel>
From: Daniel Thompson <daniel.thompson@linaro.org>
Message-ID: <957a3755-96a6-6e39-f17e-421de029ca79@linaro.org>
Date: Fri, 12 Aug 2016 12:34:06 +0100
MIME-Version: 1.0
In-Reply-To: <28485373.pjx0rukqdF@wuerfel>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 2/2] arm: apply more __ro_after_init
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>, linux-arch@vger.kernel.org, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, x86@kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Mathias Krause <minipli@googlemail.com>, Mark Brown <broonie@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 11/08/16 17:02, Arnd Bergmann wrote:
> On Thursday, August 11, 2016 12:02:42 AM CEST Russell King - ARM Linux wrote:
>> On Wed, Aug 10, 2016 at 09:31:05PM +0200, Arnd Bergmann wrote:
>>> On Wednesday, August 10, 2016 11:12:53 AM CEST Russell King - ARM Linux wrote:
>>>> There's the TLS emulation too, but that writes via the vectors mapping
>>>> at 0xffff0ff0.
>>>
>>> Ok, so that should be safe. Can we change the fiq code to also use the
>>> high mapping and then take the __ro_after_init patch on top?
>>
>> We can't - if the kernel is configured without the kuser helpers in
>> the vectors page, it's mapped read-only. I'm not sure what the
>> intersection is between platforms that can have FIQs and platforms
>> that can disable the kuser helpers.
>
> From Kconfig logic and callers of set_fiq_handler(), theoretically
> there is just i.MX3, but I think they never use fiq in their
> audio drivers in practice already, and Mark Brown mentioned
> that we could remove fiq support in the imx audio driver (don't
> remember the details at the moment).
>
> If we can prove that i.MX3 PCM FIQ support is never used, then the
> intersection is empty, and all machines that use FIQ require kuser
> helpers.
>
> This may change with Daniel Thompson's patches that use the FIQ
> for NMI backtrace.

It shouldn't do!

All the work I did (and am, very slowly, still doing) worked by using 
the default FIQ handler provided at boot time to jump into the perf code.

Nothing I have done or plan to do needs set_fiq_handler() to remain 
functional.

Likewise, nothing I have done should cause set_fiq_handler() to stop 
working for people who do still use it. FWIW I got the impression over 
the last few years that the most significant uses of FIQ on modern 
systems are out-of-tree uses who have designed custom FPGA hardware (and 
presumably designed them with very short FIFOs).


Daniel.
