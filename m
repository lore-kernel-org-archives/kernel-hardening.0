Return-Path: <SRS0=vdam=ZF=lists.openwall.com=kernel-hardening-return-17347-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27788C432C3
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Nov 2019 18:25:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B6639206EE
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Nov 2019 18:25:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gAWOwtuF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6639206EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17347-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32150 invoked by uid 550); 13 Nov 2019 18:25:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32109 invoked from network); 13 Nov 2019 18:25:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8pwxLXS3yTtk2YEMUUCjQyP203hwLsDnQtk6QOIH+hQ=;
        b=gAWOwtuF3lIquOQlfbbubJi3yzRbCWqpkHyHpURP0xiyYdIGDhL2M6a0HVtr6b0Nee
         iacrhyDyGnXJrOQU5Ea08GGqdbt5SzT6nFBJ478ifj6tfAWTrf9E2dhS4CHCo0FG8GrC
         H4ilLZIILSpwzFdlRVRfzIEJreuOREzxlUFVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8pwxLXS3yTtk2YEMUUCjQyP203hwLsDnQtk6QOIH+hQ=;
        b=novNx5HJkgTqrCVrsSw5J9ICBVeBnvq4owfuMu8oNX7t4k24zg9ttz6Q12bnDqjWDA
         S/JOPUnbPFLbH5XA3JTBaj8IM/ZIzJwdwKxTMJmVNY+c04Zk7ONPzIWIXuFnREpjFoJw
         slsYMt4zY4u9i9CMYYVOw5jJceW0AJs7jd/mLRuLXn4ezpLb9ph3N8eXH2DeutPDnjha
         Y6YmZWF5mCHDzVuxmHLsFukd5D2j7f5E3u5PelcVPtXhjYEMaQKSv7T050WQSZ4cglw0
         TJgY1yIegJXVzmJxgVLfSfnSf5ME2SlCEFYYaBqTIAOcZZK8ZIWjSgpeYQFD93XrXlwD
         b78w==
X-Gm-Message-State: APjAAAVdDnA2QrfLRKku9+LZqnV4Zhk1QquLhyOXj9BXmpDGdc3YK+GM
	nAkY3Pb4TcqM2LBg5/cT56utEg==
X-Google-Smtp-Source: APXvYqzFyWMtneWFouUDOfR0m5QsWLsUNEWASLVCp8b8qDMIjhCm38Rrg4qYd8K/ZGfuwpWmWeHLcw==
X-Received: by 2002:a17:902:8a8b:: with SMTP id p11mr5284252plo.152.1573669521942;
        Wed, 13 Nov 2019 10:25:21 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>,
	=?UTF-8?q?Jo=C3=A3o=20Moreira?= <joao.moreira@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Stephan Mueller <smueller@chronox.de>,
	x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v5 0/8] crypto: x86: Fix indirect function call casts
Date: Wed, 13 Nov 2019 10:25:08 -0800
Message-Id: <20191113182516.13545-1-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

v5:
- remove macros entirely and switch to declarations with common prototypes
v4: https://lore.kernel.org/lkml/20191111214552.36717-1-keescook@chromium.org
v3: https://lore.kernel.org/lkml/20190507161321.34611-1-keescook@chromium.org

Hi,

Now that Clang's CFI has been fixed to do the right thing with extern
asm functions, this patch series is much simplified. Repeating patch
1's commit log here:

    The crypto glue performed function prototype casting to make indirect
    calls to assembly routines. Instead of performing casts at the call
    sites (which trips Control Flow Integrity prototype checking), switch
    each prototype to a common standard set of arguments which allows the
    incremental removal of the existing macros. In order to keep pointer
    math unchanged, internal casting between u128 pointers and u8 pointers
    is added.

With this series (and the Clang LTO+CFI series) I am able to boot x86
with all crytpo selftests enabled without tripping any CFI checks.

Thanks!

-Kees

Kees Cook (8):
  crypto: x86/glue_helper: Regularize function prototypes
  crypto: x86/serpent: Remove glue function macros usage
  crypto: x86/camellia: Remove glue function macro usage
  crypto: x86/twofish: Remove glue function macro usage
  crypto: x86/cast6: Remove glue function macro usage
  crypto: x86/aesni: Remove glue function macro usage
  crypto: x86/glue_helper: Remove function prototype cast helpers
  crypto, x86/sha: Eliminate casts on asm implementations

 arch/x86/crypto/aesni-intel_glue.c         | 45 ++++++-------
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 74 ++++++++++-----------
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 74 ++++++++++-----------
 arch/x86/crypto/camellia_glue.c            | 45 +++++++------
 arch/x86/crypto/cast6_avx_glue.c           | 70 ++++++++++----------
 arch/x86/crypto/glue_helper.c              | 13 ++--
 arch/x86/crypto/serpent_avx2_glue.c        | 65 +++++++++---------
 arch/x86/crypto/serpent_avx_glue.c         | 72 ++++++++++----------
 arch/x86/crypto/serpent_sse2_glue.c        | 31 +++++----
 arch/x86/crypto/sha1_ssse3_glue.c          | 61 +++++++----------
 arch/x86/crypto/sha256_ssse3_glue.c        | 31 ++++-----
 arch/x86/crypto/sha512_ssse3_glue.c        | 28 ++++----
 arch/x86/crypto/twofish_avx_glue.c         | 76 ++++++++++------------
 arch/x86/crypto/twofish_glue_3way.c        | 38 ++++++-----
 arch/x86/include/asm/crypto/camellia.h     | 64 ++++++++----------
 arch/x86/include/asm/crypto/glue_helper.h  | 11 +---
 arch/x86/include/asm/crypto/serpent-avx.h  | 36 +++++-----
 arch/x86/include/asm/crypto/serpent-sse2.h |  6 +-
 arch/x86/include/asm/crypto/twofish.h      | 20 +++---
 crypto/cast6_generic.c                     |  6 +-
 crypto/serpent_generic.c                   |  6 +-
 include/crypto/cast6.h                     |  4 +-
 include/crypto/serpent.h                   |  4 +-
 include/crypto/xts.h                       |  2 -
 24 files changed, 409 insertions(+), 473 deletions(-)

-- 
2.17.1

