Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Wed,  8 Jun 2016 14:11:38 -0700
Message-Id: <1465420302-23754-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [RFC][PATCH v2 0/4] mm: Hardened usercopy
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is v2 of the RFC patches for a mainline port of PAX_USERCOPY. After
I started writing tests for Casey's earlier port[1], I kept fixing things
further and further until I ended up with a whole new patch series. To
that end, I also took Rik's feedback and made a number of other changes
and clean-ups, which are noted in the "v2" history at the end.

Based on my understanding (please correct anything I haven't understood
correctly), PAX_USERCOPY was designed to catch a few classes of flaws
around the use of copy_to_user/copy_from_user. These changes don't touch
get_user and put_user, since those operate on constant sized lengths,
and tend to be much less vulnerable. The goal is protecting against
flawed lengths, and then also against manipulated addresses.

There are effectively three distinct protections in this series, each of
which I've given a separate CONFIG. (Generally speaking, PAX_USERCOPY
covers both CONFIG_HARDENED_USERCOPY and CONFIG_HARDENED_USERCOPY_WHITELIST,
and PAX_USERCOPY_SLABS covers CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC.) The
new CONFIGs are:


CONFIG_HARDENED_USERCOPY checks that objects being copied to/from userspace
meet certain criteria:
- if address is a heap object, the size must not exceed the object's
  allocated size. (This will catch all kinds of heap overflow flaws.)
- if address range is in the current process stack, it must be within the
  current stack frame (if such checking is possible) or at least entirely
  within the current process's stack. (This could catch large lengths that
  would have extended beyond the current process stack.)
- if address is within the kernel text, it is rejected.
- everything else is accepted (which includes vmalloc, other process
  stacks, etc). This isn't a perfect checker, but it entirely closes
  several classes of usercopy flaws.


CONFIG_HARDENED_USERCOPY_WHITELIST adds the SLUB_USERCOPY flag to kernel
memory caches. This is used to vastly reduce the number of heap objects
that can be copied to userspace by whitelisting only those that are deemed
a "tolerable risk" to be copied. Due to kmalloc's extensive use in the
kernel, all of the kmalloc caches are marked with SLUB_USERCOPY. Beyond
those, the other caches marked for SLUB_USERCOPY are: cifs_request,
cifs_small_rq, names_cache, jfs_ip, thread_info, and kvm_vcpu. (In my
test VM, there are about 160 non-kmalloc caches in /proc/slabinfo, so
this whitelisting provides significant coverage.) With these markings
in places, the CONFIG_HARDENED_USERCOPY heap object check above gains an
additional rule:
- if address is a heap object, it must be flagged with SLUB_USERCOPY

One thing I was unable to easily solve was that "filldir" wants to read
from the "dcache" cache, which is not whitelisted in grsecurity, yet seems
to work there. I haven't figured out why, and I hope someone can help
point me in the right direction. In the meantime, I have whitelisted it.

After this minimal whitelist, this leaves a number of places in the
kernel where information needs to be moved in and out of userspace,
but without exposing an entire kernel cache that is not sensible to
whitelist. In these places, we need to adjust how the kernel handles the
copying. In my local testing, I uncovered several of them, and went to
the grsecurity/PaX patches[2] to see how they were fixed. They were:

- Changed exec to use copy of auxv instead of copying from "mm_struct"
  cache.
- Changed signal handling to use an on-stack copy of signal frames instead
  of direct copying from "task_struct" cache.
- Changed name_to_handle to use put_user (which operates on fixed sizes)
  instead of copy_to_user from "mnt_cache" cache.
- Changed readlink to use stack for in-struct names to avoid copying from
  filesystem cache (e.g. "ext4_inode_cache")
- Changed sg ioctl to bounce commands through stack instead of directly
  copying to/from "blkdev_requests" cache.

Since there are probably plenty more, it seemed prudent to split the
whitelisting into a separate CONFIG so that people could turn it on
or off depending on their desire to help find and fix these.


CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC is a less obvious protection, and
is only partially related to the prior two protections. Several userspace
APIs (e.g. ipc, seq_file) allow precise control over the size of kernel
kmallocs, which provides a trivial way to perform heap overflow attacks
where the attacker must control neighboring allocations of a particular size.
Instead, move these APIs into their own caches so they cannot interfere
with the standard kmallocs. This makes heap attacks more difficult since
easily controlled heap allocations are now isolated.


