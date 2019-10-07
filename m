Return-Path: <SRS0=I7B0=YA=lists.openwall.com=kernel-hardening-return-16994-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC3EC352AA
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Oct 2019 10:24:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C0EB9206BB
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Oct 2019 10:24:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CUiIfoUO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0EB9206BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16994-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23796 invoked by uid 550); 7 Oct 2019 10:24:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5386 invoked from network); 7 Oct 2019 09:16:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GWlYpnS2hNFrsmeeImnsTlnodR5FcAicQUn+gpn41So=;
        b=CUiIfoUOaZ3/xNsHtUlw8T3JE8alI3+A9yCgclSgsrSVH8SudVePu3TcLBdfjrN4w6
         qI9p88+ko4+5jIUbMvv3s5C/Plorq2HNTbptHbiK7ri4InsqhmR9bAUAZTu48/jAL1wq
         JEq4DbOqP3N8Kg5g3VIuVu7iUTtIlymWw/0kR36RCVAD2XjlPn67XcIl2kDVLsc1Moom
         NGIazFY6EsdDR3g43pYfj2his9jPvSelcJYjAfKiElhsxLrr+qoWOgLx1ISJnSeeznHg
         iAHoi1RbkB/QJcrosNP87m0IllT5TV9Ch/MCbYWu7KwfEooA095WRVDdXQ9Opk5Ww+hi
         1jCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GWlYpnS2hNFrsmeeImnsTlnodR5FcAicQUn+gpn41So=;
        b=LKI17oQ6EqIoBtoSloTJg0q0RlSEPAFA06VLwaSFjKSiB2C2WeryJRdwMO4UDZWWHv
         e3x+MhdV7loDXtCUsBu8DOUfYGrvT/OhjwcAUgVAPANQ63/JAxORkWh+06Pxa7UVaXuz
         h9i9MboV42D5AYhpb3JFXJ9BG0iuSsjGXTCh9mMtXpuiK/e9bo1kXRNWDERZ5aqFis4n
         OONTy11Fr9jRXpZTTiJLuA63feBDvzNZFvKWA5vA9/hckmW/otnby3MsKUwuvDJNMxQX
         UuGyLiCf4hr1dt5Oc9sTyH4SoN00nBpHhkGC7vGLeZ4biJWXrT9DtZpjF3g21auozmUE
         lxHA==
X-Gm-Message-State: APjAAAXKLYJya6YmTl7e69rz9NHrgk2K9FODwrnfMsHnPoJEeueNMnv/
	84UNgEb4jw+vxzu1+Vm4XtRXq2zsMqY=
X-Google-Smtp-Source: APXvYqynpRzgGBG57rNPA4UvwbwBjHxsiHvRcfy7RQfMf6LwP25EROhhgGlceXArVCIzArmgmjN9kYDe1qY=
X-Received: by 2002:adf:ea0d:: with SMTP id q13mr10838079wrm.111.1570439774626;
 Mon, 07 Oct 2019 02:16:14 -0700 (PDT)
Date: Mon,  7 Oct 2019 11:16:05 +0200
In-Reply-To: <20191007091605.30530-1-glider@google.com>
Message-Id: <20191007091605.30530-2-glider@google.com>
Mime-Version: 1.0
References: <20191007091605.30530-1-glider@google.com>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH 2/2] lib/test_meminit: add a kmem_cache_alloc_bulk() test
From: glider@google.com
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>
Cc: Alexander Potapenko <glider@google.com>, Kees Cook <keescook@chromium.org>, linux-mm@kvack.org, 
	kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"

Make sure allocations from kmem_cache_alloc_bulk()/kmem_cache_free_bulk()
are properly initialized.

Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org
Cc: kernel-hardening@lists.openwall.com
---
 lib/test_meminit.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/lib/test_meminit.c b/lib/test_meminit.c
index 9729f271d150..9742e5cb853a 100644
--- a/lib/test_meminit.c
+++ b/lib/test_meminit.c
@@ -297,6 +297,32 @@ static int __init do_kmem_cache_rcu_persistent(int size, int *total_failures)
 	return 1;
 }
 
+static int __init do_kmem_cache_size_bulk(int size, int *total_failures)
+{
+	struct kmem_cache *c;
+	int i, iter, maxiter = 1024;
+	int num, bytes;
+	bool fail = false;
+	void *objects[10];
+
+	c = kmem_cache_create("test_cache", size, size, 0, NULL);
+	for (iter = 0; (iter < maxiter) && !fail; iter++) {
+		num = kmem_cache_alloc_bulk(c, GFP_KERNEL, ARRAY_SIZE(objects),
+					    objects);
+		for (i = 0; i < num; i++) {
+			bytes = count_nonzero_bytes(objects[i], size);
+			if (bytes)
+				fail = true;
+			fill_with_garbage(objects[i], size);
+		}
+
+		if (num)
+			kmem_cache_free_bulk(c, num, objects);
+	}
+	*total_failures += fail;
+	return 1;
+}
+
 /*
  * Test kmem_cache allocation by creating caches of different sizes, with and
  * without constructors, with and without SLAB_TYPESAFE_BY_RCU.
@@ -318,6 +344,7 @@ static int __init test_kmemcache(int *total_failures)
 			num_tests += do_kmem_cache_size(size, ctor, rcu, zero,
 							&failures);
 		}
+		num_tests += do_kmem_cache_size_bulk(size, &failures);
 	}
 	REPORT_FAILURES_IN_FN();
 	*total_failures += failures;
-- 
2.23.0.581.g78d2f28ef7-goog

