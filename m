From: Igor Stoppa <igor.stoppa@huawei.com>
References: <20180123211508.GC5565@bombadil.infradead.org>
 <CAGXu5jJiE2yOvCpbU6U7WijNniitwW7fz3gUXZiZUbJb91auVQ@mail.gmail.com>
Message-ID: <be070733-71f4-b296-69c9-e0de9efdd357@huawei.com>
Date: Wed, 24 Jan 2018 20:05:54 +0200
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJiE2yOvCpbU6U7WijNniitwW7fz3gUXZiZUbJb91auVQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: Write-once memory
To: Kees Cook <keescook@google.com>, Matthew Wilcox <willy@infradead.org>, Laura Abbott <labbott@redhat.com>
Cc: kernel-hardening@lists.openwall.com, Dave Chinner <dchinner@redhat.com>, Christopher Lameter <cl@linux.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

+ Laura Abbott

On 24/01/18 02:01, Kees Cook wrote:
> On Wed, Jan 24, 2018 at 8:15 AM, Matthew Wilcox <willy@infradead.org> wrote:
>> At the kernel hardening BOF yesterday, we came up with the concept of
>> write-once memory.
> 
> This is something Igor Stoppa has also been looking at too:
> https://lkml.org/lkml/2017/7/10/400

Yes, I still have such plan, however I had to first solve other
problems, like improving genalloc, to have in pmalloc a drop-in
replacement for kmalloc, mirroring the kfree signature (plus the pool).

Free support is needed because in some case one might have to roll back
the allocation, before the pool is protected.

And the chunks of memory to free do not always have the same size, which
would make it more complex to track, if the allocator doesn't have an
internal mechanism.

Unfortunately, I had some unrelated tasks that kept me from speedier
development of this :-/   But now I have it ready for review.

https://lkml.org/lkml/2018/1/24/602

>> The problem it's intended to solve is that XFS allocates a large amount
>> of memory at filesystem mount time which is conceptually read-only until
>> it's destroyed.  Protecting this by making the pages read-only would be
>> a nice hardening improvement (both for security and as a defense against
>> stray writes).
>>
>> At the moment that data is mixed in with read-write data, so XFS will need
>> modifying to use this new facility.

This is precisely the reason why I had to come up with pmalloc, to
segregate R/O data in a separate set of pages.

Could pmalloc be of use for XFS, even if it's not a direct followup to
the discussion in the hardening BOF?

In that sense, I think it implicitly validates the idea behind my
initial proposal :-)

>> We believe that the right way to support write-once memory is through
>> slab APIs.  Something like:
> 
> I do like the idea of making this part of the slab API, instead of as
> a separate allocator.

When I proposed something similar, I got this (summarized) reply:

-----8<------8<------8<------8<------8<------8<------8<------8<------

https://lkml.org/lkml/2017/5/4/517

On 04/05/17 19:49, Laura Abbott wrote:

> arm and arm64 have the added complexity of using larger
> page sizes on the linear map so dynamic mapping/unmapping generally
> doesn't work. arm64 supports DEBUG_PAGEALLOC by mapping with only
> pages but this is generally only wanted as a debug mechanism.
> I don't know if you've given this any thought at all.


https://lkml.org/lkml/2017/5/8/340:

On 08/05/17 18:25, Laura Abbott wrote:

> PAGE_SIZE is still 4K/16K/64K but the underlying page table mappings
> may use larger mappings (2MB, 32M, 512M, etc.). The ARM architecture
> has a break-before-make requirement which requires old mappings be
> fully torn down and invalidated to avoid TLB conflicts. This is nearly
> impossible to do correctly on live page tables so the current policy
> is to not break down larger mappings.

-----8<------8<------8<------8<------8<------8<------8<------8<------


So I could not use kmalloc as backend and I floated toward vmalloc.

Laura Abbot was very helpful reviewing preliminary implementations and
eventually she suggested I would switch to genalloc, since I almost came
up with a 1:1 reimplementation of it.

