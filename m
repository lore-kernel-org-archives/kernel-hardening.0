Return-Path: <SRS0=yXTP=A6=lists.openwall.com=kernel-hardening-return-19395-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CFF6C433E6
	for <kernel-hardening@archiver.kernel.org>; Sun, 19 Jul 2020 15:52:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3536E207EA
	for <kernel-hardening@archiver.kernel.org>; Sun, 19 Jul 2020 15:52:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="dl9Qv6LY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3536E207EA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19395-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11371 invoked by uid 550); 19 Jul 2020 15:52:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11295 invoked from network); 19 Jul 2020 15:52:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1595173888;
	bh=N+UeP24eqVRjJpemOD2oTkwdHQmg8hfH9M861ui7lqc=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dl9Qv6LYCoziMGrFyKXiJ98zjZduLijQGDv8AUlVyG2XYMNKbyCIzB3ZU9MIN8TWC
	 wX0hb0X9KeR3RnLe4C2UMu7Z37kTBb0I5h5ABte1hdHrlKT98KrbAHE4JhmdsI+zju
	 uRYM4Oa01/jk3J1cNjAxf1bVCkAvBUd+Nk51pbRo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
From: Oscar Carter <oscar.carter@gmx.com>
To: Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@redhat.com>,
	Kees Cook <keescook@chromium.org>
Cc: Oscar Carter <oscar.carter@gmx.com>,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Jann Horn <jannh@google.com>
Subject: [PATCH v2 2/2] kernel/trace: Remove function callback casts
Date: Sun, 19 Jul 2020 17:50:33 +0200
Message-Id: <20200719155033.24201-3-oscar.carter@gmx.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200719155033.24201-1-oscar.carter@gmx.com>
References: <20200719155033.24201-1-oscar.carter@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:yMLosVOVnTKjix38LbWzPsQaGdmB29CtaF2TTr1A9omeTBF3BUz
 ydqpg8sqfwZOnZwTkLl5iCEmMpusAAzkxpTlDAUTdo5iDEw5sH4XLsaGqm0lZ9pU/sMfEUG
 +2yMMw9pxfZYU5VoiKlxUf8sN5+WWgypIKJTPBr7Poz8TwnnwaNh/oX7m2TxnUdhj990rLQ
 CeyAxe4nR4uGMJqZbuI6A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:LdEQnRocgaA=:nSFO6IKDyDnCxNWHZorvAR
 BKP7FQFRcf4ATCdiommHAote0u+awdGJh6DzY4ep15XlBSULgWzdoZNyM/hcfAgaFszEw0c44
 BMHLdOEHyZau9Zr6k8jgBsWrIQlQdjUoWj1f0iG8jKesizrNKsij3PvexG52Ejcd+UW31qkBk
 ZGdGL1ZjlhYtypfkWOeNIKUJ9l1i3rvze4wp0xbevyj+YUtlsvwSUtow8YIruOs5E5i3rbu/3
 GYIrSvuaRPQ3D8ckL5UG9yQcm/ZElaaRiBNWo2JZTdxpa5dIWA068yG/9Plo9S8I7KA8Jvov0
 G71gwJFxx+24M8Qk17M32esMG4kCQXDMj3ow8ycng7SxenRYgXW8O+kOloj4EQk1cHZvt8zfP
 1Ok0sRMnHonR2k+GIJkAc8kyfGk2Ro+JKSIsyJeHPZYAL/20GdrRhcCncq8jvfXhPGGcjOipZ
 bONO+En/2r7ioS1FaRz9D+jKjHeECKt4LZsydYvoHWxCXzmrzHe61+DhvFz+Q7C9c0ESakdys
 li/eVxQ/DHwYdnX0X/81fPUoCjxxfkOfvIgkQKQfUVU0KyGWTBOCtAWxEAX15AIuEu/XZb0du
 vCOfQ3YaaEQfG73DyFmrxVccS9jbGXEdiNGDz7yxzUgJ2c3LICkGwQ2gB6i0tCglAWn+a2udB
 ABTl9aAGV6TEMuz6hFb0KajWvtRAeYWlfDT08UOyBiaxKsP9U5O0i2eN75Me4OMdHUri7Q5rw
 C8Uv3yW+hF7kwVayXDHMyIJaUjD5cx6G4pMw4zOWjvIeM2J20BI6+AhBNOmCDEmaujED5ZXEw
 uIM7emRkwo64K3vbflZbbtujLBVawdDxTTyTMBWftKuosZ283DwNrXao8R78qIWXxgBt6ff47
 6C4lGHJZE54lDIGQOqgPidP7qVcczejAcXc0fAH+JpJG+GFIQFbQvrRSi4AnZi2hXvcPGifPI
 IQb0rpy1OcW4uWVmCc0Lmeq7UDzFnAm8vHfANtAftHJyjmUu2VmkhZftWxKxEIn5umuk9YOC/
 oCpBl2l0l9o2i/g8ejI9NtklLxuLkg1ElIcmqBjXRNS0LjdFmNqc/UJqeFVIhg1S88Sz1XmFw
 SUUWkEHmN0DpRu9/tus74AhNcaT7AXC64hss2XG8VEATk76t7CsOaaeEChxlR5Ve946MFh0tr
 oFznsBP73HcIwX664soZySaVU54FE9hfxz7z9BcKB1rGSpTVN5COcUreQjoV9bzdrQpfIgHZ6
 p6CpBJuXPEzPZ1z168MKlFnfqg/sr+n3UM4Zr6Q==

