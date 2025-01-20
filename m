Return-Path: <kernel-hardening-return-21921-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 59BE3C02187
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2025 01:32:46 +0000 (UTC)
Received: (qmail 7431 invoked by uid 550); 20 Jan 2025 01:32:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7396 invoked from network); 20 Jan 2025 01:32:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=MBO0001; t=1737336744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=MURBR24qYXT3/f8sCeWQJ7YPDGGyUpvtE3SYqUTxqvQ=;
	b=h0drQtDovTBO7uHETN8Za+YBwL0zDszLnB+Z/77N6gARwCM/XRU3tn8ZdBPUotN0vpOzN2
	nKFySYL6Na3gd1lvvxUpMfbZU6rDRc6OYZ2ZGKQD0vAidNZpLFOm5SNb5YOU7kjGh+tbyq
	MGTncgPZjqBrPl0sspD9ssKicKo8u4akmFS/+dTUfkYhSdLNJp82Vj1PfsruXaHxvp55CM
	dMWjK3y9AREm0n15gF8tmHNyHxMn6rYq4erTD1CJGGQbJG3bKM9r6T6oP2aP/rcEw896d3
	mg6vYjLsLU9SS3vitUBb77Puv0v5Kytfm0y9h/ba3ya5aMIDLgT7HuCmYbCXbw==
Date: Sun, 19 Jan 2025 20:32:20 -0500
From: Ethan Carter Edwards <ethan@ethancedwards.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-sound@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	Takashi Iwai <tiwai@suse.com>
Subject: [PATCH] ASoC: q6dsp: q6apm: change kzalloc to kcalloc
Message-ID: <s6duijftssuzy34ilogc5ggfyukfqxmbflhllyzjlu4ki3xoo4@ci57esahvmxn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 4Ybt9z5g4Fz9sTM

We are replacing any instances of kzalloc(size * count, ...) with
kcalloc(count, size, ...) due to risk of overflow [1].

[1] https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
Link: https://github.com/KSPP/linux/issues/162

Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
---
 sound/soc/qcom/qdsp6/q6apm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/qcom/qdsp6/q6apm.c b/sound/soc/qcom/qdsp6/q6apm.c
index 2a2a5bd98110..11e252a70f69 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -230,7 +230,7 @@ int q6apm_map_memory_regions(struct q6apm_graph *graph, unsigned int dir, phys_a
 		return 0;
 	}
 
-	buf = kzalloc(((sizeof(struct audio_buffer)) * periods), GFP_KERNEL);
+	buf = kcalloc(periods, sizeof(struct audio_buffer), GFP_KERNEL);
 	if (!buf) {
 		mutex_unlock(&graph->lock);
 		return -ENOMEM;
-- 
2.48.0