Using genalloc on top of vmalloc reduces significantly TLB pressure and
allows to have (at least on 64bit arch) fairly large amounts of
(virtually) contiguous memory, without the need for structures like
flex_array.

I have not published this yet, but I have a re-implementation of the
SELinux policyDB which uses pmalloc, where I was able to revert the
introduction of flex_array to kmalloc and then convert that to pmalloc.

This was a good case study for me, because it pointed out the need for a
free functionality, when reverting the allocations, in presence of a
parsing error of the SELinux rules.

>> void kmem_cache_init_once(struct kmem_cache *s, void (*init)(void *),
>>                 void *data);
>>
>> used like this:
>>
>> const struct my_ro_data *alloc_my_ro_data(struct my_context *context, gfp_t gfp)
>> {
>>         const struct my_ro_data *p = kmem_cache_alloc(cache, gfp);
>>         kmem_cache_init_once(p, my_init_once, context);
>>         return p;
>> }
>>
>> The implementation would change the page protection on that slab page
>> from RO to RW temporarily while my_init_once() is running.  This would
>> lead to a short window of vulnerability, but that doesn't feel like
>> an unreasonable tradeoff for memory efficiency (being able to allocate
>> multiple my_ro_data per page).
> 
> The memory permission lifetime of the allocation needs very careful
> attention. Allowing the write permission to be visible to other CPUs
> needs to be avoided.

As we discussed, a pmalloc pool - once it is protected - stays read-only
until it is destroyed.

-----8<------8<------8<------8<------8<------8<------8<------8<------

https://lkml.org/lkml/2017/5/23/1406

On 23/05/17 23:11, Kees Cook wrote:
> Ah! In that case, sure. This isn't what the proposed API provided,
> though, so let's adjust it to only perform the unseal at destroy time.
> That makes it much saner, IMO. "Write once" dynamic allocations

-----8<------8<------8<------8<------8<------8<------8<------8<------



You also mentioned integration with hardened user copy, which is now
implemented, as requested (at that time it was called smalloc):

-----8<------8<------8<------8<------8<------8<------8<------8<------

https://lkml.org/lkml/2017/5/23/1406

On 23/05/17 23:11, Kees Cook wrote:
> I would want hardened usercopy support as a requirement for using
> smalloc(). Without it, we're regressing the over-read protection that
> already exists for slab objects, if kernel code switched from slab to
> smalloc.

-----8<------8<------8<------8<------8<------8<------8<------8<------


We also briefly talked about write-rare for it, which is something I
think could be implemented as COW, but there should be a way (maybe a
parameter when creating the pool) to specify and segregate data which
cannot be overwritten from data that can be overwritten.

No need to weaken the protection of really write-once data.

I do not have a patch for this yet, but if XFS needs only write-once
dynamic memory, then pmalloc is already suitable for that purpose, IMHO.

> If this is part of the design, it's likely an
> attacker can just race an allocation (which makes the page writable)
> with a bug that allows a write to the page from another CPU.
> Similarly, there shouldn't be a stand-alone "make this writable"
> function, but rather only a "free" action which makes it writable and
> returns it to the freelist. 

Yes, this is basically what you wrote to me some months ago and is
already addressed with destroy.

> To me, it seems that dealing with
> fragmentation, then, becomes the real problem.

Using vmalloc as provider, the fragmentation is not an issue and
genalloc mitigates most of the problems related to TLB trashing.

Actually, from that perspective,

vmalloc + genalloc + my patch for tracking of allocation sizes

should save both memory and TLB entrie.

Furthermore, it simplifies code that otherwise should be implemented
using flex_arrays or similar sparse structures, to cope with the
fragmentation of the linear memory.

I suspect that the use of pools, for indicating even more strongly the
affinity between data structures used by the same function(s) should
also improve the use of caches, in general, because the cache entry, if
sufficiently large, will automatically pre-load also what is nearby the
data that is actually being cached.

--
igor
