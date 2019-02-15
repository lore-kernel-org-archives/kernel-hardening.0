Subject: Re: [RFC PATCH v8 08/14] arm64/mm: disable section/contiguous
 mappings if XPFO is enabled
References: <cover.1550088114.git.khalid.aziz@oracle.com>
 <0b9624b6c1fe5a31d73a6390e063d551bfebc321.1550088114.git.khalid.aziz@oracle.com>
 <20190215130942.GD53520@lakrids.cambridge.arm.com>
From: Khalid Aziz <khalid.aziz@oracle.com>
Message-ID: <259cac45-3337-d446-5abc-21b694d916e1@oracle.com>
Date: Fri, 15 Feb 2019 07:47:37 -0700
MIME-Version: 1.0
In-Reply-To: <20190215130942.GD53520@lakrids.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: Mark Rutland <mark.rutland@arm.com>
Cc: juergh@gmail.com, tycho@tycho.ws, jsteckli@amazon.de, ak@linux.intel.com, torvalds@linux-foundation.org, liran.alon@oracle.com, keescook@google.com, akpm@linux-foundation.org, mhocko@suse.com, catalin.marinas@arm.com, will.deacon@arm.com, jmorris@namei.org, konrad.wilk@oracle.com, Tycho Andersen <tycho@docker.com>, deepa.srinivasan@oracle.com, chris.hyser@oracle.com, tyhicks@canonical.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com, jcm@redhat.com, boris.ostrovsky@oracle.com, kanth.ghatraju@oracle.com, joao.m.martins@oracle.com, jmattson@google.com, pradeep.vincent@oracle.com, john.haxby@oracle.com, tglx@linutronix.de, kirill.shutemov@linux.intel.com, hch@lst.de, steven.sistare@oracle.com, labbott@redhat.com, luto@kernel.org, dave.hansen@intel.com, peterz@infradead.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 2/15/19 6:09 AM, Mark Rutland wrote:
> Hi,
>=20
> On Wed, Feb 13, 2019 at 05:01:31PM -0700, Khalid Aziz wrote:
>> From: Tycho Andersen <tycho@docker.com>
>>
>> XPFO doesn't support section/contiguous mappings yet, so let's disable=
 it
>> if XPFO is turned on.
>>
>> Thanks to Laura Abbot for the simplification from v5, and Mark Rutland=
 for
>> pointing out we need NO_CONT_MAPPINGS too.
>>
>> CC: linux-arm-kernel@lists.infradead.org
>> Signed-off-by: Tycho Andersen <tycho@docker.com>
>> Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
>=20
> There should be no point in this series where it's possible to enable a=

> broken XPFO. Either this patch should be merged into the rest of the
> arm64 bits, or it should be placed before the rest of the arm64 bits.
>=20
> That's a pre-requisite for merging, and it significantly reduces the
> burden on reviewers.
>=20
> In general, a patch series should bisect cleanly. Could you please
> restructure the series to that effect?
>=20
> Thanks,
> Mark.

That sounds reasonable to me. I will merge this with patch 5 ("arm64/mm:
Add support for XPFO") for the next version unless there are objections.

Thanks,
Khalid

>=20
>> ---
>>  arch/arm64/mm/mmu.c  | 2 +-
>>  include/linux/xpfo.h | 4 ++++
>>  mm/xpfo.c            | 6 ++++++
>>  3 files changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index d1d6601b385d..f4dd27073006 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -451,7 +451,7 @@ static void __init map_mem(pgd_t *pgdp)
>>  	struct memblock_region *reg;
>>  	int flags =3D 0;
>> =20
>> -	if (debug_pagealloc_enabled())
>> +	if (debug_pagealloc_enabled() || xpfo_enabled())
>>  		flags =3D NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
>> =20
>>  	/*
>> diff --git a/include/linux/xpfo.h b/include/linux/xpfo.h
>> index 1ae05756344d..8b029918a958 100644
>> --- a/include/linux/xpfo.h
>> +++ b/include/linux/xpfo.h
>> @@ -47,6 +47,8 @@ void xpfo_temp_map(const void *addr, size_t size, vo=
id **mapping,
>>  void xpfo_temp_unmap(const void *addr, size_t size, void **mapping,
>>  		     size_t mapping_len);
>> =20
>> +bool xpfo_enabled(void);
>> +
>>  #else /* !CONFIG_XPFO */
>> =20
>>  static inline void xpfo_kmap(void *kaddr, struct page *page) { }
>> @@ -69,6 +71,8 @@ static inline void xpfo_temp_unmap(const void *addr,=
 size_t size,
>>  }
>> =20
>> =20
>> +static inline bool xpfo_enabled(void) { return false; }
>> +
>>  #endif /* CONFIG_XPFO */
>> =20
>>  #endif /* _LINUX_XPFO_H */
>> diff --git a/mm/xpfo.c b/mm/xpfo.c
>> index 92ca6d1baf06..150784ae0f08 100644
>> --- a/mm/xpfo.c
>> +++ b/mm/xpfo.c
>> @@ -71,6 +71,12 @@ struct page_ext_operations page_xpfo_ops =3D {
>>  	.init =3D init_xpfo,
>>  };
>> =20
>> +bool __init xpfo_enabled(void)
>> +{
>> +	return !xpfo_disabled;
>> +}
>> +EXPORT_SYMBOL(xpfo_enabled);
>> +
>>  static inline struct xpfo *lookup_xpfo(struct page *page)
>>  {
>>  	struct page_ext *page_ext =3D lookup_page_ext(page);
>> --=20
>> 2.17.1
>>
