Return-Path: <SRS0=qk8v=DG=lists.openwall.com=kernel-hardening-return-20024-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A0F9C4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 18:36:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 01EA32074A
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 18:36:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01EA32074A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20024-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26415 invoked by uid 550); 29 Sep 2020 18:36:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26345 invoked from network); 29 Sep 2020 18:36:09 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H9FfRvaA+Wp3IJ0z7DJTjMPazUzC1jfP34QSVpIB8gM=;
        b=Eyg3dodEpLhXv53JAr79gl0XATIpBMXt3t3K9+pCREI1IWWyry5qPeSzau7Juo3O06
         6upssEI8kLehc1py/MtW0yBQrZnx2w7FysHEHEaOiTOl7Fq335XG8RN4N1GYdrVpE1h/
         v2OJstFWSiOge6t+AcJ1UsR+DuyLoyQxpiaE/5Z0n7erTbzqR979hv+Aa4empqs1OZo4
         jUs5ekudnHX2r5jrLHn/o1XxmsKMlMeKaWtaXzpvcwDjn2fuVCAnVpgK4vGjDSHykRNS
         MFmOXmUNY1CAi2Xu66WiQ3joMsJsnDNbuNJOSPx7PdPlVErRWur86ErJtyK6zGe2nrAm
         nt2A==
X-Gm-Message-State: AOAM5309lbfvIr/vbCVgnojLetPqgYjap4hddltOSvSUcHl5AVAs97/t
	SOFqBadEha2D+Ypvd5Ax9zs=
X-Google-Smtp-Source: ABdhPJz8ttasfOla2Nh3dmzYRTGGwGjvXLTOok9ECPboyXttbJf8+eh2xPs5JtcBJcd50lm/HCBFRQ==
X-Received: by 2002:a05:600c:2909:: with SMTP id i9mr6280384wmd.160.1601404556735;
        Tue, 29 Sep 2020 11:35:56 -0700 (PDT)
From: Alexander Popov <alex.popov@linux.com>
To: Kees Cook <keescook@chromium.org>,
	Jann Horn <jannh@google.com>,
	Will Deacon <will@kernel.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Patrick Bellasi <patrick.bellasi@arm.com>,
	David Howells <dhowells@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Laura Abbott <labbott@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Daniel Micay <danielmicay@gmail.com>,
	Andrey Konovalov <andreyknvl@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Pavel Machek <pavel@denx.de>,
	Valentin Schneider <valentin.schneider@arm.com>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org,
	Alexander Popov <alex.popov@linux.com>
Cc: notify@kernel.org
Subject: [PATCH RFC v2 4/6] mm: Implement slab quarantine randomization
Date: Tue, 29 Sep 2020 21:35:11 +0300
Message-Id: <20200929183513.380760-5-alex.popov@linux.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200929183513.380760-1-alex.popov@linux.com>
References: <20200929183513.380760-1-alex.popov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The randomization is very important for the slab quarantine security
properties. Without it the number of kmalloc()+kfree() calls that are
needed for overwriting the vulnerable object is almost the same.
That would be good for stable use-after-free exploitation, and we
should not allow that.

This commit contains very compact and hackish changes that introduce
the quarantine randomization. At first all quarantine batches are filled
by objects. Then during the quarantine reducing we randomly choose and
free 1/2 of objects from a randomly chosen batch. Now the randomized
quarantine releases the freed object at an unpredictable moment, which
is harmful for the heap spraying technique employed by use-after-free
exploits.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 mm/kasan/quarantine.c | 79 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 69 insertions(+), 10 deletions(-)

diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
index 61666263c53e..4ce100605086 100644
--- a/mm/kasan/quarantine.c
+++ b/mm/kasan/quarantine.c
@@ -29,6 +29,7 @@
 #include <linux/srcu.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/random.h>
 
 #include "../slab.h"
 #include "kasan.h"
@@ -89,8 +90,13 @@ static void qlist_move_all(struct qlist_head *from, struct qlist_head *to)
 }
 
 #define QUARANTINE_PERCPU_SIZE (1 << 20)
+
+#ifdef CONFIG_KASAN
 #define QUARANTINE_BATCHES \
 	(1024 > 4 * CONFIG_NR_CPUS ? 1024 : 4 * CONFIG_NR_CPUS)
+#else
+#define QUARANTINE_BATCHES 128
+#endif
 
 /*
  * The object quarantine consists of per-cpu queues and a global queue,
@@ -110,10 +116,7 @@ DEFINE_STATIC_SRCU(remove_cache_srcu);
 /* Maximum size of the global queue. */
 static unsigned long quarantine_max_size;
 
