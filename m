Subject: Re: [PATCH 5/8] Protectable Memory
References: <20180313214554.28521-1-igor.stoppa@huawei.com>
 <20180313214554.28521-6-igor.stoppa@huawei.com>
 <20180314121547.GE29631@bombadil.infradead.org>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <eb9bc944-b1de-48d9-652f-9f898ec4fcec@huawei.com>
Date: Wed, 14 Mar 2018 15:02:06 +0200
MIME-Version: 1.0
In-Reply-To: <20180314121547.GE29631@bombadil.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: david@fromorbit.com, rppt@linux.vnet.ibm.com, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 14/03/18 14:15, Matthew Wilcox wrote:
> On Tue, Mar 13, 2018 at 11:45:51PM +0200, Igor Stoppa wrote:
>> +static inline void *pmalloc_array(struct gen_pool *pool, size_t n,
>> +				  size_t size, gfp_t flags)
>> +{
>> +	if (unlikely(!(pool && n && size)))
>> +		return NULL;
> 
> Why not use the same formula as kvmalloc_array here?  You've failed to
> protect against integer overflow, which is the whole point of pmalloc_array.
> 
> 	if (size != 0 && n > SIZE_MAX / size)
> 		return NULL;


oops :-(

>> +static inline char *pstrdup(struct gen_pool *pool, const char *s, gfp_t gfp)
>> +{
>> +	size_t len;
>> +	char *buf;
>> +
>> +	if (unlikely(pool == NULL || s == NULL))
>> +		return NULL;
> 
> No, delete these checks.  They'll mask real bugs.

I thought I got rid of all of them, but some have escaped me

>> +static inline void pfree(struct gen_pool *pool, const void *addr)
>> +{
>> +	gen_pool_free(pool, (unsigned long)addr, 0);
>> +}
> 
> It's poor form to use a different subsystem's type here.  It ties you
> to genpool, so if somebody wants to replace it, you have to go through
> all the users and change them.  If you use your own type, it's a much
> easier task.

I thought about it, but typedef came to my mind and knowing it's usually
frowned upon, I restrained myself.

> struct pmalloc_pool {
> 	struct gen_pool g;
> }

I didn't think this could be acceptable either. But if it is, then ok.

> then:
> 
> static inline void pfree(struct pmalloc_pool *pool, const void *addr)
> {
> 	gen_pool_free(&pool->g, (unsigned long)addr, 0);
> }
> 
> Looking further down, you could (should) move the contents of pmalloc_data
> into pmalloc_pool; that's one fewer object to keep track of.
> 
>> +struct pmalloc_data {
>> +	struct gen_pool *pool;  /* Link back to the associated pool. */
>> +	bool protected;     /* Status of the pool: RO or RW. */
>> +	struct kobj_attribute attr_protected; /* Sysfs attribute. */
>> +	struct kobj_attribute attr_avail;     /* Sysfs attribute. */
>> +	struct kobj_attribute attr_size;      /* Sysfs attribute. */
>> +	struct kobj_attribute attr_chunks;    /* Sysfs attribute. */
>> +	struct kobject *pool_kobject;
>> +	struct list_head node; /* list of pools */
>> +};
> 
> sysfs attributes aren't free, you know.  I appreciate you want something
> to help debug / analyse, but having one file for the whole subsystem or
> at least one per pool would be a better idea.

Which means that it should not be normal sysfs, but rather debugfs, if I
understand correctly, since in sysfs 1 value -> 1 file.

--
igor
