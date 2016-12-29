Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Thu, 29 Dec 2016 08:56:06 +0200
Message-Id: <1482994571-18687-15-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC PATCH 14/19] tools: convert from atomic_t to refcount_t
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org, ishkamiel@gmail.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. Convert the cases found.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 tools/perf/util/cgroup.c     |  6 +++---
 tools/perf/util/cgroup.h     |  4 ++--
 tools/perf/util/comm.c       | 10 +++++-----
 tools/perf/util/cpumap.c     | 16 ++++++++--------
 tools/perf/util/cpumap.h     |  4 ++--
 tools/perf/util/dso.c        |  6 +++---
 tools/perf/util/dso.h        |  4 ++--
 tools/perf/util/evlist.c     | 18 +++++++++---------
 tools/perf/util/evlist.h     |  4 ++--
 tools/perf/util/map.c        | 10 +++++-----
 tools/perf/util/map.h        | 10 +++++-----
 tools/perf/util/thread.c     |  6 +++---
 tools/perf/util/thread.h     |  4 ++--
 tools/perf/util/thread_map.c | 20 ++++++++++----------
 tools/perf/util/thread_map.h |  4 ++--
 15 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
index 8fdee24..87b9659 100644
--- a/tools/perf/util/cgroup.c
+++ b/tools/perf/util/cgroup.c
@@ -115,19 +115,19 @@ static int add_cgroup(struct perf_evlist *evlist, char *str)
 			goto found;
 		n++;
 	}
-	if (atomic_read(&cgrp->refcnt) == 0)
+	if (refcount_read(&cgrp->refcnt) == 0)
 		free(cgrp);
 
 	return -1;
 found:
