Return-Path: <SRS0=KaFh=ZH=lists.openwall.com=kernel-hardening-return-17365-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D5FC43215
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 05:30:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4FD0C20729
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 05:30:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="P8s4lKr1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FD0C20729
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17365-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32552 invoked by uid 550); 15 Nov 2019 05:29:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32353 invoked from network); 15 Nov 2019 05:29:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YDYkBjkBbQkNa38peIYhjMIM9N8dktFnNdPZLlA0nKk=;
        b=P8s4lKr1FHUjSOA9qtcrBCw2j3pk9mrJbqYVOeH0lHfzfxEcg/qwJO1S7hpheqZ5o/
         CQGjps6xVqlJG8S1WVRn/Ir3zTgaEAtWufvcp4IoRKLt76DzEerDAOeQwHXfMa8/2vM6
         j8wbeNHMrvl4sVFspE6fRs3XCVG5xwfhJ6vn4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YDYkBjkBbQkNa38peIYhjMIM9N8dktFnNdPZLlA0nKk=;
        b=sesrY1K+DOVqUhKU7TAWYk0HGgIIUTKg3uq1omqH8tq0AI05TaT/cGoQh9WDRxPOtg
         s8N0orOgNeEn+OxMBX83AP50uj2CVi7CQUT2Urn7FS+HjD5YV61JwW7osYmEZBS72PO7
         eoqVHuJInhT1kvXxKZYcDV1gSgHvwiMuOYznhEsaRIJQLoGtWTivQVR0ZzihKpZ6/TjY
         impBV8BZs0rHxRTBfssC53o6J9iGrw1bRIKP7oxsKNQGa42vWIarI1rGjJj1HCzrGFFX
         9V6ivwZY9Sn+WmadJPLy9UbCdlJ/XG47+DDt7aFZbRan6wTd7ZrzUu3v3Ac7o95RlYkP
         8Oig==
X-Gm-Message-State: APjAAAXOlbqUDff8G5xBELBHey0HxXvojRbkOKIkNdBkKXTbYscoMegy
	XUy0YCF2l3RiEifTCaGbMh3COw==
X-Google-Smtp-Source: APXvYqx49Q0Jm9xTH248nnIbpLRKsCPTF72sZcIdUnH9MX89f02/Kw+ZPyG/obFrenhJVQUQvldPOw==
X-Received: by 2002:a63:3f4e:: with SMTP id m75mr5090958pga.392.1573795780689;
        Thu, 14 Nov 2019 21:29:40 -0800 (PST)
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
Subject: [PATCH 3/5] bnx2x: Remove config_init_t function casts
Date: Thu, 14 Nov 2019 21:07:13 -0800
Message-Id: <20191115050715.6247-4-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115050715.6247-1-keescook@chromium.org>
References: <20191115050715.6247-1-keescook@chromium.org>

No callers of .config_init check return values. Remove the casting and
change all callbacks to have the correct function prototype.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 .../net/ethernet/broadcom/bnx2x/bnx2x_link.c  | 105 ++++++++----------
 .../net/ethernet/broadcom/bnx2x/bnx2x_link.h  |   4 +-
 2 files changed, 48 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
index a124f1e0819f..2bc6408ce00d 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -7364,9 +7364,9 @@ static void bnx2x_8073_specific_func(struct bnx2x_phy *phy,
 	}
 }
 
