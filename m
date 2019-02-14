From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: [RFC PATCH v8 00/14] Add support for eXclusive Page Frame Ownership
Date: Wed, 13 Feb 2019 17:01:23 -0700
Message-Id: <cover.1550088114.git.khalid.aziz@oracle.com>
To: juergh@gmail.com, tycho@tycho.ws, jsteckli@amazon.de, ak@linux.intel.com, torvalds@linux-foundation.org, liran.alon@oracle.com, keescook@google.com, akpm@linux-foundation.org, mhocko@suse.com, catalin.marinas@arm.com, will.deacon@arm.com, jmorris@namei.org, konrad.wilk@oracle.com
Cc: Khalid Aziz <khalid.aziz@oracle.com>, deepa.srinivasan@oracle.com, chris.hyser@oracle.com, tyhicks@canonical.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com, jcm@redhat.com, boris.ostrovsky@oracle.com, kanth.ghatraju@oracle.com, oao.m.martins@oracle.com, jmattson@google.com, pradeep.vincent@oracle.com, john.haxby@oracle.com, tglx@linutronix.de, kirill.shutemov@linux.intel.com, hch@lst.de, steven.sistare@oracle.com, labbott@redhat.com, luto@kernel.org, dave.hansen@intel.com, peterz@infradead.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

I am continuing to build on the work Juerg, Tycho and Julian have
done on XPFO. After the last round of updates, we were seeing very
significant performance penalties when stale TLB entries were
flushed actively after an XPFO TLB update.  Benchmark for measuring
performance is kernel build using parallel make. To get full
protection from ret2dir attackes, we must flush stale TLB entries.
Performance penalty from flushing stale TLB entries goes up as the
number of cores goes up. On a desktop class machine with only 4
cores, enabling TLB flush for stale entries causes system time for
"make -j4" to go up by a factor of 2.61x but on a larger machine
with 96 cores, system time with "make -j60" goes up by a factor of
26.37x!  I have been working on reducing this performance penalty.

I implemented two solutions to reduce performance penalty and that
has had large impact. XPFO code flushes TLB every time a page is
allocated to userspace. It does so by sending IPIs to all processors
to flush TLB. Back to back allocations of pages to userspace on
multiple processors results in a storm of IPIs.  Each one of these
incoming IPIs is handled by a processor by flushing its TLB. To
reduce this IPI storm, I have added a per CPU flag that can be set
to tell a processor to flush its TLB. A processor checks this flag
on every context switch. If the flag is set, it flushes its TLB and
clears the flag. This allows for multiple TLB flush requests to a
single CPU to be combined into a single request. A kernel TLB entry
for a page that has been allocated to userspace is flushed on all
processors unlike the previous version of this patch. A processor
could hold a stale kernel TLB entry that was removed on another
processor until the next context switch. A local userspace page
allocation by the currently running process could force the TLB
flush earlier for such entries.

The other solution reduces the number of TLB flushes required, by
performing TLB flush for multiple pages at one time when pages are
refilled on the per-cpu freelist. If the pages being addedd to
per-cpu freelist are marked for userspace allocation, TLB entries
for these pages can be flushed upfront and pages tagged as currently
unmapped. When any such page is allocated to userspace, there is no
need to performa a TLB flush at that time any more. This batching of
TLB flushes reduces performance imapct further.

I measured system time for parallel make with unmodified 4.20
kernel, 4.20 with XPFO patches before these patches and then again
after applying each of these patches. Here are the results:

Hardware: 96-core Intel Xeon Platinum 8160 CPU @ 2.10GHz, 768 GB RAM
make -j60 all

4.20					950.966s
4.20+XPFO				25073.169s	26.37x
4.20+XPFO+Deferred flush		1372.874s	1.44x
4.20+XPFO+Deferred flush+Batch update	1255.021s	1.32x


Hardware: 4-core Intel Core i5-3550 CPU @ 3.30GHz, 8G RAM
make -j4 all

4.20					607.671s
4.20+XPFO				1588.646s	2.61x
4.20+XPFO+Deferred flush		803.989s	1.32x
4.20+XPFO+Deferred flush+Batch update	795.728s	1.31x

30+% overhead is still very high and there is room for improvement.

Performance with this patch set is good enough to use these as
starting point for further refinement before we merge it into main
kernel, hence RFC.

