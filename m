Return-Path: <SRS0=gsMj=EA=lists.openwall.com=kernel-hardening-return-20264-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC730C56201
	for <kernel-hardening@archiver.kernel.org>; Sun, 25 Oct 2020 13:47:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B57C4223AE
	for <kernel-hardening@archiver.kernel.org>; Sun, 25 Oct 2020 13:46:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="KgGaiq/A"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B57C4223AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20264-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24474 invoked by uid 550); 25 Oct 2020 13:46:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24433 invoked from network); 25 Oct 2020 13:46:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1603633591;
	bh=JrGm1wF1k+vuYjU+ydHvebWusyZNCIY3jwUYaN/WjbM=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
	b=KgGaiq/ArcYLp/0WMWClI/Gb2FikP3xypikJV9avt8L4sIsY84hmfseob3wtkvdkl
	 ZNmDfNOwp2aKhTfMC/wkBU36lnKno8sSMl0OEe09231s0CaJOPFYzKNn6ASq4TrxoL
	 Jl292ate8uJHrZDodOOJZkou2JA1O03LYbNN/x/I=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
From: John Wood <john.wood@gmx.com>
To: Kees Cook <keescook@chromium.org>,
	Jann Horn <jannh@google.com>
Cc: John Wood <john.wood@gmx.com>,
	Jonathan Corbet <corbet@lwn.net>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v2 0/8] Fork brute force attack mitigation
Date: Sun, 25 Oct 2020 14:45:32 +0100
Message-Id: <20201025134540.3770-1-john.wood@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:hEzp76Q+KEFfGVP4vNspP5jFakx1Js4QivuR+o6uUwr9wu09z8Q
 tz98LL1d9unta8it5qbwAKNt7C+hOpOsA2kvCE3lLY3mp2H44wTlTuRWzSJf/b3AL3WLdtT
 j70oL7JVkFsOKMUoqSdbJ4LDteiKJXDpLpXwG9bNC8YfCkhMMcXuFQUtwhLuaHYS3yBbh/K
 o4A7QMmo39c20xaC/K10g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:kzlZC/xxXng=:1r6hgD56eUFw5BLisPGNR6
 FkqA5cq9zOz1R61OuxOIB1ZcY6j5MqI5zO6kZi2/zPLwpQM/lrdwDTAKll15z3EdR+YxsUsLg
 zSAqcmhAe4rJzDBtIVsuRK6NZaOC+cQItJYNxia/kN5C8T05zSukJVsab/R3fdGbFHZtn/Vgf
 9tt4NCHhZDboqupnb1fAoqHTUoSNlxNGX4MifwMIfYjOy+E/Ad53hRbrpuM2mLPn2+NU2S7J6
 3Irb7MP5lrXznFe9hPizURJfStd4AbMUAzxc1OX32FNVZMya2SgrrA1zCqbvBF6zrC2pEUBqD
 EW+Uirn96Sd5eP2cK0SIhmFDs/65a7l/ZNKa9bH3deEwsyD5z6hNr/fr9uJKumekqPodEef21
 C1F254k8TZIulTIfHzWcYCm5aygubc9e2Af9Ko5GVWeJinVrCs2wrPHXA9C/d6oChE3yOLw/n
 V76q81f5PCkJcLIKz7H8608vAM1ynTNZOJU4GxIotiOo77mKCmSd55Lm0iGF04z3Su1qPFF+G
 crOkqpLN+O6BAgJbHmIe98FhP5HYIKEk5/tFFUBlPkKKcj3OI7zW2Fmmg39t8BnJ/UXme2TRd
 w9MDU9WmdLXDc4Yq+PpXGFkv6lgPAfRT78p+LrDgCccZikgLvbumzuFBNx7UpwlraXmTrU6TJ
 fQwza6dKl5VPUwYtumBwrLb6WP2ej+9cbW0rLVuZj8yTB+2ESXBiM/FFKwlkCDKl+vRUqAr11
 BhJ/ZHQybUQu+SO8lCiEmsvjFrKY2vuAvuzNmRAPRuR5nIzWrDVNiLyS0dtIiGQcawr1NU8tc
 2JRyrYT/kwVPksHSOgLrp25chbcMOmLy8YWVtxUXMU8foBM7IUMsvIqKv1JscPqVegJOkv4Vg
 L9hw+c14ZeWTa1+BA/2w==

Attacks against vulnerable userspace applications with the purpose to brea=
k
ASLR or bypass canaries traditionaly use some level of brute force with th=
e
help of the fork system call. This is possible since when creating a new
process using fork its memory contents are the same as those of the parent
process (the process that called the fork system call). So, the attacker
can test the memory infinite times to find the correct memory values or th=
e
correct memory addresses without worrying about crashing the application.

Based on the above scenario it would be nice to have this detected and
mitigated, and this is the goal of this patch serie.

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
          doesn't act if the parent crashes. So, it would still be possibl=
e
          for an attacker to fork a process and probe itself. Then, fork
          the child process and probe itself again. This way, these steps
          can be repeated infinite times without any mitigation.

This implementation
=2D------------------

The main idea behind this implementation is to improve the existing ones
focusing on the weak points annotated before. The solution for the first
bypass method is to detect a fast crash rate instead of only one simple
crash. For the second bypass method the solution is to detect both the
crash of parent and child processes. Moreover, as a mitigation method it i=
s
better to kill all the offending tasks involve in the attack instead of us=
e
delays.

