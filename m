From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 0/6] More conversions to struct_size
Date: Thu,  7 Jun 2018 07:57:14 -0700
Message-Id: <20180607145720.22590-1-willy@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Hi Kees,

Here are some patches which I had in my tree as demonstrations of
converting code to use kvzalloc_struct.  I've ported them to use
struct_size instead, since these spots weren't caught by your coccinelle
scripts.  Some of them are far too manual to have ever been doable by
a tool.  Maybe some of them will inspire more automated fixes though.

Matthew Wilcox (6):
  Convert virtio_console to struct_size
  Convert infiniband uverbs to struct_size
  Convert v4l2 event to struct_size
  Convert vhost to struct_size
  Convert jffs2 acl to struct_size
  Convert intel uncore to struct_size

 arch/x86/events/intel/uncore.c       | 19 ++++++++++---------
 drivers/char/virtio_console.c        |  3 +--
 drivers/infiniband/core/uverbs_cmd.c |  4 ++--
 drivers/media/v4l2-core/v4l2-event.c |  3 +--
 drivers/vhost/vhost.c                |  3 ++-
 fs/jffs2/acl.c                       |  3 ++-
 fs/jffs2/acl.h                       |  1 +
 include/rdma/ib_verbs.h              |  5 +----
 8 files changed, 20 insertions(+), 21 deletions(-)

-- 
2.17.0
