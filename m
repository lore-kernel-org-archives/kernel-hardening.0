MIME-Version: 1.0
In-Reply-To: <20180619152035.GM13984@arm.com>
References: <20180530044806.18449-1-yaojun8558363@gmail.com>
 <20180530091457.GB2452@arm.com> <CAKv+Gu8Zc7eQbG-Ww51GXUCEmhe2J03vbq5vVdyaKra-s13KrA@mail.gmail.com>
 <20180619152035.GM13984@arm.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 19 Jun 2018 17:23:41 +0200
Message-ID: <CAKv+Gu-Mad64U63jjuKGjhg=h2wdoEKm2vywzATBYr-t_UY_bQ@mail.gmail.com>
Subject: Re: [PATCH] arm64: mm: mark tramp_pg_dir read-only
Content-Type: text/plain; charset="UTF-8"
To: Will Deacon <will.deacon@arm.com>
Cc: YaoJun <yaojun8558363@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 19 June 2018 at 17:20, Will Deacon <will.deacon@arm.com> wrote:
> Hi Ard,
>
> Sorry, I forgot to reply to this.
>
> On Wed, May 30, 2018 at 11:53:20AM +0200, Ard Biesheuvel wrote:
>> On 30 May 2018 at 11:14, Will Deacon <will.deacon@arm.com> wrote:
>> > On Wed, May 30, 2018 at 12:48:06PM +0800, YaoJun wrote:
>> >> To protect against KSMA(Kernel Space Mirroring Attack), make
>> >> tramp_pg_dir read-only. The principle of KSMA is to insert a
>> >> carefully constructed PGD entry into the translation table.
>> >> The type of this entry is block, which maps the kernel text
>> >> and its access permissions bits are 01. The user process can
>> >> then modify kernel text directly through this mapping. In this
>> >> way, an arbitrary write can be converted to multiple arbitrary
>> >> writes.
>> >>
>> >> Signed-off-by: YaoJun <yaojun8558363@gmail.com>
>> >> ---
>> >>  arch/arm64/mm/mmu.c | 4 ++++
>> >>  1 file changed, 4 insertions(+)
>> >>
>> >> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> >> index 2dbb2c9f1ec1..ac4b22c7e435 100644
>> >> --- a/arch/arm64/mm/mmu.c
>> >> +++ b/arch/arm64/mm/mmu.c
>> >> @@ -551,6 +551,10 @@ static int __init map_entry_trampoline(void)
>> >>       __create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS, PAGE_SIZE,
>> >>                            prot, pgd_pgtable_alloc, 0);
>> >>
>> >> +     update_mapping_prot(__pa_symbol(tramp_pg_dir),
>> >> +                             (unsigned long)tramp_pg_dir,
>> >> +                             PGD_SIZE, PAGE_KERNEL_RO);
>> >
>> > Hmm, I like the idea but is there a risk that the page table has been mapped
>> > as part of a block entry, which we can't safely split at this point (i.e.
>> > we'll run into one of the BUG_ONs in the mapping code)?
>> >
>>
>> We'd need to create a separate segment for it initially so the mapping
>> is already at the right granularity.
>
> Why do you think that's the case? I can't see anything that guarantees this
> for the page table itself.
>

We'd need to pass NO_BLOCK_MAPPINGS to map_kernel_segment(),
obviously, but that shouldn't hurt since that segment is relatively
tiny anyway.
