Return-Path: <SRS0=hGaO=HY=lists.openwall.com=kernel-hardening-return-20781-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68035C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:13:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7F99564DF5
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 15:13:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F99564DF5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20781-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21858 invoked by uid 550); 22 Feb 2021 15:12:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21692 invoked from network); 22 Feb 2021 15:12:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P+jxf/c6aKxBtKoS9ZDFkjl+nA7mB7wt86sqHcoIgnU=;
        b=Igj+NEPkPWJoijrkRrH/caY1E5NfYkZDCZBhzVHmscEXfl+nAU78Fds4ChKT5iDrNC
         3Re67QcqVO7PVhLnnkmbHNIeb4QyzO5LpMQ4CZh3L5ljZOXZ9UxWRynfgTwVM+sUAJz5
         klfGDgvY+/fw5TX3ymZqTbgFogQvObV/nXFCkcasHwi372vovAHjSr/7Kasiuj3uHNm+
         jYyltTXRnnMePNacdNKWXGIGVEiOdKvLF5ZfEGDiQsT7/511k9S7wlrFXMT5o10kLEz1
         AUdPF2xJqw9I/8FJ1VAcA1OHMF/rlP127zcAuRQ/pTd7Nj+AR1jK/ld7mx5nqdHC6ElF
         QPKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P+jxf/c6aKxBtKoS9ZDFkjl+nA7mB7wt86sqHcoIgnU=;
        b=SBEtOpbZspZVmgGLsACZb6SAo1FSzAABr9VbSFmzviN44BFDb4RJWGf6zMGOzx55h7
         bKtcFLnruhDqbCmHUPN7lqG99D77Sg5ISWbaS/jzC6/UR+2HOZFy+S1pD+kOpMigTb4n
         wTeopuOP2dK1e9OnU72lVZ13tlvV9KCQg6GNQ/+L73iRJDFGVvOGTGoBtZVNUwVVZ8B/
         iFZ5h9s73Ngj6nEvB0VN/dR8a3s2820Lt4d3p4Yg0Jm+GufuJlKyL8mtEhHyOKoQlOpf
         rrSYXPaMZu3i0qZKltuK3JDfcMw0ry/+oZasKhfZXQHKiaY/J5BxMiTi/3K4EFRHbRw1
         +HPw==
X-Gm-Message-State: AOAM532MK29tIe9CSEGh8HN/UbwUBtKOODg6E0aYDEdfNHIuK3BAZmgO
	7RgIBCO0uS0Cm9X9co1P1s8=
X-Google-Smtp-Source: ABdhPJxSlaj/wGXQlhqcVSW+B87GwGWyLb3NE7717uuSVwOWnbMB2HGUqdE8D01xTcPB39n3ZpB3HQ==
X-Received: by 2002:a05:6000:10c5:: with SMTP id b5mr22235769wrx.284.1614006762869;
        Mon, 22 Feb 2021 07:12:42 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Tejun Heo <tj@kernel.org>,
	Zefan Li <lizefan.x@bytedance.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Romain Perier <romain.perier@gmail.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 01/20] cgroup: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:12 +0100
Message-Id: <20210222151231.22572-2-romain.perier@gmail.com>
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
 kernel/cgroup/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1ea995f801ec..bac0dc2ff8ad 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2265,7 +2265,7 @@ int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 		ret = cgroup_path_ns_locked(cgrp, buf, buflen, &init_cgroup_ns);
 	} else {
 		/* if no hierarchy exists, everyone is in "/" */
-		ret = strlcpy(buf, "/", buflen);
+		ret = strscpy(buf, "/", buflen);
 	}
 
 	spin_unlock_irq(&css_set_lock);

