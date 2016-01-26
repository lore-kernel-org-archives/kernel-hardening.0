Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@fedoraproject.org>
Date: Mon, 25 Jan 2016 17:15:10 -0800
Message-Id: <1453770913-32287-1-git-send-email-labbott@fedoraproject.org>
Subject: [kernel-hardening] [RFC][PATCH 0/3] Speed up SLUB poisoning + disable checks
To: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <js1304@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Laura Abbott <labbott@fedoraproject.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Based on the discussion from the series to add slab sanitization
(lkml.kernel.org/g/<1450755641-7856-1-git-send-email-laura@labbott.name>)
the existing SLAB_POISON mechanism already covers similar behavior.
The performance of SLAB_POISON isn't very good. With hackbench -g 20 -l 1000
on QEMU with one cpu:

slub_debug=-:  7.437
slub_debug=P: 15.366

Poisoning memory is certainly going to have a performance impact but there
are two major contributors to this slowdown: the fastpath is always disabled
when debugging features are enabled and there are lots of expensive
consistency checks happening. This series attempts to address both of them.

Debugging checks now happen on the fast path. This does involve disabling
preemption and interrupts for consistency. This series also introduces a
new slab flag to skip consistency checks but let poisoning or possibly
tracing to happen. After this series:

slub_debug=-:   7.932
slub_debug=PQ:  8.203
slub_debug=P:  10.707

I haven't run this series through a ton of stress tests yet as I was hoping
to get some feedback that this approach looks correct.

Since I expect this to be the trickiest part of SL*B sanitization, my plan
is to focus on getting SLUB speed up merged and then work on the rest of
SL*B sanitization.

As always, feedback is appreciated.

Thanks,
Laura

Laura Abbott (3):
  slub: Drop lock at the end of free_debug_processing
  slub: Don't limit debugging to slow paths
  slub: Add option to skip consistency checks

 include/linux/slab.h |   1 +
 init/Kconfig         |  12 +++
 mm/slub.c            | 214 ++++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 200 insertions(+), 27 deletions(-)

-- 
2.5.0
