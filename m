Return-Path: <SRS0=EWXU=7G=lists.openwall.com=kernel-hardening-return-18867-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA4AC433E0
	for <kernel-hardening@archiver.kernel.org>; Sun, 24 May 2020 13:21:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9BBD9207FB
	for <kernel-hardening@archiver.kernel.org>; Sun, 24 May 2020 13:21:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=sakamocchi.jp header.i=@sakamocchi.jp header.b="gr4FhdZT";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="j5FslOyo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BBD9207FB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sakamocchi.jp
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18867-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12183 invoked by uid 550); 24 May 2020 13:21:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12136 invoked from network); 24 May 2020 13:21:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
	 h=from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=fm1; bh=yEdv+H/O/2SpAACnPzhE79bqt6
	6x66Jv2DzRgvNuqFE=; b=gr4FhdZT9B2d8PL1hXXtX31pGKZ+s2bspeBROp3yGA
	4ZOIUaU5+qAl6mM3OL4QIFuIUHpwdfS+/kznq1bntrC6OZae5NmsKIhSiJ4957QL
	OJUGEHk1BrEvp7OFQupBaXUoOor8XsM075aL9BTDK4syBfgUkRzQRvnhYjvDK90q
	KkNujPNi+oCVx/OYm1yvQaQ7n4K7gx3MyqnTQxbnd5Rw1UtfTFIa8no7CjCtM70B
	s3pFi/rcpN3zV9ONiWylcg/qT8cQwNb2BryHysBgTh2g0i9BS5f1RGvSWPSfHjRT
	hVfL/UvpRXDzRBZoldKooV8+YaPWGWIoHh+rh6XWI/Og==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yEdv+H/O/2SpAACnP
	zhE79bqt66x66Jv2DzRgvNuqFE=; b=j5FslOyoKitukg2O5+nqXbs4c2J1OriNp
	6z9+P6bN1C6pRIP5xypck0/yVbKGvbdLg8IyhCxWz5+QSShTnYNNCxDOQq5vFIvx
	tx7YcVuU2GhYwu+s6GkWCkKDtqCy32wxWexxYMvPVcofy+ERdxelb9MFJCHj+7/O
	YU856/JdWB/rbuF5Amjm4GyrQ7+i7SIPsBEfibujrzfDWqSjJYF6SjCDTjrX/j06
	3AFSQ+9/Re3mVPhgEBjiTPXiAyosUCI0Vn/KrpqJgjR0+H4QuPG6H3/xvDRcYc8G
	7bqrG+zDgowYev1a9uewB+/PUXvWOud/vWYXyTGS8bo7g53gwUgIQ==
X-ME-Sender: <xms:tHTKXooXFSArvjV9bqpiDAkd_1QcUbUEatRmSslPKBN7jFPSk76vpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddukedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhh
    ihesshgrkhgrmhhotggthhhirdhjpheqnecuggftrfgrthhtvghrnhepteeiuefhjeekke
    efheetieekvdegfefhgffgvdeiheehhfehiedvhffgjeejuddunecuffhomhgrihhnpehk
    vghrnhgvlhdrohhrghenucfkphepudektddrvdefhedrfedrheegnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhihesshgr
    khgrmhhotggthhhirdhjph
X-ME-Proxy: <xmx:tHTKXuodT0MBd3S5MHEf0lSJNoCPLiRV2Y6WpAUOJ_dnXO4-48khdA>
    <xmx:tHTKXtNQqDQTAnA7hK-r5Y-cMZZp-6zt4bCx7TLLMUO1OxLZyoipXg>
    <xmx:tHTKXv5nr2Ul_PYH-J0jmGkKhpCZnwsbm72BjrwYvZy_6nHQuZVA8w>
    <xmx:tnTKXq1XDYRbvGSCwk7J8p1RGjc9ICxDdi5skoxJ48Zk9RD1osY5bQ>
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
To: oscar.carter@gmx.com,
	keescook@chromium.org,
	greg@kroah.com,
	stefanr@s5r6.in-berlin.de
Cc: kernel-hardening@lists.openwall.com,
	linux1394-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	clemens@ladisch.de
Subject: [PATCH v2] firewire-core: remove cast of function callback
Date: Sun, 24 May 2020 22:20:48 +0900
Message-Id: <20200524132048.243223-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 1394 OHCI specification, Isochronous Receive DMA context has several
modes. One of mode is 'BufferFill' and Linux FireWire stack uses it to
receive isochronous packets for multiple isochronous channel as
FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL.

