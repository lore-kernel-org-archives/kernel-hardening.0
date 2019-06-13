Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
 <CALCETrXHbS9VXfZ80kOjiTrreM2EbapYeGp68mvJPbosUtorYA@mail.gmail.com>
From: Alexander Graf <graf@amazon.com>
Message-ID: <459e2273-bc27-f422-601b-2d6cdaf06f84@amazon.com>
Date: Thu, 13 Jun 2019 09:52:51 +0200
MIME-Version: 1.0
In-Reply-To: <CALCETrXHbS9VXfZ80kOjiTrreM2EbapYeGp68mvJPbosUtorYA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
To: Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Nadav Amit <namit@vmware.com>
Cc: Marius Hillenbrand <mhillenb@amazon.de>, kvm list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, the
 arch/x86 maintainers <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>


On 13.06.19 03:30, Andy Lutomirski wrote:
> On Wed, Jun 12, 2019 at 1:27 PM Andy Lutomirski <luto@amacapital.net> wrote:
>>
>>
>>> On Jun 12, 2019, at 12:55 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>>>
>>>> On 6/12/19 10:08 AM, Marius Hillenbrand wrote:
>>>> This patch series proposes to introduce a region for what we call
>>>> process-local memory into the kernel's virtual address space.
>>> It might be fun to cc some x86 folks on this series.  They might have
>>> some relevant opinions. ;)
>>>
>>> A few high-level questions:
>>>
>>> Why go to all this trouble to hide guest state like registers if all the
>>> guest data itself is still mapped?
>>>
>>> Where's the context-switching code?  Did I just miss it?
>>>
>>> We've discussed having per-cpu page tables where a given PGD is only in
>>> use from one CPU at a time.  I *think* this scheme still works in such a
>>> case, it just adds one more PGD entry that would have to context-switched.
>> Fair warning: Linus is on record as absolutely hating this idea. He might change his mind, but it’s an uphill battle.
> I looked at the patch, and it (sensibly) has nothing to do with
> per-cpu PGDs.  So it's in great shape!


Thanks a lot for the very timely review!


>
> Seriously, though, here are some very high-level review comments:
>
> Please don't call it "process local", since "process" is meaningless.
> Call it "mm local" or something like that.


Naming is hard, yes :). Is "mmlocal" obvious enough to most readers? I'm 
not fully convinced, but I don't find it better or worse than proclocal. 
So whatever flies with the majority works for me :).


> We already have a per-mm kernel mapping: the LDT.  So please nix all
> the code that adds a new VA region, etc, except to the extent that
> some of it consists of valid cleanups in and of itself.  Instead,
> please refactor the LDT code (arch/x86/kernel/ldt.c, mainly) to make
> it use a more general "mm local" address range, and then reuse the
> same infrastructure for other fancy things.  The code that makes it


I don't fully understand how those two are related. Are you referring to 
the KPTI enabling code in there? That just maps the LDT at the same 
address in both kernel and user mappings, no?

So you're suggesting we use the new mm local address as LDT address 
instead and have that mapped in both kernel and user space? This patch 
set today maps "mm local" data only in kernel space, not in user space, 
as it's meant for kernel data structures.

So I'm not really seeing the path to adapt any of the LDT logic to this. 
Could you please elaborate?


> KASLR-able should be in its very own patch that applies *after* the
> code that makes it all work so that, when the KASLR part causes a
> crash, we can bisect it.


That sounds very reasonable, yes.


>
> + /*
> + * Faults in process-local memory may be caused by process-local
> + * addresses leaking into other contexts.
> + * tbd: warn and handle gracefully.
> + */
> + if (unlikely(fault_in_process_local(address))) {
> + pr_err("page fault in PROCLOCAL at %lx", address);
> + force_sig_fault(SIGSEGV, SEGV_MAPERR, (void __user *)address, current);
> + }
> +
>
> Huh?  Either it's an OOPS or you shouldn't print any special
> debugging.  As it is, you're just blatantly leaking the address of the
> mm-local range to malicious user programs.


Yes, this is a left over bit from an idea that we discussed and rejected 
yesterday. The idea was to have a DEBUG config option that allows 
proclocal memory to leak into other processes, but print debug output so 
that it's easier to catch bugs. After discussion, I think we managed to 
convince everyone that an OOPS is the better tool to find bugs :).

Any trace of this will disappear in the next version.


>
> Also, you should IMO consider using this mechanism for kmap_atomic().


It might make sense to use it for kmap_atomic() for debug purposes, as 
it ensures that other users can no longer access the same mapping 
through the linear map. However, it does come at quite a big cost, as we 
need to shoot down the TLB of all other threads in the system. So I'm 
not sure it's of general value?


Alex


> Hi, Nadav!
