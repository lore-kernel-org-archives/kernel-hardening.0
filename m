Return-Path: <SRS0=uwW2=WQ=lists.openwall.com=kernel-hardening-return-16794-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3BBFC3A589
	for <kernel-hardening@archiver.kernel.org>; Tue, 20 Aug 2019 04:48:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3782F216F4
	for <kernel-hardening@archiver.kernel.org>; Tue, 20 Aug 2019 04:48:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YR0Kl77J"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3782F216F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16794-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3658 invoked by uid 550); 20 Aug 2019 04:48:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3624 invoked from network); 20 Aug 2019 04:48:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IP1qp6mAUOtVWu5xrzBzwMPvfWVdGkZ7mtapBPsPjVU=;
        b=YR0Kl77JcI/VruPRTK4f3IwMnVxJufjL8du9jzjSbQOEGvnqrdX7Vp2+zWXx0suohX
         R+rh+65Fxa9hN+NZ9tyi5CWsJNvSuv7RSRgJm1SlsIfH94f3WIOM7KuXHzA25nZ914Gc
         Ag4TY8ZEprTeXaud99+hMfGA/BFo6JlJxo4viAJ13LHB4ERFKSFifd32WVcCAW+SSD0j
         8E4rHsgZOPeNQtbCV4dxL2iRjFtE0EvmiM/DHu3bXBLCXGubMfyMmRbx4efk6XAQzWX7
         JLOTq6fEj0ZPhSrSMiWi90VRZZsK+VzrGA2cDHmFtwhbzr7YdDzgNfgD0tKDwaslD4/O
         1xlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IP1qp6mAUOtVWu5xrzBzwMPvfWVdGkZ7mtapBPsPjVU=;
        b=mZbWpB0ooET02xb8B7UOdKtyMbTDxOLyMC0NkP8vV34yddOLLQQAMAUvdm+rPt4k6g
         OYOcCHB433eet5xhSLgPF3Pdpn0A4TiAitEFaPpPWjd/vpGzZTPJWAdEQiciM1GpwTDf
         NZecaV4kE7qHa3EuRJegsJX9IoVhZefACt0AFluX0/vJ7FHozVEuKR7Ru2BfMMYzHQRa
         7EO2lvz69Zk9F+z3/JX9Wur1Yu8cHEwg9ovWCy6czCS7XHKTAeGOwXvt4sl4jg5W+eWd
         kdGuRR/CA32SGI4Ioc3ECrnIYLQ+PgRGPOAhA3xVU2w28D2mxCLdKAJuuDwezUK8cPX4
         tW7Q==
X-Gm-Message-State: APjAAAVnQCRA7fHex+fojsdqE+xjzgp1gy8UhFYj0qqhLGBGmHddMI/Q
	Fj0o2UVBigMwZMlaZr6UmPYNg0nV
X-Google-Smtp-Source: APXvYqwp5q5BO2ilzqHao00Rkg4gDx99eXqDF3HGJYxLXciOrVLvdQPDq6hp45OMMvY6ah60+AEYfA==
X-Received: by 2002:a5d:404d:: with SMTP id w13mr31091893wrp.253.1566276476198;
        Mon, 19 Aug 2019 21:47:56 -0700 (PDT)
From: kpark3469@gmail.com
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org,
	re.emese@gmail.com,
	keun-o.park@darkmatter.ae
Subject: [PATCH] latent_entropy: make builtin_frame_address implicit
Date: Tue, 20 Aug 2019 08:47:38 +0400
Message-Id: <1566276458-6233-1-git-send-email-kpark3469@gmail.com>
X-Mailer: git-send-email 2.7.4

From: Sahara <keun-o.park@darkmatter.ae>

When Android toolchain for aarch64 is used to build this plugin,
builtin_decl_implicit(BUILT_IN_FRAME_ADDRESS) returns NULL_TREE.
Due to this issue, the returned NULL_TREE from builtin_decl_implicit
causes compiler's unexpected fault in the next gimple_build_call.
To avoid this problem, let's make it implicit before calling
builtin_decl_implicit() for the frame address.

Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
---
 scripts/gcc-plugins/latent_entropy_plugin.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/gcc-plugins/latent_entropy_plugin.c b/scripts/gcc-plugins/latent_entropy_plugin.c
index cbe1d6c..7571990 100644
--- a/scripts/gcc-plugins/latent_entropy_plugin.c
+++ b/scripts/gcc-plugins/latent_entropy_plugin.c
@@ -446,6 +446,8 @@ static void init_local_entropy(basic_block bb, tree local_entropy)
 	frame_addr = create_var(ptr_type_node, "local_entropy_frameaddr");
 
 	/* 2. local_entropy_frameaddr = __builtin_frame_address() */
+	if (!builtin_decl_implicit_p(BUILT_IN_FRAME_ADDRESS))
+		set_builtin_decl_implicit_p(BUILT_IN_FRAME_ADDRESS, true);
 	fndecl = builtin_decl_implicit(BUILT_IN_FRAME_ADDRESS);
 	call = gimple_build_call(fndecl, 1, integer_zero_node);
 	gimple_call_set_lhs(call, frame_addr);
-- 
2.7.4

