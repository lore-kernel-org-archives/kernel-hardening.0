Return-Path: <SRS0=9anR=AD=lists.openwall.com=kernel-hardening-return-19036-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F27EC433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 19:32:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BF84520776
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 19:32:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DooZtDOK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF84520776
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19036-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19777 invoked by uid 550); 22 Jun 2020 19:32:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19574 invoked from network); 22 Jun 2020 19:32:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dNG40zysheY5oB4//u6Wgw3XPF1EPVf4SWmTm1L7IBk=;
        b=DooZtDOKEbuL4Lmq0EjvgBqtOhkWAVzaD4OoBh35ywAVTh+8jjPlVrIL5pPZ1PCtVX
         +7Qt9x93Bf6jWHUSYtMRAfTERsAnE8XlcUxfZu12iJaw18sHA1rR1SQN279dsa6bQ3wr
         FyhdWobCP/rLa3NIoSLGX9JY/N9OLOfKVoKSc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dNG40zysheY5oB4//u6Wgw3XPF1EPVf4SWmTm1L7IBk=;
        b=ttSzRQe/W3G6vCpYsTTca3T5Vqs/3vnFHUt2OBkNk6Z2EDyhnMAeBepyPTcRqPeGCp
         JoYd3JO6kC8MIsYjCo90AfATQmf3i17+DC3ZJCtts5zE1RfdYPxSTKDv+GqdG4jKYyTo
         KEmNWvGjqjjzyz1r9pFtw5AeNTZIdG3s5U/BomVD341T9mOsFfoQF2f6Bb3ymW9ynFTu
         8TBq7qPGqX0G21bQ2Ds6+wMz1fXoUrEhkQFlRrBVgIvpd++hAkTfpdDalo8m7D7MhSV9
         RT51qwjhdei43sVb2hTwq+tcGIaW40zxIi0weFI9JBNGvYzJE1reCSuSkbzXBpweJ1iV
         1v4Q==
X-Gm-Message-State: AOAM530k67uQNTRttcJerSI4X5+byciYsiaMc7Yxt1U5LmgGf6AYfMJq
	V48eDxUSjlm//PHh5Dd7OSxGQQ==
X-Google-Smtp-Source: ABdhPJwzvg0AysINBE9mrBB80x8GFaUJiCmnxanMRMBRbZ6JfPpnLr9CRvHSZ2l6hQg9n7Rg0F4HWg==
X-Received: by 2002:a17:90a:9f81:: with SMTP id o1mr19808289pjp.139.1592854313385;
        Mon, 22 Jun 2020 12:31:53 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/5] Optionally randomize kernel stack offset each syscall
Date: Mon, 22 Jun 2020 12:31:41 -0700
Message-Id: <20200622193146.2985288-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v4:
- rebase to v5.8-rc2
v3: https://lore.kernel.org/lkml/20200406231606.37619-1-keescook@chromium.org/
v2: https://lore.kernel.org/lkml/20200324203231.64324-1-keescook@chromium.org/
rfc: https://lore.kernel.org/kernel-hardening/20190329081358.30497-1-elena.reshetova@intel.com/

Hi,

This is a continuation and refactoring of Elena's earlier effort to add
kernel stack base offset randomization. In the time since the previous
discussions, two attacks[1][2] were made public that depended on stack
determinism, so we're no longer in the position of "this is a good idea
but we have no examples of attacks". :)

Earlier discussions also devolved into debates on entropy sources, which
is mostly a red herring, given the already low entropy available due
to stack size. Regardless, entropy can be changed/improved separately
from this series as needed.

Earlier discussions also got stuck debating how much syscall overhead
was too much, but this is also a red herring since the feature itself
needs to be selectable at boot with no cost for those that don't want it:
this is solved here with static branches.

So, here is an improved version, made as arch-agnostic as possible,
with usage added for x86 and arm64. It also includes some small static
branch clean ups, and addresses some surprise performance issues due to
the stack canary[3].

Note that for v5.8, this depends on this fix (due to how x86 changed its
stack protector removal for syscall entry):
https://lore.kernel.org/lkml/202006221201.3641ED037E@keescook/

Thanks!

-Kees

[1] https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html
[2] https://repositorio-aberto.up.pt/bitstream/10216/125357/2/374717.pdf
[3] https://lore.kernel.org/lkml/202003281520.A9BFF461@keescook/


Kees Cook (5):
  jump_label: Provide CONFIG-driven build state defaults
  init_on_alloc: Unpessimize default-on builds
  stack: Optionally randomize kernel stack offset each syscall
  x86/entry: Enable random_kstack_offset support
  arm64: entry: Enable random_kstack_offset support

 Makefile                         |  4 ++++
 arch/Kconfig                     | 23 ++++++++++++++++++
 arch/arm64/Kconfig               |  1 +
 arch/arm64/kernel/Makefile       |  5 ++++
 arch/arm64/kernel/syscall.c      | 10 ++++++++
 arch/x86/Kconfig                 |  1 +
 arch/x86/entry/common.c          | 11 +++++++++
 include/linux/jump_label.h       | 19 +++++++++++++++
 include/linux/mm.h               | 18 +++++---------
 include/linux/randomize_kstack.h | 40 ++++++++++++++++++++++++++++++++
 init/main.c                      | 23 ++++++++++++++++++
 mm/page_alloc.c                  | 12 ++--------
 12 files changed, 145 insertions(+), 22 deletions(-)
 create mode 100644 include/linux/randomize_kstack.h

-- 
2.25.1

