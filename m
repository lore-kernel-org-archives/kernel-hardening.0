Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@fedoraproject.org>
Date: Mon, 15 Feb 2016 10:44:20 -0800
Message-Id: <1455561864-4217-1-git-send-email-labbott@fedoraproject.org>
Subject: [kernel-hardening] [PATCHv2 0/4] Improve performance for SLAB_POISON
To: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <js1304@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Laura Abbott <labbott@fedoraproject.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is a follow up to my previous series
(http://lkml.kernel.org/g/<1453770913-32287-1-git-send-email-labbott@fedoraproject.org>)
This series takes the suggestion of Christoph Lameter and only focuses on
optimizing the slow path where the debug processing runs. The two main
optimizations in this series are letting the consistency checks be skipped and
relaxing the cmpxchg restrictions when we are not doing consistency checks.
With hackbench -g 20 -l 1000 averaged over 100 runs:

Before slub_debug=P
mean 15.607
variance .086
stdev .294

After slub_debug=P
mean 10.836
variance .155
stdev .394

This still isn't as fast as what is in grsecurity unfortunately so there's still
work to be done. Profiling ___slab_alloc shows that 25-50% of time is spent in
deactivate_slab. I haven't looked too closely to see if this is something that
can be optimized. My plan for now is to focus on getting all of this merged
(if appropriate) before digging in to another task.

As always feedback is appreciated.

Laura Abbott (4):
  slub: Drop lock at the end of free_debug_processing
  slub: Fix/clean free_debug_processing return paths
  sl[aob]: Convert SLAB_DEBUG_FREE to SLAB_CONSISTENCY_CHECKS
  slub: Relax CMPXCHG consistency restrictions

 Documentation/vm/slub.txt |   4 +-
 include/linux/slab.h      |   2 +-
 mm/slab.h                 |   5 +-
 mm/slub.c                 | 126 ++++++++++++++++++++++++++++------------------
 tools/vm/slabinfo.c       |   2 +-
 5 files changed, 83 insertions(+), 56 deletions(-)

-- 
2.5.0