So, the solution to the two bypass methods previously commented is to use
some statistical data shared across all the processes that can have the
same memory contents. Or in other words, a statistical data shared between
all the fork hierarchy processes after an execve system call.

The purpose of these statistics is to compute the application crash period
in order to detect an attack. This crash period is the time between the
execve system call and the first fault or the time between two consecutive=
s
faults, but this has a drawback. If an application crashes once quickly
from the execve system call or crashes twice in a short period of time for
some reason, a false positive attack will be triggered. To avoid this
scenario the shared statistical data holds a list of the i last crashes
timestamps and the application crash period is computed as follows:

crash_period =3D (n_last_timestamp - n_minus_i_timestamp) / i;

This ways, the size of the last crashes timestamps list allows to fine
tuning the detection sensibility.

When this crash period falls under a certain threshold there is a clear
signal that something malicious is happening. Once detected, the mitigatio=
n
only kills the processes that share the same statistical data and so, all
the tasks that can have the same memory contents. This way, an attack is
rejected.

1.- Per system enabling: This feature can be enabled at build time using
    the CONFIG_SECURITY_FORK_BRUTE option or using the visual config
    application under the following menu:

    Security options ---> Fork brute force attack detection and mitigation

2.- Per process enabling/disabling: To allow that specific applications ca=
n
    turn off or turn on the detection and mitigation of a fork brute force
    attack when required, there are two new prctls.

    prctl(PR_SECURITY_FORK_BRUTE_ENABLE, 0, 0, 0, 0)
    prctl(PR_SECURITY_FORK_BRUTE_DISABLE, 0, 0, 0, 0)

3.- Fine tuning: To customize the detection's sensibility there are two ne=
w
    sysctl attributes that allow to set the last crashes timestamps list
    size and the application crash period threshold (in milliseconds). Bot=
h
    are accessible through the following files respectively.

    /proc/sys/kernel/brute/timestamps_list_size
    /proc/sys/kernel/brute/crash_period_threshold

    The list size allows to avoid false positives due to crashes unrelated
    with a real attack. The period threshold sets the time limit to detect
    an attack. And, since a fork brute force attack will be detected if th=
e
    application crash period falls under this threshold, the higher this
    value, the more sensitive the detection will be.

So, knowing all this information I will explain now the different patches:

The 1/8 patch defines a new LSM hook to get the fatal signal of a task.
This will be useful during the attack detection phase.

The 2/8 patch defines a new LSM and manages the statistical data shared by
all the fork hierarchy processes.

The 3/8 patch adds the sysctl attributes to fine tuning the detection.

Patchs 4/8 and 5/8 detect and mitigate a fork brute force attack.

Patch 6/8 adds the prctls to allow per process enabling/disabling.

Patch 7/8 adds the documentation to explain this implementation.

Patch 8/8 updates the maintainers file.

This patch series is a task of the KSPP [1] and can also be accessed from
my github tree [2] in the "brute_v2" branch.

[1] https://github.com/KSPP/linux/issues/39
[2] https://github.com/johwood/linux/

The first version can be found in:

https://lore.kernel.org/kernel-hardening/20200910202107.3799376-1-keescook=
@chromium.org/

Changelog RFC -> v2
=2D------------------
- Rename this feature with a more appropiate name (Jann Horn, Kees Cook).
- Convert the code to an LSM (Kees Cook).
- Add locking  to avoid data races (Jann Horn).
- Add a new LSM hook to get the fatal signal of a task (Jann Horn, Kees
  Cook).
- Add the last crashes timestamps list to avoid false positives in the
  attack detection (Jann Horn).
- Use "period" instead of "rate" (Jann Horn).
- Other minor changes suggested (Jann Horn, Kees Cook).

John Wood (8):
  security: Add LSM hook at the point where a task gets a fatal signal
  security/brute: Define a LSM and manage statistical data
  security/brute: Add sysctl attributes to allow detection fine tuning
  security/brute: Detect a fork brute force attack
  security/brute: Mitigate a fork brute force attack
  security/brute: Add prctls to enable/disable the fork attack detection
  Documentation: Add documentation for the Brute LSM
  MAINTAINERS: Add a new entry for the Brute LSM

 Documentation/admin-guide/LSM/Brute.rst | 118 ++++
 Documentation/admin-guide/LSM/index.rst |   1 +
 MAINTAINERS                             |   7 +
 include/brute/brute.h                   |  16 +
 include/linux/lsm_hook_defs.h           |   1 +
 include/linux/lsm_hooks.h               |   4 +
 include/linux/security.h                |   4 +
 include/uapi/linux/prctl.h              |   4 +
 kernel/signal.c                         |   1 +
 kernel/sys.c                            |   8 +
 security/Kconfig                        |  11 +-
 security/Makefile                       |   4 +
 security/brute/Kconfig                  |  13 +
 security/brute/Makefile                 |   2 +
 security/brute/brute.c                  | 749 ++++++++++++++++++++++++
 security/security.c                     |   5 +
 16 files changed, 943 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/admin-guide/LSM/Brute.rst
 create mode 100644 include/brute/brute.h
 create mode 100644 security/brute/Kconfig
 create mode 100644 security/brute/Makefile
 create mode 100644 security/brute/brute.c

=2D-
2.25.1

