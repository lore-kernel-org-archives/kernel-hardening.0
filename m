Return-Path: <SRS0=chxu=VI=lists.openwall.com=kernel-hardening-return-16412-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9B7C742A2
	for <kernel-hardening@archiver.kernel.org>; Thu, 11 Jul 2019 23:45:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1C3E921019
	for <kernel-hardening@archiver.kernel.org>; Thu, 11 Jul 2019 23:45:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="tCGTNt4C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C3E921019
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16412-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11984 invoked by uid 550); 11 Jul 2019 23:44:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11886 invoked from network); 11 Jul 2019 23:44:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sb5/sBlO0o0IY+ND5ZXjrKZw9gM/z/BZ2b8OMvqM37o=;
        b=tCGTNt4ClbRqV/NfTPLBheEFeH7Zn70VzEPVb6u6yQtg9GPOuDTUPJlXw6bBhUJ1CR
         QpGk/qoWbRMoK0Pts8WznAkBiv/X+3OAFvGO2tXIqriAKW54HJaBcZeAgZjm6E+3gJ7u
         xfrwf9Vd3o1AR/P1EbjFliZLl/0moKn0MvFEE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sb5/sBlO0o0IY+ND5ZXjrKZw9gM/z/BZ2b8OMvqM37o=;
        b=Zaz7fuQccFfXMCJwwM0n2cP6Spl53yDmmJUsQPxcBI/IenxpXzIv60Th+KuC+I+mww
         xQv/iTWXmsnzViK8IhQ4Cz2cefi3SLaYduevyQc/FVX22PArBH/8qVQREE7Yq0PeQOO6
         GpvGxL3W9eiSt8EreUWc37xf2b1smtbM7Y0Qb4JCe1HRGuojqlJHYyRIq6JowimtkHt8
         7iRAUibnbBZ5M0EmUqQqFg+1Q4Kq3KXhAMTDpYnESFErmNU4GNid2MC+sTaMp3CJO+u0
         KoD2G3vj2DrONEQ3RhLOcTL8zYvQKYNEO5hgpusdF9/+ie6Pwmd4ceTz2HfGYOEJl+x6
         UI7w==
X-Gm-Message-State: APjAAAXJiI0b0TaG78oBb8cDNuWvhVDibQvXWQQ6CAZV3tlZDHGPKrbt
	smnNMZikCv8JkkUo7Dvq4y0=
X-Google-Smtp-Source: APXvYqz7RwC1sXenfqK+KGjrZckG5hTYMGbFgu1GP0DrdQq+/nz6LQrmjYSvr647um8kWQAd2c41tw==
X-Received: by 2002:a17:902:381:: with SMTP id d1mr7408739pld.331.1562888670006;
        Thu, 11 Jul 2019 16:44:30 -0700 (PDT)
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
	Josh Triplett <josh@joshtriplett.org>,
	keescook@chromium.org,
	kernel-hardening@lists.openwall.com,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-pm@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	neilb@suse.com,
	netdev@vger.kernel.org,
	oleg@redhat.com,
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
Subject: [PATCH v1 4/6] workqueue: Convert for_each_wq to use built-in list check
Date: Thu, 11 Jul 2019 19:43:59 -0400
Message-Id: <20190711234401.220336-5-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190711234401.220336-1-joel@joelfernandes.org>
References: <20190711234401.220336-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

list_for_each_entry_rcu now has support to check for RCU reader sections
as well as lock. Just use the support in it, instead of explictly
checking in the caller.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 kernel/workqueue.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9657315405de..91ed7aca16e5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -424,9 +424,8 @@ static void workqueue_sysfs_unregister(struct workqueue_struct *wq);
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
2.22.0.410.gd8fdbe21b5-goog

