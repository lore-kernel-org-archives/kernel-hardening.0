Return-Path: <SRS0=Go0d=VI=lists.openwall.com=kernel-hardening-return-16410-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CB42C742A2
	for <kernel-hardening@archiver.kernel.org>; Thu, 11 Jul 2019 23:44:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9E55121019
	for <kernel-hardening@archiver.kernel.org>; Thu, 11 Jul 2019 23:44:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="POP2I6vc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E55121019
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16410-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10218 invoked by uid 550); 11 Jul 2019 23:44:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10126 invoked from network); 11 Jul 2019 23:44:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/GuW47+ITVwlHRyFWoit77iH8wSxBVV56wbG/AJ8g+A=;
        b=POP2I6vcsX7mrpLNszrDZ3jHjn5JeGjYvt0TIBarOc+TTSSHTMCxN8ZJl3umrbGe13
         LL/K6XJbcw8liWBMr5VJm7tJsyYXkpeSHOo93Z5cFDVSa8Vym2EQZ+vSjFXjz8J4Wkoy
         ABgjJP8Cfel0JsMbqaLz7L8BjEej7RSdpehss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/GuW47+ITVwlHRyFWoit77iH8wSxBVV56wbG/AJ8g+A=;
        b=Tv3rvCqEQZRoumCnL1IVB8AzTuZhDg/0zsRtJg1yybAgSzCDD4ykJrdAOfkTDmZ6vB
         jbWYtmPzvxWdJmVAQJ+orG1/CSMnLiLtcz+LHBiHg/HoQ4saHu4TH6f4V7DmVl1Uj/VI
         Bun9FGZ7G2ycgKOL39rgCvV/Sqe0tczbBXqvUsktSIEQNd/J9K7K9YW9p7N14REecSt1
         llwWulDYbUlSfcRyCvcibcbss0ggub9SxPfCR7j5Gl2MMjSzkyuX5iALzJDuccn1h6jP
         OHCRHLcjx+fv7lrUxWP6myAeIEB5buU5Kc7u6Q68ILQDEeyc2k6iyMiyeyj//HBQ3iSm
         2VlQ==
X-Gm-Message-State: APjAAAVZJnNsVWXuh+11e5yOi5nKsNwPeQSthpJINy9us0fF2lKE+OxM
	QkO/yuq6fm2F2bb7OQn5VFE=
X-Google-Smtp-Source: APXvYqwL3radJMAbdECmS/G+TOrWXAIf4q3T6x0oa7czoYNYGbVr9jTCwdHXMM+5nal4G43CSaqnjQ==
X-Received: by 2002:a63:3f48:: with SMTP id m69mr7029829pga.17.1562888662320;
        Thu, 11 Jul 2019 16:44:22 -0700 (PDT)
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
Subject: [PATCH v1 2/6] ipv4: add lockdep condition to fix for_each_entry
Date: Thu, 11 Jul 2019 19:43:57 -0400
Message-Id: <20190711234401.220336-3-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190711234401.220336-1-joel@joelfernandes.org>
References: <20190711234401.220336-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 net/ipv4/fib_frontend.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index b298255f6fdb..ef7c9f8e8682 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -127,7 +127,8 @@ struct fib_table *fib_get_table(struct net *net, u32 id)
 	h = id & (FIB_TABLE_HASHSZ - 1);
 
 	head = &net->ipv4.fib_table_hash[h];
-	hlist_for_each_entry_rcu(tb, head, tb_hlist) {
+	hlist_for_each_entry_rcu(tb, head, tb_hlist,
+				 lockdep_rtnl_is_held()) {
 		if (tb->tb_id == id)
 			return tb;
 	}
-- 
2.22.0.410.gd8fdbe21b5-goog

