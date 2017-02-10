MIME-Version: 1.0
In-Reply-To: <20170210101329.GD28753@leverpostej>
References: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486554947-3964-6-git-send-email-ard.biesheuvel@linaro.org> <20170210101329.GD28753@leverpostej>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 10 Feb 2017 14:31:31 +0000
Message-ID: <CAKv+Gu8sT2CLquxAdneNSQ+YqasbPM96E3h9NMc0JMCR5Wa+bA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 05/14] arm64: efi: remove forbidden values from the
 PE/COFF header
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Leif Lindholm <leif.lindholm@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Russell King <linux@armlinux.org.uk>, kernel-hardening@lists.openwall.com, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 10 February 2017 at 10:13, Mark Rutland <mark.rutland@arm.com> wrote:
> On Wed, Feb 08, 2017 at 11:55:38AM +0000, Ard Biesheuvel wrote:
>> Bring the PE/COFF header in line with the PE/COFF spec, by setting
>> NumberOfSymbols to 0, and removing the section alignment flags.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> I take it that in practice EFI implementations don't care about these?

Not at all. I just spotted it when I was cleaning up the header.

> Assuming so:
>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
>
> Otherwise, we might want to fix this first, so that we can easily
> backport it.
>

I wouldn't bother
