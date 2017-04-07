Message-ID: <58E7BA48.70903@arm.com>
Date: Fri, 07 Apr 2017 17:11:52 +0100
From: James Morse <james.morse@arm.com>
MIME-Version: 1.0
References: <20170324132410.16628-1-ard.biesheuvel@linaro.org> <20170324132410.16628-5-ard.biesheuvel@linaro.org> <58E7B478.6010305@arm.com> <CAKv+Gu9CpCWHT=3KboPTtuZVDundtGheKawS=iV_P756RFbaDg@mail.gmail.com>
In-Reply-To: <CAKv+Gu9CpCWHT=3KboPTtuZVDundtGheKawS=iV_P756RFbaDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 4/4] ef/libstub: arm/arm64: randomize the base of the
 UEFI rt services region
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com, Matt Fleming <matt@codeblueprint.co.uk>, Leif Lindholm <leif.lindholm@linaro.org>, Borislav Petkov <bp@alien8.de>, Roy Franz <rfranz@cavium.com>, Ingo Molnar <mingo@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Ard,

On 07/04/17 16:51, Ard Biesheuvel wrote:
> That is quite interesting, to be honest, because that patch should
> effectively be a NOP on systems that do not implement
> EFI_RNG_PROTOCOL.
> 
> Could you run this from the UEFI shell please?
> 
> http://people.linaro.org/~ard.biesheuvel/RngTest.efi

As you predicted:

Shell> RngTest.efi
UEFI RNG Protocol Testing :
----------------------------
 -- Locate UEFI RNG Protocol : [Fail - Status = Not Found]
Error reported: Not Found


> I would expect it to report that it has no EFI_RNG_PROTOCOL
> implementation. Could you also check whether the working kernel still
> works /after/ having executed that utility?

The broken kernel remains broken after running that test. reboot. The working
kernel continues to work after running that test.

(On Monday) I will try with just these efi changes on v4.11-rc. to try and
eliminate everything else in linux-next.

This is one of those firmware versions that prints lots of
> efi: [Firmware Bug]: IRQ flags corrupted (0x00000140=>0x00000100) by EFI
get_variable


Thanks,

James
