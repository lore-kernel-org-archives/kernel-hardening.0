Return-Path: <SRS0=HmSI=U3=lists.openwall.com=kernel-hardening-return-16316-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ABB8C5B57A
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Jun 2019 09:39:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9CC25205ED
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Jun 2019 09:39:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CR3gJDc6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CC25205ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16316-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28430 invoked by uid 550); 28 Jun 2019 09:38:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20122 invoked from network); 28 Jun 2019 09:31:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=yltp3Nr5hoDNAZ2OFPn4NI5Rzn3a2yDgIbIXrha4iaM=;
        b=CR3gJDc6z07Wkkp9RjMwVFQC4vw0FiFVhhdFCWnKVWL5Udpul5ft0d9yYfYyL0KRwe
         YvRi1l9qjXnTB1P0zT35j66EcCqiwt6K3lfL4hLf0IxNBq2QL1KE2AMHzxaMEf2pgvsa
         571ff3tO8S3tYjKNFZVANKIKaZn9uaXtksbv1SzPsNibM/a44Z0owTk9AjxE3nwh3fF9
         zQk8l8HyUsb1klLlMbqWf3aQOJZep/CGW7FwnLbg6WnsVIJkgt+uSVwepXRg/npeC29A
         uo2u96SMp7B/7q8EsHK9npvcHWfcoiwa2m0AVxrdmIMyzWADc776p/OtlxIbNBF1gmvZ
         ASqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=yltp3Nr5hoDNAZ2OFPn4NI5Rzn3a2yDgIbIXrha4iaM=;
        b=Llk9ZXUacP0MHn6gKAT2tz69xHWXGxYXimSmzTQ9YNlUf7U6QRSgrAvsFsJXQrOTB7
         q1+ru97Swd4t+GTP/qi5mhSEusfmK96lU+G0cdoFAeuzteZg1n1/xTJl450bK9xn/dFc
         OeFjyG5fUNgpCZx7PyV1Cgtnyo9t5NFQukqmx2Z1f0yy94PzWIbv4OeoHRrePJyV/EHQ
         j4epAxPgliHM1zyvJR57wYA+Wg+EAG0quZVUxNxhzIU5uBjqJ76mN3HriFJmiC1Nv1rJ
         GCkN2Jnul84IEYY0l6f9Lr28qpJanoNBeM3QaMreR4YCyzjdmrzVatjZVvMF3QwNDdDK
         S6lw==
X-Gm-Message-State: APjAAAWnQ2cNMLDKbDEDBGp/RSwDNz8gYT3HIp4QweGN68CYDpbPllsb
	TITFsO+3gcXJfbrmaeKVMYnLhAlS2i4=
X-Google-Smtp-Source: APXvYqzAImN3IyFkxzATucMUrAj64yrEoBQxTycRYblSPKjSiOfq+yF5DcKQlNTMfZ1GTbPhBbh9+vm2v60=
X-Received: by 2002:a1f:728b:: with SMTP id n133mr3319864vkc.84.1561714295487;
 Fri, 28 Jun 2019 02:31:35 -0700 (PDT)
Date: Fri, 28 Jun 2019 11:31:29 +0200
Message-Id: <20190628093131.199499-1-glider@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH v10 0/3] add init_on_alloc/init_on_free boot options
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
 mm/slub.c                                     | 40 +++++++++--
 net/core/sock.c                               |  2 +-
 security/Kconfig.hardening                    | 29 ++++++++
 11 files changed, 223 insertions(+), 18 deletions(-)
---
 v3: dropped __GFP_NO_AUTOINIT patches
 v5: dropped support for SLOB allocator, handle SLAB_TYPESAFE_BY_RCU
 v6: changed wording in boot-time message
 v7: dropped the test_meminit.c patch (picked by Andrew Morton already),
     minor wording changes
 v8: fixes for interoperability with other heap debugging features
 v9: added support for page/slab poisoning
 v10: changed pr_warn() to pr_info(), added Acked-by: tags
-- 
2.22.0.410.gd8fdbe21b5-goog

