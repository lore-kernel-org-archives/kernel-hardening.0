Return-Path: <kernel-hardening-return-21514-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id C0BF0C433F5
	for <kernel-hardening@archiver.kernel.org>; Sat,  4 Dec 2021 17:14:48 +0000 (UTC)
Received: (qmail 3871 invoked by uid 550); 4 Dec 2021 17:14:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3834 invoked from network); 4 Dec 2021 17:14:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/cksNdFZj9IWFAKVJL2S+JO52BCjhptq1rRTsh39hwU=;
        b=hDkp38Hh5EL0JAbauIY7IrYLaUFIMb2J4WxSWavCR0/NMFUkQswvhavyBvH0Xhmr65
         hT646y40uhe90P6mM9+QwIF0UgGfQhtPf7M9HH8prcEgoduOae0QeHKbuOF+2SzQpUKE
         LWdbd3HfEbQzzu/k1Z8Ot2PeTPSOztxBWbpDticprF7d+Tlwv7HoaMz3sysO+Vuasebj
         RKzcTIJBqNejda+yMZGuNE7mNbWWap4zkLHwKrtyThPJXQ8uVF93thxI9Am15jPsjU3e
         09VeM7aFt+UKrrWRaY4OGlJvgamgXlrjz037CYX/0Ic2tUzXgPEGehiwazukuSVDEMmu
         m/Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/cksNdFZj9IWFAKVJL2S+JO52BCjhptq1rRTsh39hwU=;
        b=P3AaStO9kfMuIOVrF2QlBaWNpq4Qw3NaS66eTdPuuPqkMhkPOi84hZEUEGfh9nBhI2
         rIhRx1hFGmxRfHzjorMq7XbRjfibXwjcC38tPbTcb7T2PY/W4eHscNpuqt1yt5bUUE/6
         ImzMGKLPeNj8Ty1v/e/uAvNCqd9YDoOyNfPZbHOowf9UrDQP+1ZrR3OR1qJ2MqYhJdw8
         eflJR+TJrgalBlA5HfwqGYGCkF34FvVGfW3dc7YWjCiKq11BQzCmtoRr5B2UwSpxNdaA
         OMz98Op6yFg+eFPaXKLor9iWgNkhiQ0srQR9M/+O4lws6K94+F75KwRGBUO+WZ5CAdIw
         l4/A==
X-Gm-Message-State: AOAM532w/7dkbXlmpw8lPIzvhhOP2KMCva4AWrWojh6PyHVcorScD7GY
	UKPxmrn+7zfSAkX+/G0O5Lg=
X-Google-Smtp-Source: ABdhPJzrI2rcwOxTlv1tvwELn9+hzWwa9IDuSn8C7BHPXcI4Rul83GKkIdn2/l/7qHb0tWVXpNgnrQ==
X-Received: by 2002:adf:f189:: with SMTP id h9mr31297571wro.463.1638638065263;
        Sat, 04 Dec 2021 09:14:25 -0800 (PST)
From: =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>
To: tchornyi@marvell.com
Cc: davem@davemloft.net,
	kuba@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	gustavoars@kernel.org,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>
Subject: [PATCH] net: prestera: replace zero-length array with flexible-array member
Date: Sat,  4 Dec 2021 18:13:49 +0100
Message-Id: <20211204171349.22776-1-jose.exposito89@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

One-element and zero-length arrays are deprecated and should be
replaced with flexible-array members:
https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays

Replace zero-length array with flexible-array member and make use
of the struct_size() helper.

Link: https://github.com/KSPP/linux/issues/78
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 92cb5e9099c6..6282c9822e2b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -443,7 +443,7 @@ struct prestera_msg_counter_resp {
 	__le32 offset;
 	__le32 num_counters;
 	__le32 done;
-	struct prestera_msg_counter_stats stats[0];
+	struct prestera_msg_counter_stats stats[];
 };
 
 struct prestera_msg_span_req {
@@ -1900,7 +1900,7 @@ int prestera_hw_counters_get(struct prestera_switch *sw, u32 idx,
 		.block_id = __cpu_to_le32(idx),
 		.num_counters = __cpu_to_le32(*len),
 	};
-	size_t size = sizeof(*resp) + sizeof(*resp->stats) * (*len);
+	size_t size = struct_size(resp, stats, *len);
 	int err, i;
 
 	resp = kmalloc(size, GFP_KERNEL);
-- 
2.25.1

