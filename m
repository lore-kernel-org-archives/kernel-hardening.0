Return-Path: <SRS0=iJqB=DG=lists.openwall.com=kernel-hardening-return-20026-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B23FC4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 18:37:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5D9692074A
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 18:37:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D9692074A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20026-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28201 invoked by uid 550); 29 Sep 2020 18:36:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28142 invoked from network); 29 Sep 2020 18:36:17 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G75o1vtwJEJqsn4jLLLjWPJ87JkHTslNJiSKbRH/W+U=;
        b=Apghy8PYidMWWjYdt02TI5BcmBx22W1h0L7gDeFulCrACcz/Yfis8IJ4rEKKZTSJZz
         OMLBZ/gtJIRUZgf0O1AOMxPz2+z0j1hcfEG8yH64EafpjAW5BDKJNnDb5e48dtHpGow5
         LEphxPu+RJ8XyzAeq2RICxhmKZJWdnEu6aX3Lr/bLkc0bVJ/byONMuqA7YITOCLGS09M
         Ez7MZmZ/OUcQE20mrazJRM1+WnpAWJoNqnemiDs0ydr8FXq1dHS0GV4/uzKzhgaKYq0U
         kqPgnRkxGaxHCr4KQiAAE2WDWaWM35eCVPWDa3p2iK3Cb/wQAqUB6tDHb2UC5Ug/STkh
         +wkA==
X-Gm-Message-State: AOAM530wnS2QLvrOR1DXwefWASuldAD6waJgaxJfpIeKHKaJ463ocD3K
	iGBBo6xChWghzl+lDp3xCBk=
X-Google-Smtp-Source: ABdhPJyRrT8VZbkuyR+uMlXl+IuwMfrgvg3OVh2K+Av6eKUGJ45KzkGbAM6AJojvO9e0oZN+t9TWiw==
X-Received: by 2002:adf:e58b:: with SMTP id l11mr6203909wrm.210.1601404565480;
        Tue, 29 Sep 2020 11:36:05 -0700 (PDT)
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
Subject: [PATCH RFC v2 6/6] mm: Add heap quarantine verbose debugging (not for merge)
Date: Tue, 29 Sep 2020 21:35:13 +0300
Message-Id: <20200929183513.380760-7-alex.popov@linux.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200929183513.380760-1-alex.popov@linux.com>
References: <20200929183513.380760-1-alex.popov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add verbose debugging for deeper understanding of the heap quarantine
inner workings (this patch is not for merge).

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 mm/kasan/quarantine.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
index 4ce100605086..98cd6e963755 100644
--- a/mm/kasan/quarantine.c
+++ b/mm/kasan/quarantine.c
@@ -203,6 +203,12 @@ void quarantine_put(struct kasan_free_meta *info, struct kmem_cache *cache)
 		qlist_move_all(q, &temp);
 
 		raw_spin_lock(&quarantine_lock);
+
+		pr_info("quarantine: PUT %zu to tail batch %d, whole sz %zu, batch sz %lu\n",
+				temp.bytes, quarantine_tail,
+				READ_ONCE(quarantine_size),
+				READ_ONCE(quarantine_batch_size));
+
 		WRITE_ONCE(quarantine_size, quarantine_size + temp.bytes);
 		qlist_move_all(&temp, &global_quarantine[quarantine_tail]);
 		if (global_quarantine[quarantine_tail].bytes >=
@@ -313,7 +319,22 @@ void quarantine_reduce(void)
 			quarantine_head = get_random_int() % QUARANTINE_BATCHES;
 		} while (quarantine_head == quarantine_tail);
 		qlist_move_random(&global_quarantine[quarantine_head], &to_free);
+		pr_info("quarantine: whole sz exceed max by %lu, REDUCE head batch %d by %zu, leave %zu\n",
+				quarantine_size - quarantine_max_size,
+				quarantine_head, to_free.bytes,
+				global_quarantine[quarantine_head].bytes);
 		WRITE_ONCE(quarantine_size, quarantine_size - to_free.bytes);
+
+		if (quarantine_head == 0) {
+			unsigned long i;
+
+			pr_info("quarantine: data level in batches:");
+			for (i = 0; i < QUARANTINE_BATCHES; i++) {
+				pr_info("  %lu - %lu%%\n",
+					i, global_quarantine[i].bytes *
+						100 / quarantine_batch_size);
+			}
+		}
 	}
 #endif
 
-- 
2.26.2

