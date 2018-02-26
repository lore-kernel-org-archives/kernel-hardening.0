Subject: Re: [PATCH 2/7] genalloc: selftest
References: <20180223144807.1180-1-igor.stoppa@huawei.com>
 <20180223144807.1180-3-igor.stoppa@huawei.com>
 <76b3d858-b14e-b66d-d8ae-dbd0b307308a@gmail.com>
 <a7b47f45-5929-ae07-1a10-46a02f6db078@huawei.com>
From: J Freyensee <why2jjj.linux@gmail.com>
Message-ID: <45087800-218a-7ff5-22c0-d0a5bfea5001@gmail.com>
Date: Mon, 26 Feb 2018 09:46:43 -0800
MIME-Version: 1.0
In-Reply-To: <a7b47f45-5929-ae07-1a10-46a02f6db078@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Igor Stoppa <igor.stoppa@huawei.com>, david@fromorbit.com, willy@infradead.org, keescook@chromium.org, mhocko@kernel.org
Cc: labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 2/26/18 4:11 AM, Igor Stoppa wrote:
>
> On 24/02/18 00:42, J Freyensee wrote:
>>> +	locations[action->location] = gen_pool_alloc(pool, action->size);
>>> +	BUG_ON(!locations[action->location]);
>> Again, I'd think it through if you really want to use BUG_ON() or not:
>>
>> https://lwn.net/Articles/13183/
>> https://lkml.org/lkml/2016/10/4/1
> Is it acceptable to display only a WARNing, in case of risking damaging
> a mounted filesystem?

That's a good question.  Based upon those articles, 'yes'.  But it seems 
like a 'darned-if-you-do, darned-if-you-don't' question as couldn't you 
also corrupt a mounted filesystem by crashing the kernel, yes/no?

If you really want a system crash, maybe just do a panic() like 
filesystems also use?
>
> --
> igor
