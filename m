Subject: Re: [RFC PATCH v7 14/16] EXPERIMENTAL: xpfo, mm: optimize spin lock
 usage in xpfo_kmap
References: <cover.1547153058.git.khalid.aziz@oracle.com>
 <7e8e17f519ae87a91fc6cbb57b8b27094c96305c.1547153058.git.khalid.aziz@oracle.com>
 <b2ffc4fd-e449-b6da-7070-4f182d44dd5b@redhat.com>
From: Khalid Aziz <khalid.aziz@oracle.com>
Message-ID: <1b46e0a5-476b-1eaa-3376-6848caf9e7ab@oracle.com>
Date: Thu, 17 Jan 2019 08:14:41 -0700
MIME-Version: 1.0
In-Reply-To: <b2ffc4fd-e449-b6da-7070-4f182d44dd5b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Laura Abbott <labbott@redhat.com>, juergh@gmail.com, tycho@tycho.ws, jsteckli@amazon.de, ak@linux.intel.com, torvalds@linux-foundation.org, liran.alon@oracle.com, keescook@google.com, konrad.wilk@oracle.com
Cc: deepa.srinivasan@oracle.com, chris.hyser@oracle.com, tyhicks@canonical.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com, jcm@redhat.com, boris.ostrovsky@oracle.com, kanth.ghatraju@oracle.com, joao.m.martins@oracle.com, jmattson@google.com, pradeep.vincent@oracle.com, john.haxby@oracle.com, tglx@linutronix.de, kirill.shutemov@linux.intel.com, hch@lst.de, steven.sistare@oracle.com, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, "Vasileios P . Kemerlis" <vpk@cs.columbia.edu>, Juerg Haefliger <juerg.haefliger@canonical.com>, Tycho Andersen <tycho@docker.com>, Marco Benatto <marco.antonio.780@gmail.com>, David Woodhouse <dwmw2@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 1/16/19 5:18 PM, Laura Abbott wrote:
> On 1/10/19 1:09 PM, Khalid Aziz wrote:
>> From: Julian Stecklina <jsteckli@amazon.de>
>>
>> We can reduce spin lock usage in xpfo_kmap to the 0->1 transition of
>> the mapcount. This means that xpfo_kmap() can now race and that we
>> get spurious page faults.
>>
>> The page fault handler helps the system make forward progress by
>> fixing the page table instead of allowing repeated page faults until
>> the right xpfo_kmap went through.
>>
>> Model-checked with up to 4 concurrent callers with Spin.
>>
> 
> This needs the spurious check for arm64 as well. This at
> least gets me booting but could probably use more review:
> 
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 7d9571f4ae3d..8f425848cbb9 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -32,6 +32,7 @@
>  #include <linux/perf_event.h>
>  #include <linux/preempt.h>
>  #include <linux/hugetlb.h>
> +#include <linux/xpfo.h>
>  
>  #include <asm/bug.h>
>  #include <asm/cmpxchg.h>
> @@ -289,6 +290,9 @@ static void __do_kernel_fault(unsigned long addr,
> unsigned int esr,
>         if (!is_el1_instruction_abort(esr) && fixup_exception(regs))
>                 return;
>  
> +       if (xpfo_spurious_fault(addr))
> +               return;
> +
>         if (is_el1_permission_fault(addr, esr, regs)) {
>                 if (esr & ESR_ELx_WNR)
>                         msg = "write to read-only memory";
> 
> 

That makes sense. Thanks for debugging this. I will add this to patch 14
("EXPERIMENTAL: xpfo, mm: optimize spin lock usage in xpfo_kmap").

Thanks,
Khalid
