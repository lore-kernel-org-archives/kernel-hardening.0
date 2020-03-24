Return-Path: <SRS0=fXcT=5J=lists.openwall.com=kernel-hardening-return-18172-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77A5C43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:40:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EF4C52073E
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:40:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="oBzUO2WG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF4C52073E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18172-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29696 invoked by uid 550); 24 Mar 2020 15:37:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28571 invoked from network); 24 Mar 2020 15:37:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064252;
	bh=s8x98rN3JIFXforeIZi6fVqHqm3rsPtMjmu01QfsNfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBzUO2WGI5lj7iwjFs8aSh+KQqoMKFYHe90bplIwTE4gioxy+X25SSJLiJoCNjbka
	 JDsmyp6svbZTccZH2vARyX1NXmdry8evOEje8IzAtXp1X7NQ2rh/Huu9fvSkxKBSGu
	 YhnooLqeg6ja2dhQBNpJp/ipNv7JCu9VGBjLhF5M=
From: Will Deacon <will@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>,
	Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: [RFC PATCH 17/21] linux/bit_spinlock.h: Include linux/processor.h
Date: Tue, 24 Mar 2020 15:36:39 +0000
Message-Id: <20200324153643.15527-18-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324153643.15527-1-will@kernel.org>
References: <20200324153643.15527-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Needed for cpu_relax().

Signed-off-by: Will Deacon <will@kernel.org>
---
 include/linux/bit_spinlock.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
index bbc4730a6505..505daa942527 100644
--- a/include/linux/bit_spinlock.h
+++ b/include/linux/bit_spinlock.h
@@ -6,6 +6,7 @@
 #include <linux/preempt.h>
 #include <linux/atomic.h>
 #include <linux/bug.h>
+#include <linux/processor.h>
 
 /*
  *  bit-based spin_lock()
-- 
2.20.1

