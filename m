Reply-To: kernel-hardening@lists.openwall.com
From: David Windsor <dave@progbits.org>
Date: Thu, 17 Dec 2015 09:57:42 -0500
Message-Id: <1450364270-12687-5-git-send-email-dave@progbits.org>
In-Reply-To: <1450364270-12687-1-git-send-email-dave@progbits.org>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
Subject: [kernel-hardening][RFC PATCH v2 04/12] mm: opt out of PAX_REFCOUNT protection
To: kernel-hardening@lists.openwall.com
Cc: David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>

Signed-off-by: David Windsor <dave@progbits.org>
---
 include/linux/mm.h       |  2 +-
 include/linux/mmzone.h   |  2 +-
 include/linux/slab_def.h |  8 ++++----
 include/linux/vmstat.h   | 20 ++++++++++----------
 mm/backing-dev.c         |  4 ++--
 mm/memory-failure.c      | 30 +++++++++++++++---------------
 mm/page_alloc.c          |  6 +++---
 mm/slab.c                | 20 ++++++++++++--------
 mm/sparse.c              |  2 +-
 mm/swapfile.c            | 12 ++++++------
 mm/vmstat.c              | 12 ++++++------
 11 files changed, 61 insertions(+), 57 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2b05068..54936fc 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2207,7 +2207,7 @@ extern int get_hwpoison_page(struct page *page);
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
 extern void shake_page(struct page *p, int access);
