Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 4 Jul 2011 23:22:21 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110704192221.GA4628@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] segoon's status report - #8 of 15
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Accomplishments:

  * Achieved an appliance of HARDEN_SHM feature to -mm tree.
  * Addressed all arised issues with /proc/<pid>/io and taskstats
    infoleaks.
  * Posted an RFC of lightweighted version of PAX_USERCOPY to LKML.
  * Advanced a bit with log spoofing prevention patch, identified the
    next actions direction.

Priorities:

  * Address all HARDEN_SHM arising issues.
  * Prepare and revise PAX_USERCOPY for upstream inclusion.
  * Prepare GNU_STACK configuring scheme.

-- 
Vasiliy
