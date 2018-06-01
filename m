Subject: Re: [PATCH 0/4] arm64/mm: migrate swapper_pg_dir
References: <20180601080819.11712-1-yaojun8558363@gmail.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <41dbb7d5-c9a5-3ed2-c0fe-a8bb8a3e487f@arm.com>
Date: Fri, 1 Jun 2018 10:42:10 +0100
MIME-Version: 1.0
In-Reply-To: <20180601080819.11712-1-yaojun8558363@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jun Yao <yaojun8558363@gmail.com>, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, greg@kroah.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 01/06/18 09:08, Jun Yao wrote:
> Currently, The offset between swapper_pg_dir and _text is
> fixed. When attackers know the address of _text(no KASLR or
> breaking KASLR), they can caculate the address of
> swapper_pg_dir. Then KSMA(Kernel Space Mirroring Attack) can
> be applied.
> 
> The principle of KSMA is to insert a carefully constructed PGD
> entry into the translation table. The type of this entry is

Out of interest, how does that part work? AFAICS, modifying a PGD entry 
involves writing to kernel memory, which would mean the implication of 
KSMA is "userspace can gain write permission to kernel memory by writing 
to kernel memory" - that doesn't sound like an attack in itself, more 
just a convenience for ease of exploiting whatever successful attack got 
you in there in the first place.

That's not to say that it isn't still worth mitigating, I'm just 
questioning the given rationale here.

Robin.

> block, which maps the kernel text and its access permissions
> bits are 01. The user process can then modify kernel text
> directly through this mapping.
> 
> To protect against KSMA, these patches migrate swapper_pg_dir
> to new place, which is dynamically allocated. Since it is
> allocated during the kernel boot process and the address is
> relatively fixed, further randomization may be required.
> 
> Jun Yao (4):
>    arm64/mm: pass swapper_pg_dir as an argument to __enable_mmu()
>    arm64/mm: introduce variable to save new swapper_pg_dir address
>    arm64/mm: make tramp_pg_dir and swapper_pg_dir adjacent
>    arm64/mm: migrate swapper_pg_dir and tramp_pg_dir
> 
>   arch/arm64/include/asm/mmu_context.h |  6 +--
>   arch/arm64/include/asm/pgtable.h     |  2 +
>   arch/arm64/kernel/cpufeature.c       |  2 +-
>   arch/arm64/kernel/entry.S            |  4 +-
>   arch/arm64/kernel/head.S             | 10 ++--
>   arch/arm64/kernel/hibernate.c        |  2 +-
>   arch/arm64/kernel/sleep.S            |  2 +
>   arch/arm64/kernel/vmlinux.lds.S      |  9 ++--
>   arch/arm64/mm/kasan_init.c           |  6 +--
>   arch/arm64/mm/mmu.c                  | 75 +++++++++++++++++-----------
>   10 files changed, 71 insertions(+), 47 deletions(-)
> 
