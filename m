Return-Path: <SRS0=F8HX=AF=lists.openwall.com=kernel-hardening-return-19090-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCCD3C433E1
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 12:34:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2F23E20CC7
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 12:34:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F23E20CC7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19090-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5379 invoked by uid 550); 24 Jun 2020 12:34:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5359 invoked from network); 24 Jun 2020 12:34:16 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r8hAW61/4BUI+NbyFnYc6YqQQjo8d8HK1rSbMU2IkRk=;
        b=fhvJakr8XLfAZ/g9+8a3wYsg9pu0IsKnG+UbrEWfYy03yB668XumGPJvQgQy2CSB05
         73gPaHnj5SXw5IsfUSkQQcm9cUvOAbGiDoqmMgM5ZVp4HBdWfSifrSPxtJrMjsiGSpHv
         1Fj8xFrmCa2/Ud48jCXnauFCi0YaZfyxL/dg9H/Tps0g8vF4QV47H5hSWtbP+w8XQOyV
         /gJ0fUuZJ6TFBNQWBxb2oAVyE0VYlqm87QANGslV3Ef+sSEIfamPgG62QTdNj8Dwpfdt
         GdhPxyqK2HalOEAfLls4Ss7ADpDXZEVRE/VUkXeFwPtzjh9i1Qju8J93YnHtWbDh6dqP
         CnPQ==
X-Gm-Message-State: AOAM532YDq7y+x2yeQgyKXx8mQc0Up2T4R3I5pmZzUjhYoDPbUzEajIA
	qb+MWuXzC7aq1REyBnqr/4w=
X-Google-Smtp-Source: ABdhPJxPh8KCe1nlxIC9hfI7A611S0zDh6pUHr/hn9DXDH26nDPy4DCeItaOwQUW8SJpgZNlzgTiJw==
X-Received: by 2002:aed:25a2:: with SMTP id x31mr24822436qtc.96.1593002044717;
        Wed, 24 Jun 2020 05:34:04 -0700 (PDT)
From: Alexander Popov <alex.popov@linux.com>
To: Kees Cook <keescook@chromium.org>,
	Jann Horn <jannh@google.com>,
	Emese Revfy <re.emese@gmail.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Thiago Jung Bauermann <bauerman@linux.ibm.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Jessica Yu <jeyu@kernel.org>,
	Sven Schnelle <svens@stackframe.org>,
	Iurii Zaikin <yzaikin@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Collingbourne <pcc@google.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Alexander Monakov <amonakov@ispras.ru>,
	Mathias Krause <minipli@googlemail.com>,
	PaX Team <pageexec@freemail.hu>,
	Brad Spengler <spender@grsecurity.net>,
	Laura Abbott <labbott@redhat.com>,
	Florian Weimer <fweimer@redhat.com>,
	Alexander Popov <alex.popov@linux.com>,
	kernel-hardening@lists.openwall.com,
	linux-kbuild@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	gcc@gcc.gnu.org
Cc: notify@kernel.org
Subject: [PATCH v2 1/5] gcc-plugins/stackleak: Don't instrument itself
Date: Wed, 24 Jun 2020 15:33:26 +0300
Message-Id: <20200624123330.83226-2-alex.popov@linux.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200624123330.83226-1-alex.popov@linux.com>
References: <20200624123330.83226-1-alex.popov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no need to try instrumenting functions in kernel/stackleak.c.
Otherwise that can cause issues if the cleanup pass of stackleak gcc plugin
is disabled.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
Acked-by: Kees Cook <keescook@chromium.org>
---
 kernel/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/Makefile b/kernel/Makefile
index f3218bc5ec69..155b5380500a 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -125,6 +125,7 @@ obj-$(CONFIG_WATCH_QUEUE) += watch_queue.o
 
 obj-$(CONFIG_SYSCTL_KUNIT_TEST) += sysctl-test.o
 
+CFLAGS_stackleak.o += $(DISABLE_STACKLEAK_PLUGIN)
 obj-$(CONFIG_GCC_PLUGIN_STACKLEAK) += stackleak.o
 KASAN_SANITIZE_stackleak.o := n
 KCSAN_SANITIZE_stackleak.o := n
-- 
2.25.4

