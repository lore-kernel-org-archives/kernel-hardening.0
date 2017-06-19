References: <20170607123505.16629-1-igor.stoppa@huawei.com>
 <20170607123505.16629-3-igor.stoppa@huawei.com>
 <ace6f45a-2d21-9a00-fa74-518ac727074f@redhat.com>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <5dfc037e-4812-898b-b173-cd0d1a61a701@huawei.com>
Date: Mon, 19 Jun 2017 10:12:22 +0300
MIME-Version: 1.0
In-Reply-To: <ace6f45a-2d21-9a00-fa74-518ac727074f@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 2/4] Protectable Memory Allocator
To: Laura Abbott <labbott@redhat.com>, keescook@chromium.org, mhocko@kernel.org, jmorris@namei.org
Cc: penguin-kernel@I-love.SAKURA.ne.jp, paul@paul-moore.com, sds@tycho.nsa.gov, casey@schaufler-ca.com, hch@infradead.org, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 09/06/17 21:56, Laura Abbott wrote:
> On 06/07/2017 05:35 AM, Igor Stoppa wrote:

[...]

> The pool logic looks remarkably similar to genalloc (lib/genalloc.c).
> It's not a perfect 1-to-1 mapping but it's close enough to be worth
> a look.

Indeed. I have prepared a new incarnation of pmalloc, based on genalloc.
There are a couple of things that I would like to adjust in genalloc,
but I'll discuss this in the new submission.

>> +
>> +const char msg[] = "Not a valid Pmalloc object.";
>> +const char *__pmalloc_check_object(const void *ptr, unsigned long n)
>> +{
>> +	unsigned long p;
>> +
>> +	p = (unsigned long)ptr;
>> +	n = p + n - 1;
>> +	for (; (PAGE_MASK & p) <= (PAGE_MASK & n); p += PAGE_SIZE) {
>> +		if (is_vmalloc_addr((void *)p)) {
>> +			struct page *page;
>> +
>> +			page = vmalloc_to_page((void *)p);
>> +			if (!(page && PagePmalloc(page)))
>> +				return msg;
>> +		}
> 
> Should this be an error if is_vmalloc_addr returns false?

Yes, if this function is called, at least the beginning of the range
*is* a vmalloc address and therefore the rest should be a vmalloc
address as well.

thanks, igor
