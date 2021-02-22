Return-Path: <SRS0=vpys=HY=lists.openwall.com=kernel-hardening-return-20791-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B17C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:16:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0FB636148E
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:16:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FB636148E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20791-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24045 invoked by uid 550); 22 Feb 2021 15:13:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23975 invoked from network); 22 Feb 2021 15:13:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wq4bDTy7O0vk/Xl+ds0X25qRB7OEnbCpsrwWx7YRZDc=;
        b=EWsVGNiIfiAcsHDWWrBuDfJ4HB/Yx65evF3pcHQ49AcFAsLtIVjJgbtPtnIOVVgbMU
         rTmE3lmoF8kswxq3stmLItzpXu5iDLSXUAH8TkorU+U9306F+cC0cXkgDooGGHkZ1/ip
         aaizJ+GXbNvK9eYjocx0vXNq5tFQWOec96RtxdzDT7H1VvqrFusc+kS19qP5lTK9vLCT
         xx9AcO+UQWJqOv7QmIKkcxojx/Pzc4wiP4G8h2Y0FvA8pd8liGA1IwYQfhaFFcuQeH/f
         uUaclQgc0h2SGBx5pvft17Gt2cmXL9752DIiMFpDCtu71yXFidMCqCwo7ld1lD3OaMS9
         mPKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wq4bDTy7O0vk/Xl+ds0X25qRB7OEnbCpsrwWx7YRZDc=;
        b=gIp7DpU93OoOY2+ZEfJrsaEFR9HWLdixKGEensERv6UVc/YsvT3LqEzKYRCs2TVHSd
         IrFBlF/Bklly4BgGwk+GQA85OdU49tVh1E1fP+LgKel8gdd71gCCginM0+/KVZs2b+uV
         W8hAuojJprs1UngAieMbUap5aO2zo1aS9pUcH5luNFJz5HImpOHnt7hpkvql122bhd1t
         RVNXAFOU0hc+m1PbvAYLrxuLKusUNRfOHWM/EQuKw8FfNS0HYRbB2GPXdiRvkis+e4Av
         eWRxw0Iy3TttllF+oFkH4fUgiZHJbNlvCp0UK5iUvcbYik5o9BHEKT3CjcnrT9kvN/co
         u/dg==
X-Gm-Message-State: AOAM532casMrouFJh0w6QD7F6TmDzxLX3srb3Ki600Dx48ifWWB0sDeL
	BiWqdDpaBx2CaK5DF2C+5+lF7lYBQbKsoZZnPXY=
X-Google-Smtp-Source: ABdhPJyJWNmCSm/Ui0rMFFKZx/hnNI+YYBQlrfpdochjr/Q5i7g2NMK3qCKtgS6PUnTBdo+H1ja/VA==
X-Received: by 2002:a05:600c:410d:: with SMTP id j13mr9505033wmi.55.1614006775620;
        Mon, 22 Feb 2021 07:12:55 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Guenter Roeck <linux@roeck-us.net>
Cc: Romain Perier <romain.perier@gmail.com>,
	linux-hwmon@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 11/20] hwmon: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:22 +0100
Message-Id: <20210222151231.22572-12-romain.perier@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210222151231.22572-1-romain.perier@gmail.com>
References: <20210222151231.22572-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The strlcpy() reads the entire source buffer first, it is dangerous if
the source buffer lenght is unbounded or possibility non NULL-terminated.
It can lead to linear read overflows, crashes, etc...

As recommended in the deprecated interfaces [1], it should be replaced
by strscpy.

