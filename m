Return-Path: <SRS0=eDdo=VJ=lists.openwall.com=kernel-hardening-return-16435-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68C1C742D1
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 17:01:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F226E20651
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 17:01:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="yQvAOcpI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F226E20651
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16435-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 2044 invoked by uid 550); 12 Jul 2019 17:01:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1998 invoked from network); 12 Jul 2019 17:01:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AptpBaMmXVEAzBSMLWJKxPr4rttPnZ1wioK1nwnHwy8=;
        b=yQvAOcpIfNDNwzp6qEHjOsGXYqVnpbH/+yqEi1B80+c8YsLEO2bHlrNL9T4ka/DGw/
         z2jqgOlDW+zlIDSpKaAxSzYrAquMnRnl5eFGmevh+cE6wTqwUm8hjiPn1KaWffrhd+9j
         /1RA5jQTnJIh+/+WoSk+cY6XTKUqwecgKppuY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AptpBaMmXVEAzBSMLWJKxPr4rttPnZ1wioK1nwnHwy8=;
        b=auy4ar7Y5qu93S8/Ur4vEsq/+LInaz09pqkqWSXkBw7EdxKptm2qoMKUH+SW2Y8YX8
         18c7+nNs/bRbNxCQ65sZOPMakDN/itJQ0z+hLHlGp68eSzfrnFHs9DzqSkYOobkZGLCg
         ypX9Ky1a0nHqBh0/trcvFxDGz3t8Id84uzqevEkWVn+Cwz7tafc9TSRri7hwRdYyL70/
         dmINTUabU3hrB2SOHeY2tg+vwrbP6cpnett/83dBI9u4f3Vx9TPHwPqoGhjYvhRYGYt9
         O/+5ouIszENyC/Fe/H8PjRmEyxdRhhECs0FrQ6ES7Rj3s4Igdmr0UfOwfi5RfQHSDPyE
         K0ig==
X-Gm-Message-State: APjAAAXcX1cloNvPCOrG9B8COwNY1ebKOs7VfpTXlSAr+58qyXjk0MmS
	y60wCjv0sACfeUwpwWacXR0=
X-Google-Smtp-Source: APXvYqxSVQC9IuM5FvE8lT+y5f9yl5+BBjiQfPurEohLODoTR1n3Ry5MZxUFhO2jwyxSjsXaeUm7lw==
X-Received: by 2002:a17:902:7c96:: with SMTP id y22mr12852939pll.39.1562950858903;
        Fri, 12 Jul 2019 10:00:58 -0700 (PDT)
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
Subject: [PATCH v2 6/9] workqueue: Convert for_each_wq to use built-in list check
Date: Fri, 12 Jul 2019 13:00:21 -0400
Message-Id: <20190712170024.111093-7-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190712170024.111093-1-joel@joelfernandes.org>
References: <20190712170024.111093-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

list_for_each_entry_rcu now has support to check for RCU reader sections
as well as lock. Just use the support in it, instead of explictly
checking in the caller.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 kernel/workqueue.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9657315405de..5e88449bdd83 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -363,11 +363,6 @@ static void workqueue_sysfs_unregister(struct workqueue_struct *wq);
 			 !lockdep_is_held(&wq_pool_mutex),		\
 			 "RCU or wq_pool_mutex should be held")
 
-#define assert_rcu_or_wq_mutex(wq)					\
-	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&			\
-			 !lockdep_is_held(&wq->mutex),			\
-			 "RCU or wq->mutex should be held")
-
 #define assert_rcu_or_wq_mutex_or_pool_mutex(wq)			\
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&			\
 			 !lockdep_is_held(&wq->mutex) &&		\
@@ -424,9 +419,8 @@ static void workqueue_sysfs_unregister(struct workqueue_struct *wq);
  * ignored.
  */
 #define for_each_pwq(pwq, wq)						\
-	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node)		\
-		if (({ assert_rcu_or_wq_mutex(wq); false; })) { }	\
-		else
+	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node,		\
+				 lock_is_held(&(wq->mutex).dep_map))
 
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 
-- 
2.22.0.510.g264f2c817a-goog