The mode is not used by in-kernel driver, while it's available for
userspace. The character device driver in firewire-core includes
cast of function callback for the mode since the type of callback
function is different from the other modes. The case is inconvenient
to effort of Control Flow Integrity builds due to
-Wcast-function-type warning.

This commit removes the cast. A inline helper function is newly added
to initialize isochronous context for the mode. The helper function
arranges isochronous context to assign specific callback function
after call of existent kernel API. It's noticeable that the number of
isochronous channel, speed, the size of header are not required for the
mode. The helper function is used for the mode by character device
driver instead of direct call of existent kernel API.

Changes in v2:
 - unexport helper function
 - use inline for helper function
 - arrange arguments for helper function
 - tested by libhinoko

Reported-by: Oscar Carter <oscar.carter@gmx.com>
Reference: https://lore.kernel.org/lkml/20200519173425.4724-1-oscar.carter@gmx.com/
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 drivers/firewire/core-cdev.c | 40 +++++++++++++++---------------------
 include/linux/firewire.h     | 16 +++++++++++++++
 2 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 6e291d8f3a27..7cbf6df34b43 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -957,7 +957,6 @@ static int ioctl_create_iso_context(struct client *client, union ioctl_arg *arg)
 {
 	struct fw_cdev_create_iso_context *a = &arg->create_iso_context;
 	struct fw_iso_context *context;
-	fw_iso_callback_t cb;
 	int ret;
 
 	BUILD_BUG_ON(FW_CDEV_ISO_CONTEXT_TRANSMIT != FW_ISO_CONTEXT_TRANSMIT ||
@@ -965,32 +964,27 @@ static int ioctl_create_iso_context(struct client *client, union ioctl_arg *arg)
 		     FW_CDEV_ISO_CONTEXT_RECEIVE_MULTICHANNEL !=
 					FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL);
 
-	switch (a->type) {
-	case FW_ISO_CONTEXT_TRANSMIT:
-		if (a->speed > SCODE_3200 || a->channel > 63)
-			return -EINVAL;
-
-		cb = iso_callback;
-		break;
-
-	case FW_ISO_CONTEXT_RECEIVE:
-		if (a->header_size < 4 || (a->header_size & 3) ||
-		    a->channel > 63)
-			return -EINVAL;
-
-		cb = iso_callback;
-		break;
-
-	case FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL:
-		cb = (fw_iso_callback_t)iso_mc_callback;
-		break;
+	if (a->type == FW_ISO_CONTEXT_TRANSMIT ||
+	    a->type == FW_ISO_CONTEXT_RECEIVE) {
+		if (a->type == FW_ISO_CONTEXT_TRANSMIT) {
+			if (a->speed > SCODE_3200 || a->channel > 63)
+				return -EINVAL;
+		} else {
+			if (a->header_size < 4 || (a->header_size & 3) ||
+			    a->channel > 63)
+				return -EINVAL;
+		}
 
-	default:
+		context = fw_iso_context_create(client->device->card, a->type,
+					a->channel, a->speed, a->header_size,
+					iso_callback, client);
+	} else if (a->type == FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL) {
+		context = fw_iso_mc_context_create(client->device->card,
+						   iso_mc_callback, client);
+	} else {
 		return -EINVAL;
 	}
 
-	context = fw_iso_context_create(client->device->card, a->type,
-			a->channel, a->speed, a->header_size, cb, client);
 	if (IS_ERR(context))
 		return PTR_ERR(context);
 	if (client->version < FW_CDEV_VERSION_AUTO_FLUSH_ISO_OVERFLOW)
diff --git a/include/linux/firewire.h b/include/linux/firewire.h
index aec8f30ab200..bff08118baaf 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -453,6 +453,22 @@ struct fw_iso_context {
 struct fw_iso_context *fw_iso_context_create(struct fw_card *card,
 		int type, int channel, int speed, size_t header_size,
 		fw_iso_callback_t callback, void *callback_data);
+
+static inline struct fw_iso_context *fw_iso_mc_context_create(
+						struct fw_card *card,
+						fw_iso_mc_callback_t callback,
+						void *callback_data)
+{
+	struct fw_iso_context *ctx;
+
+	ctx = fw_iso_context_create(card, FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL,
+				    0, 0, 0, NULL, callback_data);
+	if (!IS_ERR(ctx))
+		ctx->callback.mc = callback;
+
+	return ctx;
+}
+
 int fw_iso_context_set_channels(struct fw_iso_context *ctx, u64 *channels);
 int fw_iso_context_queue(struct fw_iso_context *ctx,
 			 struct fw_iso_packet *packet,
-- 
2.25.1

