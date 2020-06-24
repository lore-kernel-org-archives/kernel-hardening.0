Return-Path: <SRS0=FC1u=AF=lists.openwall.com=kernel-hardening-return-19109-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58FB3C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:33:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B256A20885
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:33:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xm0pw21C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B256A20885
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19109-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27810 invoked by uid 550); 24 Jun 2020 20:33:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27728 invoked from network); 24 Jun 2020 20:33:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xQdUf2OUslJj5DjDkMf3WWk6yA/Z9kKXMPQTw/J6IlI=;
        b=Xm0pw21CFWwXKUCWT9uv8sjRFTZSZ2FxFwksg6PZZFhaViOtrXe11fAV4rmUtsA/iD
         yw79dp1HbVFKYB9IyYfau+MusfZUyo7hsiV4z3U+B+VERxLsAmDLIOjA6ZbmwYQrk90b
         ude2AkBLX9/aWcsdUn0At059rWaNafFELeyyTNpWfaIPQWe975NuzYbO2Y2+sB6z99TZ
         DkeatZZ3I3Kg3WrJcfsykfzzNiGAFFIiaZ9KHBKGVzxxZKDwbNS3dVYdRS4I3s6IiWF7
         F9FQwIOY90ZeHvihhQegbpcF6vQYY7VW45ZJstmN7BQcaqrs2XDnMXsRYKvPnePBoQiK
         Uk5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xQdUf2OUslJj5DjDkMf3WWk6yA/Z9kKXMPQTw/J6IlI=;
        b=k7CesOnJ9qCb+yGa5HlyGh1IPfVulgoOZlmpTHOt6iQ93PDwlLy3+IEDyfG5aaGJtg
         DUCgeo+iiZ0FhK7Naz9e+TGgY18BfE65S7E4O/LOYdm9IZny74uMj/L75Ofb6sRnRpPf
         F0a4S4WaRSvgqAvv9v2IKLitGxtly8o2MYaSjn0aLRtAdA05LmUFie1Qk7KxkliYa6TG
         hD5obFYxRx+YjuRmhIsFbaFgrp3/qTJ1j9xBC/eeYy7cHdev8OV2ZCC4qpoXus0z8uoz
         1v2/upJ07uz+nQZU5MpZ4UaL5brNB3dEu7sRSjj8i+D8RXu7WMAP8OpcyJJxC9fsCslJ
         LD+Q==
X-Gm-Message-State: AOAM533ILWm8QDSpB6vxLhXn5EJ0UgVOfS/a5j9V39324yq9RuOoKtRd
	cRegVAabgc0UmxU0WHyoUno2bp+J9J4pMpIkPGg=
X-Google-Smtp-Source: ABdhPJyaNd4T7jCJ2XxtqDk7As6bELzRlErz6uaK57hfCOoUmajW51Nj+2rWe6ZzApbtPE/D/8XgpW5QlQwx29+bABU=
X-Received: by 2002:a25:4cca:: with SMTP id z193mr43175648yba.510.1593030771779;
 Wed, 24 Jun 2020 13:32:51 -0700 (PDT)
Date: Wed, 24 Jun 2020 13:31:39 -0700
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
Message-Id: <20200624203200.78870-2-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH 01/22] objtool: use sh_info to find the base for .rela sections
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>, Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"

ELF doesn't require .rela section names to match the base section. Use
the section index in sh_info to find the section instead of looking it
up by name.

LLD, for example, generates a .rela section that doesn't match the base
section name when we merge sections in a linker script for a binary
compiled with -ffunction-sections.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 tools/objtool/elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 84225679f96d..c1ba92abaa03 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -502,7 +502,7 @@ static int read_relas(struct elf *elf)
 		if (sec->sh.sh_type != SHT_RELA)
 			continue;
 
-		sec->base = find_section_by_name(elf, sec->name + 5);
+		sec->base = find_section_by_index(elf, sec->sh.sh_info);
 		if (!sec->base) {
 			WARN("can't find base section for rela section %s",
 			     sec->name);
-- 
2.27.0.212.ge8ba1cc988-goog

