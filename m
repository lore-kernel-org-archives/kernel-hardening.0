Subject: Re: [RFC PATCH 0/6] Process-local memory allocations
References: <cover.1542722764.git.jsteckli@amazon.de>
 <20181120232619.GA13641@cisco>
 <b37324d7-5d47-3ad6-d5f5-bd2b20a43f5b@gmail.com>
 <20181121174821.GA3313@cisco>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <4ce56f3c-225f-4985-7000-0fcf2f9ab5fd@gmail.com>
Date: Wed, 21 Nov 2018 20:12:32 +0200
MIME-Version: 1.0
In-Reply-To: <20181121174821.GA3313@cisco>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Tycho Andersen <tycho@tycho.ws>
Cc: Julian Stecklina <jsteckli@amazon.de>, kernel-hardening@lists.openwall.com, Liran Alon <liran.alon@oracle.com>, Jonathan Adams <jwadams@google.com>, David Woodhouse <dwmw2@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>



On 21/11/2018 19:48, Tycho Andersen wrote:
> On Wed, Nov 21, 2018 at 07:18:17PM +0200, Igor Stoppa wrote:
>> Hi,
>>
>> On 21/11/2018 01:26, Tycho Andersen wrote:

[...]

>>> This seems similar in spirit to prmem:
>>> https://lore.kernel.org/lkml/20181023213504.28905-2-igor.stoppa@huawei.com/T/#u
>>>
>>> Basically, we have some special memory that we want to leave unmapped
>>> (read only) most of the time, but map it (writable) sometimes. I
>>> wonder if we should merge the APIs in to one
>>>
>>> spmemalloc(size, flags, PRLOCAL)
>>>
>>> type thing? Could we share some infrastructure then?
>>
>> For what I can understand from the intro only, this seems to focus on
>> "local" information, related to processes, while prmem was mostly aimed, at
>> least at this stage, at system-level features, like LSM or SELinux.
>> Those have probably little value, for protection from reading.
>> And they are used quite often, typically on a critical path.
>> The main thing is to prevent rogue writes, but reads are not a problem.
>> Hiding/unhiding them even from read operations might not be so useful.
>>
>> However other components, like the kernel keyring, are used less frequently
>> and might be worth protecting them even from read operations.
> 
> Right, the goals are different, but the idea is basically the same. We
> allocate memory in some "special" way. I'm just wondering if we'll be
> adding more of these special ways in the future, and if it's worth
> synchronizing the APIs so that it's easy for people to use.

Yes, I agree. I do not see much use for this "locality" in most of the 
use cases that I have looked into, apart from maybe the kernel keyring,
but it might be possible to add a "scope" property to a memory pool, if 
it is associated to some very specific code.

Doing it for system-level components, however, might introduce too big 
an overhead. In these cases, the scope would stay global.

But I really need to see the code, before I can say more.

--
igor
