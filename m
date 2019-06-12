From: Marius Hillenbrand <mhillenb@amazon.de>
Subject: [RFC 00/10] Process-local memory allocations for hiding KVM secrets
Date: Wed, 12 Jun 2019 19:08:24 +0200
Message-Id: <20190612170834.14855-1-mhillenb@amazon.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: kvm@vger.kernel.org
Cc: Marius Hillenbrand <mhillenb@amazon.de>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>
List-ID: <kernel-hardening.lists.openwall.com>

The Linux kernel has a global address space that is the same for any
kernel code. This address space becomes a liability in a world with
processor information leak vulnerabilities, such as L1TF. With the right
cache load gadget, an attacker-controlled hyperthread pair can leak
arbitrary data via L1TF. Disabling hyperthreading is one recommended
mitigation, but it comes with a large performance hit for a wide range
of workloads.

An alternative mitigation is to not make certain data in the kernel
globally visible, but only when the kernel executes in the context of
the process where this data belongs to.

This patch series proposes to introduce a region for what we call
process-local memory into the kernel's virtual address space. Page
tables and mappings in that region will be exclusive to one address
space, instead of implicitly shared between all kernel address spaces.
Any data placed in that region will be out of reach of cache load
gadgets that execute in different address spaces. To implement
process-local memory, we introduce a new interface kmalloc_proclocal() /
kfree_proclocal() that allocates and maps pages exclusively into the
current kernel address space. As a first use case, we move architectural
state of guest CPUs in KVM out of reach of other kernel address spaces.

The patch set is a prototype for x86-64 that we have developed on top of
kernel 4.20.17 (with cherry-picked commit d253ca0c3865 "x86/mm/cpa: Add
set_direct_map_*() functions"). I am aware that the integration with KVM
will see some changes while rebasing to 5.x. Patches 7 and 8, in
particular, help make patch 9 more readable, but will be dropped in
rebasing. We have tested the code on both Intel and AMDs, launching VMs
in a loop. So far, we have not done in-depth performance evaluation.
Impact on starting VMs was within measurement noise.

---

Julian Stecklina (2):
  kvm, vmx: move CR2 context switch out of assembly path
  kvm, vmx: move register clearing out of assembly path

Marius Hillenbrand (8):
  x86/mm/kaslr: refactor to use enum indices for regions
  x86/speculation, mm: add process local virtual memory region
  x86/mm, mm,kernel: add teardown for process-local memory to mm cleanup
  mm: allocate virtual space for process-local memory
  mm: allocate/release physical pages for process-local memory
  kvm/x86: add support for storing vCPU state in process-local memory
  kvm, vmx: move gprs to process local memory
  kvm, x86: move guest FPU state into process local memory

 Documentation/x86/x86_64/mm.txt         |  11 +-
 arch/x86/Kconfig                        |   1 +
 arch/x86/include/asm/kvm_host.h         |  40 ++-
 arch/x86/include/asm/page_64.h          |   4 +
 arch/x86/include/asm/pgtable_64_types.h |  12 +
 arch/x86/include/asm/proclocal.h        |  11 +
 arch/x86/kernel/head64.c                |   8 +
 arch/x86/kvm/Kconfig                    |  10 +
 arch/x86/kvm/kvm_cache_regs.h           |   4 +-
 arch/x86/kvm/svm.c                      | 104 +++++--
 arch/x86/kvm/vmx.c                      | 213 ++++++++++-----
 arch/x86/kvm/x86.c                      |  31 ++-
 arch/x86/mm/Makefile                    |   1 +
 arch/x86/mm/dump_pagetables.c           |   9 +
 arch/x86/mm/fault.c                     |  19 ++
 arch/x86/mm/kaslr.c                     |  63 ++++-
 arch/x86/mm/proclocal.c                 | 136 +++++++++
 include/linux/mm_types.h                |  13 +
 include/linux/proclocal.h               |  35 +++
 kernel/fork.c                           |   6 +
 mm/Makefile                             |   1 +
 mm/proclocal.c                          | 348 ++++++++++++++++++++++++
 security/Kconfig                        |  18 ++
 23 files changed, 978 insertions(+), 120 deletions(-)
 create mode 100644 arch/x86/include/asm/proclocal.h
 create mode 100644 arch/x86/mm/proclocal.c
 create mode 100644 include/linux/proclocal.h
 create mode 100644 mm/proclocal.c

-- 
2.21.0
