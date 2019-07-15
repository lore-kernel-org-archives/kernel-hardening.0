Return-Path: <SRS0=day5=VM=lists.openwall.com=kernel-hardening-return-16463-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CE9C76191
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jul 2019 14:37:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3154B2182B
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jul 2019 14:37:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="AUubZl4E"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3154B2182B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16463-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28234 invoked by uid 550); 15 Jul 2019 14:37:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28120 invoked from network); 15 Jul 2019 14:37:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z+lAujGo7GrSG40jkK2/203/pKxvTLE13nrgeKcOwgI=;
        b=AUubZl4ETLIsW/m5dgXLBulJXDHc0BCosX1eCwyxi+94m0Nn+UMJmqa85ypsCsZq1j
         xz0LM9usgNKyVFOetyi7Bh0t5cemvEnRKdil/TVdpWNJXsluRFLQGvr0RhdUuQJTVlAU
         AAiUQF4zYjdlsdkxFoX9G9U8IN3eAZ1c3LtuQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z+lAujGo7GrSG40jkK2/203/pKxvTLE13nrgeKcOwgI=;
        b=Lh9WaEHsNGV4gH4VSujy7UsSczy1XqVSSE0/Uy3W3g34k2vyYnAmW7u9Vp1XU9MFUd
         Xcil0PaZdpnwpMHjGP/ZSOBbt8b6Zpyixf213GO0/Db2ERNHhV4lqi+0hLpfHarDX4ev
         d+pIXzIyKZVAo5fDeopT2rIEwd1KKgATiwfbht0ko8TF0hlbD/LDooYvlkjPemKWAVbM
         HfzCmfSQ5dH0VZYIuZLekTgo3B9a1mqBWr8tiMN0MKrNNX3gnDjTn/HHmjP73OaCgQGd
         2j74dyT731sBUtfK20jK9wz5qp2CuI8rpkoXarNQd+njVTIchWbzBhk0/lFrzL17Sn+k
         zn1Q==
X-Gm-Message-State: APjAAAWPEIEcBHLR0iE2BS6SqofQQfZaV43Xn70wW6t0Q8soDc5vAecf
	kd5k/ne1U3nNqJm+KwIkEZU=
X-Google-Smtp-Source: APXvYqyfIIGoLXgS2oKcW7Wk3sDCdph3kdkFQYwRHA7oKCzkGjxEv3JlpE2AZDMyjbjqgNcrkFD7WQ==
X-Received: by 2002:a17:902:8649:: with SMTP id y9mr28192780plt.289.1563201446297;
        Mon, 15 Jul 2019 07:37:26 -0700 (PDT)
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
Subject: [PATCH 3/9] rcu/sync: Remove custom check for reader-section (v2)
Date: Mon, 15 Jul 2019 10:36:59 -0400
Message-Id: <20190715143705.117908-4-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190715143705.117908-1-joel@joelfernandes.org>
References: <20190715143705.117908-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rcu/sync code was doing its own check whether we are in a reader
section. With RCU consolidating flavors and the generic helper added in
this series, this is no longer need. We can just use the generic helper
and it results in a nice cleanup.

Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/linux/rcu_sync.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/rcu_sync.h b/include/linux/rcu_sync.h
index 9b83865d24f9..0027d4c8087c 100644
--- a/include/linux/rcu_sync.h
+++ b/include/linux/rcu_sync.h
@@ -31,9 +31,7 @@ struct rcu_sync {
  */
 static inline bool rcu_sync_is_idle(struct rcu_sync *rsp)
 {
-	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
-			 !rcu_read_lock_bh_held() &&
-			 !rcu_read_lock_sched_held(),
+	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
 			 "suspicious rcu_sync_is_idle() usage");
 	return !READ_ONCE(rsp->gp_state); /* GP_IDLE */
 }
-- 
2.22.0.510.g264f2c817a-goog

