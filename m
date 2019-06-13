Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
From: Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190612182550.GI20308@linux.intel.com>
Date: Thu, 13 Jun 2019 13:54:51 +0300
Content-Transfer-Encoding: quoted-printable
Message-Id: <65D4DBEB-5A9A-457D-909B-2D31A3031607@oracle.com>
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <20190612182550.GI20308@linux.intel.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Marius Hillenbrand <mhillenb@amazon.de>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>
List-ID: <kernel-hardening.lists.openwall.com>



> On 12 Jun 2019, at 21:25, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Wed, Jun 12, 2019 at 07:08:24PM +0200, Marius Hillenbrand wrote:
>> The Linux kernel has a global address space that is the same for any
>> kernel code. This address space becomes a liability in a world with
>> processor information leak vulnerabilities, such as L1TF. With the =
right
>> cache load gadget, an attacker-controlled hyperthread pair can leak
>> arbitrary data via L1TF. Disabling hyperthreading is one recommended
>> mitigation, but it comes with a large performance hit for a wide =
range
>> of workloads.
>>=20
>> An alternative mitigation is to not make certain data in the kernel
>> globally visible, but only when the kernel executes in the context of
>> the process where this data belongs to.
>>=20
>> This patch series proposes to introduce a region for what we call
>> process-local memory into the kernel's virtual address space. Page
>> tables and mappings in that region will be exclusive to one address
>> space, instead of implicitly shared between all kernel address =
spaces.
>> Any data placed in that region will be out of reach of cache load
>> gadgets that execute in different address spaces. To implement
>> process-local memory, we introduce a new interface =
kmalloc_proclocal() /
>> kfree_proclocal() that allocates and maps pages exclusively into the
>> current kernel address space. As a first use case, we move =
architectural
>> state of guest CPUs in KVM out of reach of other kernel address =
spaces.
>=20
> Can you briefly describe what types of attacks this is intended to
> mitigate?  E.g. guest-guest, userspace-guest, etc...  I don't want to
> make comments based on my potentially bad assumptions.

I think I can assist in the explanation.

Consider the following scenario:
1) Hyperthread A in CPU core runs in guest and triggers a VMExit which =
is handled by host kernel.
While hyperthread A runs VMExit handler, it populates CPU core cache / =
internal-resources (e.g. MDS buffers)
with some sensitive data it have speculatively/architecturally access.
2) During hyperthread A running on host kernel, hyperthread B on same =
CPU core runs in guest and use
some CPU speculative execution vulnerability to leak the sensitive host =
data populated by hyperthread A
in CPU core cache / internal-resources.

Current CPU microcode mitigations (L1D/MDS flush) only handle the case =
of a single hyperthread and don=E2=80=99t
provide a mechanism to mitigate this hyperthreading attack scenario.

Assuming there is some guest triggerable speculative load gadget in some =
VMExit path,
it can be used to force any data that is mapped into kernel address =
space to be loaded into CPU resource that is subject to leak.
Therefore, there were multiple attempts to reduce sensitive information =
from being mapped into the kernel address space
that is accessible by this VMExit path.

One attempt was XPFO which attempts to remove from kernel direct-map any =
page that is currently used only by userspace.
Unfortunately, XPFO currently exhibits multiple performance issues that =
*currently* makes it impractical as far as I know.

Another attempt is this patch-series which attempts to remove from one =
vCPU thread host kernel address space,
the state of vCPUs of other guests. Which is very specific but I =
personally have additional ideas on how this patch series can be further =
used.
For example, vhost-net needs to kmap entire guest memory into =
kernel-space to write ingress packets data into guest memory.
Thus, vCPU thread kernel address space now maps entire other guest =
memory which can be leaked using the technique described above.
Therefore, it should be useful to also move this kmap() to happen on =
process-local kernel virtual address region.

One could argue however that there is still a much bigger issue because =
of kernel direct-map that maps all physical pages that kernel
manage (i.e. have struct page) in kernel virtual address space. And all =
of those pages can theoretically be leaked.
However, this could be handled by complementary techniques such as =
booting host kernel with =E2=80=9Cmem=3DX=E2=80=9D and mapping guest =
memory
by directly mmap relevant portion of /dev/mem.
Which is probably what AWS does given these upstream KVM patches they =
have contributed:
bd53cb35a3e9 X86/KVM: Handle PFNs outside of kernel reach when touching =
GPTEs
e45adf665a53 KVM: Introduce a new guest mapping API
0c55671f84ff kvm, x86: Properly check whether a pfn is an MMIO or not

Also note that when using such =E2=80=9Cmem=3DX=E2=80=9D technique, you =
can also avoid performance penalties introduced by CPU microcode =
mitigations.
E.g. You can avoid doing L1D flush on VMEntry if VMExit handler run only =
in kernel and didn=E2=80=99t context-switch as you assume kernel address
space don=E2=80=99t map any host sensitive data.

It=E2=80=99s also worth mentioning that another alternative that I have =
attempted to this =E2=80=9Cmem=3DX=E2=80=9D technique
was to create an isolated address space that is only used when running =
KVM VMExit handlers.
For more information, refer to:
https://lkml.org/lkml/2019/5/13/515
(See some of my comments on that thread)

This is my 2cents on this at least.

-Liran
