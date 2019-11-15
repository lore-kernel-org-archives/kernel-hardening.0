Return-Path: <SRS0=cJPB=ZH=lists.openwall.com=kernel-hardening-return-17370-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF5DC432C3
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 05:30:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7BA0220729
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 05:30:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Gf4KiRVk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BA0220729
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17370-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1244 invoked by uid 550); 15 Nov 2019 05:30:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32744 invoked from network); 15 Nov 2019 05:29:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CUnOECriyCGPMUs77nJPQe7W5fpmBDeLqmFUMqLQ4ns=;
        b=Gf4KiRVkt5957A/5n6CMLoowxR8z89RL/D0JR0F6914IPtMblpAY4h5Xoi9sdMp3/E
         mISlvAOtrAE+Wx+DOFWewx7Vc/MHnH7dcYrwhGCUKGBdejf3nj9TgYxOoQ2Le92rls14
         //g9j6jhqKm04JhOvkLBp2rT6njmcbRAPBs7s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CUnOECriyCGPMUs77nJPQe7W5fpmBDeLqmFUMqLQ4ns=;
        b=qHMxoPHyvokN1f31QPuayw0m2BoJoOCppSe+8sw1G6redjnEgfJAdQVdFRD7VgGwdK
         bFFqXV1UMO6te6/mvGn4PGX/Wkqec9OOXybQJRcjK0l5YNYf5GrMCdFLlpCV2Fl51wvO
         ju3hnvkYqUwqsWwbWxPd2L/8S1wtcq9FtUjrQoN+OMa5N6fnXf9XztwGh5wci8uanjHr
         GWd7S3FtTA2sxTcwW6NV955M+pZR4bgsR8USTY3jlMsLb4O0cx9NPPR1to/6hxFNKHFp
         WMROXhw31q8hmwmTJfBniEdkF4hJQyl7mJEIcsJIcO4/Muz3ApEznOz4RD8ggFfLUOjl
         PkLA==
X-Gm-Message-State: APjAAAV+jOaguAXAohScN9swFlQ36EQ0at9QD8QC3Ln/OS3VOzj5yNon
	rKWzPEffKeuq8yNDJsyMg28MhA==
X-Google-Smtp-Source: APXvYqxCchciC7RO/ge8MF6qR0zrw7E75p61yGCLl/oKfJf8e1BMGrQHsuVEhe+hQi9MUpPZRZKyEw==
X-Received: by 2002:a63:ca05:: with SMTP id n5mr14155578pgi.187.1573795785766;
        Thu, 14 Nov 2019 21:29:45 -0800 (PST)
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
Subject: [PATCH 4/5] bnx2x: Remove format_fw_ver_t function casts
Date: Thu, 14 Nov 2019 21:07:14 -0800
Message-Id: <20191115050715.6247-5-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115050715.6247-1-keescook@chromium.org>
References: <20191115050715.6247-1-keescook@chromium.org>

