Return-Path: <kernel-hardening-return-21929-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 146A7C02199
	for <kernel-hardening@archiver.kernel.org>; Sun,  9 Feb 2025 04:06:44 +0000 (UTC)
Received: (qmail 11510 invoked by uid 550); 9 Feb 2025 04:06:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11479 invoked from network); 9 Feb 2025 04:06:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=MBO0001; t=1739073984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=ltjFoxTAxyndszAucu/FRvuWcGA6M5KNw2ipIWnLj0A=;
	b=PSuJR+CM26cpujHSJeXkJIfkU3Tvq67PL2aXfCj2drNPGQB7FampRgON82ZCdLyzwu2t1Q
	EtCdY2toTlu6+4U3UyP+/IPc/cy0nYUW5WtFOzuy72LkpEBCshokE4t9fjPXLHJY010TSo
	9B8ynHCqfFY6VQgB0cCfS2+06PsIgzuCaYl/vo0Lm6c1UfimIGMgu5oZH9i+myBURe4MEY
	yUZ7Dn6yNVyFSd0Kani0c1psdHj9ZCq4lL1DoPFPNMEYYPcPGIj5R1E06mMQQeI0KwYR1r
	+n4fVRiWRhNNAzljKs5E4XoeEUkKqqiAgECB0RM+lF2cNkW3F5fHvxIfH0z3JA==
Date: Sat, 8 Feb 2025 23:06:21 -0500
From: Ethan Carter Edwards <ethan@ethancedwards.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-hams@vger.kernel.org, pabeni@redhat.com, linux-hardening@vger.kernel.org, 
	kernel-hardening@lists.openwall.com
Subject: [PATCH v3] hamradio: baycom: replace strcpy() with strscpy()
Message-ID: <3qo3fbrak7undfgocsi2s74v4uyjbylpdqhie4dohfoh4welfn@joq7up65ug6v>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 4YrDfS3YsSz9skQ

The strcpy() function has been deprecated and replaced with strscpy().
There is an effort to make this change treewide:
https://github.com/KSPP/linux/issues/88.

Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 v3: resend after merge window ends
 Link to v2: https://lore.kernel.org/lkml/62yrwnnvqtwv4etjeaatms5xwiixirkbm6f7urmijwp7kk7bio@r2ric7eqhsvf/T/#u
 v2: reduce verbosity
 Link to v1: https://lore.kernel.org/lkml/bqKL4XKDGLWNih2jsEzZYpBSHG6Ux5mLZfDBIgHckEUxDq4l4pPgQPEXEqKRE7pUwMrXZBVeko9aYr1w_E5h5r_R_YFA46G8dGhV1id7zy4=@ethancedwards.com/
 drivers/net/hamradio/baycom_par.c     | 4 ++--
 drivers/net/hamradio/baycom_ser_fdx.c | 2 +-
 drivers/net/hamradio/baycom_ser_hdx.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/hamradio/baycom_par.c b/drivers/net/hamradio/baycom_par.c
index 00ebc25d0b22..47bc74d3ad8c 100644
--- a/drivers/net/hamradio/baycom_par.c
+++ b/drivers/net/hamradio/baycom_par.c
@@ -427,7 +427,7 @@ static int baycom_ioctl(struct net_device *dev, void __user *data,
 		break;
 
 	case HDLCDRVCTL_GETMODE:
-		strcpy(hi->data.modename, bc->options ? "par96" : "picpar");
+		strscpy(hi->data.modename, bc->options ? "par96" : "picpar");
 		if (copy_to_user(data, hi, sizeof(struct hdlcdrv_ioctl)))
 			return -EFAULT;
 		return 0;
@@ -439,7 +439,7 @@ static int baycom_ioctl(struct net_device *dev, void __user *data,
 		return baycom_setmode(bc, hi->data.modename);
 
 	case HDLCDRVCTL_MODELIST:
-		strcpy(hi->data.modename, "par96,picpar");
+		strscpy(hi->data.modename, "par96,picpar");
 		if (copy_to_user(data, hi, sizeof(struct hdlcdrv_ioctl)))
 			return -EFAULT;
 		return 0;
diff --git a/drivers/net/hamradio/baycom_ser_fdx.c b/drivers/net/hamradio/baycom_ser_fdx.c
index 799f8ece7824..3dda6b215fe3 100644
--- a/drivers/net/hamradio/baycom_ser_fdx.c
+++ b/drivers/net/hamradio/baycom_ser_fdx.c
@@ -531,7 +531,7 @@ static int baycom_ioctl(struct net_device *dev, void __user *data,
 		return baycom_setmode(bc, hi->data.modename);
 
 	case HDLCDRVCTL_MODELIST:
-		strcpy(hi->data.modename, "ser12,ser3,ser24");
+		strscpy(hi->data.modename, "ser12,ser3,ser24");
 		if (copy_to_user(data, hi, sizeof(struct hdlcdrv_ioctl)))
 			return -EFAULT;
 		return 0;
diff --git a/drivers/net/hamradio/baycom_ser_hdx.c b/drivers/net/hamradio/baycom_ser_hdx.c
index 5d1ab4840753..4f058f61659e 100644
--- a/drivers/net/hamradio/baycom_ser_hdx.c
+++ b/drivers/net/hamradio/baycom_ser_hdx.c
@@ -570,7 +570,7 @@ static int baycom_ioctl(struct net_device *dev, void __user *data,
 		break;
 
 	case HDLCDRVCTL_GETMODE:
-		strcpy(hi->data.modename, "ser12");
+		strscpy(hi->data.modename, "ser12");
 		if (bc->opt_dcd <= 0)
 			strcat(hi->data.modename, (!bc->opt_dcd) ? "*" : (bc->opt_dcd == -2) ? "@" : "+");
 		if (copy_to_user(data, hi, sizeof(struct hdlcdrv_ioctl)))
@@ -584,7 +584,7 @@ static int baycom_ioctl(struct net_device *dev, void __user *data,
 		return baycom_setmode(bc, hi->data.modename);
 
 	case HDLCDRVCTL_MODELIST:
-		strcpy(hi->data.modename, "ser12");
+		strscpy(hi->data.modename, "ser12");
 		if (copy_to_user(data, hi, sizeof(struct hdlcdrv_ioctl)))
 			return -EFAULT;
 		return 0;
-- 
2.47.1

