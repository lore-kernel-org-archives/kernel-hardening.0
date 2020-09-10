Return-Path: <SRS0=VSet=CT=lists.openwall.com=kernel-hardening-return-19859-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA73CC43461
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 20:21:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B658220829
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 20:21:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hSQ0zdFy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B658220829
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19859-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19803 invoked by uid 550); 10 Sep 2020 20:21:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19639 invoked from network); 10 Sep 2020 20:21:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tnXdabcwXVIuE0k91OJrr49vsQn2UnhCU1YKo8kvLTw=;
        b=hSQ0zdFyPensKZojjKCfzNQrvXmoCKzNX2YVaHvRN7/XH0lKcsrFNqnc0rOgYTeRnu
         loaId2e/f5wxgNmeTXjC2i6hrj5tqPPw+EaQ3ZGZEFbZ2YtDU4PAL7cJFK/QeELvRAQt
         GPPzdeYbGBtthOo5NBnwk0gEfsyD+cuEixoyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tnXdabcwXVIuE0k91OJrr49vsQn2UnhCU1YKo8kvLTw=;
        b=X1xu9kqLIunlHSCG1MHDixb/Y69Sk3jQIPzZj48KIKoWol6a2zANyj/wSZK/onjd3U
         bDuw+/ScLgvZmv0m84fFN13shXVMm1DmHH51IGaxMUTRMTZrbkN6dY2O4UWgtk4mTMSK
         QDUSBiTwwebq7wSng+ajkxYLP39Zi/u4d2qmu+7Y48ewhXfvj0vPYB5fj1vF6KbVbXOU
         s3Mmgjc9T9n/BPD2kcpx4jpY6ElJjeATOkubRKE4H03vyeD9eaz6oE35X+/f3vviSfzR
         DHy4sXf2M0rxes6jRhKTMafNGxV+tD+nYulSPbrE2BHjryg7y9FGvJHK9AwUIRfLcELJ
         JbyQ==
X-Gm-Message-State: AOAM530QohBL/t/dE6mFERAdHG34OXITP+4Zbb2hApXF5F5WzzAkFU94
	JwXQGJt+UIFndZjWQfDB9Wd/6A==
X-Google-Smtp-Source: ABdhPJwg/CJNJzVmpJyzmZCy6oRkUsCVA9nITFo2t+x3HlTT8F3hm5Z71/ywbqzxdMnHoIL7Lroq9g==
X-Received: by 2002:a17:90a:7487:: with SMTP id p7mr1575018pjk.189.1599769278240;
        Thu, 10 Sep 2020 13:21:18 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	John Wood <john.wood@gmx.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Iurii Zaikin <yzaikin@google.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [RESEND][RFC PATCH 0/6] Fork brute force attack mitigation (fbfam)
