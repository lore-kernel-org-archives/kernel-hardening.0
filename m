Subject: Re: [RFC PATCH v8 13/14] xpfo, mm: Defer TLB flushes for non-current
 CPUs (x86 only)
References: <cover.1550088114.git.khalid.aziz@oracle.com>
 <98134cb73e911b2f0b59ffb76243a7777963d218.1550088114.git.khalid.aziz@oracle.com>
 <a6510fa8-e96d-677b-78df-da9a19c4089b@intel.com>
From: Khalid Aziz <khalid.aziz@oracle.com>
Message-ID: <95fb62d4-1dbc-e420-74c1-ff929c5552e1@oracle.com>
Date: Thu, 14 Feb 2019 12:57:30 -0700
MIME-Version: 1.0
In-Reply-To: <a6510fa8-e96d-677b-78df-da9a19c4089b@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: Dave Hansen <dave.hansen@intel.com>, juergh@gmail.com, tycho@tycho.ws, jsteckli@amazon.de, ak@linux.intel.com, torvalds@linux-foundation.org, liran.alon@oracle.com, keescook@google.com, akpm@linux-foundation.org, mhocko@suse.com, catalin.marinas@arm.com, will.deacon@arm.com, jmorris@namei.org, konrad.wilk@oracle.com
Cc: deepa.srinivasan@oracle.com, chris.hyser@oracle.com, tyhicks@canonical.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com, jcm@redhat.com, boris.ostrovsky@oracle.com, kanth.ghatraju@oracle.com, joao.m.martins@oracle.com, jmattson@google.com, pradeep.vincent@oracle.com, john.haxby@oracle.com, tglx@linutronix.de, kirill.shutemov@linux.intel.com, hch@lst.de, steven.sistare@oracle.com, labbott@redhat.com, luto@kernel.org, peterz@infradead.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 2/14/19 10:42 AM, Dave Hansen wrote:
>>  #endif
>> +
>> +	/* If there is a pending TLB flush for this CPU due to XPFO
>> +	 * flush, do it now.
>> +	 */
>=20
> Don't forget CodingStyle in all this, please.

Of course. I will fix that.

>=20
>> +	if (cpumask_test_and_clear_cpu(cpu, &pending_xpfo_flush)) {
>> +		count_vm_tlb_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
>> +		__flush_tlb_all();
>> +	}
>=20
> This seems to exist in parallel with all of the cpu_tlbstate
> infrastructure.  Shouldn't it go in there?

That sounds like a good idea. On the other hand, pending flush needs to
be kept track of entirely within arch/x86/mm/tlb.c and using a local
variable with scope limited to just that file feels like a lighter
weight implementation. I could go either way.

>=20
> Also, if we're doing full flushes like this, it seems a bit wasteful to=

> then go and do later things like invalidate_user_asid() when we *know*
> that the asid would have been flushed by this operation.  I'm pretty
> sure this isn't the only __flush_tlb_all() callsite that does this, so
> it's not really criticism of this patch specifically.  It's more of a
> structural issue.
>=20
>=20

That is a good point. It is not just wasteful, it is bound to have
performance impact even if slight.

>> +void xpfo_flush_tlb_kernel_range(unsigned long start, unsigned long e=
nd)
>> +{
>=20
> This is a bit lightly commented.  Please give this some good
> descriptions about the logic behind the implementation and the tradeoff=
s
> that are in play.
>=20
> This is doing a local flush, but deferring the flushes on all other
> processors, right?  Can you explain the logic behind that in a comment
> here, please?  This also has to be called with preemption disabled, rig=
ht?
>=20
>> +	struct cpumask tmp_mask;
>> +
>> +	/* Balance as user space task's flush, a bit conservative */
>> +	if (end =3D=3D TLB_FLUSH_ALL ||
>> +	    (end - start) > tlb_single_page_flush_ceiling << PAGE_SHIFT) {
>> +		do_flush_tlb_all(NULL);
>> +	} else {
>> +		struct flush_tlb_info info;
>> +
>> +		info.start =3D start;
>> +		info.end =3D end;
>> +		do_kernel_range_flush(&info);
>> +	}
>> +	cpumask_setall(&tmp_mask);
>> +	cpumask_clear_cpu(smp_processor_id(), &tmp_mask);
>> +	cpumask_or(&pending_xpfo_flush, &pending_xpfo_flush, &tmp_mask);
>> +}
>=20
> Fun.  cpumask_setall() is non-atomic while cpumask_clear_cpu() and
> cpumask_or() *are* atomic.  The cpumask_clear_cpu() is operating on
> thread-local storage and doesn't need to be atomic.  Please make it
> __cpumask_clear_cpu().
>=20

I will fix that. Thanks!

--
Khalid
