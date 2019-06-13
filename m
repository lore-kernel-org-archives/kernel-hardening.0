Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
 <CALCETrXHbS9VXfZ80kOjiTrreM2EbapYeGp68mvJPbosUtorYA@mail.gmail.com>
 <459e2273-bc27-f422-601b-2d6cdaf06f84@amazon.com>
 <CALCETrVRuQb-P7auHCgxzs5L=qA2_qHzVGTtRMAqoMAut0ETFw@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <f1dfbfb4-d2d5-bf30-600f-9e756a352860@intel.com>
Date: Thu, 13 Jun 2019 09:20:53 -0700
MIME-Version: 1.0
In-Reply-To: <CALCETrVRuQb-P7auHCgxzs5L=qA2_qHzVGTtRMAqoMAut0ETFw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Andy Lutomirski <luto@kernel.org>, Alexander Graf <graf@amazon.com>, Nadav Amit <namit@vmware.com>
Cc: Marius Hillenbrand <mhillenb@amazon.de>, kvm list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, the arch/x86 maintainers <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 6/13/19 9:13 AM, Andy Lutomirski wrote:
>> It might make sense to use it for kmap_atomic() for debug purposes, as
>> it ensures that other users can no longer access the same mapping
>> through the linear map. However, it does come at quite a big cost, as we
>> need to shoot down the TLB of all other threads in the system. So I'm
>> not sure it's of general value?
> What I meant was that kmap_atomic() could use mm-local memory so that
> it doesn't need to do a global shootdown.  But I guess it's not
> actually used for real on 64-bit, so this is mostly moot.  Are you
> planning to support mm-local on 32-bit?

Do we *do* global shootdowns on kmap_atomic()s on 32-bit?  I thought we
used entirely per-cpu addresses, so a stale entry from another CPU can
get loaded in the TLB speculatively but it won't ever actually get used.
 I think it goes:

kunmap_atomic() ->
__kunmap_atomic() ->
kpte_clear_flush() ->
__flush_tlb_one_kernel() ->
__flush_tlb_one_user() ->
__native_flush_tlb_one_user() ->
invlpg

The per-cpu address calculation is visible in kmap_atomic_prot():

        idx = type + KM_TYPE_NR*smp_processor_id();