Date: Thu, 10 Sep 2020 13:21:01 -0700
Message-Id: <20200910202107.3799376-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[kees: re-sending this series on behalf of John Wood <john.wood@gmx.com>
 also visible at https://github.com/johwood/linux fbfam]

From: John Wood <john.wood@gmx.com>

The goal of this patch serie is to detect and mitigate a fork brute force
attack.

Attacks with the purpose to break ASLR or bypass canaries traditionaly use
some level of brute force with the help of the fork system call. This is
possible since when creating a new process using fork its memory contents
are the same as those of the parent process (the process that called the
fork system call). So, the attacker can test the memory infinite times to
find the correct memory values or the correct memory addresses without
worrying about crashing the application.

Based on the above scenario it would be nice to have this detected and
mitigated, and this is the goal of this implementation.

Other implementations
---------------------

The public version of grsecurity, as a summary, is based on the idea of
delay the fork system call if a child died due to a fatal error. This has
some issues:

1.- Bad practices: Add delays to the kernel is, in general, a bad idea.

2.- Weak points: This protection can be bypassed using two different
    methods since it acts only when the fork is called after a child has
    crashed.

    2.1.- Bypass 1: So, it would still be possible for an attacker to fork
	  a big amount of children (in the order of thousands), then probe
	  all of them, and finally wait the protection time before repeat
	  the steps.

    2.2.- Bypass 2: This method is based on the idea that the protection
	  doesn't act if the parent crashes. So, it would still be possible
	  for an attacker to fork a process and probe itself. Then, fork
	  the child process and probe itself again. This way, these steps
	  can be repeated infinite times without any mitigation.


This implementation
-------------------

The main idea behind this implementation is to improve the existing ones
focusing on the weak points annotated before. So, the solution for the
first bypass method is to detect a fast crash rate instead of only one
simple crash. For the second bypass method the solution is to detect both
the crash of parent and child processes. Moreover, as a mitigation method
it is better to kill all the offending tasks involve in the attack instead
of use delays.

So, the solution to the two bypass methods previously commented is to use
some statistical data shared across all the processes that can have the
same memory contents. Or in other words, a statistical data shared between
all the processes that fork the task 0, and all the processes that fork
after an execve system call.

These statistics hold the timestamp for the first fork (case of a fork of
task zero) or the timestamp for the execve system call (the other case).
Also, hold the number of faults of all the tasks that share the same
statistical data since the commented timestamp.

With this information it is possible to detect a brute force attack when a
task die in a fatal way computing the crashing rate. This rate shows the
milliseconds per fault and when it goes under a certain threshold there is
a clear signal that something malicious is happening.

Once detected, the mitigation only kills the processes that share the same
statistical data and so, all the tasks that can have the same memory
contents. This way, an attack is rejected.

The fbfam feature can be enabled, disabled and tuned as follows:

1.- Per system enabling: This feature can be enabled in build time using
    the config application under:

    Security options  --->  Fork brute force attack mitigation

2.- Per process enabling/disabling: To allow that specific applications can
    turn off or turn on the detection and mitigation of a fork brute force
    attack when required, there are two new prctls.

    prctl(PR_FBFAM_ENABLE, 0, 0, 0, 0)  -> To enable the feature
    prctl(PR_FBFAM_DISABLE, 0, 0, 0, 0) -> To disable the feature

    Both functions return zero on success and -EFAULT if the current task
    doesn't have statistical data.

3.- Fine tuning: To customize the detection's sensibility there is a new
    sysctl that allows to set the crashing rate threshold. It is accessible
    through the file:

    /proc/sys/kernel/fbfam/crashing_rate_threshold

    The units are in milliseconds per fault and the attack's mitigation is
    triggered if the crashing rate of an application goes under this
    threshold. So, the higher this value, the faster an attack will be
    detected.

So, knowing all this information I will explain now the different patches:

The 1/9 patch adds a new config for the fbfam feature.

The 2/9 and 3/9 patches add and use the api to manage the statistical data
necessary to compute the crashing rate of an application.

The 4/9 patch adds a new sysctl to fine tuning the detection's sensibility.

The 5/9 patch detects a fork brute force attack calculating the crashing
rate.

The 6/9 patch mitigates the attack killing all the offending tasks.

The 7/9 patch adds two new prctls to allow per task enabling/disabling.

The 8/9 patch adds general documentation.

The 9/9 patch adds an entry to the maintainers list.

This patch series is a task of the KSPP [1] and it is worth to mention
that there is a previous attempt without any continuation [2].

[1] https://github.com/KSPP/linux/issues/39
[2] https://lore.kernel.org/linux-fsdevel/1419457167-15042-1-git-send-email-richard@nod.at/

Any constructive comments are welcome.

Note: During the compilation these warnings were shown:

kernel/exit.o: warning: objtool: __x64_sys_exit_group()+0x18: unreachable instruction
arch/x86/kernel/cpu/mce/core.o: warning: objtool: mce_panic()+0x123: unreachable instruction
arch/x86/kernel/smpboot.o: warning: objtool: native_play_dead()+0x122: unreachable instruction
net/core/skbuff.o: warning: objtool: skb_push.cold()+0x14: unreachable instruction



John Wood (6):
  security/fbfam: Add a Kconfig to enable the fbfam feature
  security/fbfam: Add the api to manage statistics
  security/fbfam: Use the api to manage statistics
  security/fbfam: Add a new sysctl to control the crashing rate
    threshold
  security/fbfam: Detect a fork brute force attack
  security/fbfam: Mitigate a fork brute force attack

 fs/coredump.c           |   2 +
 fs/exec.c               |   2 +
 include/fbfam/fbfam.h   |  24 ++++
 include/linux/sched.h   |   4 +
 kernel/exit.c           |   2 +
 kernel/fork.c           |   4 +
 kernel/sysctl.c         |   9 ++
 security/Kconfig        |   1 +
 security/Makefile       |   4 +
 security/fbfam/Kconfig  |  10 ++
 security/fbfam/Makefile |   3 +
 security/fbfam/fbfam.c  | 279 ++++++++++++++++++++++++++++++++++++++++
 security/fbfam/sysctl.c |  20 +++
 13 files changed, 364 insertions(+)
 create mode 100644 include/fbfam/fbfam.h
 create mode 100644 security/fbfam/Kconfig
 create mode 100644 security/fbfam/Makefile
 create mode 100644 security/fbfam/fbfam.c
 create mode 100644 security/fbfam/sysctl.c

-- 
2.25.1

