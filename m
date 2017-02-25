Date: Sat, 25 Feb 2017 01:56:48 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170225095648.GA4917@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] cgroups: censor kernel pointer in debug files
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

As found in grsecurity, this avoids exposing a kernel pointer through
the cgroup debug entries.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 53bbca7c4859..b794bcadefa4 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -6589,7 +6589,7 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 		struct task_struct *task;
 		int count = 0;
 
-		seq_printf(seq, "css_set %p\n", cset);
+		seq_printf(seq, "css_set %pK\n", cset);
 
 		list_for_each_entry(task, &cset->tasks, cg_list) {
 			if (count++ > MAX_TASKS_SHOWN_PER_CSS)
-- 
2.7.4


-- 
Kees Cook
Pixel Security
