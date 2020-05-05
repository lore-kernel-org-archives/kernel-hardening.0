Return-Path: <SRS0=ssfX=6T=lists.openwall.com=kernel-hardening-return-18716-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7C40C47259
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 May 2020 15:32:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 193CE206B9
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 May 2020 15:32:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 193CE206B9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18716-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31855 invoked by uid 550); 5 May 2020 15:32:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31829 invoked from network); 5 May 2020 15:32:29 -0000
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>,
	Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
	Mimi Zohar <zohar@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v5 0/6] Add support for O_MAYEXEC
Date: Tue,  5 May 2020 17:31:50 +0200
Message-Id: <20200505153156.925111-1-mic@digikod.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000

Hi,

This fifth patch series add new kernel configurations (OMAYEXEC_STATIC,
OMAYEXEC_ENFORCE_MOUNT, and OMAYEXEC_ENFORCE_FILE) to enable to
configure the security policy at kernel build time.  As requested by
Mimi Zohar, I completed the series with one of her patches for IMA.

The goal of this patch series is to enable to control script execution
with interpreters help.  A new O_MAYEXEC flag, usable through
openat2(2), is added to enable userspace script interpreter to delegate
to the kernel (and thus the system security policy) the permission to
interpret/execute scripts or other files containing what can be seen as
commands.

A simple system-wide security policy can be enforced by the system
administrator through a sysctl configuration consistent with the mount
points or the file access rights.  The documentation patch explains the
prerequisites.

Furthermore, the security policy can also be delegated to an LSM, either
a MAC system or an integrity system.  For instance, the new kernel
MAY_OPENEXEC flag closes a major IMA measurement/appraisal interpreter
integrity gap by bringing the ability to check the use of scripts [1].
Other uses are expected, such as for openat2(2) [2], SGX integration
[3], bpffs [4] or IPE [5].

Userspace needs to adapt to take advantage of this new feature.  For
example, the PEP 578 [6] (Runtime Audit Hooks) enables Python 3.8 to be
extended with policy enforcement points related to code interpretation,
which can be used to align with the PowerShell audit features.
Additional Python security improvements (e.g. a limited interpreter
withou -c, stdin piping of code) are on their way.

The initial idea come from CLIP OS 4 and the original implementation has
been used for more than 12 years:
https://github.com/clipos-archive/clipos4_doc

An introduction to O_MAYEXEC was given at the Linux Security Summit
Europe 2018 - Linux Kernel Security Contributions by ANSSI:
https://www.youtube.com/watch?v=chNjCRtPKQY&t=17m15s
The "write xor execute" principle was explained at Kernel Recipes 2018 -
CLIP OS: a defense-in-depth OS:
https://www.youtube.com/watch?v=PjRE0uBtkHU&t=11m14s

This patch series can be applied on top of v5.7-rc4.  This can be tested
with CONFIG_SYSCTL.  I would really appreciate constructive comments on
this patch series.

Previous version:
https://lore.kernel.org/lkml/20200428175129.634352-1-mic@digikod.net/


[1] https://lore.kernel.org/lkml/1544647356.4028.105.camel@linux.ibm.com/
[2] https://lore.kernel.org/lkml/20190904201933.10736-6-cyphar@cyphar.com/
[3] https://lore.kernel.org/lkml/CALCETrVovr8XNZSroey7pHF46O=kj_c5D9K8h=z2T_cNrpvMig@mail.gmail.com/
[4] https://lore.kernel.org/lkml/CALCETrVeZ0eufFXwfhtaG_j+AdvbzEWE0M3wjXMWVEO7pj+xkw@mail.gmail.com/
[5] https://lore.kernel.org/lkml/20200406221439.1469862-12-deven.desai@linux.microsoft.com/
[6] https://www.python.org/dev/peps/pep-0578/

Regards,

Mickaël Salaün (5):
  fs: Add support for an O_MAYEXEC flag on openat2(2)
  fs: Add a MAY_EXECMOUNT flag to infer the noexec mount property
  fs: Enable to enforce noexec mounts or file exec through O_MAYEXEC
  selftest/openat2: Add tests for O_MAYEXEC enforcing
  doc: Add documentation for the fs.open_mayexec_enforce sysctl

Mimi Zohar (1):
  ima: add policy support for the new file open MAY_OPENEXEC flag

 Documentation/ABI/testing/ima_policy          |   2 +-
 Documentation/admin-guide/sysctl/fs.rst       |  44 +++
 fs/fcntl.c                                    |   2 +-
 fs/namei.c                                    |  89 ++++-
 fs/open.c                                     |   8 +
 include/linux/fcntl.h                         |   2 +-
 include/linux/fs.h                            |   9 +
 include/uapi/asm-generic/fcntl.h              |   7 +
 kernel/sysctl.c                               |   9 +
 security/Kconfig                              |  26 ++
 security/integrity/ima/ima_main.c             |   3 +-
 security/integrity/ima/ima_policy.c           |  15 +-
 tools/testing/selftests/kselftest_harness.h   |   3 +
 tools/testing/selftests/openat2/Makefile      |   3 +-
 tools/testing/selftests/openat2/config        |   1 +
 tools/testing/selftests/openat2/helpers.h     |   1 +
 .../testing/selftests/openat2/omayexec_test.c | 330 ++++++++++++++++++
 17 files changed, 544 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/openat2/config
 create mode 100644 tools/testing/selftests/openat2/omayexec_test.c

-- 
2.26.2

