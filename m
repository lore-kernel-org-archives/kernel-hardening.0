Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@fedoraproject.org>
Date: Fri,  4 Mar 2016 15:50:46 -0800
Message-Id: <1457135448-15541-1-git-send-email-labbott@fedoraproject.org>
Subject: [kernel-hardening] [PATCHv4 0/2] Sanitization of buddy pages
To: Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@fedoraproject.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is v4 of the santization of buddy pages. This is mostly just a rebase
and some phrasing tweaks from v2. Kees submitted a rebase of v3 so this is v4.

Kees, I'm hoping you will give your Tested-by and provide some stats from the
tests you were running before.

Thanks,
Laura

Laura Abbott (2):
  mm/page_poison.c: Enable PAGE_POISONING as a separate option
  mm/page_poisoning.c: Allow for zero poisoning

 Documentation/kernel-parameters.txt |   5 +
 include/linux/mm.h                  |  11 +++
 include/linux/poison.h              |   4 +
 kernel/power/hibernate.c            |  17 ++++
 mm/Kconfig.debug                    |  39 +++++++-
 mm/Makefile                         |   2 +-
 mm/debug-pagealloc.c                | 137 ----------------------------
 mm/page_alloc.c                     |  13 ++-
 mm/page_ext.c                       |  10 +-
 mm/page_poison.c                    | 176 ++++++++++++++++++++++++++++++++++++
 10 files changed, 272 insertions(+), 142 deletions(-)
 delete mode 100644 mm/debug-pagealloc.c
 create mode 100644 mm/page_poison.c

-- 
2.5.0
