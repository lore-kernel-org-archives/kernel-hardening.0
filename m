Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: rjwysocki@gmail.com
In-Reply-To: <alpine.LRH.2.00.1608091121120.19185@gjva.wvxbf.pm>
References: <2206547.eDj3RJQyE5@vostro.rjw.lan> <alpine.LRH.2.00.1608091121120.19185@gjva.wvxbf.pm>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 9 Aug 2016 13:56:10 +0200
Message-ID: <CAJZ5v0iAiQwpBgY=4hH-RsBB54tD8FY4C8pWbjNNRmAjJ9Xg+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [Resend][PATCH] x86/power/64: Always create temporary identity
 mapping correctly
To: Jiri Kosina <jikos@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux PM list <linux-pm@vger.kernel.org>, Thomas Garnier <thgarnie@google.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bpetkov@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 9, 2016 at 11:23 AM, Jiri Kosina <jikos@kernel.org> wrote:
> On Mon, 8 Aug 2016, Rafael J. Wysocki wrote:
>
>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>
>> The low-level resume-from-hibernation code on x86-64 uses
>> kernel_ident_mapping_init() to create the temoprary identity mapping,
>> but that function assumes that the offset between kernel virtual
>> addresses and physical addresses is aligned on the PGD level.
>>
>> However, with a randomized identity mapping base, it may be aligned
>> on the PUD level and if that happens, the temporary identity mapping
>> created by set_up_temporary_mappings() will not reflect the actual
>> kernel identity mapping and the image restoration will fail as a
>> result (leading to a kernel panic most of the time).
>>
>> To fix this problem, rework kernel_ident_mapping_init() to support
>> unaligned offsets between KVA and PA up to the PMD level and make
>> set_up_temporary_mappings() use it as approprtiate.
>>
>> Reported-by: Thomas Garnier <thgarnie@google.com>
>> Suggested-by: Yinghai Lu <yinghai@kernel.org>
>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Acked-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>
>> This is sort of urgent, because hibernation doesn't work with KASLR on x86-64
>> in 4.8-rc1 AFAICS and this should make them work together again.
>>
>> Unless anyone sees any problems with it, I'll queue it up for 4.8-rc2.
>>
>> Thomas, would it be possible to test it with KASLR enabled, please?
>
> Unfortunately this applied on top of -rc1 still doesn't solve the reboot
> after reading hibernation image (I'd guess due to triple fault) with
> CONFIG_RANDOMIZE_MEMORY=y on my system.
>
> With CONFIG_RANDOMIZE_MEMORY=n, the system resumes correctly.

Here's a list of commits from Thomas that are related to memory randomization.

210e7a43fa90 mm: SLUB freelist randomization
7c00fce98c3e mm: reorganize SLAB freelist randomization
4ff5308744f5 x86/mm: Do not reference phys addr beyond kernel
90397a417796 x86/mm: Add memory hotplug support for KASLR memory randomization
a95ae27c2ee1 x86/mm: Enable KASLR for vmalloc memory regions
021182e52fe0 x86/mm: Enable KASLR for physical mapping memory regions
0483e1fa6e09 x86/mm: Implement ASLR for kernel memory regions
b234e8a09003 x86/mm: Separate variable for trampoline PGD
faa379332f3c x86/mm: Add PUD VA support for physical mapping
59b3d0206d74 x86/mm: Update physical mapping variable names
d899a7d146a2 x86/mm: Refactor KASLR entropy functions

I wonder if it is viable to revert them one by one top-to-bottom and
see which one of them causes things to fail?

Thanks,
Rafael
