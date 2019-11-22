Return-Path: <SRS0=v4BM=ZO=lists.openwall.com=kernel-hardening-return-17425-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA907C432C0
	for <kernel-hardening@archiver.kernel.org>; Fri, 22 Nov 2019 01:04:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 00F2A204FD
	for <kernel-hardening@archiver.kernel.org>; Fri, 22 Nov 2019 01:04:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hLEhYIK9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00F2A204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17425-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19943 invoked by uid 550); 22 Nov 2019 01:03:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19806 invoked from network); 22 Nov 2019 01:03:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yLXiD3mid8KH+vzWk5eeV9cjY9C1Tzvqr7ZpCV412RY=;
        b=hLEhYIK9flS41tAVD9Y1bn4Jt1UMYp7abrfy7AKnCXRyYLediN4w0OgzUjMgs0WAYW
         rzprgJVKdgJxLcSWW6iAsj72BUpuEc3wX6C78lTdcb6JdJgZL51SVGpEs6Ai7XrsXt+y
         5MF2Lwf3FHcIrCf8H9/NtYF9ZkNBOYzfwh3jk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yLXiD3mid8KH+vzWk5eeV9cjY9C1Tzvqr7ZpCV412RY=;
        b=MSZWjtGnKR4lI6AgYPduHzkUhDkXxkcgfLdQH/Yq7M+RHtr9rMDnjZ/QJ77HfE8Uaw
         p2NWiH6vW7ZcXMP5/OPv5Ny9GFd2pulyQzexv7P1Da3SlhXc6x0mEyn7DAWduNgcJrzn
         H+E1CK+qG2hccu78hgl5tutZ4z7uqQh10hUvOaEDkVPf8IDocV8c1s6ER00PXlJEWyQp
         eHtB3Txpu/wM5VhPGfCZ+q2pSChMrTHhykutVaVMcvIXmFtacUvUbTm0B23gcGCLkagL
         HPJEHDP2Ytt+dARv7D7/7r3dET2u6yyIXVKuPD95rKF4FJAp6M1n/KJSQiSZTdEMYCoB
         CnCg==
X-Gm-Message-State: APjAAAVGokNohGJ7WfmCFHo3HwaESKFUMAD6/ri6CGi/HwNSnQcW/Er9
	ZPynaFXr6sf1u0K4/Dr4y0Lamg==
X-Google-Smtp-Source: APXvYqz/gdanKWHRL5lO19w7tDA97M8iQ7EDdo45/bL9HF9nQFFMvAJl5aGHe6J3GPDcKfidzkpnhw==
X-Received: by 2002:a63:4705:: with SMTP id u5mr12607717pga.7.1574384623397;
        Thu, 21 Nov 2019 17:03:43 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>,
	=?UTF-8?q?Jo=C3=A3o=20Moreira?= <joao.moreira@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Stephan Mueller <smueller@chronox.de>,
	x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v6 0/8] crypto: x86: Fix indirect function call casts
Date: Thu, 21 Nov 2019 17:03:26 -0800
Message-Id: <20191122010334.12081-1-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

v6:
- minimize need for various internal casts (ebiggers)
- clarify comments (ebiggers)
- switch all context pointers to const (ebiggers)
v5: https://lore.kernel.org/lkml/20191113182516.13545-1-keescook@chromium.org
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

 arch/x86/crypto/aesni-intel_asm.S          |  8 +--
 arch/x86/crypto/aesni-intel_glue.c         | 45 ++++++-------
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 74 ++++++++++-----------
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 72 +++++++++------------
 arch/x86/crypto/camellia_glue.c            | 45 +++++++------
 arch/x86/crypto/cast6_avx_glue.c           | 68 +++++++++-----------
 arch/x86/crypto/glue_helper.c              | 23 ++++---
 arch/x86/crypto/serpent_avx2_glue.c        | 65 +++++++++----------
 arch/x86/crypto/serpent_avx_glue.c         | 63 +++++++++---------
 arch/x86/crypto/serpent_sse2_glue.c        | 30 +++++----
 arch/x86/crypto/sha1_ssse3_asm.S           | 10 ++-
 arch/x86/crypto/sha1_ssse3_glue.c          | 64 ++++++++----------
 arch/x86/crypto/sha256-ssse3-asm.S         |  4 +-
 arch/x86/crypto/sha256_ssse3_glue.c        | 34 +++++-----
 arch/x86/crypto/sha512-ssse3-asm.S         |  4 +-
 arch/x86/crypto/sha512_ssse3_glue.c        | 31 +++++----
 arch/x86/crypto/twofish_avx_glue.c         | 75 ++++++++++------------
 arch/x86/crypto/twofish_glue_3way.c        | 37 ++++++-----
 arch/x86/include/asm/crypto/camellia.h     | 63 +++++++++---------
 arch/x86/include/asm/crypto/glue_helper.h  | 18 ++----
 arch/x86/include/asm/crypto/serpent-avx.h  | 20 +++---
 arch/x86/include/asm/crypto/serpent-sse2.h | 28 ++++----
 arch/x86/include/asm/crypto/twofish.h      | 19 +++---
 crypto/cast6_generic.c                     | 18 +++---
 crypto/serpent_generic.c                   |  6 +-
 include/crypto/cast6.h                     |  4 +-
 include/crypto/serpent.h                   |  4 +-
 include/crypto/xts.h                       |  2 -
 28 files changed, 446 insertions(+), 488 deletions(-)

-- 
2.17.1