The patches in the series are:
- [PATCH 1/4] mm: Hardened usercopy
  This contains all of CONFIG_HARDENED_USERCOPY.
- [PATCH 2/4] usercopy: avoid direct copying to userspace
  This contains various kernel memory copying cleanups in support of
  CONFIG_HARDENED_USERCOPY_WHITELIST
- [PATCH 3/4] usercopy: whitelist user-copyable caches
  This contains all of CONFIG_HARDENED_USERCOPY_WHITELIST
- [PATCH 4/4] usercopy: provide split of user-controlled slabs
  This contains all of CONFIG_HARDENED_USERCOPY_SPLIT_KMALLOC


Some notes:

- I couldn't detect a measurable performance change with these features
  enabled. Kernel build times were unchanged, hackbench was unchanged,
  etc.

- SLOB seems entirely broken. I have no idea what's going on there; I
  spent my time testing SLAB and SLUB mostly.

- Ultimately, I think CONFIG_HARDENED_USERCOPY should be a no-brainer
  to enable by default. CONFIG_HARDENED_USERCOPY_WHITELIST will take
  a little time to shake out all the needed tweaks, but after that,
  it too should be enabled by default. I'm not sure how to reason
  about ..._SPLIT_KMALLOC since it needs slab merging disabled to
  be fully effective. I would need to understand the benefits of
  slab merging better to give a reasonable suggestion here.


Open questions, which hopefully spender or pageexec can help answer:

- What rationale has been used to select caches to whitelist with
  SLAB_USERCOPY? I'd like to codify something that people can use to
  guide them in their decisions.

- Why does CONFIG_PAX_USERCOPY_SLABS wrap the slub SLAB_ATTR_RO(usercopy)?
  It seems like the SLUB_USERCOPY flag would be generally interesting,
  and should be visible under CONFIG_PAX_USERCOPY instead.

- Why, in most architectures, when adding check_object_size() to the
  copy_*_user implementations, is an explicit "if (!__builtin_constant_p(n))"
  used? Is this just an optimization that assumes only non-constant
  sizes need protecting? It seems to me that it shouldn't be there since
  the address may have been manipulated too, not just the size.

- What is happening in the SLOB allocator? It seems to lack the
  SLAB_USERCOPY flag check entirely, and has a boatload of changes
  only under CONFIG_PAX_USERCOPY_SLABS. What's going on here?

- What allows filldir to work happily on grsecurity when "dcache" isn't
  whitelisted with SLAB_USERCOPY?


Things to do:

- "dcache" cache shouldn't be whitelisted.

- SLOB support needs to be fixed or removed.

- Any other fixups for non-whitelisted cache copying need to be
  rediscovered and extracted from grsecurity. (Seriously, if you hit one,
  read the stack dump, download grsecurity[2], and see if you find changes
  in the function that handles the copying differently.)

- Determine how to reason about the need for slab merging to be fully
  disabled vs partially disabled. Can someone explain to me what
  slab merging is actually doing? Is it merging across different
  caches? If so, it needs to stay fully disabled under ..._SPLIT_KMALLOC
  otherwise the benefit of forcing separated caches disappears.

- Needs porting to arm64.

- Needs per-architecture support for stack frame checking (only x86 now).

- Need to extract the drivers/char/mem.c changes for ..._SPLIT_KMALLOC.

- Testing testing


Thanks!

-Kees

v2:
- moved common checking logic from fs/exec.c to mm/usercopy.c
- fixed missing x86_64 copy_*_user checks.
- fixed typos in sparc and ia64 checks.
- changed report text from "leak" to "exposure".
- dropped #ifdefs in favor of empty static inline functions.
- consolidated common heap checks into a parent function.
- added many more comments.
- dropped curr_ip (IPv4 address) since it's unused by mainline.

v1:
- Casey's initial extraction[1].

[1] http://www.openwall.com/lists/kernel-hardening/2016/05/19/5
[2] https://grsecurity.net/download.php "grsecurity - test kernel patch"
