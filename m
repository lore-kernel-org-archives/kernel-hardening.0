Return-Path: <SRS0=1Xqr=DJ=lists.openwall.com=kernel-hardening-return-20086-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE30C4363C
	for <kernel-hardening@archiver.kernel.org>; Fri,  2 Oct 2020 15:17:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7AEEC206CD
	for <kernel-hardening@archiver.kernel.org>; Fri,  2 Oct 2020 15:17:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AEEC206CD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=clip-os.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20086-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22337 invoked by uid 550); 2 Oct 2020 15:17:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22302 invoked from network); 2 Oct 2020 15:17:32 -0000
From: Thibaut Sautereau <thibaut.sautereau@clip-os.org>
To: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Kees Cook <keescook@chromium.org>
Cc: netdev@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Willy Tarreau <w@1wt.eu>,
	Emese Revfy <re.emese@gmail.com>
Subject: [PATCH] random32: Restore __latent_entropy attribute on net_rand_state
Date: Fri,  2 Oct 2020 17:16:11 +0200
Message-Id: <20201002151610.24258-1-thibaut.sautereau@clip-os.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>

Commit f227e3ec3b5c ("random32: update the net random state on interrupt
and activity") broke compilation and was temporarily fixed by Linus in
83bdc7275e62 ("random32: remove net_rand_state from the latent entropy
gcc plugin") by entirely moving net_rand_state out of the things handled
by the latent_entropy GCC plugin.

From what I understand when reading the plugin code, using the
__latent_entropy attribute on a declaration was the wrong part and
simply keeping the __latent_entropy attribute on the variable definition
was the correct fix.

Fixes: 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy gcc plugin")
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Emese Revfy <re.emese@gmail.com>
Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
---
 lib/random32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/random32.c b/lib/random32.c
index 932345323af0..dfb9981ab798 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -49,7 +49,7 @@ static inline void prandom_state_selftest(void)
 }
 #endif
 
-DEFINE_PER_CPU(struct rnd_state, net_rand_state);
+DEFINE_PER_CPU(struct rnd_state, net_rand_state)  __latent_entropy;
 
 /**
  *	prandom_u32_state - seeded pseudo-random number generator.
-- 
2.28.0

