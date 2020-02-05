Return-Path: <SRS0=I6E2=3Z=lists.openwall.com=kernel-hardening-return-17674-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E2E9C35247
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 Feb 2020 22:40:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0122A214AF
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 Feb 2020 22:40:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0122A214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17674-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9830 invoked by uid 550); 5 Feb 2020 22:39:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9757 invoked from network); 5 Feb 2020 22:39:52 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,407,1574150400"; 
   d="scan'208";a="225092444"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	arjan@linux.intel.com,
	keescook@chromium.org
Cc: rick.p.edgecombe@intel.com,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [RFC PATCH 04/11] x86/boot/KASLR: Introduce PRNG for faster shuffling
Date: Wed,  5 Feb 2020 14:39:43 -0800
Message-Id: <20200205223950.1212394-5-kristen@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205223950.1212394-1-kristen@linux.intel.com>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

This *might* improve shuffling speed at boot. Possibly only marginally.
This has not yet been tested, and would need to have some performance
tests run to determine if it helps before merging.

(notes from Kristen) - initial performance tests suggest that any
improvement is indeed marginal. However, this code is useful
for using a known seed.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 arch/x86/boot/compressed/kaslr.c |  4 +--
 arch/x86/include/asm/kaslr.h     |  3 +-
 arch/x86/lib/kaslr.c             | 50 +++++++++++++++++++++++++++++++-
 arch/x86/mm/init.c               |  2 +-
 arch/x86/mm/kaslr.c              |  2 +-
 5 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index d7408af55738..ae4dce76a9bd 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -598,7 +598,7 @@ static unsigned long slots_fetch_random(void)
 	if (slot_max == 0)
 		return 0;
 
-	slot = kaslr_get_random_long("Physical") % slot_max;
+	slot = kaslr_get_random_seed("Physical") % slot_max;
 
 	for (i = 0; i < slot_area_index; i++) {
 		if (slot >= slot_areas[i].num) {
@@ -880,7 +880,7 @@ static unsigned long find_random_virt_addr(unsigned long minimum,
 	slots = (KERNEL_IMAGE_SIZE - minimum - image_size) /
 		 CONFIG_PHYSICAL_ALIGN + 1;
 
-	random_addr = kaslr_get_random_long("Virtual") % slots;
+	random_addr = kaslr_get_random_seed("Virtual") % slots;
 
 	return random_addr * CONFIG_PHYSICAL_ALIGN + minimum;
 }
diff --git a/arch/x86/include/asm/kaslr.h b/arch/x86/include/asm/kaslr.h
index db7ba2feb947..47d5b25e5b11 100644
--- a/arch/x86/include/asm/kaslr.h
+++ b/arch/x86/include/asm/kaslr.h
@@ -2,7 +2,8 @@
 #ifndef _ASM_KASLR_H_
 #define _ASM_KASLR_H_
 
-unsigned long kaslr_get_random_long(const char *purpose);
+unsigned long kaslr_get_random_seed(const char *purpose);
+unsigned long kaslr_get_prandom_long(void);
 
 #ifdef CONFIG_RANDOMIZE_MEMORY
 void kernel_randomize_memory(void);
diff --git a/arch/x86/lib/kaslr.c b/arch/x86/lib/kaslr.c
index 2b3eb8c948a3..41b5610855a3 100644
--- a/arch/x86/lib/kaslr.c
+++ b/arch/x86/lib/kaslr.c
@@ -46,7 +46,7 @@ static inline u16 i8254(void)
 	return timer;
 }
 
-unsigned long kaslr_get_random_long(const char *purpose)
+unsigned long kaslr_get_random_seed(const char *purpose)
 {
 #ifdef CONFIG_X86_64
 	const unsigned long mix_const = 0x5d6008cbf3848dd3UL;
@@ -96,3 +96,51 @@ unsigned long kaslr_get_random_long(const char *purpose)
 
 	return random;
 }
+
+/*
+ * 64bit variant of Bob Jenkins' public domain PRNG
+ * 256 bits of internal state
+ */
+struct prng_state {
+	u64 a, b, c, d;
+};
+
+static struct prng_state state;
+static bool initialized;
+
+#define rot(x, k) (((x)<<(k))|((x)>>(64-(k))))
+static u64 prng_u64(struct prng_state *x)
+{
+	u64 e;
+
+	e = x->a - rot(x->b, 7);
+	x->a = x->b ^ rot(x->c, 13);
+	x->b = x->c + rot(x->d, 37);
+	x->c = x->d + e;
+	x->d = e + x->a;
+
+	return x->d;
+}
+
+static void prng_init(struct prng_state *state)
+{
+	int i;
+
+	state->a = kaslr_get_random_seed(NULL);
+	state->b = kaslr_get_random_seed(NULL);
+	state->c = kaslr_get_random_seed(NULL);
+	state->d = kaslr_get_random_seed(NULL);
+
+	for (i = 0; i < 30; ++i)
+		(void)prng_u64(state);
+
+	initialized = true;
+}
+
+unsigned long kaslr_get_prandom_long(void)
+{
+	if (!initialized)
+		prng_init(&state);
+
+	return prng_u64(&state);
+}
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e7bb483557c9..c974dbab2293 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -722,7 +722,7 @@ void __init poking_init(void)
 	 */
 	poking_addr = TASK_UNMAPPED_BASE;
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE))
-		poking_addr += (kaslr_get_random_long("Poking") & PAGE_MASK) %
+		poking_addr += (kaslr_get_random_seed("Poking") & PAGE_MASK) %
 			(TASK_SIZE - TASK_UNMAPPED_BASE - 3 * PAGE_SIZE);
 
 	if (((poking_addr + PAGE_SIZE) & ~PMD_MASK) == 0)
diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index dc6182eecefa..b30bd1db7543 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -123,7 +123,7 @@ void __init kernel_randomize_memory(void)
 	for (i = 0; i < ARRAY_SIZE(kaslr_regions); i++)
 		remain_entropy -= get_padding(&kaslr_regions[i]);
 
-	prandom_seed_state(&rand_state, kaslr_get_random_long("Memory"));
+	prandom_seed_state(&rand_state, kaslr_get_random_seed("Memory"));
 
 	for (i = 0; i < ARRAY_SIZE(kaslr_regions); i++) {
 		unsigned long entropy;
-- 
2.24.1

