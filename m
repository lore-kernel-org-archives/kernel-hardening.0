Resent-To: kernel-hardening@lists.openwall.com
Resent-Message-ID: <ciirm8pnu5mmj5.fsf@u54ee758033e858cfa736.ant.amazon.com>
From: Julian Stecklina <jsteckli@amazon.de>
Subject: Re: [RFC PATCH 0/6] Process-local memory allocations
References: <cover.1542722764.git.jsteckli@amazon.de>
	<20181120232619.GA13641@cisco>
Date: Thu, 13 Dec 2018 15:28:15 +0100
In-Reply-To: <20181120232619.GA13641@cisco> (Tycho Andersen's message of "Tue,
	20 Nov 2018 16:26:19 -0700")
Message-ID: <ciirm8tvjhmrgg.fsf@u54ee758033e858cfa736.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Tycho Andersen <tycho@tycho.ws>
Cc: kernel-hardening@lists.openwall.com, Liran Alon <liran.alon@oracle.com>, Jonathan Adams <jwadams@google.com>, David Woodhouse <dwmw2@infradead.org>, Igor Stoppa <igor.stoppa@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Tycho,

sorry for the late response, I just returned from vacation.

Tycho Andersen <tycho@tycho.ws> writes:

> On Tue, Nov 20, 2018 at 03:07:59PM +0100, Julian Stecklina wrote:
>> In a world with processor information leak vulnerabilities, having a treasure
>> trove of information available for leaking in the global kernel address space
>> is
>> starting to be a liability. The biggest offender is the linear mapping of all
>> physical memory and there are already efforts (XPFO) to start addressing this.
>> In this patch series, I'd like to propose breaking up the kernel address space
>> further and introduce process-local mappings in the kernel.
>> 
>> The rationale is that there are allocations in the kernel containing data that
>> should only be accessible when the kernel is executing in the context of a
>> specific process. A prime example is KVM vCPU state. This patch series
>> introduces process-local memory in the kernel address space by claiming a PGD
>> entry for this specific purpose. Then it converts KVM on x86 to use these new
>> primitives to store GPR and FPU registers of vCPUs. KVM is a good testing
>> ground, because it makes sure userspace can only interact with a VM from a
>> single process.
[...]
> This seems similar in spirit to prmem:
> https://lore.kernel.org/lkml/20181023213504.28905-2-igor.stoppa@huawei.com/T/#u

It's similar in the sense that it adds a new way to allocate memory with
interesting properties. In that sense, it would be useful to have a
common allocation function.

As far as usage is concerned, prmem and the process local memory is very
different. From a quick glance at the prmem patchset, I see that it
works for statically allocated memory. Process-local memory is by
definition bound to the lifetime of a process (or address space to be
more precise) and thus cannot be statically allocated. It's breaking up
the global address space of the kernel and starts binding some
allocations in the kernel to specific processes.

My goal is specifically L1TF mitigation and preventing random parts of
the kernel from prefetching user data, but this approach is equally
effective for ordinary info leak vulnerabilities.

> Basically, we have some special memory that we want to leave unmapped
> (read only) most of the time, but map it (writable) sometimes. I

Unmapped should really be unmapped, i.e. not present in the page table.
Having it read-only defeats the purpose.

> wonder if we should merge the APIs in to one
>
> spmemalloc(size, flags, PRLOCAL)
>
> type thing? Could we share some infrastructure then? (I also didn't
> follow what happened to the patches Nadav was going to send that might
> replace prmem somehow.)

When writing the patch series, I had the feeling that the whole
bookkeeping of what is allocated where is something that could be
abstracted and re-used. Maybe there is already such an abstraction layer
in the kernel and I just didn't find it.

Julian