The return values for format_fw_ver_t callbacks are supposed to be
"int", not "u8". Ultimately, the top-level caller doesn't actually check
the return value at all, but just clean this all up anyway and fix the
prototypes so that casts are no longer needed.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 .../net/ethernet/broadcom/bnx2x/bnx2x_link.c  | 22 +++++++++----------
 .../net/ethernet/broadcom/bnx2x/bnx2x_link.h  |  2 +-
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
index 2bc6408ce00d..7dd35aa75925 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -11767,7 +11767,7 @@ static const struct bnx2x_phy phy_7101 = {
 	.read_status	= bnx2x_7101_read_status,
 	.link_reset	= bnx2x_common_ext_link_reset,
 	.config_loopback = bnx2x_7101_config_loopback,
-	.format_fw_ver	= (format_fw_ver_t)bnx2x_7101_format_ver,
+	.format_fw_ver	= bnx2x_7101_format_ver,
 	.hw_reset	= (hw_reset_t)bnx2x_7101_hw_reset,
 	.set_link_led	= bnx2x_7101_set_link_led,
 	.phy_specific_func = NULL
@@ -11798,7 +11798,7 @@ static const struct bnx2x_phy phy_8073 = {
 	.read_status	= bnx2x_8073_read_status,
 	.link_reset	= bnx2x_8073_link_reset,
 	.config_loopback = NULL,
-	.format_fw_ver	= (format_fw_ver_t)bnx2x_format_ver,
+	.format_fw_ver	= bnx2x_format_ver,
 	.hw_reset	= NULL,
 	.set_link_led	= NULL,
 	.phy_specific_func = bnx2x_8073_specific_func
@@ -11826,7 +11826,7 @@ static const struct bnx2x_phy phy_8705 = {
 	.read_status	= bnx2x_8705_read_status,
 	.link_reset	= bnx2x_common_ext_link_reset,
 	.config_loopback = NULL,
-	.format_fw_ver	= (format_fw_ver_t)bnx2x_null_format_ver,
+	.format_fw_ver	= bnx2x_null_format_ver,
 	.hw_reset	= NULL,
 	.set_link_led	= NULL,
 	.phy_specific_func = NULL
@@ -11855,7 +11855,7 @@ static const struct bnx2x_phy phy_8706 = {
 	.read_status	= bnx2x_8706_read_status,
 	.link_reset	= bnx2x_common_ext_link_reset,
 	.config_loopback = NULL,
-	.format_fw_ver	= (format_fw_ver_t)bnx2x_format_ver,
+	.format_fw_ver	= bnx2x_format_ver,
 	.hw_reset	= NULL,
 	.set_link_led	= NULL,
 	.phy_specific_func = NULL
@@ -11887,7 +11887,7 @@ static const struct bnx2x_phy phy_8726 = {
 	.read_status	= bnx2x_8726_read_status,
 	.link_reset	= bnx2x_8726_link_reset,
 	.config_loopback = bnx2x_8726_config_loopback,
-	.format_fw_ver	= (format_fw_ver_t)bnx2x_format_ver,
+	.format_fw_ver	= bnx2x_format_ver,
 	.hw_reset	= NULL,
 	.set_link_led	= NULL,
 	.phy_specific_func = NULL
@@ -11918,7 +11918,7 @@ static const struct bnx2x_phy phy_8727 = {
 	.read_status	= bnx2x_8727_read_status,
 	.link_reset	= bnx2x_8727_link_reset,
 	.config_loopback = NULL,
-	.format_fw_ver	= (format_fw_ver_t)bnx2x_format_ver,
+	.format_fw_ver	= bnx2x_format_ver,
 	.hw_reset	= (hw_reset_t)bnx2x_8727_hw_reset,
 	.set_link_led	= bnx2x_8727_set_link_led,
 	.phy_specific_func = bnx2x_8727_specific_func
@@ -11953,7 +11953,7 @@ static const struct bnx2x_phy phy_8481 = {
 	.read_status	= bnx2x_848xx_read_status,
 	.link_reset	= bnx2x_8481_link_reset,
 	.config_loopback = NULL,
-	.format_fw_ver	= (format_fw_ver_t)bnx2x_848xx_format_ver,
+	.format_fw_ver	= bnx2x_848xx_format_ver,
 	.hw_reset	= (hw_reset_t)bnx2x_8481_hw_reset,
 	.set_link_led	= bnx2x_848xx_set_link_led,
 	.phy_specific_func = NULL
@@ -11990,7 +11990,7 @@ static const struct bnx2x_phy phy_84823 = {
 	.read_status	= bnx2x_848xx_read_status,
 	.link_reset	= bnx2x_848x3_link_reset,
 	.config_loopback = NULL,
-	.format_fw_ver	= (format_fw_ver_t)bnx2x_848xx_format_ver,
+	.format_fw_ver	= bnx2x_848xx_format_ver,
 	.hw_reset	= NULL,
 	.set_link_led	= bnx2x_848xx_set_link_led,
 	.phy_specific_func = bnx2x_848xx_specific_func
@@ -12025,7 +12025,7 @@ static const struct bnx2x_phy phy_84833 = {
 	.read_status	= bnx2x_848xx_read_status,
 	.link_reset	= bnx2x_848x3_link_reset,
 	.config_loopback = NULL,
-	.format_fw_ver	= (format_fw_ver_t)bnx2x_848xx_format_ver,
+	.format_fw_ver	= bnx2x_848xx_format_ver,
 	.hw_reset	= (hw_reset_t)bnx2x_84833_hw_reset_phy,
 	.set_link_led	= bnx2x_848xx_set_link_led,
 	.phy_specific_func = bnx2x_848xx_specific_func
@@ -12059,7 +12059,7 @@ static const struct bnx2x_phy phy_84834 = {
 	.read_status	= bnx2x_848xx_read_status,
 	.link_reset	= bnx2x_848x3_link_reset,
 	.config_loopback = NULL,
-	.format_fw_ver	= (format_fw_ver_t)bnx2x_848xx_format_ver,
+	.format_fw_ver	= bnx2x_848xx_format_ver,
 	.hw_reset	= (hw_reset_t)bnx2x_84833_hw_reset_phy,
 	.set_link_led	= bnx2x_848xx_set_link_led,
 	.phy_specific_func = bnx2x_848xx_specific_func
@@ -12093,7 +12093,7 @@ static const struct bnx2x_phy phy_84858 = {
 	.read_status	= bnx2x_848xx_read_status,
 	.link_reset	= bnx2x_848x3_link_reset,
 	.config_loopback = NULL,
-	.format_fw_ver	= (format_fw_ver_t)bnx2x_8485x_format_ver,
+	.format_fw_ver	= bnx2x_8485x_format_ver,
 	.hw_reset	= (hw_reset_t)bnx2x_84833_hw_reset_phy,
 	.set_link_led	= bnx2x_848xx_set_link_led,
 	.phy_specific_func = bnx2x_848xx_specific_func
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h
index d31d15c78a17..cae03c89dc73 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h
@@ -135,7 +135,7 @@ typedef void (*link_reset_t)(struct bnx2x_phy *phy,
 			     struct link_params *params);
 typedef void (*config_loopback_t)(struct bnx2x_phy *phy,
 				  struct link_params *params);
-typedef u8 (*format_fw_ver_t)(u32 raw, u8 *str, u16 *len);
+typedef int (*format_fw_ver_t)(u32 raw, u8 *str, u16 *len);
 typedef void (*hw_reset_t)(struct bnx2x_phy *phy, struct link_params *params);
 typedef void (*set_link_led_t)(struct bnx2x_phy *phy,
 			       struct link_params *params, u8 mode);
-- 
2.17.1

