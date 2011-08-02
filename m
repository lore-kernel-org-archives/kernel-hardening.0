Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 2 Aug 2011 18:48:39 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110802144839.GA3598@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] segoon's status report - #12 of 15
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Accomplishments:

 * Got applied shm fixes (separate pid namespaces, optimization) to 3.1
   tree.
 * Got a new task: remove remains of a.out parts of ELF format
   interpreter.
 * Proposed mmap guard pages.
 * Posted v3 of RLIMIT_NRPOC patch to LKML.
 * Reviewed GNU_STACK handling in RHEL glibc and kernel.
 * Posted an early version of procfs *_allowed= feature on k-h list.
 * Posted a list of -ow features and their status in sense of upstream
   acceptance.

Priorities:

 * See RLIMIT_NPROC applied.
 * Resend USERCOPY (as a patch).
 * Finish procfs patch.
 * Discuss base address for libs, GNU_STACK, 32/64-bit restrictions.

-- 
Vasiliy
