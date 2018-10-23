From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [RFC v1 PATCH 00/17] prmem: protected memory
Date: Wed, 24 Oct 2018 00:34:47 +0300
Message-Id: <20181023213504.28905-1-igor.stoppa@huawei.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

-- Summary --

Preliminary version of memory protection patchset, including a sample use
case, turning into write-rare the IMA measurement list.

The core idea is to introduce two new types of memory protection, beside
const and __ro_after_init, which will support:
- statically allocated "write rare" memory
- dynamically allocated "read only" and "write rare" memory

On top of that, follows a set of patches which create a "write rare"
counterpart of the kernel infrastructure used in the example chose for
hardening: the IMA measurement list.

-- Mechanism --

Statically allocated protected memory is identified by the __wr_after_init
tag, which will cause the linker to place it in a special section.

Dynamically allocated memory is obtained through vmalloc, but compacting
each allocation, where possible, in the latest obtained vmap_area.

The write rare mechanism is implemented by creating a temporary alternate
writable mapping, applying the change through this mapping and then
removing it.

All of this is possible thanks to the system MMU, which must be able to
provide write protection.

-- Brief history --

I sent out various versions of memory protection over the last year or so,
however this patchset is significantly expanded, including several helper
data structures and a use case, so I decided to reset the numbering to v1.

As reference, the latest "old" version is here [1].

The current version is not yet ready for merge, however it is sufficiently
complete for supporting an end-to-end discussion, I think.

Eventually, I plan to write a white paper, once the code is in better shape.
In the meanwhile, an overview can be had from these slides [2], which are
the support material for my presentation at the Linux Security Summit 2018
Europe.

-- Validation --

Most of the testing is done on a Fedora image, with QEMU x86_64,
however the code has been also tested on a real x86_64 PC, yielding
similar positive results.
For ARM64, I use a custom Debian installation, still with QEMU, but I have
obtained similar failures when testing with a real device, using a
Kirin970.

I have written some test cases for the most basic parts and the behaviour
of IMA and the Fedora image in general do not seem to be negatively
affected, when used in conjunction with this patchset.
However, it's far from being exhaustive testing and the torture test for
rcu is completely missing.

-- Known Issues --

As said, this version is preliminary and certain parts need rework.
This is a short and incomplete list of known issues:

* arm64 support is broken for __wr_after_init
  I must create a separate section with proper mappings, similar to the
  ones used for vmalloc()

* alignment of data structures has not been throughly checked
  There are probably several redundant forced alignments

* there is no fallback for platforms missing MMU write protection

* some additional care might be needed when dealing with double mapping vs
  data cache coherency, on multicore systems

* lots of additional (stress) tests are needed

* memory reuse (object caches) are probably needed, to support converting
  more use cases, and so also other data structures.

* credits for original code: I have reimplemented various data structures,
  I am not sure if I have given credit correctly to the original authors.

* documentation for the re-implemented data structures is missing

* confirm that the hardened usercopy logic is correct

-- Q&As --

During reviews of the older patchset, several objections and questions
were formulated.

They are collected here in Q&A format, with both some old and new answers:

1 - "The protection can still be undone"
Yes, it is true. Using a hypervisor, like it is done in certain Huawei and
Samsung phones, provides a better level of protection.
However, even without that, it still gives a significantly better level of
protection than not protecting the memory at all.
The main advantage of this patchset is that now the attack has to focus on
the page table, which is a significantly smaller area, than the whole
kernel data.
It is my intention, eventually, to provide also support for interaction
with a FOSS hypervisor (ex: KVM), but this patchset should
support also those cases where it's not even possible to have an hypervisor.
So it seems simpler to start from there. The hypervisor is not mandatory.


2 - "Do not provide a chain of trust, but protect some memory and refer to
it with a writable pointer."
This might be ok for protecting against bugs, but in the case of an
attacker trying to compromise the system, the unprotected pointer has
become the new target. It doesn't change much.
Samsung does use a similar implementation, for protecting LSM hooks,
however that solution also add a pointer, from the protected memory back
to the writable memory, as validation loop. And the price to pay is that
every time the unprotected pointer must be used, it first has to be
validated, to point to a certain memory range and to have a specific
alignment. It's an alternative solution to the full chain of trust and
each has its specific advantages, depending on the data structures that
one wants to protect.