-static int bnx2x_8073_config_init(struct bnx2x_phy *phy,
-				  struct link_params *params,
-				  struct link_vars *vars)
+static void bnx2x_8073_config_init(struct bnx2x_phy *phy,
+				   struct link_params *params,
+				   struct link_vars *vars)
 {
 	struct bnx2x *bp = params->bp;
 	u16 val = 0, tmp1;
@@ -7427,7 +7427,7 @@ static int bnx2x_8073_config_init(struct bnx2x_phy *phy,
 	if (params->loopback_mode == LOOPBACK_EXT) {
 		bnx2x_807x_force_10G(bp, phy);
 		DP(NETIF_MSG_LINK, "Forced speed 10G on 807X\n");
-		return 0;
+		return;
 	} else {
 		bnx2x_cl45_write(bp, phy,
 				 MDIO_PMA_DEVAD, MDIO_PMA_REG_BCM_CTRL, 0x0002);
@@ -7509,7 +7509,6 @@ static int bnx2x_8073_config_init(struct bnx2x_phy *phy,
 	bnx2x_cl45_write(bp, phy, MDIO_AN_DEVAD, MDIO_AN_REG_CTRL, 0x1200);
 	DP(NETIF_MSG_LINK, "807x Autoneg Restart: Advertise 1G=%x, 10G=%x\n",
 		   ((val & (1<<5)) > 0), ((val & (1<<7)) > 0));
-	return 0;
 }
 
 static u8 bnx2x_8073_read_status(struct bnx2x_phy *phy,
@@ -7676,9 +7675,9 @@ static void bnx2x_8073_link_reset(struct bnx2x_phy *phy,
 /******************************************************************/
 /*			BCM8705 PHY SECTION			  */
 /******************************************************************/
-static int bnx2x_8705_config_init(struct bnx2x_phy *phy,
-				  struct link_params *params,
-				  struct link_vars *vars)
+static void bnx2x_8705_config_init(struct bnx2x_phy *phy,
+				   struct link_params *params,
+				   struct link_vars *vars)
 {
 	struct bnx2x *bp = params->bp;
 	DP(NETIF_MSG_LINK, "init 8705\n");
@@ -7700,7 +7699,6 @@ static int bnx2x_8705_config_init(struct bnx2x_phy *phy,
 			 MDIO_WIS_DEVAD, MDIO_WIS_REG_LASI_CNTL, 0x1);
 	/* BCM8705 doesn't have microcode, hence the 0 */
 	bnx2x_save_spirom_version(bp, params->port, params->shmem_base, 0);
-	return 0;
 }
 
 static u8 bnx2x_8705_read_status(struct bnx2x_phy *phy,
@@ -8887,9 +8885,9 @@ static u8 bnx2x_8706_8726_read_status(struct bnx2x_phy *phy,
 /******************************************************************/
 /*			BCM8706 PHY SECTION			  */
 /******************************************************************/
-static u8 bnx2x_8706_config_init(struct bnx2x_phy *phy,
-				 struct link_params *params,
-				 struct link_vars *vars)
+static void bnx2x_8706_config_init(struct bnx2x_phy *phy,
+				   struct link_params *params,
+				   struct link_vars *vars)
 {
 	u32 tx_en_mode;
 	u16 cnt, val, tmp1;
@@ -8989,8 +8987,6 @@ static u8 bnx2x_8706_config_init(struct bnx2x_phy *phy,
 		bnx2x_cl45_write(bp, phy,
 			MDIO_PMA_DEVAD, MDIO_PMA_REG_DIGITAL_CTRL, tmp1);
 	}
-
-	return 0;
 }
 
 static u8 bnx2x_8706_read_status(struct bnx2x_phy *phy,
@@ -9070,9 +9066,9 @@ static u8 bnx2x_8726_read_status(struct bnx2x_phy *phy,
 }
 
 
-static int bnx2x_8726_config_init(struct bnx2x_phy *phy,
-				  struct link_params *params,
-				  struct link_vars *vars)
+static void bnx2x_8726_config_init(struct bnx2x_phy *phy,
+				   struct link_params *params,
+				   struct link_vars *vars)
 {
 	struct bnx2x *bp = params->bp;
 	DP(NETIF_MSG_LINK, "Initializing BCM8726\n");
@@ -9150,9 +9146,6 @@ static int bnx2x_8726_config_init(struct bnx2x_phy *phy,
 				 MDIO_PMA_REG_8726_TX_CTRL2,
 				 phy->tx_preemphasis[1]);
 	}
-
-	return 0;
-
 }
 
 static void bnx2x_8726_link_reset(struct bnx2x_phy *phy,
@@ -9288,9 +9281,9 @@ static void bnx2x_8727_config_speed(struct bnx2x_phy *phy,
 	}
 }
 
-static int bnx2x_8727_config_init(struct bnx2x_phy *phy,
-				  struct link_params *params,
-				  struct link_vars *vars)
+static void bnx2x_8727_config_init(struct bnx2x_phy *phy,
+				   struct link_params *params,
+				   struct link_vars *vars)
 {
 	u32 tx_en_mode;
 	u16 tmp1, mod_abs, tmp2;
@@ -9370,8 +9363,6 @@ static int bnx2x_8727_config_init(struct bnx2x_phy *phy,
 				 MDIO_PMA_DEVAD, MDIO_PMA_REG_PHY_IDENTIFIER,
 				 (tmp2 & 0x7fff));
 	}
-
-	return 0;
 }
 
 static void bnx2x_8727_handle_mod_abs(struct bnx2x_phy *phy,
@@ -9946,9 +9937,9 @@ static int bnx2x_848xx_cmn_config_init(struct bnx2x_phy *phy,
 	return 0;
 }
 
-static int bnx2x_8481_config_init(struct bnx2x_phy *phy,
-				  struct link_params *params,
-				  struct link_vars *vars)
+static void bnx2x_8481_config_init(struct bnx2x_phy *phy,
+				   struct link_params *params,
+				   struct link_vars *vars)
 {
 	struct bnx2x *bp = params->bp;
 	/* Restore normal power mode*/
@@ -9960,7 +9951,7 @@ static int bnx2x_8481_config_init(struct bnx2x_phy *phy,
 	bnx2x_wait_reset_complete(bp, phy, params);
 
 	bnx2x_cl45_write(bp, phy, MDIO_PMA_DEVAD, MDIO_PMA_REG_CTRL, 1<<15);
-	return bnx2x_848xx_cmn_config_init(phy, params, vars);
+	bnx2x_848xx_cmn_config_init(phy, params, vars);
 }
 
 #define PHY848xx_CMDHDLR_WAIT 300
@@ -10283,9 +10274,9 @@ static int bnx2x_8483x_enable_eee(struct bnx2x_phy *phy,
 }
 
 #define PHY84833_CONSTANT_LATENCY 1193
-static int bnx2x_848x3_config_init(struct bnx2x_phy *phy,
-				   struct link_params *params,
-				   struct link_vars *vars)
+static void bnx2x_848x3_config_init(struct bnx2x_phy *phy,
+				    struct link_params *params,
+				    struct link_vars *vars)
 {
 	struct bnx2x *bp = params->bp;
 	u8 port, initialize = 1;
@@ -10430,7 +10421,7 @@ static int bnx2x_848x3_config_init(struct bnx2x_phy *phy,
 		if (rc) {
 			DP(NETIF_MSG_LINK, "Failed to configure EEE timers\n");
 			bnx2x_8483x_disable_eee(phy, params, vars);
-			return rc;
+			return;
 		}
 
 		if ((phy->req_duplex == DUPLEX_FULL) &&
@@ -10442,7 +10433,7 @@ static int bnx2x_848x3_config_init(struct bnx2x_phy *phy,
 			rc = bnx2x_8483x_disable_eee(phy, params, vars);
 		if (rc) {
 			DP(NETIF_MSG_LINK, "Failed to set EEE advertisement\n");
-			return rc;
+			return;
 		}
 	} else {
 		vars->eee_status &= ~SHMEM_EEE_SUPPORTED_MASK;
@@ -10481,7 +10472,6 @@ static int bnx2x_848x3_config_init(struct bnx2x_phy *phy,
 					  MDIO_84833_TOP_CFG_XGPHY_STRAP1,
 					  (u16)~MDIO_84833_SUPER_ISOLATE);
 	}
-	return rc;
 }
 
 static u8 bnx2x_848xx_read_status(struct bnx2x_phy *phy,
@@ -11038,9 +11028,9 @@ static void bnx2x_54618se_specific_func(struct bnx2x_phy *phy,
 	}
 }
 
-static int bnx2x_54618se_config_init(struct bnx2x_phy *phy,
-					       struct link_params *params,
-					       struct link_vars *vars)
+static void bnx2x_54618se_config_init(struct bnx2x_phy *phy,
+				      struct link_params *params,
+				      struct link_vars *vars)
 {
 	struct bnx2x *bp = params->bp;
 	u8 port;
@@ -11240,8 +11230,6 @@ static int bnx2x_54618se_config_init(struct bnx2x_phy *phy,
 
 	bnx2x_cl22_write(bp, phy,
 			MDIO_PMA_REG_CTRL, autoneg_val);
-
-	return 0;
 }
 
 
@@ -11465,9 +11453,9 @@ static void bnx2x_7101_config_loopback(struct bnx2x_phy *phy,
 			 MDIO_XS_DEVAD, MDIO_XS_SFX7101_XGXS_TEST1, 0x100);
 }
 
-static int bnx2x_7101_config_init(struct bnx2x_phy *phy,
-				  struct link_params *params,
-				  struct link_vars *vars)
+static void bnx2x_7101_config_init(struct bnx2x_phy *phy,
+				   struct link_params *params,
+				   struct link_vars *vars)
 {
 	u16 fw_ver1, fw_ver2, val;
 	struct bnx2x *bp = params->bp;
@@ -11502,7 +11490,6 @@ static int bnx2x_7101_config_init(struct bnx2x_phy *phy,
 			MDIO_PMA_DEVAD, MDIO_PMA_REG_7101_VER2, &fw_ver2);
 	bnx2x_save_spirom_version(bp, params->port,
 				  (u32)(fw_ver1<<16 | fw_ver2), phy->ver_addr);
-	return 0;
 }
 
 static u8 bnx2x_7101_read_status(struct bnx2x_phy *phy,
@@ -11671,7 +11658,7 @@ static const struct bnx2x_phy phy_serdes = {
 	.speed_cap_mask	= 0,
 	.req_duplex	= 0,
 	.rsrv		= 0,
-	.config_init	= (config_init_t)bnx2x_xgxs_config_init,
+	.config_init	= bnx2x_xgxs_config_init,
 	.read_status	= bnx2x_link_settings_status,
 	.link_reset	= bnx2x_int_link_reset,
 	.config_loopback = NULL,
@@ -11707,7 +11694,7 @@ static const struct bnx2x_phy phy_xgxs = {
 	.speed_cap_mask	= 0,
 	.req_duplex	= 0,
 	.rsrv		= 0,
-	.config_init	= (config_init_t)bnx2x_xgxs_config_init,
+	.config_init	= bnx2x_xgxs_config_init,
 	.read_status	= bnx2x_link_settings_status,
 	.link_reset	= bnx2x_int_link_reset,
 	.config_loopback = bnx2x_set_xgxs_loopback,
@@ -11745,7 +11732,7 @@ static const struct bnx2x_phy phy_warpcore = {
 	.speed_cap_mask	= 0,
 	/* req_duplex = */0,
 	/* rsrv = */0,
-	.config_init	= (config_init_t)bnx2x_warpcore_config_init,
+	.config_init	= bnx2x_warpcore_config_init,
 	.read_status	= bnx2x_warpcore_read_status,
 	.link_reset	= bnx2x_warpcore_link_reset,
 	.config_loopback = bnx2x_set_warpcore_loopback,
@@ -11776,7 +11763,7 @@ static const struct bnx2x_phy phy_7101 = {
 	.speed_cap_mask	= 0,
 	.req_duplex	= 0,
 	.rsrv		= 0,
-	.config_init	= (config_init_t)bnx2x_7101_config_init,
+	.config_init	= bnx2x_7101_config_init,
 	.read_status	= bnx2x_7101_read_status,
 	.link_reset	= bnx2x_common_ext_link_reset,
 	.config_loopback = bnx2x_7101_config_loopback,
@@ -11807,7 +11794,7 @@ static const struct bnx2x_phy phy_8073 = {
 	.speed_cap_mask	= 0,
 	.req_duplex	= 0,
 	.rsrv		= 0,
-	.config_init	= (config_init_t)bnx2x_8073_config_init,
+	.config_init	= bnx2x_8073_config_init,
 	.read_status	= bnx2x_8073_read_status,
 	.link_reset	= bnx2x_8073_link_reset,
 	.config_loopback = NULL,
@@ -11835,7 +11822,7 @@ static const struct bnx2x_phy phy_8705 = {
 	.speed_cap_mask	= 0,
 	.req_duplex	= 0,
 	.rsrv		= 0,
-	.config_init	= (config_init_t)bnx2x_8705_config_init,
+	.config_init	= bnx2x_8705_config_init,
 	.read_status	= bnx2x_8705_read_status,
 	.link_reset	= bnx2x_common_ext_link_reset,
 	.config_loopback = NULL,
@@ -11864,7 +11851,7 @@ static const struct bnx2x_phy phy_8706 = {
 	.speed_cap_mask	= 0,
 	.req_duplex	= 0,
 	.rsrv		= 0,
-	.config_init	= (config_init_t)bnx2x_8706_config_init,
+	.config_init	= bnx2x_8706_config_init,
 	.read_status	= bnx2x_8706_read_status,
 	.link_reset	= bnx2x_common_ext_link_reset,
 	.config_loopback = NULL,
@@ -11896,7 +11883,7 @@ static const struct bnx2x_phy phy_8726 = {
 	.speed_cap_mask	= 0,
 	.req_duplex	= 0,
 	.rsrv		= 0,
-	.config_init	= (config_init_t)bnx2x_8726_config_init,
+	.config_init	= bnx2x_8726_config_init,
 	.read_status	= bnx2x_8726_read_status,
 	.link_reset	= bnx2x_8726_link_reset,
 	.config_loopback = bnx2x_8726_config_loopback,
@@ -11927,7 +11914,7 @@ static const struct bnx2x_phy phy_8727 = {
 	.speed_cap_mask	= 0,
 	.req_duplex	= 0,
 	.rsrv		= 0,
-	.config_init	= (config_init_t)bnx2x_8727_config_init,
+	.config_init	= bnx2x_8727_config_init,
 	.read_status	= bnx2x_8727_read_status,
 	.link_reset	= bnx2x_8727_link_reset,
 	.config_loopback = NULL,
@@ -11962,7 +11949,7 @@ static const struct bnx2x_phy phy_8481 = {
 	.speed_cap_mask	= 0,
 	.req_duplex	= 0,
 	.rsrv		= 0,
-	.config_init	= (config_init_t)bnx2x_8481_config_init,
+	.config_init	= bnx2x_8481_config_init,
 	.read_status	= bnx2x_848xx_read_status,
 	.link_reset	= bnx2x_8481_link_reset,
 	.config_loopback = NULL,
@@ -11999,7 +11986,7 @@ static const struct bnx2x_phy phy_84823 = {
 	.speed_cap_mask	= 0,
 	.req_duplex	= 0,
 	.rsrv		= 0,
-	.config_init	= (config_init_t)bnx2x_848x3_config_init,
+	.config_init	= bnx2x_848x3_config_init,
 	.read_status	= bnx2x_848xx_read_status,
 	.link_reset	= bnx2x_848x3_link_reset,
 	.config_loopback = NULL,
@@ -12034,7 +12021,7 @@ static const struct bnx2x_phy phy_84833 = {
 	.speed_cap_mask	= 0,
 	.req_duplex	= 0,
 	.rsrv		= 0,
-	.config_init	= (config_init_t)bnx2x_848x3_config_init,
+	.config_init	= bnx2x_848x3_config_init,
 	.read_status	= bnx2x_848xx_read_status,
 	.link_reset	= bnx2x_848x3_link_reset,
 	.config_loopback = NULL,
@@ -12068,7 +12055,7 @@ static const struct bnx2x_phy phy_84834 = {
 	.speed_cap_mask	= 0,
 	.req_duplex	= 0,
 	.rsrv		= 0,
-	.config_init	= (config_init_t)bnx2x_848x3_config_init,
+	.config_init	= bnx2x_848x3_config_init,
 	.read_status	= bnx2x_848xx_read_status,
 	.link_reset	= bnx2x_848x3_link_reset,
 	.config_loopback = NULL,
@@ -12102,7 +12089,7 @@ static const struct bnx2x_phy phy_84858 = {
 	.speed_cap_mask	= 0,
 	.req_duplex	= 0,
 	.rsrv		= 0,
-	.config_init	= (config_init_t)bnx2x_848x3_config_init,
+	.config_init	= bnx2x_848x3_config_init,
 	.read_status	= bnx2x_848xx_read_status,
 	.link_reset	= bnx2x_848x3_link_reset,
 	.config_loopback = NULL,
@@ -12136,7 +12123,7 @@ static const struct bnx2x_phy phy_54618se = {
 	.speed_cap_mask	= 0,
 	/* req_duplex = */0,
 	/* rsrv = */0,
-	.config_init	= (config_init_t)bnx2x_54618se_config_init,
+	.config_init	= bnx2x_54618se_config_init,
 	.read_status	= bnx2x_54618se_read_status,
 	.link_reset	= bnx2x_54618se_link_reset,
 	.config_loopback = bnx2x_54618se_config_loopback,
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h
index 7115f5025664..d31d15c78a17 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h
@@ -127,8 +127,8 @@ struct link_vars;
 struct link_params;
 struct bnx2x_phy;
 
-typedef u8 (*config_init_t)(struct bnx2x_phy *phy, struct link_params *params,
-			    struct link_vars *vars);
+typedef void (*config_init_t)(struct bnx2x_phy *phy, struct link_params *params,
+			      struct link_vars *vars);
 typedef u8 (*read_status_t)(struct bnx2x_phy *phy, struct link_params *params,
 			    struct link_vars *vars);
 typedef void (*link_reset_t)(struct bnx2x_phy *phy,
-- 
2.17.1