-/*
- * Target size of a batch in global_quarantine.
- * Usually equal to QUARANTINE_PERCPU_SIZE unless we have too much RAM.
- */
+/* Target size of a batch in global_quarantine. */
 static unsigned long quarantine_batch_size;
 
 /*
@@ -191,7 +194,12 @@ void quarantine_put(struct kasan_free_meta *info, struct kmem_cache *cache)
 
 	q = this_cpu_ptr(&cpu_quarantine);
 	qlist_put(q, &info->quarantine_link, cache->size);
+#ifdef CONFIG_KASAN
 	if (unlikely(q->bytes > QUARANTINE_PERCPU_SIZE)) {
+#else
+	if (unlikely(q->bytes > min_t(size_t, QUARANTINE_PERCPU_SIZE,
+					READ_ONCE(quarantine_batch_size)))) {
+#endif
 		qlist_move_all(q, &temp);
 
 		raw_spin_lock(&quarantine_lock);
@@ -204,7 +212,7 @@ void quarantine_put(struct kasan_free_meta *info, struct kmem_cache *cache)
 			new_tail = quarantine_tail + 1;
 			if (new_tail == QUARANTINE_BATCHES)
 				new_tail = 0;
-			if (new_tail != quarantine_head)
+			if (new_tail != quarantine_head || !IS_ENABLED(CONFIG_KASAN))
 				quarantine_tail = new_tail;
 		}
 		raw_spin_unlock(&quarantine_lock);
@@ -213,12 +221,43 @@ void quarantine_put(struct kasan_free_meta *info, struct kmem_cache *cache)
 	local_irq_restore(flags);
 }
 
+static void qlist_move_random(struct qlist_head *from, struct qlist_head *to)
+{
+	struct qlist_node *curr;
+
+	if (unlikely(qlist_empty(from)))
+		return;
+
+	curr = from->head;
+	qlist_init(from);
+	while (curr) {
+		struct qlist_node *next = curr->next;
+		struct kmem_cache *obj_cache = qlink_to_cache(curr);
+		int rnd =  get_random_int();
+
+		/*
+		 * Hackish quarantine randomization, part 2:
+		 * move only 1/2 of objects to the destination list.
+		 * TODO: use random bits sparingly for better performance.
+		 */
+		if (rnd % 2 == 0)
+			qlist_put(to, curr, obj_cache->size);
+		else
+			qlist_put(from, curr, obj_cache->size);
+
+		curr = next;
+	}
+}
+
 void quarantine_reduce(void)
 {
-	size_t total_size, new_quarantine_size, percpu_quarantines;
+	size_t total_size;
 	unsigned long flags;
 	int srcu_idx;
 	struct qlist_head to_free = QLIST_INIT;
+#ifdef CONFIG_KASAN
+	size_t new_quarantine_size, percpu_quarantines;
+#endif
 
 	if (likely(READ_ONCE(quarantine_size) <=
 		   READ_ONCE(quarantine_max_size)))
@@ -236,12 +275,12 @@ void quarantine_reduce(void)
 	srcu_idx = srcu_read_lock(&remove_cache_srcu);
 	raw_spin_lock_irqsave(&quarantine_lock, flags);
 
-	/*
-	 * Update quarantine size in case of hotplug. Allocate a fraction of
-	 * the installed memory to quarantine minus per-cpu queue limits.
-	 */
+	/* Update quarantine size in case of hotplug */
 	total_size = (totalram_pages() << PAGE_SHIFT) /
 		QUARANTINE_FRACTION;
+
+#ifdef CONFIG_KASAN
+	/* Subtract per-cpu queue limits from total quarantine size */
 	percpu_quarantines = QUARANTINE_PERCPU_SIZE * num_online_cpus();
 	new_quarantine_size = (total_size < percpu_quarantines) ?
 		0 : total_size - percpu_quarantines;
@@ -257,6 +296,26 @@ void quarantine_reduce(void)
 		if (quarantine_head == QUARANTINE_BATCHES)
 			quarantine_head = 0;
 	}
+#else /* CONFIG_KASAN */
+	/*
+	 * Don't subtract per-cpu queue limits from total quarantine
+	 * size to consume all quarantine slots.
+	 */
+	WRITE_ONCE(quarantine_max_size, total_size);
+	WRITE_ONCE(quarantine_batch_size, total_size / QUARANTINE_BATCHES);
+
+	/*
+	 * Hackish quarantine randomization, part 1:
+	 * pick a random batch for reducing.
+	 */
+	if (likely(quarantine_size > quarantine_max_size)) {
+		do {
+			quarantine_head = get_random_int() % QUARANTINE_BATCHES;
+		} while (quarantine_head == quarantine_tail);
+		qlist_move_random(&global_quarantine[quarantine_head], &to_free);
+		WRITE_ONCE(quarantine_size, quarantine_size - to_free.bytes);
+	}
+#endif
 
 	raw_spin_unlock_irqrestore(&quarantine_lock, flags);
 
-- 
2.26.2

