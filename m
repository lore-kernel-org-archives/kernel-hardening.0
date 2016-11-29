Reply-To: kernel-hardening@lists.openwall.com
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net>
From: Alexey Kardashevskiy <aik@ozlabs.ru>
Message-ID: <000779ba-0b53-3064-db8a-f309b2c993f5@ozlabs.ru>
Date: Tue, 29 Nov 2016 14:19:56 +1100
MIME-Version: 1.0
In-Reply-To: <20161128121347.GY3092@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: Peter Zijlstra <peterz@infradead.org>, "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, david@gibson.dropbear.id.au
List-ID: <kernel-hardening.lists.openwall.com>

On 28/11/16 23:13, Peter Zijlstra wrote:
> On Mon, Nov 28, 2016 at 11:56:17AM +0000, Reshetova, Elena wrote:
>> First, about the types. 
>> We do have a number of instances of atomic_long_t used as refcounters, see below:
> 
> Right, those were expected. We could do long_refcount_t I suppose.
> 
>> And yes, we *do* have at least one instance (again not 100% finished,
>> more might show up) of atomic64_t used as refcounter:
>>
>> arch/powerpc/mm/mmu_context_iommu.c:
>> struct mm_iommu_table_group_mem_t {
>> ...
>>     atomic64_t mapped;
>> ...
>> }
> 
> *urgh*, Alexey does that really need to be atomic64_t ? Wouldn't
> atomic_long_t work for you?


It would, this code only works in 64bit where long==64bit anyway (in fact
even 32bit variant would do).



-- 
Alexey
