Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 9 Aug 2011 11:30:37 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110809073037.GA3767@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] segoon's status report - #13 of 15
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Not too many accomplishments this time - I was interrupted by unexrected
university occasions.

Accomplishments:

 * Addressed a kernel oops on ARM/MIPS/UML.
 * Posted a next procfs patch version to k-h.
 * Found a race in /proc/PID/fd{,info}/ handling, sent a patch to LKML.
 * Posted a basic patch to lock pid namespace to 32 or 64 bit
   syscalls/ELFs.

Priorities:

 * Push USERCOPY, RLIMIT_NPROC, a.out patches as soon as 3.1-rc1 is out.
 * Finish procfs and bitness locking patches.
 * Discuss base address for libs, ASLR, GNU_STACK.

-- 
Vasiliy
