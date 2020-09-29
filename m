Return-Path: <SRS0=6C71=DG=lists.openwall.com=kernel-hardening-return-20022-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D30E4C4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 18:36:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DE18D2074A
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 18:36:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE18D2074A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20022-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25681 invoked by uid 550); 29 Sep 2020 18:36:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25613 invoked from network); 29 Sep 2020 18:36:00 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MskjPp6ZpujaNwi4yQltgMjSnkxLjmoI3z/cZXeO2Hw=;
        b=dQgTi/8awkqLewD4o/nji1MdJVDkGt8eXkCjFaZ0G4nIjev3fLdoWdjcdew1ndCGKE
         SDVllEQzGBs/oqCwaonvH0KdBNJSDGtStGLFE8bHTdv4L37oZKDyXqrq67DlV4C9oNd7
         X89va7YXCLYImNSYUpkMlvwydfXoD5aD8XBIxgc+fLggzpLis/if2vyYknVU6qFfwwl+
         gSwrx1HjisD//d4QRsq29TSpREEFbyF1iyIjdN9206GjldyspffHSKjHMb7mHqs4rd/B
         PbZfX5Vu9v7RYYLZQn/gT5U10RRBz+vsJ6gsz4iSGgw0v8t+kX7qtZ3NGXMzNfMureNd
         YWHA==
X-Gm-Message-State: AOAM532weDjp+7MBvDks/igA/c3LeCLj1r2uFl6yHSTa6zbmJhgvwqKt
	fHyyhOjVaf84AYL+Ho2iKdY=
X-Google-Smtp-Source: ABdhPJwrwd83g7bnSyKaLf5bfDcLBH7k0W2piOgi8XJXLrVdkpCHESSboWm1QucjXR4ih++3BiFn+w==
X-Received: by 2002:a05:600c:21c4:: with SMTP id x4mr6092766wmj.107.1601404547746;
        Tue, 29 Sep 2020 11:35:47 -0700 (PDT)
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
Subject: [PATCH RFC v2 2/6] mm/slab: Perform init_on_free earlier
Date: Tue, 29 Sep 2020 21:35:09 +0300
Message-Id: <20200929183513.380760-3-alex.popov@linux.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200929183513.380760-1-alex.popov@linux.com>
References: <20200929183513.380760-1-alex.popov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently in CONFIG_SLAB init_on_free happens too late, and heap
objects go to the heap quarantine being dirty. Lets move memory
clearing before calling kasan_slab_free() to fix that.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 mm/slab.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 3160dff6fd76..5140203c5b76 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3414,6 +3414,9 @@ static void cache_flusharray(struct kmem_cache *cachep, struct array_cache *ac)
 static __always_inline void __cache_free(struct kmem_cache *cachep, void *objp,
 					 unsigned long caller)
 {
+	if (unlikely(slab_want_init_on_free(cachep)))
+		memset(objp, 0, cachep->object_size);
+
 	/* Put the object into the quarantine, don't touch it for now. */
 	if (kasan_slab_free(cachep, objp, _RET_IP_))
 		return;
@@ -3432,8 +3435,6 @@ void ___cache_free(struct kmem_cache *cachep, void *objp,
 	struct array_cache *ac = cpu_cache_get(cachep);
 
 	check_irq_off();
-	if (unlikely(slab_want_init_on_free(cachep)))
-		memset(objp, 0, cachep->object_size);
 	kmemleak_free_recursive(objp, cachep->flags);
 	objp = cache_free_debugcheck(cachep, objp, caller);
 	memcg_slab_free_hook(cachep, virt_to_head_page(objp), objp);
-- 
2.26.2

