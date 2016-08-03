Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 3 Aug 2016 16:36:23 +1000 (AEST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
Message-ID: <alpine.LRH.2.20.1608031635340.19613@namei.org>
References: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [RFC] [PATCH 0/5] Hardchroot LSM + additional hooks
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, keescook@chromium.org, spender@grsecurity.net, casey.schaufler@intel.com, michael.leibowitz@intel.com, william.c.roberts@intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 29 Jul 2016, Elena Reshetova wrote:

>  fs/fhandle.c                         |   5 +
>  fs/fs_struct.c                       |   7 +-
>  fs/namespace.c                       |  15 +-
>  fs/open.c                            |   3 +
>  include/linux/lsm_hooks.h            |  37 ++
>  include/linux/security.h             |  19 +
>  kernel/fork.c                        |   5 +
>  security/Kconfig                     |   1 +
>  security/Makefile                    |   2 +
>  security/hardchroot/Kconfig          |  10 +
>  security/hardchroot/Makefile         |   3 +
>  security/hardchroot/hardchroot_lsm.c | 654 +++++++++++++++++++++++++++++++++++
>  security/security.c                  |  30 ++
>  13 files changed, 786 insertions(+), 5 deletions(-)
>  create mode 100644 security/hardchroot/Kconfig
>  create mode 100644 security/hardchroot/Makefile
>  create mode 100644 security/hardchroot/hardchroot_lsm.c

Please cc: Al Viro on these changes.


-- 
James Morris
<jmorris@namei.org>
