Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 25 Jul 2011 22:53:58 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110725185358.GA16994@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] segoon's status report - #11 of 15
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Accomplishments:

 * Posted v2 and v3 of USERCOPY RFC to LKML.
 * Stated the GNU_STACK handling issue on k-h list.
 * Got a new direction of work in GNU_STACK area (RHEL's exec shield
   implementation).
 * Summarized all accomplishments of the GSoC and posted the list on k-h
   list.
 * Built and posted a list of possibly dangerous kernel infoleaks.
 * Reviewed PAX_MPROTECT feature and posted the summary to the list.
 * Reviewed securelevel'ish Grsecurity restrictions and posted my
   thoughts on k-h list.
 * Started to implement more finegranted HARDEN_PROC feature.
 * Got a new task from Solar: investigate differences in base addresses
   for mmap areas in x86-32 and 32-bit tasks in x86-64.

Priorities:

 * RLIMIT_NPROC discussion with upstream.
 * USERCOPY discussion and elaboration.
 * HARDEN_RPOC implementation.
 * GNU_STACK issue investigation.
 * Base lib address differences in x86-32 and 32-bit tasks in x86-64.

-- 
Vasiliy
