Return-Path: <SRS0=XVQN=ZH=lists.openwall.com=kernel-hardening-return-17366-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E908C432C3
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 05:30:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9F8AD20729
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 05:30:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="S2TBHmiX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F8AD20729
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17366-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32599 invoked by uid 550); 15 Nov 2019 05:29:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32382 invoked from network); 15 Nov 2019 05:29:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZchL8g0OYzmNZ1oDXGo2WqPGV2bdTUUMyrmDfLdFGw8=;
        b=S2TBHmiXjhSKr2HK3f+nMKOREnXuVHS0voav4IxRqoek1aPRK+Qhc5hnB3ZR1Z9jor
         i4YvAZV4B4RxlZqQqrDhmvmEY2fBmgRsYjTgifoW5Loy0IzEpkX5ZbVWN017OeFnQtB5
         AfhBVQoc7MsiOj6lHhUYiTM38WPAOXjlfzznA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZchL8g0OYzmNZ1oDXGo2WqPGV2bdTUUMyrmDfLdFGw8=;
        b=O+IUa/VMPUdopeywUFzv/2WHacaLAUZ2FdyEPbvejaqOzVPDzqefjenVkq495op5p5
         GjDqhKs16Ubt4m8Mqs8JW7ebvK1wbH7vSdGCy/P37r0mm8avfv0NWp8mIFNl60E95XMM
         hbiwApGLRjRGViANMQqxJk06VylL/KR2/ksaLw3tkH9artAmzwDIl1GPgh5UT/0U3gvT
         7bPv8u4BfRPM32NvziN9Db/Jxev68oGzEYksg+HIUovdBet+QEubfiZSfBRxobZbNevX
         E4hs+RvXBf0WUj3vaqRlNHQ9Qpg85vwvfG2Yh1+x3gY1Msdq0V0jITp5NkluP8DfGfyc
         6+hQ==
X-Gm-Message-State: APjAAAUQabMprbJ04EvVhRA8IfbWp2XQdsUmCYGQmc5vqCQj44tqxb3L
	8OQx5xny80iUKRXJuw6EhBb9dA==
X-Google-Smtp-Source: APXvYqxSkmTUYM8d2QJ9A2A5kmvLinYimI02VllIF2GhtID9UfB1dkaLDWXW234Pk6SvPinztoX6hA==
X-Received: by 2002:a17:90a:a40f:: with SMTP id y15mr17680436pjp.106.1573795781824;
        Thu, 14 Nov 2019 21:29:41 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: Kees Cook <keescook@chromium.org>,
	Ariel Elior <aelior@marvell.com>,
	Sudarsana Kalluru <skalluru@marvell.com>,
	GR-everest-linux-l2@marvell.com,
	Sami Tolvanen <samitolvanen@google.com>,
	netdev@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] bnx2x: Remove read_status_t function casts
Date: Thu, 14 Nov 2019 21:07:12 -0800
Message-Id: <20191115050715.6247-3-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115050715.6247-1-keescook@chromium.org>
References: <20191115050715.6247-1-keescook@chromium.org>

The function casts for .read_status callbacks end up casting some int
return values to u8. This seems to be bug-prone (-EINVAL being returned
into something that appears to be true/false), but fixing the function
prototypes doesn't change the existing behavior. Fix the return values
to remove the casts.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 .../net/ethernet/broadcom/bnx2x/bnx2x_link.c  | 44 +++++++++----------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
index decde193c5b3..a124f1e0819f 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -5611,9 +5611,9 @@ static int bnx2x_get_link_speed_duplex(struct bnx2x_phy *phy,
 	return 0;
 }
 
