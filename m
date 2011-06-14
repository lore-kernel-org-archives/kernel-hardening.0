Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 14 Jun 2011 12:35:59 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110614083559.GB7973@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] HARDEN_VM86
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar, all -

While actual implementation of CONFIG_HARDEN_VM86 is trivial, the most
important part of pushing the feature into upstream is clarifying to
what security domain vm86(2)/vm86old(2) should be restricted.  In -ow
and -grsecurity it is restricted to CAP_SYS_RAWIO.

I see 3 possibilities:

1) Restrict it to CAP_SYS_RAWIO and make it configurable via sysctl
kernel.vm86_restricted.  0 means current behaviour, 1 means
CAP_SYS_RAWIO-only.

2) The same as (1), but CAP_SYS_ADMIN.

3) Restrict it to some group or CAP_SYS_ADMIN, configurable via
kernel.vm86_group_allowed.  As vm86 is a rarely used thing, group range
makes little sense for me.  0 means root only, -1 means current
behaviour, X>0 means group X.



For people not familiar with CONFIG_HARDEN_VM86:

CONFIG_HARDEN_VM86
  On x86 processors, the Virtual 8086 (VM86) mode allows the execution
  of real mode operating systems and applications (primarily DOS) under
  protected mode operating systems such as Linux (with dosemu).  This
  requires support from the kernel.  Although the amount of kernel code
  needed to support the VM86 mode is small and no security problems
  with it are currently known, that code is unused on most Linux systems
  and as such it poses an unreasonable risk.  This option restricts
  access to system calls used to enter the VM86 mode to processes that
  possess the CAP_SYS_RAWIO capability.  The effect is that any potential
  security bugs in the VM86 mode support code are neutralized.


Thanks,

-- 
Vasiliy
