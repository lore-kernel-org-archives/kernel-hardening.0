Return-Path: <SRS0=4sW5=4I=lists.openwall.com=kernel-hardening-return-17859-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50D23C11D20
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Feb 2020 20:48:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AA99720801
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Feb 2020 20:48:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA99720801
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17859-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27703 invoked by uid 550); 20 Feb 2020 20:48:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27660 invoked from network); 20 Feb 2020 20:48:40 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,  LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux API <linux-api@vger.kernel.org>,  Linux FS Devel <linux-fsdevel@vger.kernel.org>,  Linux Security Module <linux-security-module@vger.kernel.org>,  Akinobu Mita <akinobu.mita@gmail.com>,  Alexey Dobriyan <adobriyan@gmail.com>,  Andrew Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,  Daniel Micay <danielmicay@gmail.com>,  Djalal Harouni <tixxdz@gmail.com>,  "Dmitry V . Levin" <ldv@altlinux.org>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Ingo Molnar <mingo@kernel.org>,  "J . Bruce Fields" <bfields@fieldses.org>,  Jeff Layton <jlayton@poochiereds.net>,  Jonathan Corbet <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Oleg Nesterov <oleg@redhat.com>,  Solar Designer <solar@openwall.com>
References: <20200210150519.538333-8-gladkov.alexey@gmail.com>
	<87v9odlxbr.fsf@x220.int.ebiederm.org>
	<20200212144921.sykucj4mekcziicz@comp-core-i7-2640m-0182e6>
	<87tv3vkg1a.fsf@x220.int.ebiederm.org>
	<CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
	<87v9obipk9.fsf@x220.int.ebiederm.org>
	<CAHk-=wgwmu4jpmOqW0+Lz0dcem1Fub=ThLHvmLobf_WqCq7bwg@mail.gmail.com>
	<20200212200335.GO23230@ZenIV.linux.org.uk>
	<CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
	<20200212203833.GQ23230@ZenIV.linux.org.uk>
	<20200212204124.GR23230@ZenIV.linux.org.uk>
	<CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
	<87lfp7h422.fsf@x220.int.ebiederm.org>
	<CAHk-=wgmn9Qds0VznyphouSZW6e42GWDT5H1dpZg8pyGDGN+=w@mail.gmail.com>
	<87pnejf6fz.fsf@x220.int.ebiederm.org>
Date: Thu, 20 Feb 2020 14:46:25 -0600
In-Reply-To: <87pnejf6fz.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Wed, 12 Feb 2020 22:37:52 -0600")
Message-ID: <871rqpaswu.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j4skD-00085Y-Cz;;;mid=<871rqpaswu.fsf_-_@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/Q6NKhmM+yXD+yJ+hS7KlJi2ul8+5zveY=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 0/7] proc: Dentry flushing without proc_mnt
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)


Just because it is less of a fundamental change and less testing I went
and looked at updating proc_flush_task to use a list as Al suggested.

If we can stand an sget/deactivate_super pair for every dentry we want
to invalidate I think I have something.

Comments from anyone will be appreciated I gave this some light testing
and the code is based on something similar already present in proc so
I think there is a high chance this code is correct but I could easily
be wrong.

Linus, does this approach look like something you can stand?

Eric

Eric W. Biederman (7):
      proc: Rename in proc_inode rename sysctl_inodes sibling_inodes
      proc: Generalize proc_sys_prune_dcache into proc_prune_siblings_dcache
      proc: Mov rcu_read_(lock|unlock) in proc_prune_siblings_dcache
      proc: Use d_invalidate in proc_prune_siblings_dcache
      proc: Clear the pieces of proc_inode that proc_evict_inode cares about
      proc: Use a list of inodes to flush from proc
      proc: Ensure we see the exit of each process tid exactly once

 fs/exec.c               |   5 +--
 fs/proc/base.c          | 111 ++++++++++++++++--------------------------------
 fs/proc/inode.c         |  60 +++++++++++++++++++++++---
 fs/proc/internal.h      |   4 +-
 fs/proc/proc_sysctl.c   |  45 +++-----------------
 include/linux/pid.h     |   2 +
 include/linux/proc_fs.h |   4 +-
 kernel/exit.c           |   4 +-
 kernel/pid.c            |  16 +++++++
 9 files changed, 124 insertions(+), 127 deletions(-)


