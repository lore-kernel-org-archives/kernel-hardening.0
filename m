Return-Path: <kernel-hardening-return-21919-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 240D0C02188
	for <kernel-hardening@archiver.kernel.org>; Sun, 19 Jan 2025 18:23:56 +0000 (UTC)
Received: (qmail 16229 invoked by uid 550); 19 Jan 2025 18:23:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16200 invoked from network); 19 Jan 2025 18:23:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=MBO0001; t=1737311013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=/KGoDwqG4ed2dZMwbpmR67Xf+mOEwFNKNvbnBK6Ourk=;
	b=Q83GecbSNSu1oMT+2eiLfM2n3roUhBRY3/pL2XpWQst8t3jHmM0ZWDpW4wuXNZypjzsAhr
	AETELv7eaAU3Myt1/mMw/vZzgKWjw0stnn8utoyRJX384W7Ft/DdsMKmu4y7Ar+UCtCHP8
	A+6bNFs+7w7FlmPOTZKqOZzfnQ7xK1rewTsCcPL+QNVdyW7pq/OHcQ1PdhH0mPeqWY75nC
	djO61k+i8hs2XM5Spj3Rth1ffRQC4XJiJSBT4Cr4mLNGW2E64S0KwG2mGVAqufu4gX8JMt
	njPX3TUwfcq/DOP/+5dp+6AhR7/KY0eeVnKVaXw8swid1zGA5SEgQnx1w56cHw==
Date: Sun, 19 Jan 2025 13:23:29 -0500
From: Ethan Carter Edwards <ethan@ethancedwards.com>
To: mingo@redhat.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "bsegall@google.com" <bsegall@google.com>, 
	"peterz@infradead.org" <peterz@infradead.org>
Subject: [PATCH v2] sched/topology: change kzalloc to kcalloc
Message-ID: <wayfdq456uccu2kzujdokp5kklbl7evp432rmnxcdh2222wwlp@67idbpxoy32u>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

We are replacing any instances of kzalloc(size * count, ...) with
kcalloc(count, size, ...) due to risk of overflow [1].

[1] https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
Link: https://github.com/KSPP/linux/issues/162

Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
---
 V2: fix email client formatting.
 kernel/sched/topology.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 9748a4c8d668..17eb12819563 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1920,7 +1920,7 @@ void sched_init_numa(int offline_node)
 	 */
 	sched_domains_numa_levels = 0;
 
-	masks = kzalloc(sizeof(void *) * nr_levels, GFP_KERNEL);
+	masks = kcalloc(nr_levels, sizeof(void *), GFP_KERNEL);
 	if (!masks)
 		return;
 
@@ -1929,7 +1929,7 @@ void sched_init_numa(int offline_node)
 	 * CPUs of nodes that are that many hops away from us.
 	 */
 	for (i = 0; i < nr_levels; i++) {
-		masks[i] = kzalloc(nr_node_ids * sizeof(void *), GFP_KERNEL);
+		masks[i] = kcalloc(nr_node_ids, sizeof(void *), GFP_KERNEL);
 		if (!masks[i])
 			return;
 
-- 
2.47.1

