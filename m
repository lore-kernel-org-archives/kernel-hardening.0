Return-Path: <SRS0=tyZN=CP=lists.openwall.com=kernel-hardening-return-19791-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B9FAC43461
	for <kernel-hardening@archiver.kernel.org>; Sun,  6 Sep 2020 14:21:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EA4B32080A
	for <kernel-hardening@archiver.kernel.org>; Sun,  6 Sep 2020 14:21:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="liWD4LF/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA4B32080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19791-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7614 invoked by uid 550); 6 Sep 2020 14:21:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7576 invoked from network); 6 Sep 2020 14:21:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1599402072;
	bh=fQwrab/3EerbqYpxqZ04WJLrtDjl6Vf1m279QN3M5dY=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
	b=liWD4LF/svptUw6dc0UH+eLoWnDa/EU1bN0dylHWxTAhZgqeNC8ymC372rsI8wg5I
	 1eiec43kK21oSwr+s3bu35ILEPqdjJnggLXqQ/1zKl58zExIdbkUhQOkvqwQuzbD30
	 7cXAgbUKEFSktob6fSCsQhU9c9VOK5Au51SjmHmg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
From: John Wood <john.wood@gmx.com>
To: Kees Cook <keescook@chromium.org>
Cc: John Wood <john.wood@gmx.com>,
	kernel-hardening@lists.openwall.com
Subject: [RFC PATCH 0/9] Fork brute force attack mitigation (fbfam)
Date: Sun,  6 Sep 2020 16:20:20 +0200
Message-Id: <20200906142029.6348-1-john.wood@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8hr0c8NNY4iA0jFZysYWA+iPVc1BCWQwKHn/HIdKKe2GfR5V72M
 EZ+MjnfrLih//IlV8gMdRjv//C10uau2ahy+JGPfUH0g4KYfzxIYOfRTnN0HTZeJaPyLsDZ
 Yf7poGfcgXXnASjlVnLxYAsP1yAL4c+bqXYVdFRfTsLfgW1OIHNmKUIv9mdfb5+k1bP77xz
 /Z5QrfLrH1pOHCYP1D1tA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:QYCeYhDc6z4=:BR/kn8rOFhhghxNJ0s0bAj
 l5B6tcHOgUBQjp251j3KhksMHzxIAdqTjeIhsHwe+raIj1Nhw8gptTMsVowR5+U2WmetFRnWD
 hyLeoj65vKshz6yOGf8PgZkzXdrsZlS013EUDXdkGMUc6431PCMCmnkrWsov+vRQ3nmgWvUTY
 9kykBnYxtsmyAv0r8SoRu11Fbs1BZQvkKJl8v0vmoXhAkTfjkZloc9GAXjWNUJlSYSLGEUkDN
 AdC417R/i0L32U9mA0hVZIJCjjVV5J7vSzZbVcWQQcF1vLDj8PTytkm3x2SYEQ3HpOpcpVhWn
 D72hAySscu3rSw2qkEjkPa8YHc9JFPanD6YGaW0M8q15d35t1/mtK2S6tLxIUIOIRqR4wids/
 mB8fJA6Bo0gXtljRFozRUtZMAJXMxQGOFEf95eFK1HyxePCi2hQ7gQmj57rieEuFvgrbbk3ni
 ACdgFAGiUGnNHbTDxXdl+54jBXGNOrzWBVkz6Yx26goxlWoNXwNzEGoC3H011NdJ+jRGlW5ie
 4Dxl4F5kR4ar+F5WAthZGAmwVJkyggbGYX5uKamwjsZkL5/wdJVoGEYJ7JteVYf7bDezUhpOT
 JdyitmqfAvLB3laOuUXCtfWRyBQUifTgrrReAnqyPvF+apO5m76osKGtgNJz16g9PV7VLiO1s
 kJzmRHxFRu1oHGSKy4VxDRzqZ1qbOyalZN5k4NqM+oH5d904lmFPZJedlwpEmkWxLAT2Fby3z
 heclPZSZdeVc/iXL835D+e8DqsMt6RiIT/cCzGsXFuo17J1Lib/ea1eXK/k+0BSxEoeRD1b/3
 Kgn68rkHxGBDspingx/PaWtWJ2iLl6TPtRk5d8pXRC9uabsuUIMD+aX9hKZm3VOpVTi1CTyt4
 Luj5AoUBrdYD5PvmTIfbgKNkMeEejxsNyv6SmHl3+/S20LVfvpkcLN2dMVhRxTe54CPCzpSPa
 mA1eWnIjMzbfwfY0humPBmOdEr2WRBnUAl8GuHmzM2Z/rKmaZLoAiho0Mp3Q5I6ySsGGiTgXj
 yfV+CyROKzE+mHmfoPbK6Dbg1HCtv1P/YT6D3drwtbXMv8aZ7FIRmtP/aQPbyHKUgZ7h+2YcW
 6Mh7E122INz236LdG6SoDq3inhedkBXkewgOadTzfsZ5kn2ye2FR/9HVzKmmeZTmjbbkKRo50
 f4bQ9W+FAHDDqdiJgqDQiiQekpc0GMiql5Kd8srOs0Wz2XFAb1SzwtxGxtPNOtw3qCMUiiTPr
 6/zpzegy0PIXROVRMoBGkYxjnDbfNZ2w6IQbjTw==

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
=2D--------------------

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
=2D------------------

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