-static int bnx2x_link_settings_status(struct bnx2x_phy *phy,
-				      struct link_params *params,
-				      struct link_vars *vars)
+static u8 bnx2x_link_settings_status(struct bnx2x_phy *phy,
+				     struct link_params *params,
+				     struct link_vars *vars)
 {
 	struct bnx2x *bp = params->bp;
 
@@ -5685,7 +5685,7 @@ static int bnx2x_link_settings_status(struct bnx2x_phy *phy,
 	return rc;
 }
 
-static int bnx2x_warpcore_read_status(struct bnx2x_phy *phy,
+static u8 bnx2x_warpcore_read_status(struct bnx2x_phy *phy,
 				     struct link_params *params,
 				     struct link_vars *vars)
 {
@@ -8993,9 +8993,9 @@ static u8 bnx2x_8706_config_init(struct bnx2x_phy *phy,
 	return 0;
 }
 
-static int bnx2x_8706_read_status(struct bnx2x_phy *phy,
-				  struct link_params *params,
-				  struct link_vars *vars)
+static u8 bnx2x_8706_read_status(struct bnx2x_phy *phy,
+				 struct link_params *params,
+				 struct link_vars *vars)
 {
 	return bnx2x_8706_8726_read_status(phy, params, vars);
 }
@@ -11672,7 +11672,7 @@ static const struct bnx2x_phy phy_serdes = {
 	.req_duplex	= 0,
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_xgxs_config_init,
-	.read_status	= (read_status_t)bnx2x_link_settings_status,
+	.read_status	= bnx2x_link_settings_status,
 	.link_reset	= bnx2x_int_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= NULL,
@@ -11708,7 +11708,7 @@ static const struct bnx2x_phy phy_xgxs = {
 	.req_duplex	= 0,
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_xgxs_config_init,
-	.read_status	= (read_status_t)bnx2x_link_settings_status,
+	.read_status	= bnx2x_link_settings_status,
 	.link_reset	= bnx2x_int_link_reset,
 	.config_loopback = bnx2x_set_xgxs_loopback,
 	.format_fw_ver	= NULL,
@@ -11746,7 +11746,7 @@ static const struct bnx2x_phy phy_warpcore = {
 	/* req_duplex = */0,
 	/* rsrv = */0,
 	.config_init	= (config_init_t)bnx2x_warpcore_config_init,
-	.read_status	= (read_status_t)bnx2x_warpcore_read_status,
+	.read_status	= bnx2x_warpcore_read_status,
 	.link_reset	= bnx2x_warpcore_link_reset,
 	.config_loopback = bnx2x_set_warpcore_loopback,
 	.format_fw_ver	= NULL,
@@ -11777,7 +11777,7 @@ static const struct bnx2x_phy phy_7101 = {
 	.req_duplex	= 0,
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_7101_config_init,
-	.read_status	= (read_status_t)bnx2x_7101_read_status,
+	.read_status	= bnx2x_7101_read_status,
 	.link_reset	= bnx2x_common_ext_link_reset,
 	.config_loopback = bnx2x_7101_config_loopback,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_7101_format_ver,
@@ -11808,7 +11808,7 @@ static const struct bnx2x_phy phy_8073 = {
 	.req_duplex	= 0,
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_8073_config_init,
-	.read_status	= (read_status_t)bnx2x_8073_read_status,
+	.read_status	= bnx2x_8073_read_status,
 	.link_reset	= bnx2x_8073_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_format_ver,
@@ -11836,7 +11836,7 @@ static const struct bnx2x_phy phy_8705 = {
 	.req_duplex	= 0,
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_8705_config_init,
-	.read_status	= (read_status_t)bnx2x_8705_read_status,
+	.read_status	= bnx2x_8705_read_status,
 	.link_reset	= bnx2x_common_ext_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_null_format_ver,
@@ -11865,7 +11865,7 @@ static const struct bnx2x_phy phy_8706 = {
 	.req_duplex	= 0,
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_8706_config_init,
-	.read_status	= (read_status_t)bnx2x_8706_read_status,
+	.read_status	= bnx2x_8706_read_status,
 	.link_reset	= bnx2x_common_ext_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_format_ver,
@@ -11897,7 +11897,7 @@ static const struct bnx2x_phy phy_8726 = {
 	.req_duplex	= 0,
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_8726_config_init,
-	.read_status	= (read_status_t)bnx2x_8726_read_status,
+	.read_status	= bnx2x_8726_read_status,
 	.link_reset	= bnx2x_8726_link_reset,
 	.config_loopback = bnx2x_8726_config_loopback,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_format_ver,
@@ -11928,7 +11928,7 @@ static const struct bnx2x_phy phy_8727 = {
 	.req_duplex	= 0,
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_8727_config_init,
-	.read_status	= (read_status_t)bnx2x_8727_read_status,
+	.read_status	= bnx2x_8727_read_status,
 	.link_reset	= bnx2x_8727_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_format_ver,
@@ -11963,7 +11963,7 @@ static const struct bnx2x_phy phy_8481 = {
 	.req_duplex	= 0,
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_8481_config_init,
-	.read_status	= (read_status_t)bnx2x_848xx_read_status,
+	.read_status	= bnx2x_848xx_read_status,
 	.link_reset	= bnx2x_8481_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_848xx_format_ver,
@@ -12000,7 +12000,7 @@ static const struct bnx2x_phy phy_84823 = {
 	.req_duplex	= 0,
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_848x3_config_init,
-	.read_status	= (read_status_t)bnx2x_848xx_read_status,
+	.read_status	= bnx2x_848xx_read_status,
 	.link_reset	= bnx2x_848x3_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_848xx_format_ver,
@@ -12035,7 +12035,7 @@ static const struct bnx2x_phy phy_84833 = {
 	.req_duplex	= 0,
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_848x3_config_init,
-	.read_status	= (read_status_t)bnx2x_848xx_read_status,
+	.read_status	= bnx2x_848xx_read_status,
 	.link_reset	= bnx2x_848x3_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_848xx_format_ver,
@@ -12069,7 +12069,7 @@ static const struct bnx2x_phy phy_84834 = {
 	.req_duplex	= 0,
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_848x3_config_init,
-	.read_status	= (read_status_t)bnx2x_848xx_read_status,
+	.read_status	= bnx2x_848xx_read_status,
 	.link_reset	= bnx2x_848x3_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_848xx_format_ver,
@@ -12103,7 +12103,7 @@ static const struct bnx2x_phy phy_84858 = {
 	.req_duplex	= 0,
 	.rsrv		= 0,
 	.config_init	= (config_init_t)bnx2x_848x3_config_init,
-	.read_status	= (read_status_t)bnx2x_848xx_read_status,
+	.read_status	= bnx2x_848xx_read_status,
 	.link_reset	= bnx2x_848x3_link_reset,
 	.config_loopback = NULL,
 	.format_fw_ver	= (format_fw_ver_t)bnx2x_8485x_format_ver,
@@ -12137,7 +12137,7 @@ static const struct bnx2x_phy phy_54618se = {
 	/* req_duplex = */0,
 	/* rsrv = */0,
 	.config_init	= (config_init_t)bnx2x_54618se_config_init,
-	.read_status	= (read_status_t)bnx2x_54618se_read_status,
+	.read_status	= bnx2x_54618se_read_status,
 	.link_reset	= bnx2x_54618se_link_reset,
 	.config_loopback = bnx2x_54618se_config_loopback,
 	.format_fw_ver	= NULL,
-- 
2.17.1

