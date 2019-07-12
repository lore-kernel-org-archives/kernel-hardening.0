Return-Path: <SRS0=elvd=VJ=lists.openwall.com=kernel-hardening-return-16432-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F4B4C742D1
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 17:01:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D325520863
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 17:01:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="yP4qEse4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D325520863
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16432-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1058 invoked by uid 550); 12 Jul 2019 17:00:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32707 invoked from network); 12 Jul 2019 17:00:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ztK1SoGReZBhwdZ89bE2tj3KKCQLEvHK7oy3z8Z+Xn8=;
        b=yP4qEse42R/bByX9BK8SGILXb5Wt77EgL1NJAsCWrORS0X+47/A1wlZRAGMUp76hRy
         CmHGpOQduNYedmfSLa2MAEs1GRfukRXFpiwZwrWYx+pNcWUsMXhp5CsUVwfhJuzOD4bb
         3DX/JieFW8x/XH4h0XyF0SJABUyC20gApI/ZM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ztK1SoGReZBhwdZ89bE2tj3KKCQLEvHK7oy3z8Z+Xn8=;
        b=c4kuznFvZ9Wcpd1NBNLOKLFEp6jrE6gVmUbX9c0+MhgLUtlQMGwXL3VYQ9THy8/XoM
         NT62ul0CAiEaB5qrU++JdmWMa/2D6Pkqhomc29aYCei7SdBCGfACHdsCEa8gawDXoz1a
         Q3+UOXauah7DNKsC/hbhM6u49rbtNzLkYDc2SzEzz2zCMINVOOXrg1+220QpDwqyAiN6
         9Vzu3Bbl3fisbNx2g+nHXZ+G8/vR6BHoCOoo9OS3VHbWyiRqd+DdSdUbWp4flMtFjl24
         Wie7E3PSb8GwFFmcLmDq7XXApe2dMqeD+ubRR2eeIunrbF7A7UGW1Tic9B+JkMn2jJRF
         apUw==
X-Gm-Message-State: APjAAAVyrvAFMXCrIVwslrToXq+hcnDC920G/G/K0vX11BIeJWcLfl5w
	EsMoyERcNu11lhWKkZxJbVE=
X-Google-Smtp-Source: APXvYqxiMVhL5/bUvAI8iAaiaoWG6pTJu5V5J0XbdvBlQDWwxj7kS9rYgN7m4WPBHurlzZP/Kw2/0Q==
X-Received: by 2002:a17:90a:ad41:: with SMTP id w1mr12826209pjv.52.1562950846214;
        Fri, 12 Jul 2019 10:00:46 -0700 (PDT)
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Oleg Nesterov <oleg@redhat.com>,
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
Subject: [PATCH v2 3/9] rcu/sync: Remove custom check for reader-section
Date: Fri, 12 Jul 2019 13:00:18 -0400
Message-Id: <20190712170024.111093-4-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190712170024.111093-1-joel@joelfernandes.org>
References: <20190712170024.111093-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rcu/sync code was doing its own check whether we are in a reader
section. With RCU consolidating flavors and the generic helper added in
this series, this is no longer need. We can just use the generic helper
and it results in a nice cleanup.

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
Please note: Only build and boot tested this particular patch so far.

 include/linux/rcu_sync.h |  5 ++---
 kernel/rcu/sync.c        | 22 ----------------------
 2 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/include/linux/rcu_sync.h b/include/linux/rcu_sync.h
index 6fc53a1345b3..c954f1efc919 100644
--- a/include/linux/rcu_sync.h
+++ b/include/linux/rcu_sync.h
@@ -39,9 +39,8 @@ extern void rcu_sync_lockdep_assert(struct rcu_sync *);
  */
 static inline bool rcu_sync_is_idle(struct rcu_sync *rsp)
 {
-#ifdef CONFIG_PROVE_RCU
-	rcu_sync_lockdep_assert(rsp);
-#endif
+	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
+			 "suspicious rcu_sync_is_idle() usage");
 	return !rsp->gp_state; /* GP_IDLE */
 }
 
diff --git a/kernel/rcu/sync.c b/kernel/rcu/sync.c
index a8304d90573f..535e02601f56 100644
--- a/kernel/rcu/sync.c
+++ b/kernel/rcu/sync.c
@@ -10,37 +10,25 @@
 #include <linux/rcu_sync.h>
 #include <linux/sched.h>
 
-#ifdef CONFIG_PROVE_RCU
-#define __INIT_HELD(func)	.held = func,
-#else
-#define __INIT_HELD(func)
-#endif
-
 static const struct {
 	void (*sync)(void);
 	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
 	void (*wait)(void);
-#ifdef CONFIG_PROVE_RCU
-	int  (*held)(void);
-#endif
 } gp_ops[] = {
 	[RCU_SYNC] = {
 		.sync = synchronize_rcu,
 		.call = call_rcu,
 		.wait = rcu_barrier,
-		__INIT_HELD(rcu_read_lock_held)
 	},
 	[RCU_SCHED_SYNC] = {
 		.sync = synchronize_rcu,
 		.call = call_rcu,
 		.wait = rcu_barrier,
-		__INIT_HELD(rcu_read_lock_sched_held)
 	},
 	[RCU_BH_SYNC] = {
 		.sync = synchronize_rcu,
 		.call = call_rcu,
 		.wait = rcu_barrier,
-		__INIT_HELD(rcu_read_lock_bh_held)
 	},
 };
 
@@ -49,16 +37,6 @@ enum { CB_IDLE = 0, CB_PENDING, CB_REPLAY };
 
 #define	rss_lock	gp_wait.lock
 
-#ifdef CONFIG_PROVE_RCU
-void rcu_sync_lockdep_assert(struct rcu_sync *rsp)
-{
-	RCU_LOCKDEP_WARN(!gp_ops[rsp->gp_type].held(),
-			 "suspicious rcu_sync_is_idle() usage");
-}
-
-EXPORT_SYMBOL_GPL(rcu_sync_lockdep_assert);
-#endif
-
 /**
  * rcu_sync_init() - Initialize an rcu_sync structure
  * @rsp: Pointer to rcu_sync structure to be initialized
-- 
2.22.0.510.g264f2c817a-goog