I have dropped the patch "mm, x86: omit TLB flushing by default for
XPFO page table modifications" since not flushing TLB leaves kernel
wide open to attack and there is no point in enabling XPFO without
flushing TLB every time kernel TLB entries for pages are removed. I
also dropped the patch "EXPERIMENTAL: xpfo, mm: optimize spin lock
usage in xpfo_kmap". There was not a measurable improvement in
performance with this patch and it introduced a possibility for
deadlock that Laura found.

What remains to be done beyond this patch series:

1. Performance improvements: Ideas to explore - (1) Add a freshly
   freed page to per cpu freelist and not make a kernel TLB entry
   for it, (2) kernel mappings private to an mm, (3) Any others??
2. Re-evaluate the patch "arm64/mm: Add support for XPFO to swiotlb"
   from Juerg. I dropped it for now since swiotlb code for ARM has
   changed a lot in 4.20.
3. Extend the patch "xpfo, mm: Defer TLB flushes for non-current
   CPUs" to other architectures besides x86.


---------------------------------------------------------

Juerg Haefliger (5):
  mm, x86: Add support for eXclusive Page Frame Ownership (XPFO)
  swiotlb: Map the buffer if it was unmapped by XPFO
  arm64/mm: Add support for XPFO
  arm64/mm, xpfo: temporarily map dcache regions
  lkdtm: Add test for XPFO

Julian Stecklina (2):
  xpfo, mm: remove dependency on CONFIG_PAGE_EXTENSION
  xpfo, mm: optimize spinlock usage in xpfo_kunmap

Khalid Aziz (2):
  xpfo, mm: Defer TLB flushes for non-current CPUs (x86 only)
  xpfo, mm: Optimize XPFO TLB flushes by batching them together

Tycho Andersen (5):
  mm: add MAP_HUGETLB support to vm_mmap
  x86: always set IF before oopsing from page fault
  xpfo: add primitives for mapping underlying memory
  arm64/mm: disable section/contiguous mappings if XPFO is enabled
  mm: add a user_virt_to_phys symbol

 .../admin-guide/kernel-parameters.txt         |   2 +
 arch/arm64/Kconfig                            |   1 +
 arch/arm64/mm/Makefile                        |   2 +
 arch/arm64/mm/flush.c                         |   7 +
 arch/arm64/mm/mmu.c                           |   2 +-
 arch/arm64/mm/xpfo.c                          |  64 +++++
 arch/x86/Kconfig                              |   1 +
 arch/x86/include/asm/pgtable.h                |  26 ++
 arch/x86/include/asm/tlbflush.h               |   1 +
 arch/x86/mm/Makefile                          |   2 +
 arch/x86/mm/fault.c                           |   6 +
 arch/x86/mm/pageattr.c                        |  23 +-
 arch/x86/mm/tlb.c                             |  38 +++
 arch/x86/mm/xpfo.c                            | 181 ++++++++++++++
 drivers/misc/lkdtm/Makefile                   |   1 +
 drivers/misc/lkdtm/core.c                     |   3 +
 drivers/misc/lkdtm/lkdtm.h                    |   5 +
 drivers/misc/lkdtm/xpfo.c                     | 194 +++++++++++++++
 include/linux/highmem.h                       |  15 +-
 include/linux/mm.h                            |   2 +
 include/linux/mm_types.h                      |   8 +
 include/linux/page-flags.h                    |  18 +-
 include/linux/xpfo.h                          |  95 ++++++++
 include/trace/events/mmflags.h                |  10 +-
 kernel/dma/swiotlb.c                          |   3 +-
 mm/Makefile                                   |   1 +
 mm/mmap.c                                     |  19 +-
 mm/page_alloc.c                               |   7 +
 mm/util.c                                     |  32 +++
 mm/xpfo.c                                     | 223 ++++++++++++++++++
 security/Kconfig                              |  29 +++
 31 files changed, 977 insertions(+), 44 deletions(-)
 create mode 100644 arch/arm64/mm/xpfo.c
 create mode 100644 arch/x86/mm/xpfo.c
 create mode 100644 drivers/misc/lkdtm/xpfo.c
 create mode 100644 include/linux/xpfo.h
 create mode 100644 mm/xpfo.c

-- 
2.17.1
