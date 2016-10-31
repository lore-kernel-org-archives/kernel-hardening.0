Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Mon, 31 Oct 2016 13:43:36 +0200
Message-Id: <1477914225-11298-5-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1477914225-11298-1-git-send-email-elena.reshetova@intel.com>
References: <1477914225-11298-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC v3 PATCH 04/13] mm: identify wrapping atomic usage
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: David Windsor <dwindsor@gmail.com>

In some cases atomic is not used for reference
counting and therefore should be allowed to overflow.
Identify such cases and make a switch to non-hardened
atomic version.

The copyright for the original PAX_REFCOUNT code:
  - all REFCOUNT code in general: PaX Team <pageexec@freemail.hu>
  - various false positive fixes: Mathias Krause <minipli@googlemail.com>

Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 fs/proc/meminfo.c        |  2 +-
 include/linux/mm.h       |  2 +-
 include/linux/mmzone.h   |  4 ++--
 include/linux/slab_def.h |  8 ++++----
 include/linux/swapops.h  | 10 +++++-----
 include/linux/vmstat.h   | 38 +++++++++++++++++++-------------------
 lib/show_mem.c           |  3 ++-
 mm/backing-dev.c         |  4 ++--
 mm/memory-failure.c      |  2 +-
 mm/slab.c                | 16 ++++++++--------
 mm/sparse.c              |  2 +-
 mm/swapfile.c            | 12 ++++++------
 mm/vmstat.c              | 26 ++++++++++++++------------
 13 files changed, 66 insertions(+), 63 deletions(-)

diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 8a42849..1e6f3d0 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -136,7 +136,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 
 #ifdef CONFIG_MEMORY_FAILURE
 	seq_printf(m, "HardwareCorrupted: %5lu kB\n",
-		   atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10));
+		   atomic_long_read_wrap(&num_poisoned_pages) << (PAGE_SHIFT - 10));
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/include/linux/mm.h b/include/linux/mm.h
index a92c8d7..6601c0c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2360,7 +2360,7 @@ extern int get_hwpoison_page(struct page *page);
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
 extern void shake_page(struct page *p, int access);
