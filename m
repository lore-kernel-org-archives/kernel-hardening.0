Return-Path: <SRS0=jBnk=HY=lists.openwall.com=kernel-hardening-return-20790-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27238C433DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:15:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4E5EA64E04
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:15:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E5EA64E04
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20790-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23990 invoked by uid 550); 22 Feb 2021 15:13:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23853 invoked from network); 22 Feb 2021 15:13:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d9B3We5q5jUlMWnG7lj9lYkkhNy18/R2y/H2GADaTPU=;
        b=J2kQ3vgVupU7YxCo469wvYqdCl6XIMH1CifuQ6lqo0nfRC2HC6qL/Hu7pPCFG3wVO1
         AJazkQBjIjycD2lZ2tVJtpvRGnBbWvjygTtzO12wMEmdOoqMIugwge6SiA/Mm5obxsQr
         xXpUUBL9z6E+LMv2K1hQSqXMteumLji9331jU57wo5EZTBponbsQF1QtOv3ibUuWxkHO
         N+SUraB7WMmiVjmFhmv9Mgg65zS+YNWiqPx1ByHJvn7Sdk/lEeXk5zzivUQgdj8w8ky2
         bFKG71ukVVa4UrLln4GZ/r1c+3Q5U1+p6+5vMMXCIASLnj7jIEcdH8m4E+FqvfH3U3Ey
         dkvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d9B3We5q5jUlMWnG7lj9lYkkhNy18/R2y/H2GADaTPU=;
        b=LqB/Qo818zlA8PTTcq3KDSavNYE6OUvTM0ibRkn0intiLJpTDojSqfCkj5gDywVZvr
         CvSawBTBJukOF58MpTLs7KLf7pWc/CgLI+hGXToEgV5mG1/rFDfvWQD9AGGMI9OIOVLt
         FxE9mpn6b7p9J/VUWXk1yx/n7TcX/3oQzVk2HD4DK0dupdMlhO7rpB/7ntjs5lVF5Uqh
         BKIB+qF+p2jeKULSrfsgf/15WuDCRSzWB6IfuRsGbqJlR1lwCN2uYv0xIdyN/IbQF+Uz
         7ZObulcNiuPXYeSqkwwypKmmeCW7HbWrft9T8ixh5iDi8mEu3CfgF6gkhygVmyLT0w0Q
         MzNQ==
X-Gm-Message-State: AOAM530YikP9N2koSuP3wKvcwfavfw4pKFrSNZYEQqUUVghDkAq4s6DW
	Tz0MLkPhS0fHA2wHhvV5YW8=
X-Google-Smtp-Source: ABdhPJxDf8AHZgB69k5I3nPeFatACq/O425spQLOXZFJX8APIsbJQSLk4JPCzbFKiTm033Oj1UXGFw==
X-Received: by 2002:a1c:1bc4:: with SMTP id b187mr20410506wmb.18.1614006774481;
        Mon, 22 Feb 2021 07:12:54 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Jessica Yu <jeyu@kernel.org>
Cc: Romain Perier <romain.perier@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 10/20] module: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:21 +0100
Message-Id: <20210222151231.22572-11-romain.perier@gmail.com>
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
 kernel/module.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index 4bf30e4b3eaa..46aad8e92a81 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2814,6 +2814,7 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
 	Elf_Sym *dst;
 	char *s;
 	Elf_Shdr *symsec = &info->sechdrs[info->index.sym];
+	ssize_t len;
 
 	/* Set up to point into init section. */
 	mod->kallsyms = mod->init_layout.base + info->mod_kallsyms_init_off;
@@ -2841,8 +2842,9 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
 			    mod->kallsyms->typetab[i];
 			dst[ndst] = src[i];
 			dst[ndst++].st_name = s - mod->core_kallsyms.strtab;
-			s += strlcpy(s, &mod->kallsyms->strtab[src[i].st_name],
+			len = strscpy(s, &mod->kallsyms->strtab[src[i].st_name],
 				     KSYM_NAME_LEN) + 1;
+			s += (len != -E2BIG) ? len : 0;
 		}
 	}
 	mod->core_kallsyms.num_symtab = ndst;

