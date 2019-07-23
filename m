Return-Path: <SRS0=hxEb=VU=lists.openwall.com=kernel-hardening-return-16554-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C41D5C7618B
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 13:52:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 17C26218BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 13:52:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17C26218BE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16554-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13323 invoked by uid 550); 23 Jul 2019 13:51:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12262 invoked from network); 23 Jul 2019 13:51:53 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: tiger29_82ea9ecb2fe20
X-Filterd-Recvd-Size: 1297
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Stephen Kitt <steve@sk2.org>,
	Kees Cook <keescook@chromium.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	jannh@google.com,
	kernel-hardening@lists.openwall.com,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH V2 0/2] string: Add stracpy and stracpy_pad
Date: Tue, 23 Jul 2019 06:51:35 -0700
Message-Id: <cover.1563889130.git.joe@perches.com>
X-Mailer: git-send-email 2.15.0

Add more string copy mechanisms to help avoid defects

Joe Perches (2):
  string: Add stracpy and stracpy_pad mechanisms
  kernel-doc: core-api: Include string.h into core-api

 Documentation/core-api/kernel-api.rst |  3 +++
 include/linux/string.h                | 50 +++++++++++++++++++++++++++++++++--
 lib/string.c                          | 10 ++++---
 3 files changed, 57 insertions(+), 6 deletions(-)

-- 
2.15.0

