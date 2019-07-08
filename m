Return-Path: <SRS0=zLyU=VF=lists.openwall.com=kernel-hardening-return-16384-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC1DC606C6
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2019 17:49:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 97D102189F
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2019 17:49:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Cp2JMiqR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97D102189F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16384-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26189 invoked by uid 550); 8 Jul 2019 17:49:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26165 invoked from network); 8 Jul 2019 17:49:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u3wADtOhWERBIwfgOKqVInl3i4gu5vwcVNjYQ611JUc=;
        b=Cp2JMiqRMbHHc8yVRj5gwNVXKSXDh307ZJxdfhj5m5wZqxjCcjOB1cq6Hoydsv5OFo
         14RVaNEV9QQ8pm4bi7zWlnTUgO/o0R9Nb9nSi+ekxv0wRSSnm/Ntf2nDLjSDt3fpc+ag
         If9clYeN+kLlkea7uIf7yLK5X+UGvuATfkHc4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u3wADtOhWERBIwfgOKqVInl3i4gu5vwcVNjYQ611JUc=;
        b=K2RFYeIOSNiZVeXZLy2XRTynjxSaOawkhujKLBK0egY66t7gZXT9LLxJfp61q/0fn8
         4wv5EIIoXyAfPPduOPswD2kTchBmZ3DY347QTkIuEHMGVe7dclq8w9vy3r1+Ao0ODv1o
         OVWMCG7VhzUp+eCljAK+PNcNZe8+VcIv475vSn/Cslh/5f1woKpn3BmKp5qVE1QfEQhx
         1keUqNdFvQvIvYQTsHR5ABACOkYoBfPtrodNORqp+BGJ3QYuzrExw9+4ILrdTpdqIL2A
         6wxBjADalfgWdCaaELeS1JMbXtygUkJpOgMlSZo7KUVY9NAQSzzFjfTmiYTX9OEsBGUY
         iQiQ==
X-Gm-Message-State: APjAAAXfyRkMcnOVwvAbf0SACQjhNqDfqUFuizEZpvPtrThDwucnFZkq
	6sFgZzgCDmFJzLgQ4yBS4+n3H6pBTgU=
X-Google-Smtp-Source: APXvYqx5LipVNdbKqMBoKjNn4lRTatM0sZZZf8RlaGam+sYAQe4c/KcA1glvKLTNDdd17g2N+PzrMw==
X-Received: by 2002:a17:902:6b02:: with SMTP id o2mr24590139plk.99.1562608164453;
        Mon, 08 Jul 2019 10:49:24 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	keescook@chromium.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Alok Kataria <akataria@vmware.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>,
	Pavel Machek <pavel@ucw.cz>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Garnier <thgarnie@chromium.org>,
	Nadav Amit <namit@vmware.com>,
	Jann Horn <jannh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Feng Tang <feng.tang@intel.com>,
	Maran Wilson <maran.wilson@oracle.com>,
	Enrico Weigelt <info@metux.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexios Zavras <alexios.zavras@intel.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-pm@vger.kernel.org
Subject: [PATCH v8 00/11] x86: PIE support to extend KASLR randomization
Date: Mon,  8 Jul 2019 10:48:53 -0700
Message-Id: <20190708174913.123308-1-thgarnie@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Splitting the previous serie in two. This part contains assembly code
changes required for PIE but without any direct dependencies with the
rest of the patchset.

