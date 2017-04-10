MIME-Version: 1.0
In-Reply-To: <20170410094124.GA9450@leverpostej>
References: <20170324132410.16628-1-ard.biesheuvel@linaro.org>
 <20170324132410.16628-5-ard.biesheuvel@linaro.org> <58E7B478.6010305@arm.com>
 <CAKv+Gu9CpCWHT=3KboPTtuZVDundtGheKawS=iV_P756RFbaDg@mail.gmail.com> <20170410094124.GA9450@leverpostej>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 10 Apr 2017 10:44:39 +0100
Message-ID: <CAKv+Gu9YfALdyL-28X20X=T=XyyjDUxmtHy3_ZDDq-PF8RMxUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 4/4] ef/libstub: arm/arm64: randomize the base of the UEFI
 rt services region
To: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, kernel-hardening@lists.openwall.com, Matt Fleming <matt@codeblueprint.co.uk>, Leif Lindholm <leif.lindholm@linaro.org>, Borislav Petkov <bp@alien8.de>, Roy Franz <rfranz@cavium.com>, Ingo Molnar <mingo@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 10 April 2017 at 10:41, Mark Rutland <mark.rutland@arm.com> wrote:
> On Fri, Apr 07, 2017 at 04:51:16PM +0100, Ard Biesheuvel wrote:
>> On 7 April 2017 at 16:47, James Morse <james.morse@arm.com> wrote:
>> > On 24/03/17 13:24, Ard Biesheuvel wrote:
>> >> Update the allocation logic for the virtual mapping of the UEFI runtime
>> >> services to start from a randomized base address if KASLR is in effect,
>> >> and if the UEFI firmware exposes an implementation of EFI_RNG_PROTOCOL.
>> >>
>> >> This makes it more difficult to predict the location of exploitable
>> >> data structures in the runtime UEFI firmware, which increases robustness
>> >> against attacks. Note that these regions are only mapped during the
>> >> time a runtime service call is in progress, and only on a single CPU
>> >> at a time, bit give the lack of a downside, let's enable it nonetheless.
>> >
>> > With next-20170407 on Seattle Overdrive, I get an SError[0] on boot:
>
>> > * Revert "ef/libstub/arm/arm64: Randomize the base of the UEFI rt services region"
>> >
>> > At which point the machine start booting to a prompt again, (its noisier than
>> > usual but looks like double-printing).
>
>> That is quite interesting, to be honest, because that patch should
>> effectively be a NOP on systems that do not implement
>> EFI_RNG_PROTOCOL.
>
> FWIW, I'm also seeing a crash as a result of this patch, on a Juno R1
> with an EFI_RNG_PROTOCOL implementation, with next-20170410 defconfig.
> I'm using the Linaro 15.08 toolchain.
>
> ----
> EFI stub: Booting Linux Kernel...
> EFI stub: Using DTB from configuration table
>
>
> WARNING: this system is using an unsafe pseudo-random implementation of
> RngLib!
>
>
>
> Synchronous Exception at 0x00000000F80FC7E8
> ----
>
> If I replace the !nokaslr() in efi_entry() with false, my kernel boots.
>
> If I replace !nokaslr() with true, it fails to boot, even with the call
> to efi_get_random_bytes() replaced with status = EFI_ERROR.
>
> The problem appears to be the use of TASK_SIZE, since on arm64 that's:
>
> #define TASK_SIZE               (test_thread_flag(TIF_32BIT) ? \
>                                 TASK_SIZE_32 : TASK_SIZE_64)
>
> ... which would mean that the stub would be trying to dereference whatever it
> found in sp_el0. Looking at objdump:
>
> 0000000000000160 <efi_entry>:
>  ...
>  4b4:   94000000        bl      0 <nokaslr>
>  4b8:   35000280        cbnz    w0, 508 <efi_entry+0x3a8>
>  4bc:   d5384100        mrs     x0, sp_el0
>  4c0:   f9400004        ldr     x4, [x0]
> ...
>
> So I think we should revert this for now.
>

Thanks for debugging this! I will get a fixed version out asap
