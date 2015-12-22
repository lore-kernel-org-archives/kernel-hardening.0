Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <laura@labbott.name>
Date: Mon, 21 Dec 2015 19:40:34 -0800
Message-Id: <1450755641-7856-1-git-send-email-laura@labbott.name>
Subject: [kernel-hardening] [RFC][PATCH 0/7] Sanitization of slabs based on grsecurity/PaX
To: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Laura Abbott <laura@labbott.name>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is a partial port of the PAX_MEMORY_SANITIZE feature. The concept is
fairly simple: when memory is freed, existing data should be erased. This
helps to reduce the impact of problems
(e.g. 45a22f4 inotify: Fix reporting of cookies for inotify events
e4514cb RDMA/cxgb3: Fix information leak in send_abort()
your favorite use after free bug)

The biggest change from PAX_MEMORY_SANTIIZE is that this feature sanitizes
the SL[AOU]B allocators only. My plan is to work on the buddy allocator
santization after this series gets picked up. A side effect of this is
that allocations which go directly to the buddy allocator (i.e. large
allocations) aren't sanitized. I'd like feedback about whether it's worth
it to add sanitization on that path directly or just use the page
allocator sanitization when that comes in.

I also expanded the command line options, mostly for SLUB. Since SLUB
has had so much tuning work done for performance, I added an option
to only sanitize on the slow path. Freeing on only fast vs. slow path
was most noticable in the bulk test cases. Overall, I saw impacts of
3% to 20% on various benchmarks when this feature was enabled. The
overall impact of sanitize_slab=off seemed to be pretty negligable.

This feature is similar to the debug feature of SLAB_POISON. I did
consider trying to make that feature not related to debug. Ultimately,
I concluded there was too much extra debug overhead and other features
to make it worth it.

Bike shed whatever you like. The Kconfig will probably end up in
a separate sanitization Kconfig.

All credit for the original work should be given to Brad Spengler and
the PaX Team. 

Thanks,
Laura

Laura Abbott (7):
  mm/slab_common.c: Add common support for slab saniziation
  slub: Add support for sanitization
  slab: Add support for sanitization
  slob: Add support for sanitization
  mm: Mark several cases as SLAB_NO_SANITIZE
  mm: Add Kconfig option for slab sanitization
  lkdtm: Add READ_AFTER_FREE test

 drivers/misc/lkdtm.c     | 29 ++++++++++++++++
 fs/buffer.c              |  2 +-
 fs/dcache.c              |  2 +-
 include/linux/slab.h     |  7 ++++
 include/linux/slab_def.h |  4 +++
 init/Kconfig             | 48 ++++++++++++++++++++++++++
 kernel/fork.c            |  2 +-
 mm/rmap.c                |  4 +--
 mm/slab.c                | 35 +++++++++++++++++++
 mm/slab.h                | 24 ++++++++++++-
 mm/slab_common.c         | 53 ++++++++++++++++++++++++++++
 mm/slob.c                | 27 +++++++++++----
 mm/slub.c                | 90 +++++++++++++++++++++++++++++++++++++++++++++++-
 net/core/skbuff.c        |  4 +--
 14 files changed, 316 insertions(+), 15 deletions(-)

-- 
2.5.0
