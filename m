Return-Path: <SRS0=/nTs=VI=lists.openwall.com=kernel-hardening-return-16405-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5982FC74A35
	for <kernel-hardening@archiver.kernel.org>; Thu, 11 Jul 2019 13:06:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A613021019
	for <kernel-hardening@archiver.kernel.org>; Thu, 11 Jul 2019 13:06:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="W+eYmai1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A613021019
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16405-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3442 invoked by uid 550); 11 Jul 2019 13:06:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3424 invoked from network); 11 Jul 2019 13:06:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562850384;
	bh=bI7P/JiKe8i673RB+8uZZ7KGdqMIu1kiJ+67svzY7XE=;
	h=Subject:To:Cc:From:Date:From;
	b=W+eYmai1z9AvJcKxW1HVRetgL5L1q1qDCM63Hd+vYxtdr9MddSICrLypt/OB4v3oV
	 xCnTrBn+nE9xuqBr/OouyXrLEhnBaKTSIWZhn43lBhcZ6/JcFbzXsA+GDeSDQKYupS
	 2d9HFxyZFiKoK4f2SYpq623LWsFxL7XRVGcL3gZc=
Subject: Patch "Documentation/admin: Remove the vsyscall=native documentation" has been added to the 4.19-stable tree
To: bp@alien8.de,fweimer@redhat.com,gregkh@linuxfoundation.org,jannh@google.com,keescook@chromium.org,kernel-hardening@lists.openwall.com,luto@kernel.org,peterz@infradead.org,tglx@linutronix.de
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 11 Jul 2019 13:45:25 +0200
Message-ID: <156284552510181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    Documentation/admin: Remove the vsyscall=native documentation

to the 4.19-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     documentation-admin-remove-the-vsyscall-native-documentation.patch
and it can be found in the queue-4.19 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From d974ffcfb7447db5f29a4b662a3eaf99a4e1109e Mon Sep 17 00:00:00 2001
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 26 Jun 2019 21:45:02 -0700
Subject: Documentation/admin: Remove the vsyscall=native documentation

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
@@ -4976,12 +4976,6 @@
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


Patches currently in stable-queue which might be from luto@kernel.org are

queue-4.19/documentation-admin-remove-the-vsyscall-native-documentation.patch
