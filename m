Date: Wed, 21 Nov 2018 10:48:21 -0700
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [RFC PATCH 0/6] Process-local memory allocations
Message-ID: <20181121174821.GA3313@cisco>
References: <cover.1542722764.git.jsteckli@amazon.de>
 <20181120232619.GA13641@cisco>
 <b37324d7-5d47-3ad6-d5f5-bd2b20a43f5b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b37324d7-5d47-3ad6-d5f5-bd2b20a43f5b@gmail.com>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Julian Stecklina <jsteckli@amazon.de>, kernel-hardening@lists.openwall.com, Liran Alon <liran.alon@oracle.com>, Jonathan Adams <jwadams@google.com>, David Woodhouse <dwmw2@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 21, 2018 at 07:18:17PM +0200, Igor Stoppa wrote:
> Hi,
> 
> On 21/11/2018 01:26, Tycho Andersen wrote:
> > On Tue, Nov 20, 2018 at 03:07:59PM +0100, Julian Stecklina wrote:
> > > In a world with processor information leak vulnerabilities, having a treasure
> > > trove of information available for leaking in the global kernel address space is
> > > starting to be a liability. The biggest offender is the linear mapping of all
> > > physical memory and there are already efforts (XPFO) to start addressing this.
> > > In this patch series, I'd like to propose breaking up the kernel address space
> > > further and introduce process-local mappings in the kernel.
> > > 
> > > The rationale is that there are allocations in the kernel containing data that
> > > should only be accessible when the kernel is executing in the context of a
> > > specific process. A prime example is KVM vCPU state. This patch series
> > > introduces process-local memory in the kernel address space by claiming a PGD
> > > entry for this specific purpose. Then it converts KVM on x86 to use these new
> > > primitives to store GPR and FPU registers of vCPUs. KVM is a good testing
> > > ground, because it makes sure userspace can only interact with a VM from a
> > > single process.
> > > 
> > > Process-local allocations in the kernel can be part of a robust L1TF mitigation
> > > strategy that works even with SMT enabled. The specific goal here is to make it
> > > harder for a random thread using cache load gadget (usually a bounds check of a
> > > system call argument plus array access suffices) to prefetch interesting data
> > > into the L1 cache and use L1TF to leak this data.
> > > 
> > > The patch set applies to kvm/next [1]. Feedback is very welcome, both about the
> > > general approach and the actual implementation. As far as testing goes, the KVM
> > > unit tests seem happy on Intel. AMD is only compile tested at the moment.
> 
> Where is the full set of patches?
> I'm sorry, I searched both KVM and LKML archives, but I couldn't find it.

It looks like they were only sent to kernel hardening, but not sent to
the archives? I only see our replies here:

https://www.openwall.com/lists/kernel-hardening/

Julian, perhaps you can re-send with a CC to lkml as well?

> > This seems similar in spirit to prmem:
> > https://lore.kernel.org/lkml/20181023213504.28905-2-igor.stoppa@huawei.com/T/#u
> > 
> > Basically, we have some special memory that we want to leave unmapped
> > (read only) most of the time, but map it (writable) sometimes. I
> > wonder if we should merge the APIs in to one
> > 
> > spmemalloc(size, flags, PRLOCAL)
> > 
> > type thing? Could we share some infrastructure then?
> 
> For what I can understand from the intro only, this seems to focus on
> "local" information, related to processes, while prmem was mostly aimed, at
> least at this stage, at system-level features, like LSM or SELinux.
> Those have probably little value, for protection from reading.
> And they are used quite often, typically on a critical path.
> The main thing is to prevent rogue writes, but reads are not a problem.
> Hiding/unhiding them even from read operations might not be so useful.
> 
> However other components, like the kernel keyring, are used less frequently
> and might be worth protecting them even from read operations.

Right, the goals are different, but the idea is basically the same. We
allocate memory in some "special" way. I'm just wondering if we'll be
adding more of these special ways in the future, and if it's worth
synchronizing the APIs so that it's easy for people to use.

> > (I also didn't
> > follow what happened to the patches Nadav was going to send that might
> > replace prmem somehow.)
> 
> I just replied to the old prmem thread - I stil lhave some doubts about the
> implementation, however my understanding is that I could replicate or at
> least base on those patches the very low level part of the write rare
> mechanism.

Cool, thanks.

Tycho