-extern atomic_long_t num_poisoned_pages;
+extern atomic_long_wrap_t num_poisoned_pages;
 extern int soft_offline_page(struct page *page, int flags);
 
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 0f088f3..be64052 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -491,7 +491,7 @@ struct zone {
 
 	ZONE_PADDING(_pad3_)
 	/* Zone statistics */
-	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
+	atomic_long_wrap_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 } ____cacheline_internodealigned_in_smp;
 
 enum pgdat_flags {
@@ -695,7 +695,7 @@ typedef struct pglist_data {
 
 	/* Per-node vmstats */
 	struct per_cpu_nodestat __percpu *per_cpu_nodestats;
-	atomic_long_t		vm_stat[NR_VM_NODE_STAT_ITEMS];
+	atomic_long_wrap_t		vm_stat[NR_VM_NODE_STAT_ITEMS];
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 4ad2c5a..601c69a 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -56,10 +56,10 @@ struct kmem_cache {
 	unsigned long node_allocs;
 	unsigned long node_frees;
 	unsigned long node_overflow;
-	atomic_t allochit;
-	atomic_t allocmiss;
-	atomic_t freehit;
-	atomic_t freemiss;
+	atomic_wrap_t allochit;
+	atomic_wrap_t allocmiss;
+	atomic_wrap_t freehit;
+	atomic_wrap_t freemiss;
 #ifdef CONFIG_DEBUG_SLAB_LEAK
 	atomic_t store_user_clean;
 #endif
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 5c3a5f3..04f5430 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -165,7 +165,7 @@ static inline int is_write_migration_entry(swp_entry_t entry)
 
 #ifdef CONFIG_MEMORY_FAILURE
 
-extern atomic_long_t num_poisoned_pages __read_mostly;
+extern atomic_long_wrap_t num_poisoned_pages __read_mostly;
 
 /*
  * Support for hardware poisoned pages
@@ -188,22 +188,22 @@ static inline bool test_set_page_hwpoison(struct page *page)
 
 static inline void num_poisoned_pages_inc(void)
 {
-	atomic_long_inc(&num_poisoned_pages);
+	atomic_long_inc_wrap(&num_poisoned_pages);
 }
 
 static inline void num_poisoned_pages_dec(void)
 {
-	atomic_long_dec(&num_poisoned_pages);
+	atomic_long_dec_wrap(&num_poisoned_pages);
 }
 
 static inline void num_poisoned_pages_add(long num)
 {
-	atomic_long_add(num, &num_poisoned_pages);
+	atomic_long_add_wrap(num, &num_poisoned_pages);
 }
 
 static inline void num_poisoned_pages_sub(long num)
 {
-	atomic_long_sub(num, &num_poisoned_pages);
+	atomic_long_sub_wrap(num, &num_poisoned_pages);
 }
 #else
 
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 6137719..9e0830e 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -107,26 +107,26 @@ static inline void vm_events_fold_cpu(int cpu)
 /*
  * Zone and node-based page accounting with per cpu differentials.
  */
-extern atomic_long_t vm_zone_stat[NR_VM_ZONE_STAT_ITEMS];
-extern atomic_long_t vm_node_stat[NR_VM_NODE_STAT_ITEMS];
+extern atomic_long_wrap_t vm_zone_stat[NR_VM_ZONE_STAT_ITEMS];
+extern atomic_long_wrap_t vm_node_stat[NR_VM_NODE_STAT_ITEMS];
 
 static inline void zone_page_state_add(long x, struct zone *zone,
 				 enum zone_stat_item item)
 {
-	atomic_long_add(x, &zone->vm_stat[item]);
-	atomic_long_add(x, &vm_zone_stat[item]);
+	atomic_long_add_wrap(x, &zone->vm_stat[item]);
+	atomic_long_add_wrap(x, &vm_zone_stat[item]);
 }
 
 static inline void node_page_state_add(long x, struct pglist_data *pgdat,
 				 enum node_stat_item item)
 {
-	atomic_long_add(x, &pgdat->vm_stat[item]);
-	atomic_long_add(x, &vm_node_stat[item]);
+	atomic_long_add_wrap(x, &pgdat->vm_stat[item]);
+	atomic_long_add_wrap(x, &vm_node_stat[item]);
 }
 
 static inline unsigned long global_page_state(enum zone_stat_item item)
 {
-	long x = atomic_long_read(&vm_zone_stat[item]);
+	long x = atomic_long_read_wrap(&vm_zone_stat[item]);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -136,7 +136,7 @@ static inline unsigned long global_page_state(enum zone_stat_item item)
 
 static inline unsigned long global_node_page_state(enum node_stat_item item)
 {
-	long x = atomic_long_read(&vm_node_stat[item]);
+	long x = atomic_long_read_wrap(&vm_node_stat[item]);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -147,7 +147,7 @@ static inline unsigned long global_node_page_state(enum node_stat_item item)
 static inline unsigned long zone_page_state(struct zone *zone,
 					enum zone_stat_item item)
 {
-	long x = atomic_long_read(&zone->vm_stat[item]);
+	long x = atomic_long_read_wrap(&zone->vm_stat[item]);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -164,7 +164,7 @@ static inline unsigned long zone_page_state(struct zone *zone,
 static inline unsigned long zone_page_state_snapshot(struct zone *zone,
 					enum zone_stat_item item)
 {
-	long x = atomic_long_read(&zone->vm_stat[item]);
+	long x = atomic_long_read_wrap(&zone->vm_stat[item]);
 
 #ifdef CONFIG_SMP
 	int cpu;
@@ -180,7 +180,7 @@ static inline unsigned long zone_page_state_snapshot(struct zone *zone,
 static inline unsigned long node_page_state_snapshot(pg_data_t *pgdat,
 					enum node_stat_item item)
 {
-	long x = atomic_long_read(&pgdat->vm_stat[item]);
+	long x = atomic_long_read_wrap(&pgdat->vm_stat[item]);
 
 #ifdef CONFIG_SMP
 	int cpu;
@@ -267,26 +267,26 @@ static inline void __mod_node_page_state(struct pglist_data *pgdat,
 
 static inline void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 {
-	atomic_long_inc(&zone->vm_stat[item]);
-	atomic_long_inc(&vm_zone_stat[item]);
+	atomic_long_inc_wrap(&zone->vm_stat[item]);
+	atomic_long_inc_wrap(&vm_zone_stat[item]);
 }
 
 static inline void __inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
 {
-	atomic_long_inc(&pgdat->vm_stat[item]);
-	atomic_long_inc(&vm_node_stat[item]);
+	atomic_long_inc_wrap(&pgdat->vm_stat[item]);
+	atomic_long_inc_wrap(&vm_node_stat[item]);
 }
 
 static inline void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 {
-	atomic_long_dec(&zone->vm_stat[item]);
-	atomic_long_dec(&vm_zone_stat[item]);
+	atomic_long_dec_wrap(&zone->vm_stat[item]);
+	atomic_long_dec_wrap(&vm_zone_stat[item]);
 }
 
 static inline void __dec_node_state(struct pglist_data *pgdat, enum node_stat_item item)
 {
-	atomic_long_dec(&pgdat->vm_stat[item]);
-	atomic_long_dec(&vm_node_stat[item]);
+	atomic_long_dec_wrap(&pgdat->vm_stat[item]);
+	atomic_long_dec_wrap(&vm_node_stat[item]);
 }
 
 static inline void __inc_zone_page_state(struct page *page,
diff --git a/lib/show_mem.c b/lib/show_mem.c
index 1feed6a..b92a754 100644
--- a/lib/show_mem.c
+++ b/lib/show_mem.c
@@ -47,6 +47,7 @@ void show_mem(unsigned int filter)
 		quicklist_total_size());
 #endif
 #ifdef CONFIG_MEMORY_FAILURE
-	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
+	printk("%lu pages hwpoisoned\n",
+			atomic_long_read_wrap(&num_poisoned_pages));
 #endif
 }
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 8fde443..8e44fcc 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -12,7 +12,7 @@
 #include <linux/device.h>
 #include <trace/events/writeback.h>
 
-static atomic_long_t bdi_seq = ATOMIC_LONG_INIT(0);
+static atomic_long_wrap_t bdi_seq = ATOMIC_LONG_INIT(0);
 
 struct backing_dev_info noop_backing_dev_info = {
 	.name		= "noop",
@@ -898,7 +898,7 @@ int bdi_setup_and_register(struct backing_dev_info *bdi, char *name)
 		return err;
 
 	err = bdi_register(bdi, NULL, "%.28s-%ld", name,
-			   atomic_long_inc_return(&bdi_seq));
+			   atomic_long_inc_return_wrap(&bdi_seq));
 	if (err) {
 		bdi_destroy(bdi);
 		return err;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index de88f33..2797182 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -64,7 +64,7 @@ int sysctl_memory_failure_early_kill __read_mostly = 0;
 
 int sysctl_memory_failure_recovery __read_mostly = 1;
 
-atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
+atomic_long_wrap_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
 #if defined(CONFIG_HWPOISON_INJECT) || defined(CONFIG_HWPOISON_INJECT_MODULE)
 
diff --git a/mm/slab.c b/mm/slab.c
index 090fb26..3113caf 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -284,10 +284,10 @@ static void kmem_cache_node_init(struct kmem_cache_node *parent)
 		if ((x)->max_freeable < i)				\
 			(x)->max_freeable = i;				\
 	} while (0)
-#define STATS_INC_ALLOCHIT(x)	atomic_inc(&(x)->allochit)
-#define STATS_INC_ALLOCMISS(x)	atomic_inc(&(x)->allocmiss)
-#define STATS_INC_FREEHIT(x)	atomic_inc(&(x)->freehit)
-#define STATS_INC_FREEMISS(x)	atomic_inc(&(x)->freemiss)
+#define STATS_INC_ALLOCHIT(x)	atomic_inc_wrap(&(x)->allochit)
+#define STATS_INC_ALLOCMISS(x)	atomic_inc_wrap(&(x)->allocmiss)
+#define STATS_INC_FREEHIT(x)	atomic_inc_wrap(&(x)->freehit)
+#define STATS_INC_FREEMISS(x)	atomic_inc_wrap(&(x)->freemiss)
 #else
 #define	STATS_INC_ACTIVE(x)	do { } while (0)
 #define	STATS_DEC_ACTIVE(x)	do { } while (0)
@@ -4178,10 +4178,10 @@ void slabinfo_show_stats(struct seq_file *m, struct kmem_cache *cachep)
 	}
 	/* cpu stats */
 	{
-		unsigned long allochit = atomic_read(&cachep->allochit);
-		unsigned long allocmiss = atomic_read(&cachep->allocmiss);
-		unsigned long freehit = atomic_read(&cachep->freehit);
-		unsigned long freemiss = atomic_read(&cachep->freemiss);
+		unsigned long allochit = atomic_read_wrap(&cachep->allochit);
+		unsigned long allocmiss = atomic_read_wrap(&cachep->allocmiss);
+		unsigned long freehit = atomic_read_wrap(&cachep->freehit);
+		unsigned long freemiss = atomic_read_wrap(&cachep->freemiss);
 
 		seq_printf(m, " : cpustat %6lu %6lu %6lu %6lu",
 			   allochit, allocmiss, freehit, freemiss);
diff --git a/mm/sparse.c b/mm/sparse.c
index 1e168bf..56f7ee9 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -749,7 +749,7 @@ static void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
 
 	for (i = 0; i < nr_pages; i++) {
 		if (PageHWPoison(&memmap[i])) {
-			atomic_long_sub(1, &num_poisoned_pages);
+			atomic_long_sub_wrap(1, &num_poisoned_pages);
 			ClearPageHWPoison(&memmap[i]);
 		}
 	}
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2210de2..e56a677 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -90,7 +90,7 @@ static DEFINE_MUTEX(swapon_mutex);
 
 static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
 /* Activity counter to indicate that a swapon or swapoff has occurred */
-static atomic_t proc_poll_event = ATOMIC_INIT(0);
+static atomic_wrap_t proc_poll_event = ATOMIC_INIT(0);
 
 static inline unsigned char swap_count(unsigned char ent)
 {
@@ -1985,7 +1985,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	spin_unlock(&swap_lock);
 
 	err = 0;
-	atomic_inc(&proc_poll_event);
+	atomic_inc_wrap(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 
 out_dput:
@@ -2002,8 +2002,8 @@ static unsigned swaps_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &proc_poll_wait, wait);
 
-	if (seq->poll_event != atomic_read(&proc_poll_event)) {
-		seq->poll_event = atomic_read(&proc_poll_event);
+	if (seq->poll_event != atomic_read_wrap(&proc_poll_event)) {
+		seq->poll_event = atomic_read_wrap(&proc_poll_event);
 		return POLLIN | POLLRDNORM | POLLERR | POLLPRI;
 	}
 
@@ -2101,7 +2101,7 @@ static int swaps_open(struct inode *inode, struct file *file)
 		return ret;
 
 	seq = file->private_data;
-	seq->poll_event = atomic_read(&proc_poll_event);
+	seq->poll_event = atomic_read_wrap(&proc_poll_event);
 	return 0;
 }
 
@@ -2536,7 +2536,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		(frontswap_map) ? "FS" : "");
 
 	mutex_unlock(&swapon_mutex);
-	atomic_inc(&proc_poll_event);
+	atomic_inc_wrap(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 
 	if (S_ISREG(inode->i_mode))
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 604f26a..70fb0a2 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -86,8 +86,10 @@ void vm_events_fold_cpu(int cpu)
  *
  * vm_stat contains the global counters
  */
-atomic_long_t vm_zone_stat[NR_VM_ZONE_STAT_ITEMS] __cacheline_aligned_in_smp;
-atomic_long_t vm_node_stat[NR_VM_NODE_STAT_ITEMS] __cacheline_aligned_in_smp;
+atomic_long_wrap_t vm_zone_stat[NR_VM_ZONE_STAT_ITEMS]
+		__cacheline_aligned_in_smp;
+atomic_long_wrap_t vm_node_stat[NR_VM_NODE_STAT_ITEMS]
+		__cacheline_aligned_in_smp;
 EXPORT_SYMBOL(vm_zone_stat);
 EXPORT_SYMBOL(vm_node_stat);
 
@@ -611,13 +613,13 @@ static int fold_diff(int *zone_diff, int *node_diff)
 
 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
 		if (zone_diff[i]) {
-			atomic_long_add(zone_diff[i], &vm_zone_stat[i]);
+			atomic_long_add_wrap(zone_diff[i], &vm_zone_stat[i]);
 			changes++;
 	}
 
 	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
 		if (node_diff[i]) {
-			atomic_long_add(node_diff[i], &vm_node_stat[i]);
+			atomic_long_add_wrap(node_diff[i], &vm_node_stat[i]);
 			changes++;
 	}
 	return changes;
@@ -657,7 +659,7 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
 			v = this_cpu_xchg(p->vm_stat_diff[i], 0);
 			if (v) {
 
-				atomic_long_add(v, &zone->vm_stat[i]);
+				atomic_long_add_wrap(v, &zone->vm_stat[i]);
 				global_zone_diff[i] += v;
 #ifdef CONFIG_NUMA
 				/* 3 seconds idle till flush */
@@ -706,7 +708,7 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
 
 			v = this_cpu_xchg(p->vm_node_stat_diff[i], 0);
 			if (v) {
-				atomic_long_add(v, &pgdat->vm_stat[i]);
+				atomic_long_add_wrap(v, &pgdat->vm_stat[i]);
 				global_node_diff[i] += v;
 			}
 		}
@@ -740,7 +742,7 @@ void cpu_vm_stats_fold(int cpu)
 
 				v = p->vm_stat_diff[i];
 				p->vm_stat_diff[i] = 0;
-				atomic_long_add(v, &zone->vm_stat[i]);
+				atomic_long_add_wrap(v, &zone->vm_stat[i]);
 				global_zone_diff[i] += v;
 			}
 	}
@@ -756,7 +758,7 @@ void cpu_vm_stats_fold(int cpu)
 
 				v = p->vm_node_stat_diff[i];
 				p->vm_node_stat_diff[i] = 0;
-				atomic_long_add(v, &pgdat->vm_stat[i]);
+				atomic_long_add_wrap(v, &pgdat->vm_stat[i]);
 				global_node_diff[i] += v;
 			}
 	}
@@ -776,8 +778,8 @@ void drain_zonestat(struct zone *zone, struct per_cpu_pageset *pset)
 		if (pset->vm_stat_diff[i]) {
 			int v = pset->vm_stat_diff[i];
 			pset->vm_stat_diff[i] = 0;
-			atomic_long_add(v, &zone->vm_stat[i]);
-			atomic_long_add(v, &vm_zone_stat[i]);
+			atomic_long_add_wrap(v, &zone->vm_stat[i]);
+			atomic_long_add_wrap(v, &vm_zone_stat[i]);
 		}
 }
 #endif
@@ -807,7 +809,7 @@ unsigned long sum_zone_node_page_state(int node,
 unsigned long node_page_state(struct pglist_data *pgdat,
 				enum node_stat_item item)
 {
-	long x = atomic_long_read(&pgdat->vm_stat[item]);
+	long x = atomic_long_read_wrap(&pgdat->vm_stat[item]);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -1580,7 +1582,7 @@ int vmstat_refresh(struct ctl_table *table, int write,
 	if (err)
 		return err;
 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++) {
-		val = atomic_long_read(&vm_zone_stat[i]);
+		val = atomic_long_read_wrap(&vm_zone_stat[i]);
 		if (val < 0) {
 			switch (i) {
 			case NR_PAGES_SCANNED:
-- 
2.7.4
