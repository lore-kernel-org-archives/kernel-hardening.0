Date: Tue, 31 Jul 2018 23:25:57 +0900
From: Jinbum Park <jinb.park7@gmail.com>
Subject: [PATCH] perf/core: Fix possible Spectre-v1 for perf_swevent_enabled
Message-ID: <20180731142557.GA12460@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: peterz@infradead.org, mingo@redhat.com, acme@kernel.org, alexander.shishkin@linux.intel.com, jolsa@redhat.com, namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

User controls @event_id which to be used as index of perf_swevent_enabled.
So, It can be exploited via Spectre-like attack. (speculative execution)

So sanitize @event_id before using it to prevent attack.

I leveraged strategy [1] to find this gadget.

[1] https://github.com/jinb-park/linux-exploit/
tree/master/exploit-remaining-spectre-gadget/

Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
---
 kernel/events/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f6ea33a..3313552 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -50,6 +50,7 @@
 #include <linux/sched/mm.h>
 #include <linux/proc_ns.h>
 #include <linux/mount.h>
+#include <linux/nospec.h>
 
 #include "internal.h"
 
@@ -8200,6 +8201,7 @@ static int perf_swevent_init(struct perf_event *event)
 		if (err)
 			return err;
 
+		event_id = array_index_nospec(event_id, PERF_COUNT_SW_MAX);
 		static_key_slow_inc(&perf_swevent_enabled[event_id]);
 		event->destroy = sw_perf_event_destroy;
 	}
-- 
1.9.1
