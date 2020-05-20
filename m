Return-Path: <SRS0=jclx=7C=lists.openwall.com=kernel-hardening-return-18833-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E23C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 20 May 2020 06:48:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0DB9E205CB
	for <kernel-hardening@archiver.kernel.org>; Wed, 20 May 2020 06:48:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=sakamocchi.jp header.i=@sakamocchi.jp header.b="lbAvaMGU";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="mW2PZna9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DB9E205CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sakamocchi.jp
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18833-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31757 invoked by uid 550); 20 May 2020 06:47:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30651 invoked from network); 20 May 2020 06:47:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=0x5Q9TMW/pcKY
	WBvmhtdapFpEqLWfDSRp7i7zc3uhac=; b=lbAvaMGUu03zDg6XsB+E7tS/ZgFDS
	B9IW9lYWm1mPP35CksdGb8t8x6QtnpgQsBsAZglzJ8ALb23UQSzZcgEqHFM450GD
	QxTd5Iyk7sVkAGVrdy4xDkNa6Lr99YXYkuZiR3tAJyoACsXPfFndcRQtLgA5PxTy
	hYOT6t0zXZaLYNNc80LdkMFFjW/c4FK6/tClhlKckNlYXB3tkHXZD27MisR+Omy0
	F8aIOiBn/WhKTfdAnQvMATTv0K4iPZNtFv4IDOmbnOL42ItbXWFyO0rrXqSPSKtO
	6tE4FYdQFkyIkUdDiLgSnesGo1v9mPsEDdTubeAnBtc53GkdLGZYKjRPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=0x5Q9TMW/pcKYWBvmhtdapFpEqLWfDSRp7i7zc3uhac=; b=mW2PZna9
	P52SNXpQ4GT1sVkxxFVXYND/OrmTBBQsAAAgIL9iGW1SnOqlj+iL7D9ZuCji+SCk
	VX06hnTqqk9xbmVaXVcWDLfU17TkG7boVHkqcEoM2irzCcknwqeJnirg7lOd7WMn
	TWtGGnk+ivqzH9VDVVNcUPIBxH5aaxZAAwVyqDJqv6tx9QZvUBBD+HescazjOFSZ
	paLwV3snjUqBgIetXUnO+0RocXKBCGvoBEpinWDpzyjUMXq7HDLqMaIsFXOq1DSn
	EvGxEOqcNg56oaWF45WQsw7q7u4DjpIGoEBUiAczGcyQguUIlXFc+Cl5/+BRASXQ
	ulx3SZeF+1HXxw==
X-ME-Sender: <xms:idLEXpgzOGWeZyZRSIivUMEEDbBal43yeAVVInaoqjg31e7JrFRKNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtkedguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefvrghkrghshhhiucfurghkrghmohhtohcuoehoqdhtrghk
    rghshhhisehsrghkrghmohgttghhihdrjhhpqeenucggtffrrghtthgvrhhnpeduuefffe
    eiteeludevieetgeeiueelfeeifffhheetveeiveelfeetheeuhfektdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppedukedtrddvfeehrdefrdehgeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehoqdhtrghkrghshhhi
    sehsrghkrghmohgttghhihdrjhhp
X-ME-Proxy: <xmx:idLEXuCjXj_Lee-SQyRtkYRmn9Ac6gEZkXb-kFovtUnXqpuK60s8Sw>
    <xmx:idLEXpFeZ0z21DI0kinkZOuCVhN3ZePb4rS9TBApRO3D3b0YvbVi5A>
    <xmx:idLEXuT1iJf6XmzAhAmA8bggY1V0FQWQ-Im9qPPV0OMCOszpqIQqqg>
    <xmx:idLEXqdXF5To2ccakZPDISGatrzHmWIIEhrQ8CPoJGGxKfrkXB2JGHnh-qA>
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
To: oscar.carter@gmx.com,
	keescook@chromium.org,
	mchehab@kernel.org,
	clemens@ladisch.de,
	tiwai@suse.de,
	perex@perex.cz
Cc: kernel-hardening@lists.openwall.com,
	linux1394-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	levonshe@gmail.com,
	alsa-devel@alsa-project.org,
	stefanr@s5r6.in-berlin.de
Subject: [PATCH 2/2] firewire-core: obsolete cast of function callback
Date: Wed, 20 May 2020 15:47:26 +0900
Message-Id: <20200520064726.31838-3-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200520064726.31838-1-o-takashi@sakamocchi.jp>
References: <20200520064726.31838-1-o-takashi@sakamocchi.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit obsoletes cast of function callback to assist attempt of
Control Flow Integrity builds.

Reported-by: Oscar Carter <oscar.carter@gmx.com>
Reference: https://lore.kernel.org/lkml/20200519173425.4724-1-oscar.carter@gmx.com/
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 drivers/firewire/core-cdev.c | 44 +++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 6e291d8f3a27..f1e83396dd22 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -957,7 +957,6 @@ static int ioctl_create_iso_context(struct client *client, union ioctl_arg *arg)
 {
 	struct fw_cdev_create_iso_context *a = &arg->create_iso_context;
 	struct fw_iso_context *context;
-	fw_iso_callback_t cb;
 	int ret;
 
 	BUILD_BUG_ON(FW_CDEV_ISO_CONTEXT_TRANSMIT != FW_ISO_CONTEXT_TRANSMIT ||
@@ -965,32 +964,35 @@ static int ioctl_create_iso_context(struct client *client, union ioctl_arg *arg)
 		     FW_CDEV_ISO_CONTEXT_RECEIVE_MULTICHANNEL !=
 					FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL);
 
-	switch (a->type) {
-	case FW_ISO_CONTEXT_TRANSMIT:
-		if (a->speed > SCODE_3200 || a->channel > 63)
-			return -EINVAL;
-
-		cb = iso_callback;
-		break;
+	if (a->type != FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL) {
+		fw_iso_callback_t cb;
 
-	case FW_ISO_CONTEXT_RECEIVE:
-		if (a->header_size < 4 || (a->header_size & 3) ||
-		    a->channel > 63)
-			return -EINVAL;
+		switch (a->type) {
+		case FW_ISO_CONTEXT_TRANSMIT:
+			if (a->speed > SCODE_3200 || a->channel > 63)
+				return -EINVAL;
 
-		cb = iso_callback;
-		break;
+			cb = iso_callback;
+			break;
 
-	case FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL:
-		cb = (fw_iso_callback_t)iso_mc_callback;
-		break;
+		case FW_ISO_CONTEXT_RECEIVE:
+			if (a->header_size < 4 || (a->header_size & 3) ||
+			    a->channel > 63)
+				return -EINVAL;
 
-	default:
-		return -EINVAL;
-	}
+			cb = iso_callback;
+			break;
+		default:
+			return -EINVAL;
+		}
 
-	context = fw_iso_context_create(client->device->card, a->type,
+		context = fw_iso_context_create(client->device->card, a->type,
 			a->channel, a->speed, a->header_size, cb, client);
+	} else {
+		context = fw_iso_mc_context_create(client->device->card,
+				a->type, a->channel, a->speed, a->header_size,
+				iso_mc_callback, client);
+	}
 	if (IS_ERR(context))
 		return PTR_ERR(context);
 	if (client->version < FW_CDEV_VERSION_AUTO_FLUSH_ISO_OVERFLOW)
-- 
2.25.1

