Subject: Re: [RFC PATCH v9 11/13] xpfo, mm: optimize spinlock usage in
 xpfo_kunmap
References: <cover.1554248001.git.khalid.aziz@oracle.com>
 <5bab13e12d4215112ad2180106cc6bb9b513754a.1554248002.git.khalid.aziz@oracle.com>
 <20190404075648.GQ4038@hirez.programming.kicks-ass.net>
From: Khalid Aziz <khalid.aziz@oracle.com>
Message-ID: <89dd158f-c341-9dd9-d70c-787b5eb0b410@oracle.com>
Date: Thu, 4 Apr 2019 10:06:43 -0600
MIME-Version: 1.0
In-Reply-To: <20190404075648.GQ4038@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: Peter Zijlstra <peterz@infradead.org>
Cc: juergh@gmail.com, tycho@tycho.ws, jsteckli@amazon.de, ak@linux.intel.com, liran.alon@oracle.com, keescook@google.com, konrad.wilk@oracle.com, deepa.srinivasan@oracle.com, chris.hyser@oracle.com, tyhicks@canonical.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com, jcm@redhat.com, boris.ostrovsky@oracle.com, kanth.ghatraju@oracle.com, joao.m.martins@oracle.com, jmattson@google.com, pradeep.vincent@oracle.com, john.haxby@oracle.com, tglx@linutronix.de, kirill.shutemov@linux.intel.com, hch@lst.de, steven.sistare@oracle.com, labbott@redhat.com, luto@kernel.org, dave.hansen@intel.com, akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com, aneesh.kumar@linux.ibm.com, arnd@arndb.de, bigeasy@linutronix.de, bp@alien8.de, catalin.marinas@arm.com, corbet@lwn.net, dan.j.williams@intel.com, gregkh@linuxfoundation.org, guro@fb.com, hannes@cmpxchg.org, hpa@zytor.com, iamjoonsoo.kim@lge.com, james.morse@arm.com, jannh@google.com, jkosina@suse.cz, jmorris@namei.org, joe@perches.com, jrdr.linux@gmail.com, jroedel@suse.de, keith.busch@intel.com, khlebnikov@yandex-team.ru, mark.rutland@arm.com, mgorman@techsingularity.net, Michal Hocko <mhocko@kernel.org>, mike.kravetz@oracle.com, mingo@redhat.com, mst@redhat.com, npiggin@gmail.com, paulmck@linux.vnet.ibm.com, pavel.tatashin@microsoft.com, rdunlap@infradead.org, richard.weiyang@gmail.com, riel@surriel.com, rientjes@google.com, rostedt@goodmis.org, rppt@linux.vnet.ibm.com, will.deacon@arm.com, willy@infradead.org, yaojun8558363@gmail.com, ying.huang@intel.com, iommu@lists.linux-foundation.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, Khalid Aziz <khalid@gonehiking.org>, kernel-hardening@lists.openwall.com, "Vasileios P . Kemerlis" <vpk@cs.columbia.edu>
List-ID: <kernel-hardening.lists.openwall.com>

On 4/4/19 1:56 AM, Peter Zijlstra wrote:
> On Wed, Apr 03, 2019 at 11:34:12AM -0600, Khalid Aziz wrote:
>> From: Julian Stecklina <jsteckli@amazon.de>
>>
>> Only the xpfo_kunmap call that needs to actually unmap the page
>> needs to be serialized. We need to be careful to handle the case,
>> where after the atomic decrement of the mapcount, a xpfo_kmap
>> increased the mapcount again. In this case, we can safely skip
>> modifying the page table.
>>
>> Model-checked with up to 4 concurrent callers with Spin.
>>
>> Signed-off-by: Julian Stecklina <jsteckli@amazon.de>
>> Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
>> Cc: Khalid Aziz <khalid@gonehiking.org>
>> Cc: x86@kernel.org
>> Cc: kernel-hardening@lists.openwall.com
>> Cc: Vasileios P. Kemerlis <vpk@cs.columbia.edu>
>> Cc: Juerg Haefliger <juerg.haefliger@canonical.com>
>> Cc: Tycho Andersen <tycho@tycho.ws>
>> Cc: Marco Benatto <marco.antonio.780@gmail.com>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> ---
>>  include/linux/xpfo.h | 24 +++++++++++++++---------
>>  1 file changed, 15 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/linux/xpfo.h b/include/linux/xpfo.h
>> index 2318c7eb5fb7..37e7f52fa6ce 100644
>> --- a/include/linux/xpfo.h
>> +++ b/include/linux/xpfo.h
>> @@ -61,6 +61,7 @@ static inline void xpfo_kmap(void *kaddr, struct pag=
e *page)
>>  static inline void xpfo_kunmap(void *kaddr, struct page *page)
>>  {
>>  	unsigned long flags;
>> +	bool flush_tlb =3D false;
>> =20
>>  	if (!static_branch_unlikely(&xpfo_inited))
>>  		return;
>> @@ -72,18 +73,23 @@ static inline void xpfo_kunmap(void *kaddr, struct=
 page *page)
>>  	 * The page is to be allocated back to user space, so unmap it from
>>  	 * the kernel, flush the TLB and tag it as a user page.
>>  	 */
>> -	spin_lock_irqsave(&page->xpfo_lock, flags);
>> -
>>  	if (atomic_dec_return(&page->xpfo_mapcount) =3D=3D 0) {
>> -#ifdef CONFIG_XPFO_DEBUG
>> -		WARN_ON(PageXpfoUnmapped(page));
>> -#endif
>> -		SetPageXpfoUnmapped(page);
>> -		set_kpte(kaddr, page, __pgprot(0));
>> -		xpfo_flush_kernel_tlb(page, 0);
>> +		spin_lock_irqsave(&page->xpfo_lock, flags);
>> +
>> +		/*
>> +		 * In the case, where we raced with kmap after the
>> +		 * atomic_dec_return, we must not nuke the mapping.
>> +		 */
>> +		if (atomic_read(&page->xpfo_mapcount) =3D=3D 0) {
>> +			SetPageXpfoUnmapped(page);
>> +			set_kpte(kaddr, page, __pgprot(0));
>> +			flush_tlb =3D true;
>> +		}
>> +		spin_unlock_irqrestore(&page->xpfo_lock, flags);
>>  	}
>> =20
>> -	spin_unlock_irqrestore(&page->xpfo_lock, flags);
>> +	if (flush_tlb)
>> +		xpfo_flush_kernel_tlb(page, 0);
>>  }
>=20
> This doesn't help with the TLB invalidation issue, AFAICT this is still=

> completely buggered. kunmap_atomic() can be called from IRQ context.
>=20

OK. xpfo_kmap/xpfo_kunmap need redesign.

--
Khalid
