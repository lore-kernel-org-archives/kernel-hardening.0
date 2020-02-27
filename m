Return-Path: <SRS0=4EKJ=4P=lists.openwall.com=kernel-hardening-return-17978-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BAC5C4BA2D
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Feb 2020 18:50:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BFE13246C6
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Feb 2020 18:50:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="M2bJFwGR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFE13246C6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17978-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3772 invoked by uid 550); 27 Feb 2020 18:49:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3701 invoked from network); 27 Feb 2020 18:49:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uio9MFsHXugpSMEN2c2VbCCKbgwswLA7MQ9KMJphrpM=;
        b=M2bJFwGRUurTAq2OXqUC83zEYHOro2pmObSwZO6Bo+WiLoXHkYK1zpCQs6116+4JSv
         uGBJpDdGelG5RJ4fgFLQViDWAnSVRj/IlZJnNp11SqCTTBtNIN/T9W+56EdwZbVGngSB
         VI85KVSzpvpJNyvsflH49hczSrHzddFNtjqT8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uio9MFsHXugpSMEN2c2VbCCKbgwswLA7MQ9KMJphrpM=;
        b=M0ihByHMi/2yYUuDlxXH4n34HSZtaLyFoODxOr2sb3yhCojw23QXMGkegCQpxPreea
         noG+srpXUT+DM7pac3VtQNPIpovUrNK41FTWVaKLfiq/A8T5UvZfdbOP7eNcLWUfgQzx
         Gpg4zSdHrWbQ4z5mGQE6Q1DyR/6vsiVl26HEUn9Ybm20Bv2hRn4L54MZR60DLFoa31AQ
         W191UyulYFH6J+hMSKEVLF1ljTlfrZi3/qGVll9MeKwBBWcv7LNLgAePTKAtbNW2Vbab
         ZaLjZAM8gqLVpEjGPjlznzHejZRSX3AYmY2dHUmuLaIJ6r8YId679TLC1WvzP7CBi5/3
         QlHA==
X-Gm-Message-State: APjAAAU2rZTbNLaQEALVthc7ddDFjTeyhFlvqGxdNwGCXyqStQ5sJXKO
	+7y16GrPiebEG9TNTq9rloFGag==
X-Google-Smtp-Source: APXvYqzjFLlBwzUnS9Buay5SU6EClRdGPy50Ngz3GJVvxZkvUCu0e9OzvgVYH7vICIR7BSm10X7QoA==
X-Received: by 2002:a62:e414:: with SMTP id r20mr371760pfh.154.1582829368003;
        Thu, 27 Feb 2020 10:49:28 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Elena Petrova <lenaptr@google.com>,
	Andrey Konovalov <andreyknvl@google.com>,
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
Subject: [PATCH v4 0/6] ubsan: Split out bounds checker
Date: Thu, 27 Feb 2020 10:49:15 -0800
Message-Id: <20200227184921.30215-1-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This splits out the bounds checker so it can be individually used. This
is enabled in Android and hopefully for syzbot. Includes LKDTM tests for
behavioral corner-cases (beyond just the bounds checker), and adjusts
ubsan and kasan slightly for correct panic handling.

-Kees

v4:
 - use hyphenated bug class names (andreyknvl)
 - add Acks
v3: https://lore.kernel.org/lkml/20200116012321.26254-1-keescook@chromium.org
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

