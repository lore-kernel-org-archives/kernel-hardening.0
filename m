Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 15 Jun 2011 23:53:58 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110615195358.GA7180@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] segoon's status report - #5 of 15
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Accomplishments:

  * Reworked and sent procfs patch to LKML.
  * Discussed an RLIMIT_NPROC check inside of setuid() and execve(),
    started a discussion on LKML.
  * Discussed a log spoofing via user supplied string in printk().

Priorities:

  * More actively communicate with upstream.
  * Implement patches for orphaned shmem segments destroy, vm86
    restrictions.
  * Overview PaX features, determine what parts of it are acceptable for
    upstream.

-- 
Vasiliy
