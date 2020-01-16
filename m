Return-Path: <SRS0=pjnT=3F=lists.openwall.com=kernel-hardening-return-17559-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839B8C32771
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 01:24:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D59042467E
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 01:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Necsxt4U"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D59042467E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17559-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3677 invoked by uid 550); 16 Jan 2020 01:24:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3643 invoked from network); 16 Jan 2020 01:24:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ztBntqcbRDpikloUpN2F0KWZjGouqnztxdMWfXHrneU=;
        b=Necsxt4UM069dJn7UjGMxHP4B4Sb0ubZNcm+nTrWn7TXh6RK8XLGxhuR6iy+4r9KvX
         HtSp4KGSa43ZdYKf5GtwMSyGz/DsjpqSBBps9cJKtCKviSO7uwPrv9LibT7DWL71ALGF
         w4jbfha23PQIwPGtO/NJIuyW3VbmoDRbPfxSU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ztBntqcbRDpikloUpN2F0KWZjGouqnztxdMWfXHrneU=;
        b=s3m/Mx6Z0+lj6dF7N3yeuZk+0p0oJAmnMeA2oy2vxobp/Yqcjg5090vZfs1RDU85hw
         gVxQ8UpD82kLoOqjkOHv53tTJlszq8HnV9LIBz4yb20E+ITNKzGQ4FfffZlokBFEQfpZ
         pST7ujAZ9Npej4hPBqqvUPFLH5eEMR5CL+XusUZ5NPseCYrnm1oKbANzQ8/aaQFeBewn
         mOMrjsxkThEGPEad0520YoAkw81SWIKkFguXX4cOVPgLoBWGEyC4IhsUcIiu2J63s1zJ
         5l8aivckIpp85btvwrgNjJwaBfxevcioO130lwPMlo9VbOqctc+kk8hA5x79Cv5Xb2S+
         km2Q==
X-Gm-Message-State: APjAAAVYz3bDEqXwJLHPxMkR1vF94OJd5B3xsw8sQW4USxvUQh9qc5D8
	yqfxkFHYazJVZPcHau+CTVvtkg==
X-Google-Smtp-Source: APXvYqyEY91Ps4j5Unu6q/04cKkVouK2+nDVdzN3lDLdlCCZsHk9TuTlpS854xybBZZK2RoncaRauQ==
X-Received: by 2002:a63:7843:: with SMTP id t64mr36298336pgc.144.1579137860501;
        Wed, 15 Jan 2020 17:24:20 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Elena Petrova <lenaptr@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	syzkaller@googlegroups.com
Subject: [PATCH v3 0/6] ubsan: Split out bounds checker
Date: Wed, 15 Jan 2020 17:23:15 -0800
Message-Id: <20200116012321.26254-1-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This splits out the bounds checker so it can be individually used. This
is expected to be enabled in Android and hopefully for syzbot. Includes
LKDTM tests for behavioral corner-cases (beyond just the bounds checker),
and adjusts ubsan and kasan slightly for correct panic handling.

-Kees

v3:
 - use UBSAN menuconfig (will)
 - clean up ubsan report titles (dvyukov)
 - fix ubsan/kasan "panic" handling
 - add Acks
v2: https://lore.kernel.org/lkml/20191121181519.28637-1-keescook@chromium.org
v1: https://lore.kernel.org/lkml/20191120010636.27368-1-keescook@chromium.org


Kees Cook (6):
  ubsan: Add trap instrumentation option
  ubsan: Split "bounds" checker from other options
  lkdtm/bugs: Add arithmetic overflow and array bounds checks
  ubsan: Check panic_on_warn
  kasan: Unset panic_on_warn before calling panic()
  ubsan: Include bug type in report header

 drivers/misc/lkdtm/bugs.c  | 75 ++++++++++++++++++++++++++++++++++++++
 drivers/misc/lkdtm/core.c  |  3 ++
 drivers/misc/lkdtm/lkdtm.h |  3 ++
 lib/Kconfig.ubsan          | 49 +++++++++++++++++++++----
 lib/Makefile               |  2 +
 lib/ubsan.c                | 47 +++++++++++++-----------
 mm/kasan/report.c          | 10 ++++-
 scripts/Makefile.ubsan     | 16 ++++++--
 8 files changed, 172 insertions(+), 33 deletions(-)

-- 
2.20.1

