Return-Path: <SRS0=UCoi=VJ=lists.openwall.com=kernel-hardening-return-16423-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE2A8C742BA
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 12:33:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 19557216E3
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 12:32:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="fvwEbnpZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19557216E3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16423-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5558 invoked by uid 550); 12 Jul 2019 12:32:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5539 invoked from network); 12 Jul 2019 12:32:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562934761;
	bh=m4atKtWxwNsdWMmPKBnGNNVfQ4ouO8QtM5/ynhUxPw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvwEbnpZOXvEAOAsvJ/Wju/4jtWe/q/M+lwTnYIzEuTqPkwhbFAONwccFfeZRbiSJ
	 ND6gNYBdfUHaNYiHLLzZ6MsnPcWLTocQrse7DClDaKrwUQuf8UUIoySp9VPv48T/jK
	 Z6Pzt+sijUsbQz04Bq6fORhqpudWof0Vp35VtkaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Kees Cook <keescook@chromium.org>,
	Florian Weimer <fweimer@redhat.com>,
	Jann Horn <jannh@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5.2 22/61] Documentation/admin: Remove the vsyscall=native documentation
Date: Fri, 12 Jul 2019 14:19:35 +0200
Message-Id: <20190712121621.837838383@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Lutomirski <luto@kernel.org>

commit d974ffcfb7447db5f29a4b662a3eaf99a4e1109e upstream.

The vsyscall=native feature is gone -- remove the docs.

Fixes: 076ca272a14c ("x86/vsyscall/64: Drop "native" vsyscalls")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: stable@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lkml.kernel.org/r/d77c7105eb4c57c1a95a95b6a5b8ba194a18e764.1561610354.git.luto@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/admin-guide/kernel-parameters.txt |    6 ------
 1 file changed, 6 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5102,12 +5102,6 @@
 			emulate     [default] Vsyscalls turn into traps and are
 			            emulated reasonably safely.
 
-			native      Vsyscalls are native syscall instructions.
-			            This is a little bit faster than trapping
-			            and makes a few dynamic recompilers work
-			            better than they would in emulation mode.
-			            It also makes exploits much easier to write.
-
 			none        Vsyscalls don't work at all.  This makes
 			            them quite hard to use for exploits but
 			            might break your system.