In an effort to enable -Wcast-function-type in the top-level Makefile to
support Control Flow Integrity builds, there are the need to remove all
the function callback casts.

ftrace_ops_list_func() can no longer be defined as ftrace_ops_no_ops().
The reason for ftrace_ops_no_ops() is to use that when an architecture
calls ftrace_ops_list_func() with only two parameters (called from
assembly). And to make sure there's no C side-effects, those archs call
ftrace_ops_no_ops() which only has two parameters, as the function
ftrace_ops_list_func() has four parameters.

This patch removes the no longer needed function ftrace_ops_no_ops() and
all the function callback casts using the previous defined ftrace_func
union and the two function helpers called ftrace_set_ufunc() and
ftrace_same_address_ufunc().

Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
=2D--
 kernel/trace/ftrace.c | 48 ++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index fd8fbb422860..124ccf914657 100644
=2D-- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -143,9 +143,7 @@ static inline bool ftrace_same_address_ufunc(union ftr=
ace_func *ufunc,
 	return (ufunc->ops =3D=3D func);
 }
 #else
-/* See comment below, where ftrace_ops_list_func is defined */
-static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip);
-#define ftrace_ops_list_func ((ftrace_func_t)ftrace_ops_no_ops)
+static void ftrace_ops_list_func(unsigned long ip, unsigned long parent_i=
p);

 static inline void ftrace_set_ufunc(union ftrace_func *ufunc,
 				    ftrace_func_no_ops_t func)
@@ -198,22 +196,29 @@ static void ftrace_sync_ipi(void *data)
 	smp_rmb();
 }

