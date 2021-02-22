Return-Path: <SRS0=qoz8=HY=lists.openwall.com=kernel-hardening-return-20787-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5593C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:14:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B675564EC3
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:14:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B675564EC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20787-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23652 invoked by uid 550); 22 Feb 2021 15:13:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22489 invoked from network); 22 Feb 2021 15:13:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=65uTl/DL0ujA6C8p6tAwX4+93DKKilnR81zX6h8q1v8=;
        b=b1r1t7/9FkfFvI8NzbPsWItaj3Vp8C1YOhKzqWDv/cIeky/XuHH9lL48rVM1yGCDQM
         rYYwTs+SOxYhOfw5Z+59Gn+navsY/NfttlX1NbrQUYk/Qc68NddzJFdzbuDTX8GpQLTB
         wBhgKXIFZug2leJR1e8TkH+md11czHNCQqs3jqi6qv/eTwSfES1On6EUG6wqwVsDiUix
         Arv9gm7BT3V09ls3cWgJky4r8RyyC5tqLKw9aJDFkjVJrMUgDoc1sjDc5ACqVM5Up1wS
         KWkZfPcFZM7K4Dxoj66LfT6arTk1SvQk5+ZkE9/v9Ipd9E7sGPqzMMaStGYWCyqNPQSI
         YxaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=65uTl/DL0ujA6C8p6tAwX4+93DKKilnR81zX6h8q1v8=;
        b=rLphuBhXouQZaSBjok7L//ESS3sn4NV/5rpAhHWNW7UqAfTBC2Ze9viWj2ZFQV5rhQ
         RxPyMb9nnTEv2cPf+2Y9cnKrAmh2JPv3t0sbTiIMCOo3aktOjEpmVtJmvNXXOz7ynHXf
         jdc1sl2ip/O7dnkZBuOBf2WqKV5yZJJn40MBdeZ0GMkiP12k8QMgQ/Uh3xjh22dW0ug9
         2BGXwc2f0LDP/IGbn33QbCQv3sj62P3QaV7+6ZVSB8BqQe0+tqwTDQ2AwgajZqTxJLVD
         36dCi2WqU534hoO8dQIgrPLplEQS9jEqL1Pm8bSCf2YMrehI/pp+JmXkrQqrsGxKdK9O
         HrQg==
X-Gm-Message-State: AOAM5330YLLJqKDIm3jfYNpvzPY0xSRiB2MH9UlHDONyhOY8nSOHRWJk
	z76PgnFIHNwqpCwhn3LbxoY=
X-Google-Smtp-Source: ABdhPJyr+0yYY214oKEDBI29fhzZwAOghMQnhkDW+SagA7DHVRiuybGQ/ITWc05OdOmwnuyzlppXNA==
X-Received: by 2002:a1c:ac86:: with SMTP id v128mr20718184wme.175.1614006770799;
        Mon, 22 Feb 2021 07:12:50 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Chuck Lever <chuck.lever@oracle.com>
Cc: Romain Perier <romain.perier@gmail.com>,
	linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 07/20] SUNRPC: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:18 +0100
Message-Id: <20210222151231.22572-8-romain.perier@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210222151231.22572-1-romain.perier@gmail.com>
References: <20210222151231.22572-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The strlcpy() reads the entire source buffer first, it is dangerous if
the source buffer lenght is unbounded or possibility non NULL-terminated.
It can lead to linear read overflows, crashes, etc...

As recommended in the deprecated interfaces [1], it should be replaced
by strscpy.

This commit replaces all calls to strlcpy that handle the return values
by the corresponding strscpy calls with new handling of the return
values (as it is quite different between the two functions).

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 net/sunrpc/clnt.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 612f0a641f4c..3c5c4ad8a808 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -282,7 +282,7 @@ static struct rpc_xprt *rpc_clnt_set_transport(struct rpc_clnt *clnt,
 
 static void rpc_clnt_set_nodename(struct rpc_clnt *clnt, const char *nodename)
 {
-	clnt->cl_nodelen = strlcpy(clnt->cl_nodename,
+	clnt->cl_nodelen = strscpy(clnt->cl_nodename,
 			nodename, sizeof(clnt->cl_nodename));
 }
 
@@ -422,6 +422,10 @@ static struct rpc_clnt * rpc_new_client(const struct rpc_create_args *args,
 		nodename = utsname()->nodename;
 	/* save the nodename */
 	rpc_clnt_set_nodename(clnt, nodename);
+	if (clnt->cl_nodelen == -E2BIG) {
+		err = -ENOMEM;
+		goto out_no_path;
+	}
 
 	err = rpc_client_register(clnt, args->authflavor, args->client_name);
 	if (err)