-	atomic_inc(&cgrp->refcnt);
+	refcount_inc(&cgrp->refcnt);
 	counter->cgrp = cgrp;
 	return 0;
 }
 
 void close_cgroup(struct cgroup_sel *cgrp)
 {
-	if (cgrp && atomic_dec_and_test(&cgrp->refcnt)) {
+	if (cgrp && refcount_dec_and_test(&cgrp->refcnt)) {
 		close(cgrp->fd);
 		zfree(&cgrp->name);
 		free(cgrp);
diff --git a/tools/perf/util/cgroup.h b/tools/perf/util/cgroup.h
index 31f8dcd..d91966b 100644
--- a/tools/perf/util/cgroup.h
+++ b/tools/perf/util/cgroup.h
@@ -1,14 +1,14 @@
 #ifndef __CGROUP_H__
 #define __CGROUP_H__
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 
 struct option;
 
 struct cgroup_sel {
 	char *name;
 	int fd;
-	atomic_t refcnt;
+	refcount_t refcnt;
 };
 
 
diff --git a/tools/perf/util/comm.c b/tools/perf/util/comm.c
index 21b7ff3..ef36402 100644
--- a/tools/perf/util/comm.c
+++ b/tools/perf/util/comm.c
@@ -2,12 +2,12 @@
 #include "util.h"
 #include <stdlib.h>
 #include <stdio.h>
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 
 struct comm_str {
 	char *str;
 	struct rb_node rb_node;
-	atomic_t refcnt;
+	refcount_t refcnt;
 };
 
 /* Should perhaps be moved to struct machine */
@@ -16,13 +16,13 @@ static struct rb_root comm_str_root;
 static struct comm_str *comm_str__get(struct comm_str *cs)
 {
 	if (cs)
-		atomic_inc(&cs->refcnt);
+		refcount_inc(&cs->refcnt);
 	return cs;
 }
 
 static void comm_str__put(struct comm_str *cs)
 {
-	if (cs && atomic_dec_and_test(&cs->refcnt)) {
+	if (cs && refcount_dec_and_test(&cs->refcnt)) {
 		rb_erase(&cs->rb_node, &comm_str_root);
 		zfree(&cs->str);
 		free(cs);
@@ -43,7 +43,7 @@ static struct comm_str *comm_str__alloc(const char *str)
 		return NULL;
 	}
 
-	atomic_set(&cs->refcnt, 0);
+	refcount_set(&cs->refcnt, 0);
 
 	return cs;
 }
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 2c0b522..0e21e28 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -28,7 +28,7 @@ static struct cpu_map *cpu_map__default_new(void)
 			cpus->map[i] = i;
 
 		cpus->nr = nr_cpus;
-		atomic_set(&cpus->refcnt, 1);
+		refcount_set(&cpus->refcnt, 1);
 	}
 
 	return cpus;
@@ -42,7 +42,7 @@ static struct cpu_map *cpu_map__trim_new(int nr_cpus, int *tmp_cpus)
 	if (cpus != NULL) {
 		cpus->nr = nr_cpus;
 		memcpy(cpus->map, tmp_cpus, payload_size);
-		atomic_set(&cpus->refcnt, 1);
+		refcount_set(&cpus->refcnt, 1);
 	}
 
 	return cpus;
@@ -251,7 +251,7 @@ struct cpu_map *cpu_map__dummy_new(void)
 	if (cpus != NULL) {
 		cpus->nr = 1;
 		cpus->map[0] = -1;
-		atomic_set(&cpus->refcnt, 1);
+		refcount_set(&cpus->refcnt, 1);
 	}
 
 	return cpus;
@@ -268,7 +268,7 @@ struct cpu_map *cpu_map__empty_new(int nr)
 		for (i = 0; i < nr; i++)
 			cpus->map[i] = -1;
 
-		atomic_set(&cpus->refcnt, 1);
+		refcount_set(&cpus->refcnt, 1);
 	}
 
 	return cpus;
@@ -277,7 +277,7 @@ struct cpu_map *cpu_map__empty_new(int nr)
 static void cpu_map__delete(struct cpu_map *map)
 {
 	if (map) {
-		WARN_ONCE(atomic_read(&map->refcnt) != 0,
+		WARN_ONCE(refcount_read(&map->refcnt) != 0,
 			  "cpu_map refcnt unbalanced\n");
 		free(map);
 	}
@@ -286,13 +286,13 @@ static void cpu_map__delete(struct cpu_map *map)
 struct cpu_map *cpu_map__get(struct cpu_map *map)
 {
 	if (map)
-		atomic_inc(&map->refcnt);
+		refcount_inc(&map->refcnt);
 	return map;
 }
 
 void cpu_map__put(struct cpu_map *map)
 {
-	if (map && atomic_dec_and_test(&map->refcnt))
+	if (map && refcount_dec_and_test(&map->refcnt))
 		cpu_map__delete(map);
 }
 
@@ -356,7 +356,7 @@ int cpu_map__build_map(struct cpu_map *cpus, struct cpu_map **res,
 	/* ensure we process id in increasing order */
 	qsort(c->map, c->nr, sizeof(int), cmp_ids);
 
-	atomic_set(&c->refcnt, 1);
+	refcount_set(&c->refcnt, 1);
 	*res = c;
 	return 0;
 }
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
index 06bd689..4f12a01 100644
--- a/tools/perf/util/cpumap.h
+++ b/tools/perf/util/cpumap.h
@@ -3,13 +3,13 @@
 
 #include <stdio.h>
 #include <stdbool.h>
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 
 #include "perf.h"
 #include "util/debug.h"
 
 struct cpu_map {
-	atomic_t refcnt;
+	refcount_t refcnt;
 	int nr;
 	int map[];
 };
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index d2c6cdd..50f088da 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1083,7 +1083,7 @@ struct dso *dso__new(const char *name)
 		INIT_LIST_HEAD(&dso->node);
 		INIT_LIST_HEAD(&dso->data.open_entry);
 		pthread_mutex_init(&dso->lock, NULL);
-		atomic_set(&dso->refcnt, 1);
+		refcount_set(&dso->refcnt, 1);
 	}
 
 	return dso;
@@ -1121,13 +1121,13 @@ void dso__delete(struct dso *dso)
 struct dso *dso__get(struct dso *dso)
 {
 	if (dso)
-		atomic_inc(&dso->refcnt);
+		refcount_inc(&dso->refcnt);
 	return dso;
 }
 
 void dso__put(struct dso *dso)
 {
-	if (dso && atomic_dec_and_test(&dso->refcnt))
+	if (dso && refcount_dec_and_test(&dso->refcnt))
 		dso__delete(dso);
 }
 
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index ecc4bbd..12350b1 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_DSO
 #define __PERF_DSO
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/types.h>
 #include <linux/rbtree.h>
 #include <sys/types.h>
@@ -187,7 +187,7 @@ struct dso {
 		void	 *priv;
 		u64	 db_id;
 	};
-	atomic_t	 refcnt;
+	refcount_t	 refcnt;
 	char		 name[0];
 };
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index d92e020..dba424d 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -777,7 +777,7 @@ union perf_event *perf_mmap__read_forward(struct perf_mmap *md, bool check_messu
 	/*
 	 * Check if event was unmapped due to a POLLHUP/POLLERR.
 	 */
-	if (!atomic_read(&md->refcnt))
+	if (!refcount_read(&md->refcnt))
 		return NULL;
 
 	head = perf_mmap__read_head(md);
@@ -794,7 +794,7 @@ perf_mmap__read_backward(struct perf_mmap *md)
 	/*
 	 * Check if event was unmapped due to a POLLHUP/POLLERR.
 	 */
-	if (!atomic_read(&md->refcnt))
+	if (!refcount_read(&md->refcnt))
 		return NULL;
 
 	head = perf_mmap__read_head(md);
@@ -856,7 +856,7 @@ void perf_mmap__read_catchup(struct perf_mmap *md)
 {
 	u64 head;
 
-	if (!atomic_read(&md->refcnt))
+	if (!refcount_read(&md->refcnt))
 		return;
 
 	head = perf_mmap__read_head(md);
@@ -875,14 +875,14 @@ static bool perf_mmap__empty(struct perf_mmap *md)
 
 static void perf_mmap__get(struct perf_mmap *map)
 {
-	atomic_inc(&map->refcnt);
+	refcount_inc(&map->refcnt);
 }
 
 static void perf_mmap__put(struct perf_mmap *md)
 {
-	BUG_ON(md->base && atomic_read(&md->refcnt) == 0);
+	BUG_ON(md->base && refcount_read(&md->refcnt) == 0);
 
-	if (atomic_dec_and_test(&md->refcnt))
+	if (refcount_dec_and_test(&md->refcnt))
 		perf_mmap__munmap(md);
 }
 
@@ -894,7 +894,7 @@ void perf_mmap__consume(struct perf_mmap *md, bool overwrite)
 		perf_mmap__write_tail(md, old);
 	}
 
-	if (atomic_read(&md->refcnt) == 1 && perf_mmap__empty(md))
+	if (refcount_read(&md->refcnt) == 1 && perf_mmap__empty(md))
 		perf_mmap__put(md);
 }
 
@@ -937,7 +937,7 @@ static void perf_mmap__munmap(struct perf_mmap *map)
 		munmap(map->base, perf_mmap__mmap_len(map));
 		map->base = NULL;
 		map->fd = -1;
-		atomic_set(&map->refcnt, 0);
+		refcount_set(&map->refcnt, 0);
 	}
 	auxtrace_mmap__munmap(&map->auxtrace_mmap);
 }
