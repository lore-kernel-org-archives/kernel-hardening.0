Return-Path: <SRS0=TAxR=K7=lists.openwall.com=kernel-hardening-return-21284-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFEBFC47082
	for <kernel-hardening@archiver.kernel.org>; Sat,  5 Jun 2021 17:59:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0783861207
	for <kernel-hardening@archiver.kernel.org>; Sat,  5 Jun 2021 17:59:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0783861207
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21284-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18056 invoked by uid 550); 5 Jun 2021 17:59:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18033 invoked from network); 5 Jun 2021 17:59:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1622915918;
	bh=LJZMH4mKKG4Y4RH/IKRmcuoSuYAs3YZ6GSXZNks3Imw=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EXvn/Qe1G20n0eCfzE5oqH9nCio58KhDVyrKq87mvUn5a8gNLLkdFSi6kOi+BoMnY
	 1hDvjbSm7pE5rTXadLV9eQ8lFHUU+l7oMzrA0fvIEEgGuFDDUwD7mQLglDQSkSDCKk
	 7YpGopCJ5tA0g8uLT9Zl3u6SXCYduGi1BElJOQoY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
From: John Wood <john.wood@gmx.com>
To: Kees Cook <keescook@chromium.org>,
	Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <shuah@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arnd Bergmann <arnd@arndb.de>
Cc: John Wood <john.wood@gmx.com>,
	Andi Kleen <ak@linux.intel.com>,
	valdis.kletnieks@vt.edu,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v8 8/8] MAINTAINERS: Add a new entry for the Brute LSM
Date: Sat,  5 Jun 2021 17:04:05 +0200
Message-Id: <20210605150405.6936-9-john.wood@gmx.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210605150405.6936-1-john.wood@gmx.com>
References: <20210605150405.6936-1-john.wood@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:zkSY+Nk10Hb9RRhiRldy4BtP2AIFThepaw+IBLiQxGRKAu76Tfz
 u/xwkD/5Xjj+4nPrpcNbps49Prlmno1jLjtPMU0HsCFJ8K+bm+sJ7XuKlC6BGL7piwviohY
 sTlX6Cko1RB0w10cj7CJ1tXWloewJz9zjikX65FCu8KyF9jqJGcXtdHzxZDjQX0PCOxFvnd
 7U8jbQRCot2JkQcmxsVhA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Zll4jERGK4o=:b0ECLFhKc1ov8XftBxIOl9
 Bm00CA3vk6hTwdngrb1VLwvu2bvhDT96UWxpd5QHIfH1c2O5zW+gq6YD8aknBSKHms6Dub/s5
 f7jMvDzfr5Mutwll/uQ5YbB8JC7nFGHTzf6hbcttzV66aa+9jlbs3/ABbaQDmtH+Ly+qYDQE6
 FJpIA61UHheW6K0IyVh8t2m1+jHn7my8B3BQhdc+PrMe0gQHPjEU+ZJis00K5/gvkyrxTuGHo
 3iKblKo1mjMcUN1oGVKrRjirMb/TSVxwz7XTUB/P51Velw8SgxuMTg53j1FnpuIvvv+ZG7xcM
 rmG1oAg0tdheQ+pPQogFWskdNK4Ag8VyzweuZ0fUVY+dWaKKtmpBQ874+29gkw6Y3+70hvc1t
 jKfB8ckTMcibE9oDb6mKVl78uE1GRAIS8nhyb/kne1ua2bEqJ7tysrbjFc8360U1qjgPFE4a8
 kWRb0oTX6CQSAAeJ3YGCjz+WCiRyJYAMcfo4Gn83R2JOjPBXdJoPX6iGxF/2A24DJQBruU8hr
 Mt5TAwuaw/q+PHowLaTJbqCFVrXJ0aCas4utyh4tULM1nV2SfxU9vYtxtz598ePmrFz2Xgi0N
 dlWbtJrwwBzPMAiQBUv0awrFs6FmK0tviDCY30HkQcsnHvCZbJHH3BVCrJqzP/oRtfGvpjpF7
 R6w3tXo5XyxV95pQb8np03wgVP40n7oGErvs5Elsw1r2nS4zDRzQKQ/0CQgjA4tAH2DIAd8fn
 NzoaFJZg0jIvsi7Mx8a575YtGSGwFGOSaMS2YstcN/TkldgpaI0M9AGAxklmmiTQ9w0ZRsBAD
 zAAsVtzFlfXsBbPEYB16GqQVR1GfJw+QirLv+4i1jFPM6vcesajUz1HKeqxtFjkNlHVVEZzTY
 thwIgWTL1P9kdR7uy66I1xegj0nPCui+X1+xHTtLWMLfBk6Ci9RK2kI28meJyPq0ITYlS6OGv
 N3iR4UwFaRr2RLHQPZFXPZW46bgHRTI7sKQOtVwRVVSEGZCyTVyf/dR8zdcZig0VOlLAIWyvz
 OGAAlfnYKEtf+eT3FDxtEzVc1viYBZUKzCl716RqEIlhUc1D9FYU7g/5bQrWTIyT/wv1i6IbI
 PubMFX8o76gckRAj7fkDwA2yyiLtOqwYun5

In order to maintain the code for the Brute LSM add a new entry to the
maintainers list.

Signed-off-by: John Wood <john.wood@gmx.com>
=2D--
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 503fd21901f1..665cd6aaadac 100644
=2D-- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3847,6 +3847,14 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/brocade/bna/

+BRUTE SECURITY MODULE
+M:	John Wood <john.wood@gmx.com>
+S:	Maintained
+F:	Documentation/admin-guide/LSM/Brute.rst
+F:	include/brute/
+F:	security/brute/
+F:	tools/testing/selftests/brute/
+
 BSG (block layer generic sg v4 driver)
 M:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
 L:	linux-scsi@vger.kernel.org
=2D-
2.25.1

