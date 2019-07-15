Return-Path: <SRS0=+JYf=VM=lists.openwall.com=kernel-hardening-return-16466-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE527C7618F
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jul 2019 14:38:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2DD1420651
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jul 2019 14:38:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="sb4sRCBH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DD1420651
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16466-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30496 invoked by uid 550); 15 Jul 2019 14:37:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30406 invoked from network); 15 Jul 2019 14:37:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UMymzQWyTMjq6dLEXUYHnnYNVQu32eRzbAFgwnIdCTM=;
        b=sb4sRCBHFXSE2cPqMR4+T5ZCDTZOXkYZvOefdmVbThG07/8ujO+ZMUI1qi0RzfQNtk
         L2SG3O8Wv6tkY7NUfEU97Sodrr0ncVViDxOuD+Tu+lrXlmz95G5bFlD4Z39OvL7tmZa8
         r01KC9K2ZD2d1/zC/71KGiI4hO6ZU/NWudwNw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UMymzQWyTMjq6dLEXUYHnnYNVQu32eRzbAFgwnIdCTM=;
        b=onJrARy6zYYxxbzTId9Srl4T/5bNRR88mKtbuTn16Bmk+jO9QSlozvllCbwj0BLB1O
         bLSQhpJ5Ks6gST8g5aJ5JrVGX6TgsAagZJrxWzLNrIUcmTy7jg+TDZWc07ZgJjIoXStg
         oWFM7BDJMmrKZdQ1XdzYOUbOx7fxnnNaDZMmHn9/u+ZrM6BlOvlraxigC494lSRWBOcA
         ZRCc3fl/jHeJpfomPK5KJ7k9N3UW0YmevXbqOQBO6lovMkjRbUSxLx5dbPZpoWmjDXHY
         OS7tuxFFO4QMpux3fT5rDjsuNZIhALK+CWAtUd5mqxTwoEBl2w/42ombWPSFA6ZifxLF
         EoPQ==
X-Gm-Message-State: APjAAAVgbp77mhuvPUQWtx6VDH+S5LxmFoRV19LgRarOFnOVxzI6w+sJ
	yQQz+oVW1wpY62j5TML0ZnE=
X-Google-Smtp-Source: APXvYqwREOPm8jU5KaBh/4wpCriK+UOZQMzbDI3ea0SFjpipVn94p6ZbCr/TlFhUWr/4kL8J5e58FQ==
X-Received: by 2002:a17:90a:3270:: with SMTP id k103mr28578111pjb.54.1563201458425;
        Mon, 15 Jul 2019 07:37:38 -0700 (PDT)
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
Subject: [PATCH 6/9] workqueue: Convert for_each_wq to use built-in list check (v2)
Date: Mon, 15 Jul 2019 10:37:02 -0400
Message-Id: <20190715143705.117908-7-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190715143705.117908-1-joel@joelfernandes.org>
References: <20190715143705.117908-1-joel@joelfernandes.org>
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
index 601d61150b65..e882477ebf6e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -364,11 +364,6 @@ static void workqueue_sysfs_unregister(struct workqueue_struct *wq);
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
@@ -425,9 +420,8 @@ static void workqueue_sysfs_unregister(struct workqueue_struct *wq);
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