This commit replaces all calls to strlcpy that handle the return values
by the corresponding strscpy calls with new handling of the return
values (as it is quite different between the two functions).

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/hwmon/pmbus/max20730.c |   66 +++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/hwmon/pmbus/max20730.c b/drivers/hwmon/pmbus/max20730.c
index 9dd3dd79bc18..a384b57b7327 100644
--- a/drivers/hwmon/pmbus/max20730.c
+++ b/drivers/hwmon/pmbus/max20730.c
@@ -107,7 +107,8 @@ struct max20730_debugfs_data {
 static ssize_t max20730_debugfs_read(struct file *file, char __user *buf,
 				     size_t count, loff_t *ppos)
 {
-	int ret, len;
+	int ret;
+	ssize_t len;
 	int *idxp = file->private_data;
 	int idx = *idxp;
 	struct max20730_debugfs_data *psu = to_psu(idxp, idx);
@@ -148,13 +149,13 @@ static ssize_t max20730_debugfs_read(struct file *file, char __user *buf,
 			>> MAX20730_MFR_DEVSET1_TSTAT_BIT_POS;
 
 		if (val == 0)
-			len = strlcpy(tbuf, "2000\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "2000\n", DEBUG_FS_DATA_MAX);
 		else if (val == 1)
-			len = strlcpy(tbuf, "125\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "125\n", DEBUG_FS_DATA_MAX);
 		else if (val == 2)
-			len = strlcpy(tbuf, "62.5\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "62.5\n", DEBUG_FS_DATA_MAX);
 		else
-			len = strlcpy(tbuf, "32\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "32\n", DEBUG_FS_DATA_MAX);
 		break;
 	case MAX20730_DEBUGFS_INTERNAL_GAIN:
 		val = (data->mfr_devset1 & MAX20730_MFR_DEVSET1_RGAIN_MASK)
@@ -163,35 +164,35 @@ static ssize_t max20730_debugfs_read(struct file *file, char __user *buf,
 		if (data->id == max20734) {
 			/* AN6209 */
 			if (val == 0)
-				len = strlcpy(tbuf, "0.8\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "0.8\n", DEBUG_FS_DATA_MAX);
 			else if (val == 1)
-				len = strlcpy(tbuf, "3.2\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "3.2\n", DEBUG_FS_DATA_MAX);
 			else if (val == 2)
-				len = strlcpy(tbuf, "1.6\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "1.6\n", DEBUG_FS_DATA_MAX);
 			else
-				len = strlcpy(tbuf, "6.4\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "6.4\n", DEBUG_FS_DATA_MAX);
 		} else if (data->id == max20730 || data->id == max20710) {
 			/* AN6042 or AN6140 */
 			if (val == 0)
-				len = strlcpy(tbuf, "0.9\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "0.9\n", DEBUG_FS_DATA_MAX);
 			else if (val == 1)
-				len = strlcpy(tbuf, "3.6\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "3.6\n", DEBUG_FS_DATA_MAX);
 			else if (val == 2)
-				len = strlcpy(tbuf, "1.8\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "1.8\n", DEBUG_FS_DATA_MAX);
 			else
-				len = strlcpy(tbuf, "7.2\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "7.2\n", DEBUG_FS_DATA_MAX);
 		} else if (data->id == max20743) {
 			/* AN6042 */
 			if (val == 0)
-				len = strlcpy(tbuf, "0.45\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "0.45\n", DEBUG_FS_DATA_MAX);
 			else if (val == 1)
-				len = strlcpy(tbuf, "1.8\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "1.8\n", DEBUG_FS_DATA_MAX);
 			else if (val == 2)
-				len = strlcpy(tbuf, "0.9\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "0.9\n", DEBUG_FS_DATA_MAX);
 			else
-				len = strlcpy(tbuf, "3.6\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "3.6\n", DEBUG_FS_DATA_MAX);
 		} else {
-			len = strlcpy(tbuf, "Not supported\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "Not supported\n", DEBUG_FS_DATA_MAX);
 		}
 		break;
 	case MAX20730_DEBUGFS_BOOT_VOLTAGE:
@@ -199,26 +200,26 @@ static ssize_t max20730_debugfs_read(struct file *file, char __user *buf,
 			>> MAX20730_MFR_DEVSET1_VBOOT_BIT_POS;
 
 		if (val == 0)
-			len = strlcpy(tbuf, "0.6484\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "0.6484\n", DEBUG_FS_DATA_MAX);
 		else if (val == 1)
-			len = strlcpy(tbuf, "0.8984\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "0.8984\n", DEBUG_FS_DATA_MAX);
 		else if (val == 2)
-			len = strlcpy(tbuf, "1.0\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "1.0\n", DEBUG_FS_DATA_MAX);
 		else
-			len = strlcpy(tbuf, "Invalid\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "Invalid\n", DEBUG_FS_DATA_MAX);
 		break;
 	case MAX20730_DEBUGFS_OUT_V_RAMP_RATE:
 		val = (data->mfr_devset2 & MAX20730_MFR_DEVSET2_VRATE)
 			>> MAX20730_MFR_DEVSET2_VRATE_BIT_POS;
 
 		if (val == 0)
-			len = strlcpy(tbuf, "4\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "4\n", DEBUG_FS_DATA_MAX);
 		else if (val == 1)
-			len = strlcpy(tbuf, "2\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "2\n", DEBUG_FS_DATA_MAX);
 		else if (val == 2)
-			len = strlcpy(tbuf, "1\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "1\n", DEBUG_FS_DATA_MAX);
 		else
-			len = strlcpy(tbuf, "Invalid\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "Invalid\n", DEBUG_FS_DATA_MAX);
 		break;
 	case MAX20730_DEBUGFS_OC_PROTECT_MODE:
 		ret = (data->mfr_devset2 & MAX20730_MFR_DEVSET2_OCPM_MASK)
@@ -230,13 +231,13 @@ static ssize_t max20730_debugfs_read(struct file *file, char __user *buf,
 			>> MAX20730_MFR_DEVSET2_SS_BIT_POS;
 
 		if (val == 0)
-			len = strlcpy(tbuf, "0.75\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "0.75\n", DEBUG_FS_DATA_MAX);
 		else if (val == 1)
-			len = strlcpy(tbuf, "1.5\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "1.5\n", DEBUG_FS_DATA_MAX);
 		else if (val == 2)
-			len = strlcpy(tbuf, "3\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "3\n", DEBUG_FS_DATA_MAX);
 		else
-			len = strlcpy(tbuf, "6\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "6\n", DEBUG_FS_DATA_MAX);
 		break;
 	case MAX20730_DEBUGFS_IMAX:
 		ret = (data->mfr_devset2 & MAX20730_MFR_DEVSET2_IMAX_MASK)
@@ -287,9 +288,12 @@ static ssize_t max20730_debugfs_read(struct file *file, char __user *buf,
 				"%d.%d\n", ret / 10000, ret % 10000);
 		break;
 	default:
-		len = strlcpy(tbuf, "Invalid\n", DEBUG_FS_DATA_MAX);
+		len = strscpy(tbuf, "Invalid\n", DEBUG_FS_DATA_MAX);
 	}
 
+	if (len == -E2BIG)
+		return -E2BIG;
+
 	return simple_read_from_buffer(buf, count, ppos, tbuf, len);
 }
 

