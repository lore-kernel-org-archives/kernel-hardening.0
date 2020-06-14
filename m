Return-Path: <SRS0=V9zD=73=lists.openwall.com=kernel-hardening-return-18960-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15657C433DF
	for <kernel-hardening@archiver.kernel.org>; Sun, 14 Jun 2020 07:03:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5F61C2065C
	for <kernel-hardening@archiver.kernel.org>; Sun, 14 Jun 2020 07:03:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="kbYt/rfn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F61C2065C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18960-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21626 invoked by uid 550); 14 Jun 2020 07:03:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21595 invoked from network); 14 Jun 2020 07:03:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1592118147;
	bh=2er3+RlmK+N8EaDXDNpr+N0HNLmwX0D+VNkwX3n3REY=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
	b=kbYt/rfnL/l5FRL6gNUSW95h7/vDo85/8QQHUMQP4hkC8k/8KbFHsTPQJ6Q2/qsjK
	 Tab9Zv1fO8C1hk+gquHHCH5hSR3VYvnLieroisknHxXAmHzBo+dBjFXAfeODveoxR3
	 5ce2TI8MLhXEniZagaWtQxnHCsB5J6HyL5Wnc53g=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
From: Oscar Carter <oscar.carter@gmx.com>
To: Kees Cook <keescook@chromium.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org,
	Oscar Carter <oscar.carter@gmx.com>
Subject: [PATCH] kernel/trace: Remove function callback casts
Date: Sun, 14 Jun 2020 09:01:54 +0200
Message-Id: <20200614070154.6039-1-oscar.carter@gmx.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:oYe7EI4mSWdSCcnjUa0R5EjviCt5khEr175w1xniGgy/IdT92nf
 LOm5be6ZQpGHhNfovw09T+4rWArknGMpeqti3VnLKFsmFK+fJjl/xMni5HB+Ngo1PPocaI/
 N9Pj7P5ETxvnJbdM/uwVfXaxJga8vIbTH7muhHr489YFHWk5zL38FyMKquwnbY30V7/CLp4
 2w3eIWXp+NAwmUlY7XxuA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:P+9wTh2Fjck=:ZeMsb69edwx/2Y0aTsH6Yu
 Rd9Dq+Lprn920jG2Y+mRXJnQpTBCg1BYpRNjpOu+kUNidX04Jj/uYk9iOgkY0EvkShUesky+Z
 0eU6PjC3Qk4mcVG2SLaRM9XLtVMdYK6fCpeztbhHPp2+4aXyANfuscVQ3e2bmJCAqjeDKHFfr
 lvT44anXUQC9/PcoUPT7W8U87nmNI/Z5Zgh2oh9opqVrCVoL/6eqw5SCyZsz75tpbRwZ6K+qD
 eGV1iytVs0wpEwide5HUAnzrBVxvEUbnPBjt0+ccNXyunx5fhVABD11L13Ef3wnLJZkgX2G2D
 H/q9GU8RQ2HlbpJQkAx5UpINSJBYdD/VRK49CkkxfXvpGZ73wotrkgqdghnuG0fREdKiuYSpB
 J1G+4L1j4Dzpg4d7MPs6QrvRQbZFhtgegeUYGeTHkyZdLMVJZV0EhzerGOXX0mwcqew+DDE9E
 4/svaNPMLjl8/JBylNgwLsrgJuYm5ZJ7yX5cIzHGJ9xAGA9rd2snZk77TXAfd2gtW+sLEF1R4
 L/it6TGEq/LcoVhvv4UzHxGaFXwgCVJdJ7omXMSZF1H0ImtLBMoi3VOQZ/+nQBpq1YZFw474d
 1t9YLv7YgtK7A1iZRIaA4vw+/US6M0QpMuVjURyT6qsfZJkc1gvF5ydlbGfob9C7OVIu2LcjA
 AqGndEkDx9vQ1CkHtcwQlgaK2lk9g80HFKab02xRBbgzS5qlgzm4CT4m8we4fQnx8plUMR3ZX
 95avX6h0RI5d8kBNUt5vXliWcpLSnOHbIqkVJUZzWU32W9eZeIuZkR8MyA/DV64z7jnOskksc
 4oZSqUwrfk7U7wVu6aWHLzTpA94beZY937QAZpytpi8nnoaHZtasQhA7wiIZakNkYFWRWYSVA
 RxrwNJrKD60kynJ5HRLkFtZi7IZew/ZpPMP3kIcEFG5smCgp+WUVHytq1WyT9nw4uX4/SQNnW
 l4ShDkkrk3zBwrzy5VDxOptzbYcXARBReddNSGb4vJZpmtyY7SlSvQUX2l9JDX9S9qoOdnMSd
 cwI+KLEy04Rn92UC7anxUMDics0mdrlmiqsC17zphrZ45LIi9Lg/IB19wNXZp9SRFVdD/5QBO
 wXnzq03aZkul/tgd8iOwwr6Dmz0NQCxRJX2Ii+iF1XQNqwXmGesilQlkIKeHMhrv93X0OpNgS
 uy5uX8VwYLub8wxpiidb+ExllmAlYbkh348pBtR/sM5zOPiIb1iDFytGt9b2P7BclCJiE9XpA
 WXsqRECYKEmYgmV53

In an effort to enable -Wcast-function-type in the top-level Makefile to
support Control Flow Integrity builds, remove all the function callback
casts.

To do this, use the ftrace_ops_list_func function as a wrapper when the
arch not supports ftrace ops instead of the use of a function cast.

Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
=2D--
 kernel/trace/ftrace.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c163c3531faf..ed1efc0e3a25 100644
=2D-- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -119,13 +119,12 @@ struct ftrace_ops __rcu *ftrace_ops_list __read_most=
ly =3D &ftrace_list_end;
 ftrace_func_t ftrace_trace_function __read_mostly =3D ftrace_stub;
 struct ftrace_ops global_ops;

-#if ARCH_SUPPORTS_FTRACE_OPS
 static void ftrace_ops_list_func(unsigned long ip, unsigned long parent_i=
p,
 				 struct ftrace_ops *op, struct pt_regs *regs);
-#else
+
+#if !ARCH_SUPPORTS_FTRACE_OPS
 /* See comment below, where ftrace_ops_list_func is defined */
 static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip);
-#define ftrace_ops_list_func ((ftrace_func_t)ftrace_ops_no_ops)
 #endif

 static inline void ftrace_ops_init(struct ftrace_ops *ops)
@@ -6860,6 +6859,12 @@ static void ftrace_ops_list_func(unsigned long ip, =
unsigned long parent_ip,
 }
 NOKPROBE_SYMBOL(ftrace_ops_list_func);
 #else
+static void ftrace_ops_list_func(unsigned long ip, unsigned long parent_i=
p,
+				 struct ftrace_ops *op, struct pt_regs *regs)
+{
+	ftrace_ops_no_ops(ip, parent_ip);
+}
+
 static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip)
 {
 	__ftrace_ops_list_func(ip, parent_ip, NULL, NULL);
=2D-
2.20.1

