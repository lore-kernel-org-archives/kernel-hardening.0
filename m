Return-Path: <SRS0=IH6E=HY=lists.openwall.com=kernel-hardening-return-20788-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 008BDC433DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:15:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2D16864EC3
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:15:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D16864EC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20788-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23716 invoked by uid 550); 22 Feb 2021 15:13:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23656 invoked from network); 22 Feb 2021 15:13:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fvdst0ke5NfAjFDKzfIGeJQUVrU5WqaPoSE7N9OL8Lk=;
        b=ByUTfEFTtBWT1+a0ndUHz1KXLJgEtcEoht2zWrZ92q9qenV/FW/QItrNFBA9yTMyEu
         nAxoZ+5AXu3tbOCmNa03Q8qLomQDKJiPxv7eM+CBxbCITTfPr61VnFrxqNLmeXxlwO3D
         NSpdRj4Lfc+il7l9Z296wz7zGGhZmRTTRRQtCoJTKm2wn4y36LdYZ9EjyeLCQJ4lYebI
         mYOlnGVeZdOkqV6tdEV2vpkWfpAsY7t3TGFQ6/SyIT186qvj7qU7fcfJQq7KTLm3B5ig
         A/gh1JqPwarb2PAOkQI97K0mXH1teQXM1pBWa2rExNw6siyEglWGb/yNUH+O8aiFhMYI
         3MXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fvdst0ke5NfAjFDKzfIGeJQUVrU5WqaPoSE7N9OL8Lk=;
        b=irB4jE0bxpSIqEVMO7JF0By76UpTBtdfApteRh6Kug9LqU3Psn5BlRwMGOsdb6j32w
         wQO19uRS1C4NGm7OlLnV+5RPWg3Vvd8vmfq0MVTO07Qb+PBQosCKcz9+qym5F8nDp7Tm
         79FoUJgpdOxeMPH7qzvldTgwzlJa+MyVR2Q2eLbEGL4hbxvCeHwDqa9GzK0dvvLWFNXy
         Aos7MwToLDlPWt9kCXLL905DYgCldRXXVxPl5O5AGEaCjfTxJqYAcsSzcjK1Zerv6zoR
         PzfhP+vwYFQutuPkeV8Wd6zAawePQpmKQ4bzpNF1p3So25ktupJK0r1/RDsssAH7GYd7
         fx9Q==
X-Gm-Message-State: AOAM533jSYpJSB/JGRWSd0wP2gnCsuNqx1EucOfta3+QooR8GnQJGW4M
	EeeNa0sNmxShFCI9sgVhI/Rev8gCnHSTDYgVjHo=
X-Google-Smtp-Source: ABdhPJx3HdU5Aax1CbhYORFA+t6gTkfB7mL2V+O6OWbY4u994qmgJk/1EWCkqEb3ImN5wm0C+wO/uA==
X-Received: by 2002:a1c:c906:: with SMTP id f6mr20165149wmb.128.1614006771938;
        Mon, 22 Feb 2021 07:12:51 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>
Cc: Romain Perier <romain.perier@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 08/20] kernfs: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:19 +0100
Message-Id: <20210222151231.22572-9-romain.perier@gmail.com>
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
 fs/kernfs/dir.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 7a53eed69fef..9e65b595d880 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -42,9 +42,9 @@ static bool kernfs_lockdep(struct kernfs_node *kn)
 static int kernfs_name_locked(struct kernfs_node *kn, char *buf, size_t buflen)
 {
 	if (!kn)
-		return strlcpy(buf, "(null)", buflen);
+		return strscpy(buf, "(null)", buflen);
 
-	return strlcpy(buf, kn->parent ? kn->name : "/", buflen);
+	return strscpy(buf, kn->parent ? kn->name : "/", buflen);
 }
 
 /* kernfs_node_depth - compute depth from @from to @to */
@@ -125,17 +125,18 @@ static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
 {
 	struct kernfs_node *kn, *common;
 	const char parent_str[] = "/..";
-	size_t depth_from, depth_to, len = 0;
+	size_t depth_from, depth_to;
+	ssize_t len = 0;
 	int i, j;
 
 	if (!kn_to)
-		return strlcpy(buf, "(null)", buflen);
+		return strscpy(buf, "(null)", buflen);
 
 	if (!kn_from)
 		kn_from = kernfs_root(kn_to)->kn;
 
 	if (kn_from == kn_to)
-		return strlcpy(buf, "/", buflen);
+		return strscpy(buf, "/", buflen);
 
 	if (!buf)
 		return -EINVAL;
@@ -150,16 +151,16 @@ static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
 	buf[0] = '\0';
 
 	for (i = 0; i < depth_from; i++)
-		len += strlcpy(buf + len, parent_str,
+		len += strscpy(buf + len, parent_str,
 			       len < buflen ? buflen - len : 0);
 
 	/* Calculate how many bytes we need for the rest */
 	for (i = depth_to - 1; i >= 0; i--) {
 		for (kn = kn_to, j = 0; j < i; j++)
 			kn = kn->parent;
-		len += strlcpy(buf + len, "/",
+		len += strscpy(buf + len, "/",
 			       len < buflen ? buflen - len : 0);
-		len += strlcpy(buf + len, kn->name,
+		len += strscpy(buf + len, kn->name,
 			       len < buflen ? buflen - len : 0);
 	}
 
@@ -173,8 +174,8 @@ static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
  * @buflen: size of @buf
  *
  * Copies the name of @kn into @buf of @buflen bytes.  The behavior is
- * similar to strlcpy().  It returns the length of @kn's name and if @buf
- * isn't long enough, it's filled upto @buflen-1 and nul terminated.
+ * similar to strscpy().  It returns the length of @kn's name and if @buf
+ * isn't long enough or @buflen is 0, it returns -E2BIG.
  *
  * Fills buffer with "(null)" if @kn is NULL.
  *
@@ -858,7 +859,7 @@ static struct kernfs_node *kernfs_walk_ns(struct kernfs_node *parent,
 					  const unsigned char *path,
 					  const void *ns)
 {
-	size_t len;
+	ssize_t len;
 	char *p, *name;
 
 	lockdep_assert_held(&kernfs_mutex);
@@ -866,9 +867,9 @@ static struct kernfs_node *kernfs_walk_ns(struct kernfs_node *parent,
 	/* grab kernfs_rename_lock to piggy back on kernfs_pr_cont_buf */
 	spin_lock_irq(&kernfs_rename_lock);
 
-	len = strlcpy(kernfs_pr_cont_buf, path, sizeof(kernfs_pr_cont_buf));
+	len = strscpy(kernfs_pr_cont_buf, path, sizeof(kernfs_pr_cont_buf));
 
-	if (len >= sizeof(kernfs_pr_cont_buf)) {
+	if (len == -E2BIG) {
 		spin_unlock_irq(&kernfs_rename_lock);
 		return NULL;
 	}