-static ftrace_func_t ftrace_ops_get_list_func(struct ftrace_ops *ops)
+static union ftrace_func ftrace_ops_get_list_func(struct ftrace_ops *ops)
 {
+	union ftrace_func list_func;
+
 	/*
 	 * If this is a dynamic, RCU, or per CPU ops, or we force list func,
 	 * then it needs to call the list anyway.
 	 */
 	if (ops->flags & (FTRACE_OPS_FL_DYNAMIC | FTRACE_OPS_FL_RCU) ||
 	    FTRACE_FORCE_LIST_FUNC)
-		return ftrace_ops_list_func;
+		ftrace_set_ufunc(&list_func, ftrace_ops_list_func);
+	else
+		list_func.ops =3D ftrace_ops_get_func(ops);

-	return ftrace_ops_get_func(ops);
+	return list_func;
 }

 static void update_ftrace_function(void)
 {
-	ftrace_func_t func;
+	union ftrace_func func;
+#ifndef CONFIG_DYNAMIC_FTRACE
+	union ftrace_func tmp;
+#endif

 	/*
 	 * Prepare the ftrace_ops that the arch callback will use.
@@ -225,7 +230,7 @@ static void update_ftrace_function(void)

 	/* If there's no ftrace_ops registered, just call the stub function */
 	if (set_function_trace_op =3D=3D &ftrace_list_end) {
-		func =3D ftrace_stub;
+		func.ops =3D ftrace_stub;

 	/*
 	 * If we are at the end of the list and this ops is
@@ -239,21 +244,21 @@ static void update_ftrace_function(void)
 	} else {
 		/* Just use the default ftrace_ops */
 		set_function_trace_op =3D &ftrace_list_end;
-		func =3D ftrace_ops_list_func;
+		ftrace_set_ufunc(&func, ftrace_ops_list_func);
 	}

 	update_function_graph_func();

 	/* If there's no change, then do nothing more here */
-	if (ftrace_trace_function =3D=3D func)
+	if (ftrace_trace_function =3D=3D func.ops)
 		return;

 	/*
 	 * If we are using the list function, it doesn't care
 	 * about the function_trace_ops.
 	 */
-	if (func =3D=3D ftrace_ops_list_func) {
-		ftrace_trace_function =3D func;
+	if (ftrace_same_address_ufunc(&func, ftrace_ops_list_func)) {
+		ftrace_trace_function =3D func.ops;
 		/*
 		 * Don't even bother setting function_trace_ops,
 		 * it would be racy to do so anyway.
@@ -272,7 +277,9 @@ static void update_ftrace_function(void)
 	 * function we want, albeit indirectly, but it handles the
 	 * ftrace_ops and doesn't depend on function_trace_op.
 	 */
-	ftrace_trace_function =3D ftrace_ops_list_func;
+	ftrace_set_ufunc(&tmp, ftrace_ops_list_func);
+	ftrace_trace_function =3D tmp.ops;
+
 	/*
 	 * Make sure all CPUs see this. Yes this is slow, but static
 	 * tracing is slow and nasty to have enabled.
@@ -287,7 +294,7 @@ static void update_ftrace_function(void)
 	/* OK, we are all set to update the ftrace_trace_function now! */
 #endif /* !CONFIG_DYNAMIC_FTRACE */

-	ftrace_trace_function =3D func;
+	ftrace_trace_function =3D func.ops;
 }

 static void add_ftrace_ops(struct ftrace_ops __rcu **list,
@@ -2680,6 +2687,7 @@ void ftrace_modify_all_code(int command)
 	int update =3D command & FTRACE_UPDATE_TRACE_FUNC;
 	int mod_flags =3D 0;
 	int err =3D 0;
+	union ftrace_func func;

 	if (command & FTRACE_MAY_SLEEP)
 		mod_flags =3D FTRACE_MODIFY_MAY_SLEEP_FL;
@@ -2695,7 +2703,8 @@ void ftrace_modify_all_code(int command)
 	 * traced.
 	 */
 	if (update) {
-		err =3D ftrace_update_ftrace_func(ftrace_ops_list_func);
+		ftrace_set_ufunc(&func, ftrace_ops_list_func);
+		err =3D ftrace_update_ftrace_func(func.ops);
 		if (FTRACE_WARN_ON(err))
 			return;
 	}
@@ -2705,7 +2714,9 @@ void ftrace_modify_all_code(int command)
 	else if (command & FTRACE_DISABLE_CALLS)
 		ftrace_replace_code(mod_flags);

-	if (update && ftrace_trace_function !=3D ftrace_ops_list_func) {
+	ftrace_set_ufunc(&func, ftrace_ops_list_func);
+
+	if (update && ftrace_trace_function !=3D func.ops) {
 		function_trace_op =3D set_function_trace_op;
 		smp_wmb();
 		/* If irqs are disabled, we are in stop machine */
@@ -6890,14 +6901,13 @@ static void ftrace_ops_list_func(unsigned long ip,=
 unsigned long parent_ip,
 {
 	__ftrace_ops_list_func(ip, parent_ip, NULL, regs);
 }
-NOKPROBE_SYMBOL(ftrace_ops_list_func);
 #else
-static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip)
+static void ftrace_ops_list_func(unsigned long ip, unsigned long parent_i=
p)
 {
 	__ftrace_ops_list_func(ip, parent_ip, NULL, NULL);
 }
-NOKPROBE_SYMBOL(ftrace_ops_no_ops);
 #endif
+NOKPROBE_SYMBOL(ftrace_ops_list_func);

 /*
  * If there's only one function registered but it does not support
=2D-
2.20.1