-extern atomic_long_t num_poisoned_pages;
+extern atomic_long_unchecked_t num_poisoned_pages;
 extern int soft_offline_page(struct page *page, int flags);
 
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 754c259..7b65ac6 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -526,7 +526,7 @@ struct zone {
 
 	ZONE_PADDING(_pad3_)
 	/* Zone statistics */
-	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
+	atomic_long_unchecked_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 } ____cacheline_internodealigned_in_smp;
 
 enum zone_flags {
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 33d0490..e3c7936 100644
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
+	atomic_unchecked_t allochit;
+	atomic_unchecked_t allocmiss;
+	atomic_unchecked_t freehit;
+	atomic_unchecked_t freemiss;
 
 	/*
 	 * If debugging is enabled, then the allocator can add additional
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 82e7db7..39e551e 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -108,18 +108,18 @@ static inline void vm_events_fold_cpu(int cpu)
 /*
  * Zone based page accounting with per cpu differentials.
  */
-extern atomic_long_t vm_stat[NR_VM_ZONE_STAT_ITEMS];
+extern atomic_long_unchecked_t vm_stat[NR_VM_ZONE_STAT_ITEMS];
 
 static inline void zone_page_state_add(long x, struct zone *zone,
 				 enum zone_stat_item item)
 {
-	atomic_long_add(x, &zone->vm_stat[item]);
-	atomic_long_add(x, &vm_stat[item]);
+	atomic_long_add_unchecked(x, &zone->vm_stat[item]);
+	atomic_long_add_unchecked(x, &vm_stat[item]);
 }
 
 static inline unsigned long global_page_state(enum zone_stat_item item)
 {
-	long x = atomic_long_read(&vm_stat[item]);
+	long x = atomic_long_read_unchecked(&vm_stat[item]);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -130,7 +130,7 @@ static inline unsigned long global_page_state(enum zone_stat_item item)
 static inline unsigned long zone_page_state(struct zone *zone,
 					enum zone_stat_item item)
 {
-	long x = atomic_long_read(&zone->vm_stat[item]);
+	long x = atomic_long_read_unchecked(&zone->vm_stat[item]);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -147,7 +147,7 @@ static inline unsigned long zone_page_state(struct zone *zone,
 static inline unsigned long zone_page_state_snapshot(struct zone *zone,
 					enum zone_stat_item item)
 {
-	long x = atomic_long_read(&zone->vm_stat[item]);
+	long x = atomic_long_read_unchecked(&zone->vm_stat[item]);
 
 #ifdef CONFIG_SMP
 	int cpu;
@@ -234,14 +234,14 @@ static inline void __mod_zone_page_state(struct zone *zone,
 
 static inline void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 {
-	atomic_long_inc(&zone->vm_stat[item]);
-	atomic_long_inc(&vm_stat[item]);
+	atomic_long_inc_unchecked(&zone->vm_stat[item]);
+	atomic_long_inc_unchecked(&vm_stat[item]);
 }
 
 static inline void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 {
-	atomic_long_dec(&zone->vm_stat[item]);
-	atomic_long_dec(&vm_stat[item]);
+	atomic_long_dec_unchecked(&zone->vm_stat[item]);
+	atomic_long_dec_unchecked(&vm_stat[item]);
 }
 
 static inline void __inc_zone_page_state(struct page *page,
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index dc07d88..3929c29 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -12,7 +12,7 @@
 #include <linux/device.h>
 #include <trace/events/writeback.h>
 
-static atomic_long_t bdi_seq = ATOMIC_LONG_INIT(0);
+static atomic_long_unchecked_t bdi_seq = ATOMIC_LONG_INIT(0);
 
 struct backing_dev_info noop_backing_dev_info = {
 	.name		= "noop",
@@ -865,7 +865,7 @@ int bdi_setup_and_register(struct backing_dev_info *bdi, char *name)
 		return err;
 
 	err = bdi_register(bdi, NULL, "%.28s-%ld", name,
-			   atomic_long_inc_return(&bdi_seq));
+			   atomic_long_inc_return_unchecked(&bdi_seq));
 	if (err) {
 		bdi_destroy(bdi);
 		return err;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 1f4446a..e837835 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -63,7 +63,7 @@ int sysctl_memory_failure_early_kill __read_mostly = 0;
 
 int sysctl_memory_failure_recovery __read_mostly = 1;
 
-atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
+atomic_long_unchecked_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
 #if defined(CONFIG_HWPOISON_INJECT) || defined(CONFIG_HWPOISON_INJECT_MODULE)
 
@@ -1100,7 +1100,7 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
 		nr_pages = 1 << compound_order(hpage);
 	else /* normal page or thp */
 		nr_pages = 1;
-	atomic_long_add(nr_pages, &num_poisoned_pages);
+	atomic_long_add_unchecked(nr_pages, &num_poisoned_pages);
 
 	/*
 	 * We need/can do nothing about count=0 pages.
@@ -1128,7 +1128,7 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
 			if (PageHWPoison(hpage)) {
 				if ((hwpoison_filter(p) && TestClearPageHWPoison(p))
 				    || (p != hpage && TestSetPageHWPoison(hpage))) {
-					atomic_long_sub(nr_pages, &num_poisoned_pages);
+					atomic_long_sub_unchecked(nr_pages, &num_poisoned_pages);
 					unlock_page(hpage);
 					return 0;
 				}
@@ -1152,7 +1152,7 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
 			else
 				pr_err("MCE: %#lx: thp split failed\n", pfn);
 			if (TestClearPageHWPoison(p))
-				atomic_long_sub(nr_pages, &num_poisoned_pages);
+				atomic_long_sub_unchecked(nr_pages, &num_poisoned_pages);
 			put_page(p);
 			if (p != hpage)
 				put_page(hpage);
@@ -1214,14 +1214,14 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
 	 */
 	if (!PageHWPoison(p)) {
 		printk(KERN_ERR "MCE %#lx: just unpoisoned\n", pfn);
-		atomic_long_sub(nr_pages, &num_poisoned_pages);
+		atomic_long_sub_unchecked(nr_pages, &num_poisoned_pages);
 		unlock_page(hpage);
 		put_page(hpage);
 		return 0;
 	}
 	if (hwpoison_filter(p)) {
 		if (TestClearPageHWPoison(p))
-			atomic_long_sub(nr_pages, &num_poisoned_pages);
+			atomic_long_sub_unchecked(nr_pages, &num_poisoned_pages);
 		unlock_page(hpage);
 		put_page(hpage);
 		return 0;
@@ -1450,7 +1450,7 @@ int unpoison_memory(unsigned long pfn)
 			return 0;
 		}
 		if (TestClearPageHWPoison(p))
-			atomic_long_dec(&num_poisoned_pages);
+			atomic_long_dec_unchecked(&num_poisoned_pages);
 		pr_info("MCE: Software-unpoisoned free page %#lx\n", pfn);
 		return 0;
 	}
@@ -1464,7 +1464,7 @@ int unpoison_memory(unsigned long pfn)
 	 */
 	if (TestClearPageHWPoison(page)) {
 		pr_info("MCE: Software-unpoisoned page %#lx\n", pfn);
-		atomic_long_sub(nr_pages, &num_poisoned_pages);
+		atomic_long_sub_unchecked(nr_pages, &num_poisoned_pages);
 		freeit = 1;
 		if (PageHuge(page))
 			clear_page_hwpoison_huge_page(page);
@@ -1600,11 +1600,11 @@ static int soft_offline_huge_page(struct page *page, int flags)
 		if (PageHuge(page)) {
 			set_page_hwpoison_huge_page(hpage);
 			dequeue_hwpoisoned_huge_page(hpage);
-			atomic_long_add(1 << compound_order(hpage),
+			atomic_long_add_unchecked(1 << compound_order(hpage),
 					&num_poisoned_pages);
 		} else {
 			SetPageHWPoison(page);
-			atomic_long_inc(&num_poisoned_pages);
+			atomic_long_inc_unchecked(&num_poisoned_pages);
 		}
 	}
 	return ret;
@@ -1643,7 +1643,7 @@ static int __soft_offline_page(struct page *page, int flags)
 		put_page(page);
 		pr_info("soft_offline: %#lx: invalidated\n", pfn);
 		SetPageHWPoison(page);
-		atomic_long_inc(&num_poisoned_pages);
+		atomic_long_inc_unchecked(&num_poisoned_pages);
 		return 0;
 	}
 
@@ -1664,7 +1664,7 @@ static int __soft_offline_page(struct page *page, int flags)
 					page_is_file_cache(page));
 		list_add(&page->lru, &pagelist);
 		if (!TestSetPageHWPoison(page))
-			atomic_long_inc(&num_poisoned_pages);
+			atomic_long_inc_unchecked(&num_poisoned_pages);
 		ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 					MIGRATE_SYNC, MR_MEMORY_FAILURE);
 		if (ret) {
@@ -1680,7 +1680,7 @@ static int __soft_offline_page(struct page *page, int flags)
 			if (ret > 0)
 				ret = -EIO;
 			if (TestClearPageHWPoison(page))
-				atomic_long_dec(&num_poisoned_pages);
+				atomic_long_dec_unchecked(&num_poisoned_pages);
 		}
 	} else {
 		pr_info("soft offline: %#lx: isolation failed: %d, page count %d, type %lx\n",
@@ -1742,11 +1742,11 @@ int soft_offline_page(struct page *page, int flags)
 		if (PageHuge(page)) {
 			set_page_hwpoison_huge_page(hpage);
 			if (!dequeue_hwpoisoned_huge_page(hpage))
-				atomic_long_add(1 << compound_order(hpage),
+				atomic_long_add_unchecked(1 << compound_order(hpage),
 					&num_poisoned_pages);
 		} else {
 			if (!TestSetPageHWPoison(page))
-				atomic_long_inc(&num_poisoned_pages);
+				atomic_long_inc_unchecked(&num_poisoned_pages);
 		}
 	}
 	return ret;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5b5240b..da8c7af 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2116,7 +2116,7 @@ struct page *buffered_rmqueue(struct zone *preferred_zone,
 	}
 
 	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
-	if (atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]) <= 0 &&
+	if (atomic_long_read_unchecked(&zone->vm_stat[NR_ALLOC_BATCH]) <= 0 &&
 	    !test_bit(ZONE_FAIR_DEPLETED, &zone->flags))
 		set_bit(ZONE_FAIR_DEPLETED, &zone->flags);
 
@@ -2435,7 +2435,7 @@ static void reset_alloc_batches(struct zone *preferred_zone)
 	do {
 		mod_zone_page_state(zone, NR_ALLOC_BATCH,
 			high_wmark_pages(zone) - low_wmark_pages(zone) -
-			atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]));
+			atomic_long_read_unchecked(&zone->vm_stat[NR_ALLOC_BATCH]));
 		clear_bit(ZONE_FAIR_DEPLETED, &zone->flags);
 	} while (zone++ != preferred_zone);
 }
@@ -6184,7 +6184,7 @@ static void __setup_per_zone_wmarks(void)
 
 		__mod_zone_page_state(zone, NR_ALLOC_BATCH,
 			high_wmark_pages(zone) - low_wmark_pages(zone) -
-			atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]));
+			atomic_long_read_unchecked(&zone->vm_stat[NR_ALLOC_BATCH]));
 
 		setup_zone_migrate_reserve(zone);
 		spin_unlock_irqrestore(&zone->lock, flags);