Changes:
 - patch v8 (assembly):
   - Fix issues in crypto changes (thanks to Eric Biggers).
   - Remove unnecessary jump table change.
   - Change author and signoff to chromium email address.
 - patch v7 (assembly):
   - Split patchset and reorder changes.
 - patch v6:
   - Rebase on latest changes in jump tables and crypto.
   - Fix wording on couple commits.
   - Revisit checkpatch warnings.
   - Moving to @chromium.org.
 - patch v5:
   - Adapt new crypto modules for PIE.
   - Improve per-cpu commit message.
   - Fix xen 32-bit build error with .quad.
   - Remove extra code for ftrace.
 - patch v4:
   - Simplify early boot by removing global variables.
   - Modify the mcount location script for __mcount_loc intead of the address
     read in the ftrace implementation.
   - Edit commit description to explain better where the kernel can be located.
   - Streamlined the testing done on each patch proposal. Always testing
     hibernation, suspend, ftrace and kprobe to ensure no regressions.
 - patch v3:
   - Update on message to describe longer term PIE goal.
   - Minor change on ftrace if condition.
   - Changed code using xchgq.
 - patch v2:
   - Adapt patch to work post KPTI and compiler changes
   - Redo all performance testing with latest configs and compilers
   - Simplify mov macro on PIE (MOVABS now)
   - Reduce GOT footprint
 - patch v1:
   - Simplify ftrace implementation.
   - Use gcc mstack-protector-guard-reg=%gs with PIE when possible.
 - rfc v3:
   - Use --emit-relocs instead of -pie to reduce dynamic relocation space on
     mapped memory. It also simplifies the relocation process.
   - Move the start the module section next to the kernel. Remove the need for
     -mcmodel=large on modules. Extends module space from 1 to 2G maximum.
   - Support for XEN PVH as 32-bit relocations can be ignored with
     --emit-relocs.
   - Support for GOT relocations previously done automatically with -pie.
   - Remove need for dynamic PLT in modules.
   - Support dymamic GOT for modules.
 - rfc v2:
   - Add support for global stack cookie while compiler default to fs without
     mcmodel=kernel
   - Change patch 7 to correctly jump out of the identity mapping on kexec load
     preserve.

These patches make some of the changes necessary to build the kernel as
Position Independent Executable (PIE) on x86_64. Another patchset will
add the PIE option and larger architecture changes.

The patches:
 - 1, 3-11: Change in assembly code to be PIE compliant.
 - 2: Add a new _ASM_MOVABS macro to fetch a symbol address generically.

diffstat:
 crypto/aegis128-aesni-asm.S         |    6 +-
 crypto/aegis128l-aesni-asm.S        |    8 +--
 crypto/aegis256-aesni-asm.S         |    6 +-
 crypto/aes-x86_64-asm_64.S          |   45 ++++++++++------
 crypto/aesni-intel_asm.S            |    8 +--
 crypto/aesni-intel_avx-x86_64.S     |    3 -
 crypto/camellia-aesni-avx-asm_64.S  |   42 +++++++--------
 crypto/camellia-aesni-avx2-asm_64.S |   44 ++++++++--------
 crypto/camellia-x86_64-asm_64.S     |    8 +--
 crypto/cast5-avx-x86_64-asm_64.S    |   50 ++++++++++--------
 crypto/cast6-avx-x86_64-asm_64.S    |   44 +++++++++-------
 crypto/des3_ede-asm_64.S            |   96 ++++++++++++++++++++++++------------
 crypto/ghash-clmulni-intel_asm.S    |    4 -
 crypto/glue_helper-asm-avx.S        |    4 -
 crypto/glue_helper-asm-avx2.S       |    6 +-
 crypto/morus1280-avx2-asm.S         |    4 -
 crypto/morus1280-sse2-asm.S         |    8 +--
 crypto/morus640-sse2-asm.S          |    6 +-
 crypto/sha256-avx2-asm.S            |   18 ++++--
 entry/entry_64.S                    |   16 ++++--
 include/asm/alternative.h           |    6 +-
 include/asm/asm.h                   |    1 
 include/asm/paravirt_types.h        |   25 +++++++--
 include/asm/pm-trace.h              |    2 
 include/asm/processor.h             |    6 +-
 kernel/acpi/wakeup_64.S             |   31 ++++++-----
 kernel/head_64.S                    |   16 +++---
 kernel/relocate_kernel_64.S         |    2 
 power/hibernate_asm_64.S            |    4 -
 29 files changed, 306 insertions(+), 213 deletions(-)

Patchset is based on next-20190708.


