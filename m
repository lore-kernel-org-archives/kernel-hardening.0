Return-Path: <SRS0=Snyq=YA=lists.openwall.com=kernel-hardening-return-16993-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 172FFC352AA
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Oct 2019 10:24:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5F1DD2084D
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Oct 2019 10:24:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lHWyy8sO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F1DD2084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16993-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22416 invoked by uid 550); 7 Oct 2019 10:24:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5349 invoked from network); 7 Oct 2019 09:16:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=45HqM66XkDTGJdcHH0Mj9B4/t81i7fjp0X54i65fB7c=;
        b=lHWyy8sO/U0UxHqkJyz7HbZLur5RvuNog2JLwrY/dzOidpSdBVR3SZFZgElA/CeNm+
         Udw/XbbjXjT7Fd8WZcUXYhqqZgCbRnHxePCLEcF0uG7tEgsLxge/b1vD98S7O7yrj0rl
         QtrzzwvqDW+YJGJ4I7F3Y76BB+DHfaSYyXlcxEHR3CaXRS3fxjan+Jvb4o+PGHZTLNHa
         IC2G0Ggw+XsQg4FdnioaUXwoujUoDVIMYJHDDDxXtzu8VnQOQoax/Ag9fO1wG/XIlWx8
         m5xz8oKGBbRF6mkHV7dsIGDrgty6uZKtF8gtjKyXAJ5yUKC4qE3kQr/lZUsGIkYugVvJ
         elqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=45HqM66XkDTGJdcHH0Mj9B4/t81i7fjp0X54i65fB7c=;
        b=VuUCFg4ONAEKDRl7a1H1LgmgYicQMU+IfiOSD0cbKWRnyKy2swrk0LlNjrwC+8hmY7
         PrRPFWHEYhDgBjOQnG3EitjGravX8YN0oLVj3fu2Ot+79fuCdijb0BAT3X258fp0lu2e
         e7rFpENNNNFxaY1S1i3SX015o+tewIzIhXT6kjR9TgoTL0HbJKCNCVXsaH0FU5PaCA9k
         YiRxQs9UiOxrla/+S/m2RUom2SORAlremfZfX1p7/7zJ+rUteTIu4ZB46lUsSiW+Jvy4
         y7l5ZHV0/iLALmEDd4Pp5OubZBE0jtTtlGT0ED0k7YYMqnwMpkpMWxOLHHImgGwBVZSz
         O21A==
X-Gm-Message-State: APjAAAVyMI+u6IOCD/antRyseei8XMx4WrEwAfvqH3Gh+yh2N6DbR0KC
	sXZNIJxRN/nTJ2Ef5ZOz9AtzdbAfPek=
X-Google-Smtp-Source: APXvYqwOBauZkHh/db5vsa2IjQROpgcpgTYnXMyKeDSqPzsADDmRokwCWRrtixo/HVZouqJnm+09QamcFpY=
X-Received: by 2002:a05:6000:43:: with SMTP id k3mr23345847wrx.84.1570439769928;
 Mon, 07 Oct 2019 02:16:09 -0700 (PDT)
Date: Mon,  7 Oct 2019 11:16:04 +0200
Message-Id: <20191007091605.30530-1-glider@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH 1/2] mm: slub: init_on_free=1 should wipe freelist ptr for
 bulk allocations
From: glider@google.com
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
 v2:
  - added a missing return type to maybe_wipe_obj_freeptr() (spotted by
    kbuild test robot <lkp@intel.com>)
---
 mm/slub.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8834563cdb4b..89a69aaf58c4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2669,6 +2669,17 @@ static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	return p;
 }
 
+/*
+ * If the object has been wiped upon free, make sure it's fully initialized by
+ * zeroing out freelist pointer.
+ */
+static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
+						   void *obj)
+{
+	if (unlikely(slab_want_init_on_free(s)) && obj)
+		memset((void *)((char *)obj + s->offset), 0, sizeof(void *));
+}
+
 /*
  * Inlined fastpath so that allocation functions (kmalloc, kmem_cache_alloc)
  * have the fastpath folded into their functions. So no function call
@@ -2757,12 +2768,8 @@ static __always_inline void *slab_alloc_node(struct kmem_cache *s,
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
@@ -3176,10 +3183,13 @@ int kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
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

