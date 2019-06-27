Return-Path: <SRS0=mFkN=U2=lists.openwall.com=kernel-hardening-return-16285-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436E5C48BD6
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 13:05:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8D3812053B
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 13:05:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iBxY0ZFg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D3812053B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16285-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27983 invoked by uid 550); 27 Jun 2019 13:05:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26075 invoked from network); 27 Jun 2019 13:03:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=nkuGlh1b+gHriNiPX/Ra1Bh+mzhPWQ4oquwmkvO30T4=;
        b=iBxY0ZFgO84nGjeC4loAOGtpGOs9Yd+fQ6I8SutqbHSeU1rnf5JzTtlDWjLJJd0/Nr
         zxHj+IuFkHMyvyWAC33SPbFZGoTK8algV818k/Q71cVpkVHuMBWJKC2ksgxr8pUJEAaP
         dutE+V9ZPEuAoDr2MSkkEBS313KEVD9qNR/3caN6hxA6tFWKop/qr1X7z/Lboo8tZQwW
         I254YFH5T0q6XJAe0Tm+VeVcDZaaB1k/+ZUj+rUz7ui9QpYJ0gGlpps4Mr8zWe3VA6HN
         icTzVRARAhzNdo2Mw8haBEcLFFm82kBhXJPRKv+9+EU9hoEDndfPYq5OKewAgDwKnu5l
         kK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=nkuGlh1b+gHriNiPX/Ra1Bh+mzhPWQ4oquwmkvO30T4=;
        b=oYlzUkVgmBRFlO/eAqYxvjK7wWjs3qBUtNQlevfYZ6ernRMCQ4KcQa0MMRKRT9eC4y
         hf1sLOjH2jClWUNZ07q26vgmxcqyvRaGHb/BP7IvY3/epIPlYFzQEFKh2o2IT6bv5gFm
         g8PN7qXGzlxj1ZsbbN9P47+Djb4OtRs/8Qeo7gmfiELhwr7LtSbv9xZFGPofxJnE51f0
         cGtbVfmwqnQ03NCMBYmkpl2VJWAvdQPhIYtcTXnGCLdxavau4Bi3xL68ECATuU1LAXYu
         tRABLHQDwPMFSB+f7rWNuBIFdTPlgVq1xaVS/rHlnnOoi7Dk9fNRU+etJgeAuq6Ihofy
         IKPw==
X-Gm-Message-State: APjAAAWH68H6Nxulz69ckcydcLxpjLqjJX8owVq4i8AOylVFNlOLT2Q2
	2miPUc7/J8Orc1BNz5yvj+h+AkIfSa4=
X-Google-Smtp-Source: APXvYqyb2fwdKxY/0wj7U997eReOnW8Kj1pQxO+Xnu7fYid+NvlrsgBAglMJ1qJ5NwkNSnI/uio1IDG6JGY=
X-Received: by 2002:a05:620a:35e:: with SMTP id t30mr3084826qkm.1.1561640603625;
 Thu, 27 Jun 2019 06:03:23 -0700 (PDT)
Date: Thu, 27 Jun 2019 15:03:14 +0200
Message-Id: <20190627130316.254309-1-glider@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH v9 0/3] add init_on_alloc/init_on_free boot options
From: Alexander Potapenko <glider@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, 
	Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, 
	Michal Hocko <mhocko@kernel.org>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>, Qian Cai <cai@lca.pw>, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"

Provide init_on_alloc and init_on_free boot options.

These are aimed at preventing possible information leaks and making the
control-flow bugs that depend on uninitialized values more deterministic.

Enabling either of the options guarantees that the memory returned by the
page allocator and SL[AU]B is initialized with zeroes.
SLOB allocator isn't supported at the moment, as its emulation of kmem
caches complicates handling of SLAB_TYPESAFE_BY_RCU caches correctly.

Enabling init_on_free also guarantees that pages and heap objects are
initialized right after they're freed, so it won't be possible to access
stale data by using a dangling pointer.

As suggested by Michal Hocko, right now we don't let the heap users to
disable initialization for certain allocations. There's not enough
evidence that doing so can speed up real-life cases, and introducing
ways to opt-out may result in things going out of control.

To: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
To: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Sandeep Patil <sspatil@android.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Qian Cai <cai@lca.pw>
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com

Alexander Potapenko (2):
  mm: security: introduce init_on_alloc=1 and init_on_free=1 boot
    options
  mm: init: report memory auto-initialization features at boot time

 .../admin-guide/kernel-parameters.txt         |  9 +++
 drivers/infiniband/core/uverbs_ioctl.c        |  2 +-
 include/linux/mm.h                            | 24 +++++++
 init/main.c                                   | 24 +++++++
 mm/dmapool.c                                  |  4 +-
 mm/page_alloc.c                               | 71 +++++++++++++++++--
 mm/slab.c                                     | 16 ++++-
 mm/slab.h                                     | 20 ++++++
 mm/slub.c                                     | 41 +++++++++--
 net/core/sock.c                               |  2 +-
 security/Kconfig.hardening                    | 29 ++++++++
 11 files changed, 224 insertions(+), 18 deletions(-)
---
 v3: dropped __GFP_NO_AUTOINIT patches
 v5: dropped support for SLOB allocator, handle SLAB_TYPESAFE_BY_RCU
 v6: changed wording in boot-time message
 v7: dropped the test_meminit.c patch (picked by Andrew Morton already),
     minor wording changes
 v8: fixes for interoperability with other heap debugging features
 v9: added support for page/slab poisoning
-- 
2.22.0.410.gd8fdbe21b5-goog

