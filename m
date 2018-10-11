From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v2 0/7] Rlimit for module space
Date: Thu, 11 Oct 2018 16:31:10 -0700
Message-Id: <20181011233117.7883-1-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com, daniel@iogearbox.net, keescook@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org, arnd@arndb.de, jeyu@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: kristen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, deneen.t.dock@intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is v2 of a patch series that was first sent to security@kernel.org. The
recommendation was to pursue the fix on public lists. First I’ll describe the
issue that this is trying to solve, and then the general solution being
proposed, and lastly summarize the feedback so far. At a high level, this is
coming from a local DOS on eBPF, a KASLR module offset leak and desire for
general hardening of module space usage.

Problem
-------
If BPF JIT is on, there is no effective limit to prevent filling the entire
module space with JITed e/BPF filters. For classic BPF filters attached with
setsockopt SO_ATTACH_FILTER, there is no memlock rlimit check to limit the
number of insertions like this is for the bpf syscall. The cBPF gets converted
to eBPF and then handled by the JIT depending on if JIT is enabled. There is a
low enough default limit for open file descriptors per process, but this can be
worked around easily by forking before inserting. If the memlock rlimit is set
high for some other reason, eBPF programs inserted with the bpf syscall can also
exhaust the space.

This can cause problems not limited to:
 - Filling the entire module space with filters so that kernel modules cannot
   be loaded.
 - If CONFIG_BPF_JIT_ALWAYS_ON is configured, then if the module space is full,
   other BPF insertions will fail. This could cause filters that apps are
   relying on for security to fail to insert.
 - Counting the allocations until failure, since the module space is
   allocated linearly, the number of allocations can be used to de-randomize
   modules, with KASLR module base randomization. (This has been POCed with some
   assumptions)

Thanks to Daniel Borkmann for helping me understand what was happening with the
classic BPF JIT compilation and CONFIG_BPF_JIT_ALWAYS_ON config.

Proposed solution
-----------------
The solution being proposed here is to add a per user rlimit for module space,
similar to memlock rlimit. For the case of fds with attached filters being sent
over domain sockets, there is tracking for the uid of each module allocation.

Hopefully this could also be used for helping prevent BPF JIT spray type attacks
if a lower, more locked down setting is used.

The default memlock rlimit is pretty low, so just adding a check to classic BPF
similar to what happens in the bpf syscall may cause breakages. In addition,
some usages may increase the memlock limit for other reasons, which will remove
the protection for exhausting the module space.

There is unfortunately no cross platform place to perform this accounting
during allocation in the module space, so instead two helpers are created to be
inserted into the various arch’s that implement module_alloc. These helpers
perform the checks and help with tracking. The intention is that they can be
added to the other arch’s as easily as possible.

For decrementing the module space usage when an area is free, there _is_ a
cross-platform place to do this, so its done there. The behavior is that if the
helpers to increment and check are not added into an arch’s module_alloc, then
the decrement should have no effect. This is due to the allocation being missing
from the allocation-uid tracking.

Changes since v1 RFC
--------------------
Some feedback from Kees Cook was to try to plug this in for every architecture
and so this is done in this set for every architecture that has a BPF JIT
implementation. I have only done testing on x86.

There was also a suggestion from Daniel Borkmann to have default value for the
rlimit scale with the module size. This was complicated because the module space
size is not named the same accross architectures. It also is not always a
compile time constant and so the struct initilization would need to be changed.
So instead for this version a default value is added that can be overridden for
each architecture. For this set it is just defined for x86, all others get the
default.

Questions
---------
 - Should there be any special behavior for root or users with superuser
   capabilities?

Rick Edgecombe (7):
  modules: Create rlimit for module space
  x86/modules: Add rlimit checking for x86 modules
  arm/modules: Add rlimit checking for arm modules
  arm64/modules: Add rlimit checking for arm64 modules
  mips/modules: Add rlimit checking for mips modules
  sparc/modules: Add rlimit for sparc modules
  s390/modules: Add rlimit checking for s390 modules

 arch/arm/kernel/module.c                |  12 +-
 arch/arm64/kernel/module.c              |   5 +
 arch/mips/kernel/module.c               |  11 +-
 arch/s390/kernel/module.c               |  12 +-
 arch/sparc/kernel/module.c              |   5 +
 arch/x86/include/asm/pgtable_32_types.h |   3 +
 arch/x86/include/asm/pgtable_64_types.h |   2 +
 arch/x86/kernel/module.c                |   7 +-
 fs/proc/base.c                          |   1 +
 include/asm-generic/resource.h          |   8 ++
 include/linux/moduleloader.h            |   3 +
 include/linux/sched/user.h              |   4 +
 include/uapi/asm-generic/resource.h     |   3 +-
 kernel/module.c                         | 141 +++++++++++++++++++++++-
 14 files changed, 210 insertions(+), 7 deletions(-)

-- 
2.17.1
