Return-Path: <SRS0=G9jP=VM=lists.openwall.com=kernel-hardening-return-16467-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C95C76195
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jul 2019 14:38:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 134D4205ED
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jul 2019 14:38:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="uThll7Bo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 134D4205ED
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16467-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31858 invoked by uid 550); 15 Jul 2019 14:37:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31778 invoked from network); 15 Jul 2019 14:37:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eTBxLnGTenFE9+XP/mevxUw30LYF4J7nnGDQ6rB2fzk=;
        b=uThll7BoraMqSjAErrpT4Me7GMeqrtPRWLdwCAfnN2EINbKNVrnQwWny0Uq7RfMVSW
         D1UfsncjiP6lcIIPxTI3DM7jVe9GIEWeYgH4cPRgvi0Vi2Lfx+Xm8cjna4+yOwHO2T9j
         n/4HM9YDYLCy6N041wqa0BohuR1TMRyc8xwns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eTBxLnGTenFE9+XP/mevxUw30LYF4J7nnGDQ6rB2fzk=;
        b=R1LbCKFRsPpId9aR05VcOHyEMdgLZsQca8B85T5Hc7yJwOlp8x3r5fXDge1qgIx0dM
         p7PsD/lc+xPKAPEHbo1fHBhFRq+Ef2nlNzM8L0NMmqRZF9Zw9YQvh9vUdhsijv+yj8/T
         UO2hrPhs57tZoTbx9wgdknY6Z0NeN9IqaBSYcA+2fXw7gSfxgnxv1QSccEfJhDdMsF4V
         ZFQID5avOt6GVJqqkW8T/Rs74gfPDwA7ZZjio0f+l+OFgRig595PB4Q6/rlmt/fcLbkz
         retv0Wj+H8DujFV2lz3f9yC9m8ZAeJ4wieUWLhB6dcbUq/Hui/fiz+hmNTvwECelQQ1v
         9n4Q==
X-Gm-Message-State: APjAAAUbKtsTiDVZwkht5WkUTf/Wx9JMzclONN9e6IX95pfJXBxt2cCC
	sdcPpmMYlhkNq/1rq377xdw=
X-Google-Smtp-Source: APXvYqyQVnMZHW30j+dzF3HoVSq03SIuwJyiMH4A5bHh8OI/EHwBlloUHwhc6xRgf31xUUYhBfS1bQ==
X-Received: by 2002:a63:f312:: with SMTP id l18mr27687193pgh.440.1563201462557;
        Mon, 15 Jul 2019 07:37:42 -0700 (PDT)
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
Subject: [PATCH 7/9] x86/pci: Pass lockdep condition to pcm_mmcfg_list iterator (v1)
Date: Mon, 15 Jul 2019 10:37:03 -0400
Message-Id: <20190715143705.117908-8-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190715143705.117908-1-joel@joelfernandes.org>
References: <20190715143705.117908-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pcm_mmcfg_list is traversed with list_for_each_entry_rcu without a
reader-lock held, because the pci_mmcfg_lock is already held. Make this
known to the list macro so that it fixes new lockdep warnings that
trigger due to lockdep checks added to list_for_each_entry_rcu().

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 arch/x86/pci/mmconfig-shared.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 7389db538c30..6fa42e9c4e6f 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -29,6 +29,7 @@
 static bool pci_mmcfg_running_state;
 static bool pci_mmcfg_arch_init_failed;
 static DEFINE_MUTEX(pci_mmcfg_lock);
+#define pci_mmcfg_lock_held() lock_is_held(&(pci_mmcfg_lock).dep_map)
 
 LIST_HEAD(pci_mmcfg_list);
 
@@ -54,7 +55,7 @@ static void list_add_sorted(struct pci_mmcfg_region *new)
 	struct pci_mmcfg_region *cfg;
 
 	/* keep list sorted by segment and starting bus number */
-	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list) {
+	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list, pci_mmcfg_lock_held()) {
 		if (cfg->segment > new->segment ||
 		    (cfg->segment == new->segment &&
 		     cfg->start_bus >= new->start_bus)) {
@@ -118,7 +119,7 @@ struct pci_mmcfg_region *pci_mmconfig_lookup(int segment, int bus)
 {
 	struct pci_mmcfg_region *cfg;
 
-	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list)
+	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list, pci_mmcfg_lock_held())
 		if (cfg->segment == segment &&
 		    cfg->start_bus <= bus && bus <= cfg->end_bus)
 			return cfg;
-- 
2.22.0.510.g264f2c817a-goog