@@ -1001,7 +1001,7 @@ static int perf_mmap__mmap(struct perf_mmap *map,
 	 * evlist layer can't just drop it when filtering events in
 	 * perf_evlist__filter_pollfd().
 	 */
-	atomic_set(&map->refcnt, 2);
+	refcount_set(&map->refcnt, 2);
 	map->prev = 0;
 	map->mask = mp->mask;
 	map->base = mmap(NULL, perf_mmap__mmap_len(map), mp->prot,
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 4fd034f..7e6c558 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_EVLIST_H
 #define __PERF_EVLIST_H 1
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/list.h>
 #include <api/fd/array.h>
 #include <stdio.h>
@@ -29,7 +29,7 @@ struct perf_mmap {
 	void		 *base;
 	int		 mask;
 	int		 fd;
-	atomic_t	 refcnt;
+	refcount_t	 refcnt;
 	u64		 prev;
 	struct auxtrace_mmap auxtrace_mmap;
 	char		 event_copy[PERF_SAMPLE_MAX_SIZE] __attribute__((aligned(8)));
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 4f9a71c..5fa139d 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -141,7 +141,7 @@ void map__init(struct map *map, enum map_type type,
 	RB_CLEAR_NODE(&map->rb_node);
 	map->groups   = NULL;
 	map->erange_warned = false;
-	atomic_set(&map->refcnt, 1);
+	refcount_set(&map->refcnt, 1);
 }
 
 struct map *map__new(struct machine *machine, u64 start, u64 len,
@@ -255,7 +255,7 @@ void map__delete(struct map *map)
 
 void map__put(struct map *map)
 {
-	if (map && atomic_dec_and_test(&map->refcnt))
+	if (map && refcount_dec_and_test(&map->refcnt))
 		map__delete(map);
 }
 
@@ -354,7 +354,7 @@ struct map *map__clone(struct map *from)
 	struct map *map = memdup(from, sizeof(*map));
 
 	if (map != NULL) {
-		atomic_set(&map->refcnt, 1);
+		refcount_set(&map->refcnt, 1);
 		RB_CLEAR_NODE(&map->rb_node);
 		dso__get(map->dso);
 		map->groups = NULL;
@@ -485,7 +485,7 @@ void map_groups__init(struct map_groups *mg, struct machine *machine)
 		maps__init(&mg->maps[i]);
 	}
 	mg->machine = machine;
-	atomic_set(&mg->refcnt, 1);
+	refcount_set(&mg->refcnt, 1);
 }
 
 static void __maps__purge(struct maps *maps)
@@ -547,7 +547,7 @@ void map_groups__delete(struct map_groups *mg)
 
 void map_groups__put(struct map_groups *mg)
 {
-	if (mg && atomic_dec_and_test(&mg->refcnt))
+	if (mg && refcount_dec_and_test(&mg->refcnt))
 		map_groups__delete(mg);
 }
 
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index abdacf8..c8a5a64 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_MAP_H
 #define __PERF_MAP_H
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/compiler.h>
 #include <linux/list.h>
 #include <linux/rbtree.h>
@@ -51,7 +51,7 @@ struct map {
 
 	struct dso		*dso;
 	struct map_groups	*groups;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 };
 
 struct kmap {
@@ -67,7 +67,7 @@ struct maps {
 struct map_groups {
 	struct maps	 maps[MAP__NR_TYPES];
 	struct machine	 *machine;
-	atomic_t	 refcnt;
+	refcount_t	 refcnt;
 };
 
 struct map_groups *map_groups__new(struct machine *machine);
@@ -77,7 +77,7 @@ bool map_groups__empty(struct map_groups *mg);
 static inline struct map_groups *map_groups__get(struct map_groups *mg)
 {
 	if (mg)
-		atomic_inc(&mg->refcnt);
+		refcount_inc(&mg->refcnt);
 	return mg;
 }
 
@@ -150,7 +150,7 @@ struct map *map__clone(struct map *map);
 static inline struct map *map__get(struct map *map)
 {
 	if (map)
-		atomic_inc(&map->refcnt);
+		refcount_inc(&map->refcnt);
 	return map;
 }
 
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index f5af87f..74e79d2 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -53,7 +53,7 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 			goto err_thread;
 
 		list_add(&comm->list, &thread->comm_list);
-		atomic_set(&thread->refcnt, 1);
+		refcount_set(&thread->refcnt, 1);
 		RB_CLEAR_NODE(&thread->rb_node);
 	}
 
@@ -88,13 +88,13 @@ void thread__delete(struct thread *thread)
 struct thread *thread__get(struct thread *thread)
 {
 	if (thread)
-		atomic_inc(&thread->refcnt);
+		refcount_inc(&thread->refcnt);
 	return thread;
 }
 
 void thread__put(struct thread *thread)
 {
-	if (thread && atomic_dec_and_test(&thread->refcnt)) {
+	if (thread && refcount_dec_and_test(&thread->refcnt)) {
 		/*
 		 * Remove it from the dead_threads list, as last reference
 		 * is gone.
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 99263cb..e571885 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_THREAD_H
 #define __PERF_THREAD_H
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/rbtree.h>
 #include <linux/list.h>
 #include <unistd.h>
@@ -23,7 +23,7 @@ struct thread {
 	pid_t			tid;
 	pid_t			ppid;
 	int			cpu;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	char			shortname[3];
 	bool			comm_set;
 	int			comm_len;
diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
index 40585f5..35f14ee 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -66,7 +66,7 @@ struct thread_map *thread_map__new_by_pid(pid_t pid)
 		for (i = 0; i < items; i++)
 			thread_map__set_pid(threads, i, atoi(namelist[i]->d_name));
 		threads->nr = items;
-		atomic_set(&threads->refcnt, 1);
+		refcount_set(&threads->refcnt, 1);
 	}
 
 	for (i=0; i<items; i++)
@@ -83,7 +83,7 @@ struct thread_map *thread_map__new_by_tid(pid_t tid)
 	if (threads != NULL) {
 		thread_map__set_pid(threads, 0, tid);
 		threads->nr = 1;
-		atomic_set(&threads->refcnt, 1);
+		refcount_set(&threads->refcnt, 1);
 	}
 
 	return threads;
@@ -105,7 +105,7 @@ struct thread_map *thread_map__new_by_uid(uid_t uid)
 		goto out_free_threads;
 
 	threads->nr = 0;
-	atomic_set(&threads->refcnt, 1);
+	refcount_set(&threads->refcnt, 1);
 
 	while ((dirent = readdir(proc)) != NULL) {
 		char *end;
@@ -235,7 +235,7 @@ static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
 out:
 	strlist__delete(slist);
 	if (threads)
-		atomic_set(&threads->refcnt, 1);
+		refcount_set(&threads->refcnt, 1);
 	return threads;
 
 out_free_namelist:
@@ -255,7 +255,7 @@ struct thread_map *thread_map__new_dummy(void)
 	if (threads != NULL) {
 		thread_map__set_pid(threads, 0, -1);
 		threads->nr = 1;
-		atomic_set(&threads->refcnt, 1);
+		refcount_set(&threads->refcnt, 1);
 	}
 	return threads;
 }
@@ -300,7 +300,7 @@ struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
 	}
 out:
 	if (threads)
-		atomic_set(&threads->refcnt, 1);
+		refcount_set(&threads->refcnt, 1);
 	return threads;
 
 out_free_threads:
@@ -326,7 +326,7 @@ static void thread_map__delete(struct thread_map *threads)
 	if (threads) {
 		int i;
 
-		WARN_ONCE(atomic_read(&threads->refcnt) != 0,
+		WARN_ONCE(refcount_read(&threads->refcnt) != 0,
 			  "thread map refcnt unbalanced\n");
 		for (i = 0; i < threads->nr; i++)
 			free(thread_map__comm(threads, i));
@@ -337,13 +337,13 @@ static void thread_map__delete(struct thread_map *threads)
 struct thread_map *thread_map__get(struct thread_map *map)
 {
 	if (map)
-		atomic_inc(&map->refcnt);
+		refcount_inc(&map->refcnt);
 	return map;
 }
 
 void thread_map__put(struct thread_map *map)
 {
-	if (map && atomic_dec_and_test(&map->refcnt))
+	if (map && refcount_dec_and_test(&map->refcnt))
 		thread_map__delete(map);
 }
 
@@ -423,7 +423,7 @@ static void thread_map__copy_event(struct thread_map *threads,
 		threads->map[i].comm = strndup(event->entries[i].comm, 16);
 	}
 
-	atomic_set(&threads->refcnt, 1);
+	refcount_set(&threads->refcnt, 1);
 }
 
 struct thread_map *thread_map__new_event(struct thread_map_event *event)
diff --git a/tools/perf/util/thread_map.h b/tools/perf/util/thread_map.h
index bd3b971..dae46da 100644
--- a/tools/perf/util/thread_map.h
+++ b/tools/perf/util/thread_map.h
@@ -3,7 +3,7 @@
 
 #include <sys/types.h>
 #include <stdio.h>
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 
 struct thread_map_data {
 	pid_t    pid;
@@ -11,7 +11,7 @@ struct thread_map_data {
 };
 
 struct thread_map {
-	atomic_t refcnt;
+	refcount_t refcnt;
 	int nr;
 	struct thread_map_data map[];
 };
-- 
2.7.4
