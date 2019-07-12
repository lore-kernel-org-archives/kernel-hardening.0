Return-Path: <SRS0=6T59=VJ=lists.openwall.com=kernel-hardening-return-16430-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ECB8C742D1
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 17:01:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AD16F21670
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 17:01:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="r+S4YTbr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD16F21670
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16430-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32052 invoked by uid 550); 12 Jul 2019 17:00:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31970 invoked from network); 12 Jul 2019 17:00:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HcJl4MkrcKZUWVrbOFfh0nnEc2FkI1NyULrXND4C1ok=;
        b=r+S4YTbrFLXAaoxGT4GzejGKAZshIM9bV3jcdcbEAdv0c619zHSqLN4ei3n7OXVNx6
         n8Mkpq4NMeAreqKp6CxwsDaUWLUdSJGaBd+a1NpA03X4d2w8pRoRmAK3YM7By8+HEacE
         0fDSDMaBiifV8te0r9UChxgacvAyvBEzMCd4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HcJl4MkrcKZUWVrbOFfh0nnEc2FkI1NyULrXND4C1ok=;
        b=EQoTE27qmabP8l86z7WwEUEn8i4fIXCANroQUn20+kx2FAqJpE9Y6+k1aI7BUqhdIf
         O4fGMyAbPfE/t4TQ9QRVWffOQxKVg/DYGUdUIztNtST7jYVzT1T/aeRcT2KgpnU9RRrA
         6Yktw8nfXV/W4QtQrLwxVmCqyUvtMjvrDtyiwFzQZmCM/4pts1RJi7lorJqPKEw3Hs0W
         QdOm9Q8C1GVRJUBvpqTN7eG/Io8Xa4lI8C7ZShDS1LIpdWg7jZ+geDQNpc6pC2eO8VcP
         Qr5nt7LTHxaH4EaUHrB3BmkV/mtqvIVnCIuSblpFH39t9rehSmvJlQJcMc7gZZiG6P3E
         ++MA==
X-Gm-Message-State: APjAAAWjGITtEZ4hhzCyRCewYEkYOs4VFXDX/SxDforwu0Zict4UvQtA
	ykQLJAAePC9lUqUxIk0YwCA=
X-Google-Smtp-Source: APXvYqz15AQfC5v0dP6hN1pCpPQdyBrMqETAncc2VKUY67QfxtlC3x1zPGrp7KZtSsMpaH2x5QNcdQ==
X-Received: by 2002:a17:90b:8c8:: with SMTP id ds8mr13144837pjb.89.1562950837630;
        Fri, 12 Jul 2019 10:00:37 -0700 (PDT)
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Borislav Petkov <bp@alien8.de>,
	c0d1n61at3@gmail.com,
	"David S. Miller" <davem@davemloft.net>,
	edumazet@google.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	keescook@chromium.org,
	kernel-hardening@lists.openwall.com,
	kernel-team@android.com,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-pm@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	neilb@suse.com,
	netdev@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.ibm.com>,
	Pavel Machek <pavel@ucw.cz>,
	peterz@infradead.org,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
	rcu@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	will@kernel.org,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [PATCH v2 1/9] rcu/update: Remove useless check for debug_locks
Date: Fri, 12 Jul 2019 13:00:16 -0400
Message-Id: <20190712170024.111093-2-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190712170024.111093-1-joel@joelfernandes.org>
References: <20190712170024.111093-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In rcu_read_lock_sched_held(), debug_locks can never be true at the
point we check it because we already check debug_locks in
debug_lockdep_rcu_enabled() in the beginning. Remove the check.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 kernel/rcu/update.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index c3bf44ba42e5..bb961cd89e76 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -93,17 +93,13 @@ module_param(rcu_normal_after_boot, int, 0);
  */
 int rcu_read_lock_sched_held(void)
 {
-	int lockdep_opinion = 0;
-
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
 	if (!rcu_is_watching())
 		return 0;
 	if (!rcu_lockdep_current_cpu_online())
 		return 0;
-	if (debug_locks)
-		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
-	return lockdep_opinion || !preemptible();
+	return lock_is_held(&rcu_sched_lock_map) || !preemptible();
 }
 EXPORT_SYMBOL(rcu_read_lock_sched_held);
 #endif
-- 
2.22.0.510.g264f2c817a-goog

