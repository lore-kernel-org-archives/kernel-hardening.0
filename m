Return-Path: <SRS0=5Kh/=X5=lists.openwall.com=kernel-hardening-return-16990-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A7C6C4360C
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Oct 2019 13:34:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 86AFD222C0
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Oct 2019 13:34:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u75M3iFy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86AFD222C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16990-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3163 invoked by uid 550); 4 Oct 2019 13:34:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30701 invoked from network); 4 Oct 2019 13:26:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GWlYpnS2hNFrsmeeImnsTlnodR5FcAicQUn+gpn41So=;
        b=u75M3iFyHxY2l+lvcWD5ax+LgH7eSKoGg5Hq64aRsm4ffslEyEPzzpkQDRDgJuS3zJ
         wYFBb1iENWoGX7MR1muFp3riMwAPVpPCqEXqU880Q1tHkv66/ZabS1rxt0q3YHY8w7S9
         7qtD2FEDbfjoRk7esXGfQQ8/8mVHfCaGBuZO/xYZc64AHsxdVQ2+4Pzeb0IZQ/WNhe9w
         KFcfSh4QJBFuzk7iTL3IIQIyQRLnAMBMxNwXGp89pJJyard6+wfzNhjmF9zk4EjqIPOq
         LCk+/U6xR1me4dLTDdbfdmADOD2gbSTMnFIBx9jM6K507PHcd8YHXP/MmcJyFTlGbNo8
         nRFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GWlYpnS2hNFrsmeeImnsTlnodR5FcAicQUn+gpn41So=;
        b=cT63iiWabEe6tJ8KgUNLk6UnUNNNHN+KsbYlID1FpDJj7brQoIotuM0pLNb4dT5Hqo
         AVd56CvN0q2fRXyWG+h3Bxri5Nni+wWj5yHwMIO/wPpnK0sOJ9KDF81M200wIskI9I7K
         hkpgKVtYDZxANH84W7pLSZq1PlVtVvMv64JYzvjgrh7gpDOLHvyZiBwaVy+NGXpLfuUs
         lZdRLuAcVFGZA9YKssgmQX5BwCUSVWT/3PYy8TVXr67cyx1pPtNAFCw8JsIs64tZ7XhV
         yOXaeUYF42VsP9YWDiAUMHjoYVnSsRmYfeCQuxLpNJl4GmEuyLu6PEBsqGRfZYZUwh9I
         eC8A==
X-Gm-Message-State: APjAAAVERnceHUIDcfcM81Mre1GGU+CjREQKR8qOeg8Z6mMHa7EjePVh
	LbPlhXCsp6t/FNxjLvyLbtB4ZBQUFbo=
X-Google-Smtp-Source: APXvYqyDRmK5S8c3gaI8EpnXE6TNfIWQuNU8VFYCXMa0lctyNLV9CLLAW218TuV0cLdfpX30HrNaF0j643E=
X-Received: by 2002:ac5:cc4a:: with SMTP id l10mr2655269vkm.60.1570195566177;
 Fri, 04 Oct 2019 06:26:06 -0700 (PDT)
Date: Fri,  4 Oct 2019 15:25:55 +0200
In-Reply-To: <20191004132555.202973-1-glider@google.com>
Message-Id: <20191004132555.202973-2-glider@google.com>
Mime-Version: 1.0
References: <20191004132555.202973-1-glider@google.com>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH v1 2/2] lib/test_meminit: add a kmem_cache_alloc_bulk() test
From: Alexander Potapenko <glider@google.com>
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