diff --git a/mm/slab.c b/mm/slab.c
index ae36028..154e594 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -314,10 +314,12 @@ static void kmem_cache_node_init(struct kmem_cache_node *parent)
 		if ((x)->max_freeable < i)				\
 			(x)->max_freeable = i;				\
 	} while (0)
-#define STATS_INC_ALLOCHIT(x)	atomic_inc(&(x)->allochit)
-#define STATS_INC_ALLOCMISS(x)	atomic_inc(&(x)->allocmiss)
-#define STATS_INC_FREEHIT(x)	atomic_inc(&(x)->freehit)
-#define STATS_INC_FREEMISS(x)	atomic_inc(&(x)->freemiss)
+#define STATS_INC_ALLOCHIT(x)	atomic_inc_unchecked(&(x)->allochit)
+#define STATS_INC_ALLOCMISS(x)	atomic_inc_unchecked(&(x)->allocmiss)
+#define STATS_INC_FREEHIT(x)	atomic_inc_unchecked(&(x)->freehit)
+#define STATS_INC_FREEMISS(x)	atomic_inc_unchecked(&(x)->freemiss)
+#define STATS_INC_SANITIZED(x)	atomic_inc_unchecked(&(x)->sanitized)
+#define STATS_INC_NOT_SANITIZED(x) atomic_inc_unchecked(&(x)->not_sanitized)
 #else
 #define	STATS_INC_ACTIVE(x)	do { } while (0)
 #define	STATS_DEC_ACTIVE(x)	do { } while (0)