2.- Per process enabling/disabling: To allow that specific applications ca=
n
    turn off or turn on the detection and mitigation of a fork brute force
    attack when required, there are two new prctls.

    prctl(PR_FBFAM_ENABLE, 0, 0, 0, 0)  -> To enable the feature
    prctl(PR_FBFAM_DISABLE, 0, 0, 0, 0) -> To disable the feature

    Both functions return zero on success and -EFAULT if the current task
    doesn't have statistical data.

3.- Fine tuning: To customize the detection's sensibility there is a new
    sysctl that allows to set the crashing rate threshold. It is accessibl=
e
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

The 4/9 patch adds a new sysctl to fine tuning the detection's sensibility=
.

The 5/9 patch detects a fork brute force attack calculating the crashing
rate.

The 6/9 patch mitigates the attack killing all the offending tasks.

The 7/9 patch adds two new prctls to allow per task enabling/disabling.

The 8/9 patch adds general documentation.

The 9/9 patch adds an entry to the maintainers list.

This patch series is a task of the KSPP [1] and it is worth to mention
that there is a previous attempt without any continuation [2].

[1] https://github.com/KSPP/linux/issues/39
[2] https://lore.kernel.org/linux-fsdevel/1419457167-15042-1-git-send-emai=
l-richard@nod.at/

Any constructive comments are welcome.

Note: During the compilation these warnings were shown:

kernel/exit.o: warning: objtool: __x64_sys_exit_group()+0x18: unreachable =
instruction
arch/x86/kernel/cpu/mce/core.o: warning: objtool: mce_panic()+0x123: unrea=
chable instruction
arch/x86/kernel/smpboot.o: warning: objtool: native_play_dead()+0x122: unr=
eachable instruction
net/core/skbuff.o: warning: objtool: skb_push.cold()+0x14: unreachable ins=
truction

John Wood (9):
  security/fbfam: Add a Kconfig to enable the fbfam feature
  security/fbfam: Add the api to manage statistics
  security/fbfam: Use the api to manage statistics
  security/fbfam: Add a new sysctl to control the crashing rate
    threshold
  security/fbfam: Detect a fork brute force attack
  security/fbfam: Mitigate a fork brute force attack
  security/fbfam: Add two new prctls to enable and disable the fbfam
    feature
  Documentation/security: Add documentation for the fbfam feature
  MAINTAINERS: Add a new entry for the fbfam feature

 Documentation/security/fbfam.rst | 111 +++++++++++
 Documentation/security/index.rst |   1 +
 MAINTAINERS                      |   7 +
 fs/coredump.c                    |   2 +
 fs/exec.c                        |   2 +
 include/fbfam/fbfam.h            |  29 +++
 include/linux/sched.h            |   4 +
 include/uapi/linux/prctl.h       |   4 +
 kernel/exit.c                    |   2 +
 kernel/fork.c                    |   4 +
 kernel/sys.c                     |   8 +
 kernel/sysctl.c                  |   9 +
 security/Kconfig                 |   1 +
 security/Makefile                |   4 +
 security/fbfam/Kconfig           |  10 +
 security/fbfam/Makefile          |   3 +
 security/fbfam/fbfam.c           | 329 +++++++++++++++++++++++++++++++
 security/fbfam/sysctl.c          |  20 ++
 18 files changed, 550 insertions(+)
 create mode 100644 Documentation/security/fbfam.rst
 create mode 100644 include/fbfam/fbfam.h
 create mode 100644 security/fbfam/Kconfig
 create mode 100644 security/fbfam/Makefile
 create mode 100644 security/fbfam/fbfam.c
 create mode 100644 security/fbfam/sysctl.c

=2D-
2.25.1

