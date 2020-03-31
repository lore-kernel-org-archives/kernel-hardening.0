Return-Path: <SRS0=jXZb=5R=lists.openwall.com=kernel-hardening-return-18349-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FB09C43331
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 07:33:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6B8E420772
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 07:33:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=bacher09.org header.i=@bacher09.org header.b="sA0E+eeY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B8E420772
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bacher09.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18349-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24414 invoked by uid 550); 1 Apr 2020 07:33:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3338 invoked from network); 31 Mar 2020 21:57:08 -0000
From: Slava Bacherikov <slava@bacher09.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bacher09.org;
	s=reg; t=1585691814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YT3MtOxItDdm7TWprAjBs6HigHaG9iwHyVl+Qij+P7Q=;
	b=sA0E+eeYQDfev3TzgMOUJL7ighcMggnMl5MnYXjtYSA9nOlaYPPtalbXpF4MzDd1DK1Vdm
	x9LhwSZ9OPigKOjS6GPiXHp22dMJnDFWcDwsykFS9EgBoQ0b4MR4M2VaLVcMgp9mGJc54R
	eyVOhTIXjHKjZ2LUSGqtAE4Ltsspl1Q=
To: andriin@fb.com
Cc: keescook@chromium.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jannh@google.com,
	alexei.starovoitov@gmail.com,
	daniel@iogearbox.net,
	kernel-hardening@lists.openwall.com,
	Slava Bacherikov <slava@bacher09.org>,
	Liu Yiding <liuyd.fnst@cn.fujitsu.com>
Subject: [PATCH v2 bpf] kbuild: fix dependencies for DEBUG_INFO_BTF
Date: Wed,  1 Apr 2020 00:55:37 +0300
Message-Id: <20200331215536.34162-1-slava@bacher09.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes

Currently turning on DEBUG_INFO_SPLIT when DEBUG_INFO_BTF is also
enabled will produce invalid btf file, since gen_btf function in
link-vmlinux.sh script doesn't handle *.dwo files.

Enabling DEBUG_INFO_REDUCED will also produce invalid btf file, and
using GCC_PLUGIN_RANDSTRUCT with BTF makes no sense.

Signed-off-by: Slava Bacherikov <slava@bacher09.org>
Reported-by: Jann Horn <jannh@google.com>
Reported-by: Liu Yiding <liuyd.fnst@cn.fujitsu.com>
Fixes: e83b9f55448a ("kbuild: add ability to generate BTF type info for vmlinux")
---
 lib/Kconfig.debug | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index f61d834e02fe..9ae288e2a6c0 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -223,6 +223,7 @@ config DEBUG_INFO_DWARF4
 config DEBUG_INFO_BTF
 	bool "Generate BTF typeinfo"
 	depends on DEBUG_INFO
+	depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED && !GCC_PLUGIN_RANDSTRUCT
 	help
 	  Generate deduplicated BTF type information from DWARF debug info.
 	  Turning this on expects presence of pahole tool, which will convert
-- 
2.24.1