@@ -334,6 +336,8 @@ static void kmem_cache_node_init(struct kmem_cache_node *parent)
 #define STATS_INC_ALLOCMISS(x)	do { } while (0)
 #define STATS_INC_FREEHIT(x)	do { } while (0)
 #define STATS_INC_FREEMISS(x)	do { } while (0)
+#define STATS_INC_SANITIZED(x)	do { } while (0)
+#define STATS_INC_NOT_SANITIZED(x) do { } while (0)
 #endif
 
 #if DEBUG
@@ -4003,10 +4007,10 @@ void slabinfo_show_stats(struct seq_file *m, struct kmem_cache *cachep)
 	}
 	/* cpu stats */
 	{
-		unsigned long allochit = atomic_read(&cachep->allochit);
-		unsigned long allocmiss = atomic_read(&cachep->allocmiss);
-		unsigned long freehit = atomic_read(&cachep->freehit);
-		unsigned long freemiss = atomic_read(&cachep->freemiss);
+		unsigned long allochit = atomic_read_unchecked(&cachep->allochit);
+		unsigned long allocmiss = atomic_read_unchecked(&cachep->allocmiss);
+		unsigned long freehit = atomic_read_unchecked(&cachep->freehit);
+		unsigned long freemiss = atomic_read_unchecked(&cachep->freemiss);
 
 		seq_printf(m, " : cpustat %6lu %6lu %6lu %6lu",
 			   allochit, allocmiss, freehit, freemiss);
diff --git a/mm/sparse.c b/mm/sparse.c
index d1b48b6..6e8590e 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -750,7 +750,7 @@ static void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
 
 	for (i = 0; i < PAGES_PER_SECTION; i++) {
 		if (PageHWPoison(&memmap[i])) {
-			atomic_long_sub(1, &num_poisoned_pages);
+			atomic_long_sub_unchecked(1, &num_poisoned_pages);
 			ClearPageHWPoison(&memmap[i]);
 		}
 	}
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 41e4581..6c452c9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -84,7 +84,7 @@ static DEFINE_MUTEX(swapon_mutex);
 
 static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
 /* Activity counter to indicate that a swapon or swapoff has occurred */
-static atomic_t proc_poll_event = ATOMIC_INIT(0);
+static atomic_unchecked_t proc_poll_event = ATOMIC_INIT(0);
 
 static inline unsigned char swap_count(unsigned char ent)
 {
@@ -1944,7 +1944,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	spin_unlock(&swap_lock);
 
 	err = 0;
-	atomic_inc(&proc_poll_event);
+	atomic_inc_unchecked(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 
 out_dput:
@@ -1961,8 +1961,8 @@ static unsigned swaps_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &proc_poll_wait, wait);
 
-	if (seq->poll_event != atomic_read(&proc_poll_event)) {
-		seq->poll_event = atomic_read(&proc_poll_event);
+	if (seq->poll_event != atomic_read_unchecked(&proc_poll_event)) {
+		seq->poll_event = atomic_read_unchecked(&proc_poll_event);
 		return POLLIN | POLLRDNORM | POLLERR | POLLPRI;
 	}
 
@@ -2060,7 +2060,7 @@ static int swaps_open(struct inode *inode, struct file *file)
 		return ret;
 
 	seq = file->private_data;
-	seq->poll_event = atomic_read(&proc_poll_event);
+	seq->poll_event = atomic_read_unchecked(&proc_poll_event);
 	return 0;
 }
 
@@ -2520,7 +2520,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		(frontswap_map) ? "FS" : "");
 
 	mutex_unlock(&swapon_mutex);
-	atomic_inc(&proc_poll_event);
+	atomic_inc_unchecked(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 
 	if (S_ISREG(inode->i_mode))
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 4f5cd97..35d42ba 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -86,7 +86,7 @@ void vm_events_fold_cpu(int cpu)
  *
  * vm_stat contains the global counters
  */
-atomic_long_t vm_stat[NR_VM_ZONE_STAT_ITEMS] __cacheline_aligned_in_smp;
+atomic_long_unchecked_t vm_stat[NR_VM_ZONE_STAT_ITEMS] __cacheline_aligned_in_smp;
 EXPORT_SYMBOL(vm_stat);
 
 #ifdef CONFIG_SMP
@@ -438,7 +438,7 @@ static int fold_diff(int *diff)
 
 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
 		if (diff[i]) {
-			atomic_long_add(diff[i], &vm_stat[i]);
+			atomic_long_add_unchecked(diff[i], &vm_stat[i]);
 			changes++;
 	}
 	return changes;
@@ -476,7 +476,7 @@ static int refresh_cpu_vm_stats(void)
 			v = this_cpu_xchg(p->vm_stat_diff[i], 0);
 			if (v) {
 
-				atomic_long_add(v, &zone->vm_stat[i]);
+				atomic_long_add_unchecked(v, &zone->vm_stat[i]);
 				global_diff[i] += v;
 #ifdef CONFIG_NUMA
 				/* 3 seconds idle till flush */
@@ -540,7 +540,7 @@ void cpu_vm_stats_fold(int cpu)
 
 				v = p->vm_stat_diff[i];
 				p->vm_stat_diff[i] = 0;
-				atomic_long_add(v, &zone->vm_stat[i]);
+				atomic_long_add_unchecked(v, &zone->vm_stat[i]);
 				global_diff[i] += v;
 			}
 	}
@@ -560,8 +560,8 @@ void drain_zonestat(struct zone *zone, struct per_cpu_pageset *pset)
 		if (pset->vm_stat_diff[i]) {
 			int v = pset->vm_stat_diff[i];
 			pset->vm_stat_diff[i] = 0;
-			atomic_long_add(v, &zone->vm_stat[i]);
-			atomic_long_add(v, &vm_stat[i]);
+			atomic_long_add_unchecked(v, &zone->vm_stat[i]);
+			atomic_long_add_unchecked(v, &vm_stat[i]);
 		}
 }
 #endif
-- 
2.5.0
