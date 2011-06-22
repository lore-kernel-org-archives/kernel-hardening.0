Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 22 Jun 2011 23:28:51 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110622192851.GA14650@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] segoon's status report - #6 of 15
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Accomplishments:

  * Implemented and tested HARDEN_SHM.
  * Implemented HARDEN_VM86, spotted an analogy with seccomp v2.
  * Got an information from LKML that procfs patch is incomplete in sense of
    taskstats and proc connector.  Heavily reworked implementation,
    removed hidepid=2.  Sent a ptrace part of the patch to LKML.
  * While observing taskstats code, fixed local DoS.
  * Sent a comment about RLIMIT_NPROC.
  * Started to read Intel Architecture Developer's Manual to
    review/implement full kernel RO/NX.

Priorities:

  * Continue to discuss everything with upstream.
  * Push/discuss pending patches to LKML.
  * Overview PaX features, determine what parts of it are acceptable for
    upstream.

-- 
Vasiliy
