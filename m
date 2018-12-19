Subject: Re: [RFC PATCH 0/6] Process-local memory allocations
References: <cover.1542722764.git.jsteckli@amazon.de>
 <20181120232619.GA13641@cisco>
 <ciirm8tvjhmrgg.fsf@u54ee758033e858cfa736.ant.amazon.com>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <89247bcb-d48e-99fb-8904-c1120c1567db@gmail.com>
Date: Thu, 20 Dec 2018 01:00:13 +0200
MIME-Version: 1.0
In-Reply-To: <ciirm8tvjhmrgg.fsf@u54ee758033e858cfa736.ant.amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Julian Stecklina <jsteckli@amazon.de>, Tycho Andersen <tycho@tycho.ws>
Cc: kernel-hardening@lists.openwall.com, Liran Alon <liran.alon@oracle.com>, Jonathan Adams <jwadams@google.com>, David Woodhouse <dwmw2@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On 13/12/2018 16:28, Julian Stecklina wrote:

> As far as usage is concerned, prmem and the process local memory is very
> different. From a quick glance at the prmem patchset, I see that it
> works for statically allocated memory. 

I suspect you have looked only at the latest patchset, which is a subset 
of the whole feature-set.
It was agreed that I would first address the integration of write-rare 
for statically allocated memory, and so I did.

But the origin of this work actually resides in protecting the  SELinux 
policyDB, which is entirely dynamically allocated.

> Process-local memory is by
> definition bound to the lifetime of a process (or address space to be
> more precise) and thus cannot be statically allocated. It's breaking up
> the global address space of the kernel and starts binding some
> allocations in the kernel to specific processes.

yes, I agree with the explanation you give, however the starting 
assumption (prmem is only static) is not correct.
> 
> My goal is specifically L1TF mitigation and preventing random parts of
> the kernel from prefetching user data, but this approach is equally
> effective for ordinary info leak vulnerabilities.
> 
>> Basically, we have some special memory that we want to leave unmapped
>> (read only) most of the time, but map it (writable) sometimes.


This would apply nicely also to kernel data that is particularly 
sensitive and one would not want to expose to random (possibly buggy) reads.

> Unmapped should really be unmapped, i.e. not present in the page table.
> Having it read-only defeats the purpose.

Given the current implementation (for x86_64) which uses an alternate 
mapping for writable, it should not be too difficult to use a similar 
mechanism for implementing a sort of alternative to a TEE data-vault.

Instead of using a special function to alter normally readable data, it 
would use a special function to read/write normally unaccessible data.

But, before getting into that, I'd prefer to first get the write rare 
static merged or at least ACKed.

--
igor
