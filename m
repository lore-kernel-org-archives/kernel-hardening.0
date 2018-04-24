Subject: Re: [PATCH 7/9] Pmalloc Rare Write: modify selected pools
From: Igor Stoppa <igor.stoppa@gmail.com>
References: <20180423125458.5338-1-igor.stoppa@huawei.com>
 <20180423125458.5338-8-igor.stoppa@huawei.com>
 <20180424115050.GD26636@bombadil.infradead.org>
 <98799559-121f-3d9d-343f-b22d30f21b6d@gmail.com>
Message-ID: <be0c9294-90a3-5820-dca2-7ce0a9a5dcab@gmail.com>
Date: Tue, 24 Apr 2018 21:04:42 +0400
MIME-Version: 1.0
In-Reply-To: <98799559-121f-3d9d-343f-b22d30f21b6d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Matthew Wilcox <willy@infradead.org>
Cc: keescook@chromium.org, paul@paul-moore.com, sds@tycho.nsa.gov, mhocko@kernel.org, corbet@lwn.net, labbott@redhat.com, david@fromorbit.com, rppt@linux.vnet.ibm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Igor Stoppa <igor.stoppa@huawei.com>, Carlos Chinea Perez <carlos.chinea.perez@huawei.com>, Remi Denis Courmont <remi.denis.courmont@huawei.com>, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 24/04/18 16:33, Igor Stoppa wrote:
> 
> 
> On 24/04/18 15:50, Matthew Wilcox wrote:
>> On Mon, Apr 23, 2018 at 04:54:56PM +0400, Igor Stoppa wrote:
>>> While the vanilla version of pmalloc provides support for permanently
>>> transitioning between writable and read-only of a memory pool, this
>>> patch seeks to support a separate class of data, which would still
>>> benefit from write protection, most of the time, but it still needs to
>>> be modifiable. Maybe very seldom, but still cannot be permanently marked
>>> as read-only.
>>
>> This seems like a horrible idea that basically makes this feature 
>> useless.
>> I would say the right way to do this is to have:
>>
>> struct modifiable_data {
>>     struct immutable_data *d;
>>     ...
>> };
>>
>> Then allocate a new pool, change d and destroy the old pool.
> 
> I'm not sure I understand.

A few cups of coffee later ...

This seems like a regression from my case.

My case (see the example with the initialized state) is:

static void *pointer_to_pmalloc_memory __ro_after_init;

then, during init:

pointer_to_pmalloc_memory = pmalloc(pool, size);

then init happens

*pointer_to_pmalloc_memory = some_value;

pmalloc_protect_pool(pool9;

and to change the value:

support_variable = some_other_value;

pmalloc_rare_write(pool, pointer_to_pmalloc_memory,
                    &support_variable, size)

But in this case the pmalloc allocation would be assigned to a writable 
variable.

This seems like a regression to me: at this point who cares anymore 
about the pmalloc memory?

Just rewrite the pointer to point to somewhere else that is writable and 
has the desired (from the attacker) value.

It doesn't even require gadgets. pmalloc becomes useless.

Do I still need more coffee?

--
igor
