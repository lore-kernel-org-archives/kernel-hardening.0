Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 28 Jun 2011 13:46:32 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110628094632.GA6006@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] segoon's status report - #7 of 15
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Accomplishments:

  * Lead a discussion on LKML about HARDEN_PROC patch.
  * Discovered /proc/*/io and taskstats private information infoleak.
    Suggested a patch series on LKML.
  * Proposed a fix for log spoofing.
  * Posted HARDEN_SHM patch to LKML.
  * Finished initial review of PaX features.
  * Posted a constification patch for acpi drivers.

Priorities:

  * Continue to discuss the patches with upstream.
  * Implement PAX_USERCOPY and PAX_REFCOUNT.

-- 
Vasiliy
