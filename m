Return-Path: <kernel-hardening-return-21662-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 424F0C77B7C
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 May 2023 21:30:45 +0000 (UTC)
Received: (qmail 15522 invoked by uid 550); 4 May 2023 21:30:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15487 invoked from network); 4 May 2023 21:30:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683235822; x=1685827822;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dpDrHaDFb9uvY+Y5nUdaIxQKRWlMia3wPTlgfDNdf4c=;
        b=qwrCJncTbPjo7OVmLb6DC5CkyjhsTdxQEiYUjTISYeax0QnqJ+7w+fLvAGvuaJxaPp
         Biy+dpVNBJiWXPjTLS+Qjh7jTGnXGR054skBqurueUu4mQWWDFwk051N9sNmIVKpJlSm
         TtFoeRQKXeWTkPAParUiybl3T2AqyyLA+h36wqpHyuC/fQmynrFvoPnWeHhOkaJH1Jgj
         u9rNKsiyyy6gEYMZweRZ7GkEXNtSkiCyE7OhDcLiksv0RNr5Wlce5aK2IPjhGIYzVfJv
         S2Mmws/AseRyPGDs1Z8egoP2B3KfaGRUmRGMnwRjiF7GyKCb+bPVpN6/r4DPaYbQPKxw
         I93g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683235822; x=1685827822;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dpDrHaDFb9uvY+Y5nUdaIxQKRWlMia3wPTlgfDNdf4c=;
        b=DPsEOFITH+N1+8pwFtJAMbNrg2KQPHTWBKqBYdMt2EIVzvflN/AogXu2ppLaPnJprY
         AEsCyMGrNhF7vvMOXCEpbnM9NyObvehEiuaaUNPmd/EDv1gTq8WhOHMCJAnf1zAwv/MY
         mE+gsJDYqtH+Jt1aBA6JuSUMMZjDWkdCr+urYof/vUHjLcxYqcJQ0VXEepFZUCkZjuEa
         qnd+U+IZApLspFE2I078El5JuyMiG506WD32LMscCgjokCuuAqBuVznx5c1cmct6Be61
         Q9Jltwf4bYwY1IlgjFgx4a04tZZ/bQW2bcab29xjNY0u4kYPmJP+NwbsuUHOGQHvTCkF
         dg1w==
X-Gm-Message-State: AC+VfDxIRn6u0NBpfVJWI2pEFs9yP9eSbikR0TmWAURzmZjrOX9Erz5E
	IJzvc68avl1eoUXcpRm0foo=
X-Google-Smtp-Source: ACHHUZ5Wn3isdXputF03nNuI/MZ3Uu+owH1nKZqePrOGnu81HEC8Zu53kDXxLbOPkyMXsTcPaUAMwg==
X-Received: by 2002:a17:906:4785:b0:94a:7716:e649 with SMTP id cw5-20020a170906478500b0094a7716e649mr222144ejc.13.1683235822205;
        Thu, 04 May 2023 14:30:22 -0700 (PDT)
From: Michael McCracken <michael.mccracken@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com,
	serge@hallyn.com,
	tycho@tycho.pizza,
	Michael McCracken <michael.mccracken@gmail.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Iurii Zaikin <yzaikin@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] sysctl: add config to make randomize_va_space RO
Date: Thu,  4 May 2023 14:30:02 -0700
Message-Id: <20230504213002.56803-1-michael.mccracken@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add config RO_RANDMAP_SYSCTL to set the mode of the randomize_va_space
sysctl to 0444 to disallow all runtime changes. This will prevent
accidental changing of this value by a root service.

The config is disabled by default to avoid surprises.

Signed-off-by: Michael McCracken <michael.mccracken@gmail.com>
---
 kernel/sysctl.c | 4 ++++
 mm/Kconfig      | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index bfe53e835524..c5aafb734abe 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1913,7 +1913,11 @@ static struct ctl_table kern_table[] = {
 		.procname	= "randomize_va_space",
 		.data		= &randomize_va_space,
 		.maxlen		= sizeof(int),
+#if defined(CONFIG_RO_RANDMAP_SYSCTL)
+		.mode		= 0444,
+#else
 		.mode		= 0644,
+#endif
 		.proc_handler	= proc_dointvec,
 	},
 #endif
diff --git a/mm/Kconfig b/mm/Kconfig
index 7672a22647b4..91a4a86d70e0 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1206,6 +1206,13 @@ config PER_VMA_LOCK
 	  This feature allows locking each virtual memory area separately when
 	  handling page faults instead of taking mmap_lock.
 
+config RO_RANDMAP_SYSCTL
+    bool "Make randomize_va_space sysctl 0444"
+    depends on MMU
+    default n
+    help
+      Set file mode of /proc/sys/kernel/randomize_va_space to 0444 to disallow runtime changes in ASLR.
+
 source "mm/damon/Kconfig"
 
 endmenu
-- 
2.37.1 (Apple Git-137.1)

