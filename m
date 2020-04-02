Return-Path: <SRS0=qgOw=5S=lists.openwall.com=kernel-hardening-return-18400-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4581FC43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 20:42:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 92C1820678
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 20:42:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=bacher09.org header.i=@bacher09.org header.b="vpyvacP4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92C1820678
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bacher09.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18400-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5896 invoked by uid 550); 2 Apr 2020 20:42:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5864 invoked from network); 2 Apr 2020 20:42:51 -0000
From: Slava Bacherikov <slava@bacher09.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bacher09.org;
	s=reg; t=1585860159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FjEUUecMFmSmjNvMMdOE00B64A4ZBeK571WEZ1itbTo=;
	b=vpyvacP4IlEQAZZTqSLxAxWKl1ADfLPJ4lur44nnd4UAiN6TqY5XLfICXUQhElx58DN4/F
	VZ9EmZ9StR/86gGMuuu8ucf+W+sM3/hT+blRRXxoNsndkZhqNTdVksavxWpmqEIaBN3a9P
	NrZtSC8erogUojOk08ONx4mHH+pr3FE=
To: andriin@fb.com
Cc: keescook@chromium.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jannh@google.com,
	alexei.starovoitov@gmail.com,
	daniel@iogearbox.net,
	kernel-hardening@lists.openwall.com,
	liuyd.fnst@cn.fujitsu.com,
	kpsingh@google.com,
	Slava Bacherikov <slava@bacher09.org>
Subject: [PATCH v5 bpf] kbuild: fix dependencies for DEBUG_INFO_BTF
Date: Thu,  2 Apr 2020 23:41:39 +0300
Message-Id: <20200402204138.408021-1-slava@bacher09.org>
In-Reply-To: <202004021328.E6161480@keescook>
References: <202004021328.E6161480@keescook>
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
Acked-by: KP Singh <kpsingh@google.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Fixes: e83b9f55448a ("kbuild: add ability to generate BTF type info for vmlinux")
---
 lib/Kconfig.debug | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index f61d834e02fe..6118d99117da 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -223,6 +223,8 @@ config DEBUG_INFO_DWARF4
 config DEBUG_INFO_BTF
 	bool "Generate BTF typeinfo"
 	depends on DEBUG_INFO
+	depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
+	depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
 	help
 	  Generate deduplicated BTF type information from DWARF debug info.
 	  Turning this on expects presence of pahole tool, which will convert
