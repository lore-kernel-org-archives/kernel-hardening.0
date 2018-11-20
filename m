Date: Tue, 20 Nov 2018 16:26:19 -0700
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [RFC PATCH 0/6] Process-local memory allocations
Message-ID: <20181120232619.GA13641@cisco>
References: <cover.1542722764.git.jsteckli@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1542722764.git.jsteckli@amazon.de>
To: Julian Stecklina <jsteckli@amazon.de>
Cc: kernel-hardening@lists.openwall.com, Liran Alon <liran.alon@oracle.com>, Jonathan Adams <jwadams@google.com>, David Woodhouse <dwmw2@infradead.org>, Igor Stoppa <igor.stoppa@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 20, 2018 at 03:07:59PM +0100, Julian Stecklina wrote:
> In a world with processor information leak vulnerabilities, having a treasure
> trove of information available for leaking in the global kernel address space is
> starting to be a liability. The biggest offender is the linear mapping of all
> physical memory and there are already efforts (XPFO) to start addressing this.
> In this patch series, I'd like to propose breaking up the kernel address space
> further and introduce process-local mappings in the kernel.
> 
> The rationale is that there are allocations in the kernel containing data that
> should only be accessible when the kernel is executing in the context of a
> specific process. A prime example is KVM vCPU state. This patch series
> introduces process-local memory in the kernel address space by claiming a PGD
> entry for this specific purpose. Then it converts KVM on x86 to use these new
> primitives to store GPR and FPU registers of vCPUs. KVM is a good testing
> ground, because it makes sure userspace can only interact with a VM from a
> single process.
> 
> Process-local allocations in the kernel can be part of a robust L1TF mitigation
> strategy that works even with SMT enabled. The specific goal here is to make it
> harder for a random thread using cache load gadget (usually a bounds check of a
> system call argument plus array access suffices) to prefetch interesting data
> into the L1 cache and use L1TF to leak this data.
> 
> The patch set applies to kvm/next [1]. Feedback is very welcome, both about the
> general approach and the actual implementation. As far as testing goes, the KVM
> unit tests seem happy on Intel. AMD is only compile tested at the moment.

This seems similar in spirit to prmem:
https://lore.kernel.org/lkml/20181023213504.28905-2-igor.stoppa@huawei.com/T/#u

Basically, we have some special memory that we want to leave unmapped
(read only) most of the time, but map it (writable) sometimes. I
wonder if we should merge the APIs in to one

spmemalloc(size, flags, PRLOCAL)

type thing? Could we share some infrastructure then? (I also didn't
follow what happened to the patches Nadav was going to send that might
replace prmem somehow.)

Tycho
