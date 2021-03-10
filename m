Return-Path: <SRS0=ah+p=II=lists.openwall.com=kernel-hardening-return-20908-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 401C1C433DB
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Mar 2021 16:10:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7BA5264F02
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Mar 2021 16:10:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BA5264F02
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20908-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10173 invoked by uid 550); 10 Mar 2021 16:10:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10135 invoked from network); 10 Mar 2021 16:10:30 -0000
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Al Viro <viro@zeniv.linux.org.uk>,
	James Morris <jmorris@namei.org>,
	Serge Hallyn <serge@hallyn.com>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christoph Hellwig <hch@lst.de>,
	David Howells <dhowells@redhat.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Eric Biederman <ebiederm@xmission.com>,
	John Johansen <john.johansen@canonical.com>,
	Kees Cook <keescook@chromium.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	kernel-hardening@lists.openwall.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v1 0/1] Unprivileged chroot
Date: Wed, 10 Mar 2021 17:09:59 +0100
Message-Id: <20210310161000.382796-1-mic@digikod.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

The chroot system call is currently limited to be used by processes with
the CAP_SYS_CHROOT capability.  This protects against malicious
procesess willing to trick SUID-like binaries.  The following patch
allows unprivileged users to safely use chroot(2).

This patch is a follow-up of a previous one sent by Andy Lutomirski some
time ago:
https://lore.kernel.org/lkml/0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net/

This patch can be applied on top of v5.12-rc2 .  I would really
appreciate constructive reviews.

Regards,

Mickaël Salaün (1):
  fs: Allow no_new_privs tasks to call chroot(2)

 fs/open.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 61 insertions(+), 3 deletions(-)


base-commit: a38fd8748464831584a19438cbb3082b5a2dab15
-- 
2.30.2

