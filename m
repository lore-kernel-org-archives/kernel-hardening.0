Return-Path: <SRS0=hIgG=X5=lists.openwall.com=kernel-hardening-return-16989-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C24C47404
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Oct 2019 13:34:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 94262222C0
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Oct 2019 13:34:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SsSQMBTT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94262222C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16989-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1860 invoked by uid 550); 4 Oct 2019 13:34:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30666 invoked from network); 4 Oct 2019 13:26:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=GVHCzrg5aWfdjBlvLj9MYI2lYCOnNMg5uvSXdM3+TzE=;
        b=SsSQMBTTYizI5qI0BSu+IiCrsXqCqRd81yCDa8fzJLCceaGzy95YWXA+A9Eu43vK1X
         KFwr7w2uflGE5E14QZs0iYRSxN+6BdqajQTs4joicH9ItFxIWML7+AirG2yJMe5Q747k
         Ip6VqxqQGOuqBLFt+Ti9gGWrvYb6OoUuEtJ++/q/5NkFaAGNaqmvGxdcbV4p6UVE69Tg
         0GnE0nmvDxIst3FAwpsHIjmbH2cw6Hwq0oEcG1+ZnZg/h+kvvy1TpeV+1O+tlQsbOB0n
         310hvdgqkmq385JYCzwb6omFGEqvIRDtFG2MxNN4kvD8ukPQzT174pVv0HpOHhSyidrO
         +bIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=GVHCzrg5aWfdjBlvLj9MYI2lYCOnNMg5uvSXdM3+TzE=;
        b=ZjgYgJ46YEvhcciJbED9wlFZz077hEvWUEF92Zn6D5Y0JDTDaIG9mIcUT23JdombXR
         A6A/UyMwmYcWBxLISQ9G1iqN190WZhJGHUC2WuvAGGKi9xji3Nn4uwxBrsYF5UZBjFvc
         M9sAMe2Isp1YmUBAKJxx2Eo82Q44h1C7xSKoU8iBlehz+tViGINQZcMXDs3+KZx6+Axv
         tCMZ42dc0bG1bnoFkshQ3DDONwzyUFwT5lNpMpa8x7rxfpdQQc0MP88EErotnorTqt32
         yCROXr7gp1yLACMDEhl7xxfTDZXDOmqlgkipzgSvr/cPdo4LgKSWqlp43aDC3+P/sW2m
         kScw==
X-Gm-Message-State: APjAAAVw7owRBxyWIKOIEZKTQCCfRavT21zyR4aC4HBMTTf7QyBmnqzB
	HXvh8LpQkU5Xovi/lNrb+4JN/OFF8yo=
X-Google-Smtp-Source: APXvYqzH2Bqrc6KpwbpAS0ASdf5kHMXJcm41OrYbCmvSOjgQMNFVuYuFC+kQDrRyPbcaOawdhCgwTzByuTU=
X-Received: by 2002:a05:6122:9e:: with SMTP id r30mr7847880vka.10.1570195561944;
 Fri, 04 Oct 2019 06:26:01 -0700 (PDT)
Date: Fri,  4 Oct 2019 15:25:54 +0200
Message-Id: <20191004132555.202973-1-glider@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH v1 1/2] mm: slub: init_on_free=1 should wipe freelist ptr for
 bulk allocations
From: Alexander Potapenko <glider@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>
Cc: Alexander Potapenko <glider@google.com>, Thibaut Sautereau <thibaut@sautereau.fr>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, linux-mm@kvack.org, 
	kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"

slab_alloc_node() already zeroed out the freelist pointer if
init_on_free was on.
Thibaut Sautereau noticed that the same needs to be done for
kmem_cache_alloc_bulk(), which performs the allocations separately.

kmem_cache_alloc_bulk() is currently used in two places in the kernel,
so this change is unlikely to have a major performance impact.

SLAB doesn't require a similar change, as auto-initialization makes the
allocator store the freelist pointers off-slab.

Reported-by: Thibaut Sautereau <thibaut@sautereau.fr>
Reported-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Alexander Potapenko <glider@google.com>
Fixes: 6471384af2a6 ("mm: security: introduce init_on_alloc=1 and init_on_free=1 boot options")
To: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: linux-mm@kvack.org
Cc: kernel-hardening@lists.openwall.com
---
 mm/slub.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8834563cdb4b..fe90bed40eb3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2669,6 +2669,16 @@ static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	return p;
 }
 
+/*
+ * If the object has been wiped upon free, make sure it's fully initialized by
+ * zeroing out freelist pointer.
+ */
+static __always_inline maybe_wipe_obj_freeptr(struct kmem_cache *s, void *obj)
+{
+	if (unlikely(slab_want_init_on_free(s)) && obj)
+		memset((void *)((char *)obj + s->offset), 0, sizeof(void *));
+}
+
 /*
  * Inlined fastpath so that allocation functions (kmalloc, kmem_cache_alloc)
  * have the fastpath folded into their functions. So no function call
@@ -2757,12 +2767,8 @@ static __always_inline void *slab_alloc_node(struct kmem_cache *s,
 		prefetch_freepointer(s, next_object);
 		stat(s, ALLOC_FASTPATH);
 	}
-	/*
-	 * If the object has been wiped upon free, make sure it's fully
-	 * initialized by zeroing out freelist pointer.
-	 */
-	if (unlikely(slab_want_init_on_free(s)) && object)
-		memset(object + s->offset, 0, sizeof(void *));
+
+	maybe_wipe_obj_freeptr(s, object);
 
 	if (unlikely(slab_want_init_on_alloc(gfpflags, s)) && object)
 		memset(object, 0, s->object_size);
@@ -3176,10 +3182,13 @@ int kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
 				goto error;
 
 			c = this_cpu_ptr(s->cpu_slab);
+			maybe_wipe_obj_freeptr(s, p[i]);
+
 			continue; /* goto for-loop */
 		}
 		c->freelist = get_freepointer(s, object);
 		p[i] = object;
+		maybe_wipe_obj_freeptr(s, p[i]);
 	}
 	c->tid = next_tid(c->tid);
 	local_irq_enable();
-- 
2.23.0.581.g78d2f28ef7-goog