3 - "Do not use a secondary mapping, unprotect the current one"
The purpose of the secondary mapping is to create a hard-to-spot window of
writability at a random address, which cannot be easily exploited.
Unprotecting the primary mapping would allow an attack where a core is
busy looping trying to figure out if a specific location becomes writable
and race against the legitimate writer. For the same reason, interrupts
are disabled on the core that is performing the write-rare operation.


4 - "Do not create another allocator over vmalloc(), use it plain"
This is not good for various reasons:
a) vmalloc() allocates at least one page for every request it receives,
leaving most of the page typically unused. While it might not be a big
deal on large systems, on IoT class devices it is possible to find
relatively powerful cores paired to relatively little memory.
Taking as example a system using SELinux, a relatively small set of rules
can genarate a few thousands of allocations (SELinux is deny-by-default).
Modeling each allocation to be about 64bytes, on a system with 4kB pages,
assuming that the grand total of allocation is 100k, that means
                 100k * 4kB = 390MB
while, using each 64bytes slot in a page yields:
                 100k * 64B = 6MB
The first case would not be very compatible with a system having only
512MB or 1GB.
b) even worse, the amount of thrashing of the TLB would be terrible, with
each allocation having its own translation.

--

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>


-- References --

[1]: https://lkml.org/lkml/2018/4/23/508
[2]: https://events.linuxfoundation.org/wp-content/uploads/2017/12/Kernel-Hardening-Protecting-the-Protection-Mechanisms-Igor-Stoppa-Huawei.pdf

-- List of patches --

[PATCH 01/17] prmem: linker section for static write rare
[PATCH 02/17] prmem: write rare for static allocation
[PATCH 03/17] prmem: vmalloc support for dynamic allocation
[PATCH 04/17] prmem: dynamic allocation
[PATCH 05/17] prmem: shorthands for write rare on common types
[PATCH 06/17] prmem: test cases for memory protection
[PATCH 07/17] prmem: lkdtm tests for memory protection
[PATCH 08/17] prmem: struct page: track vmap_area
[PATCH 09/17] prmem: hardened usercopy
[PATCH 10/17] prmem: documentation
[PATCH 11/17] prmem: llist: use designated initializer
[PATCH 12/17] prmem: linked list: set alignment
[PATCH 13/17] prmem: linked list: disable layout randomization
[PATCH 14/17] prmem: llist, hlist, both plain and rcu
[PATCH 15/17] prmem: test cases for prlist and prhlist
[PATCH 16/17] prmem: pratomic-long
[PATCH 17/17] prmem: ima: turn the measurements list write rare

-- Diffstat --

 Documentation/core-api/index.rst          |   1 +
 Documentation/core-api/prmem.rst          | 172 +++++
 MAINTAINERS                               |  14 +
 drivers/misc/lkdtm/core.c                 |  13 +
 drivers/misc/lkdtm/lkdtm.h                |  13 +
 drivers/misc/lkdtm/perms.c                | 248 +++++++
 include/asm-generic/vmlinux.lds.h         |  20 +
 include/linux/cache.h                     |  17 +
 include/linux/list.h                      |   5 +-
 include/linux/mm_types.h                  |  25 +-
 include/linux/pratomic-long.h             |  73 ++
 include/linux/prlist.h                    | 934 ++++++++++++++++++++++++
 include/linux/prmem.h                     | 446 +++++++++++
 include/linux/prmemextra.h                | 133 ++++
 include/linux/types.h                     |  20 +-
 include/linux/vmalloc.h                   |  11 +-
 lib/Kconfig.debug                         |   9 +
 lib/Makefile                              |   1 +
 lib/test_prlist.c                         | 252 +++++++
 mm/Kconfig                                |   6 +
 mm/Kconfig.debug                          |   9 +
 mm/Makefile                               |   2 +
 mm/prmem.c                                | 273 +++++++
 mm/test_pmalloc.c                         | 629 ++++++++++++++++
 mm/test_write_rare.c                      | 236 ++++++
 mm/usercopy.c                             |   5 +
 mm/vmalloc.c                              |   7 +
 security/integrity/ima/ima.h              |  18 +-
 security/integrity/ima/ima_api.c          |  29 +-
 security/integrity/ima/ima_fs.c           |  12 +-
 security/integrity/ima/ima_main.c         |   6 +
 security/integrity/ima/ima_queue.c        |  28 +-
 security/integrity/ima/ima_template.c     |  14 +-
 security/integrity/ima/ima_template_lib.c |  14 +-
 34 files changed, 3635 insertions(+), 60 deletions(-)
