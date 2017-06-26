From: Igor Stoppa <igor.stoppa@huawei.com>
Date: Mon, 26 Jun 2017 17:41:13 +0300
Message-ID: <20170626144116.27599-1-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] [PATCH v7 0/3] ro protection for dynamic data
To: keescook@chromium.org, mhocko@kernel.org, jmorris@namei.org, labbott@redhat.com
Cc: penguin-kernel@I-love.SAKURA.ne.jp, paul@paul-moore.com, sds@tycho.nsa.gov, casey@schaufler-ca.com, hch@infradead.org, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Igor
 Stoppa <igor.stoppa@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,
please consider for inclusion.

This patch introduces the possibility of protecting memory that has
been allocated dynamically.

The memory is managed in pools: when a pool is made R/O, all the memory
that is part of it, will become R/O.

A R/O pool can be destroyed to recover its memory, but it cannot be
turned back into R/W mode.

This is intentional. This feature is meant for data that doesn't need
further modifications, after initialization.

An example is provided, showing how to turn into a boot-time option the
writable state of the security hooks.
Prior to this patch, it was a compile-time option.

This is made possible, thanks to Tetsuo Handa's rework of the hooks
structure (included in the patchset).

Changes since the v6 version:
- complete rewrite, to use the genalloc library
- added sysfs interface for tracking of active pools

The only question still open is if there should be a possibility for
unprotecting a memory pool in other cases than destruction.

The only cases found for this topic are:
- protecting the LSM header structure between creation and insertion of a
  security module that was not built as part of the kernel
  (but the module can protect the headers after it has loaded)

- unloading SELinux from RedHat, if the system has booted, but no policy
  has been loaded yet - this feature is going away, according to Casey.


Igor Stoppa (2):
  Protectable memory support
  Make LSM Writable Hooks a command line option

Tetsuo Handa (1):
  LSM: Convert security_hook_heads into explicit array of struct
    list_head

 arch/Kconfig                   |   1 +
 include/linux/lsm_hooks.h      | 420 ++++++++++++++++++++---------------------
 include/linux/page-flags.h     |   2 +
 include/linux/pmalloc.h        | 111 +++++++++++
 include/trace/events/mmflags.h |   1 +
 init/main.c                    |   2 +
 lib/Kconfig                    |   1 +
 lib/genalloc.c                 |   4 +-
 mm/Makefile                    |   1 +
 mm/pmalloc.c                   | 346 +++++++++++++++++++++++++++++++++
 mm/usercopy.c                  |  24 ++-
 security/security.c            |  49 +++--
 12 files changed, 726 insertions(+), 236 deletions(-)
 create mode 100644 include/linux/pmalloc.h
 create mode 100644 mm/pmalloc.c

-- 
2.9.3
