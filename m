MIME-Version: 1.0
In-Reply-To: <58E7B478.6010305@arm.com>
References: <20170324132410.16628-1-ard.biesheuvel@linaro.org>
 <20170324132410.16628-5-ard.biesheuvel@linaro.org> <58E7B478.6010305@arm.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 7 Apr 2017 16:51:16 +0100
Message-ID: <CAKv+Gu9CpCWHT=3KboPTtuZVDundtGheKawS=iV_P756RFbaDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 4/4] ef/libstub: arm/arm64: randomize the base of the UEFI
 rt services region
To: James Morse <james.morse@arm.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com, Matt Fleming <matt@codeblueprint.co.uk>, Leif Lindholm <leif.lindholm@linaro.org>, Borislav Petkov <bp@alien8.de>, Roy Franz <rfranz@cavium.com>, Ingo Molnar <mingo@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 7 April 2017 at 16:47, James Morse <james.morse@arm.com> wrote:
> Hi Ard,
>
> On 24/03/17 13:24, Ard Biesheuvel wrote:
>> Update the allocation logic for the virtual mapping of the UEFI runtime
>> services to start from a randomized base address if KASLR is in effect,
>> and if the UEFI firmware exposes an implementation of EFI_RNG_PROTOCOL.
>>
>> This makes it more difficult to predict the location of exploitable
>> data structures in the runtime UEFI firmware, which increases robustness
>> against attacks. Note that these regions are only mapped during the
>> time a runtime service call is in progress, and only on a single CPU
>> at a time, bit give the lack of a downside, let's enable it nonetheless.
>
> With next-20170407 on Seattle Overdrive, I get an SError[0] on boot:
>
> The three patches I have on top of 4.11.0-rc5-next-20170407 are:
> * Revert "efi/libstub/arm*: Set default address and size cells values for an
> empty dtb"
> * Revert "ef/libstub/arm/arm64: Randomize the base of the UEFI rt services region"
>
> At which point the machine start booting to a prompt again, (its noisier than
> usual but looks like double-printing).
>
> If I then cherry-pick:
> * ef/libstub/arm/arm64: Randomize the base of the UEFI rt services region"
>

That is quite interesting, to be honest, because that patch should
effectively be a NOP on systems that do not implement
EFI_RNG_PROTOCOL.

Could you run this from the UEFI shell please?

http://people.linaro.org/~ard.biesheuvel/RngTest.efi

I would expect it to report that it has no EFI_RNG_PROTOCOL
implementation. Could you also check whether the working kernel still
works /after/ having executed that utility?


> It again fails, producing the trace below. This is all with next-20170407's
> defconfig, 4K/48. UEFI identifies itself as:
>> UEFI v2.40 (American Megatrends, 0x0005000B)
>
>
> Thanks,
>
> James
>
>
> [0]
> Shell> efi\morse\Image console=ttyAMA0,115200 root=PARTUUID=b2edf709-3b28-4cb3-8
> 809-203f262e2bcc rw earlycon=pl011,0xe1010000 crashkernel=1G stacktrace ignore_l
> oglevel=1 acpi=on efi=debug resume=/dev/sda3
> EFI stub: Booting Linux Kernel...
> EFI stub: Using DTB from configuration table
> EFI stub: Exiting boot services and installing virtual address map...
> [    0.000000] Booting Linux on physical CPU 0x0
> [    0.000000] Linux version 4.11.0-rc5-next-20170407-00003-gbe65d54f8671 (morse
> @melchizedek) (gcc version 4.9.3 20141031 (prerelease) (Linaro GCC 2014.11) ) #7
> 401 SMP PREEMPT Fri Apr 7 16:19:28 BST 2017
> [    0.000000] Boot CPU: AArch64 Processor [411fd072]
> [    0.000000] earlycon: pl11 at MMIO 0x00000000e1010000 (options '')
> [    0.000000] bootconsole [pl11] enabled
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] Bad mode in Error handler detected on CPU0, code 0xbf000000 -- SError
> [    0.000000] Internal error: Oops - bad mode: 0 [#1] PREEMPT SMP
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.11.0-rc5-next-20170407-
> 00003-gbe65d54f8671 #7401
> [    0.000000] Hardware name: AMD Seattle (Rev.B0) Development Board (Overdrive)
>  (DT)
> [    0.000000] task: ffff000008e02b80 task.stack: ffff000008df0000
> [    0.000000] PC is at setup_arch+0xf0/0x504
> [    0.000000] LR is at setup_arch+0xec/0x504
> [    0.000000] pc : [<ffff000008ce2844>] lr : [<ffff000008ce2840>] pstate: 000000c5
>
> [    0.000000] Call trace:
> [    0.000000] [<ffff000008ce2844>] setup_arch+0xf0/0x504
> [    0.000000] [<ffff000008ce0838>] start_kernel+0x70/0x398
> [    0.000000] [<ffff000008ce01e0>] __primary_switched+0x64/0x74
> [    0.000000] Code: 9111c000 940034d9 97fff7cd d50344ff (90fffce3)
> [    0.000000] ---[ end trace 0000000000000000 ]---
> [    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
> [    0.000000] ---[ end Kernel panic - not syncing: Attempted to kill the idle task!
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
