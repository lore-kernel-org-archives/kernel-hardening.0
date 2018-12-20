From: Tycho Andersen <tycho@tycho.ws>
Subject: [RFC v1 0/4] static analysis of copy_to_user()
Date: Thu, 20 Dec 2018 12:59:27 -0700
Message-Id: <20181220195931.20331-1-tycho@tycho.ws>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Tycho Andersen <tycho@tycho.ws>
List-ID: <kernel-hardening.lists.openwall.com>

Hi all,

A while ago I talked with various people about whether some static
analsys of copy_to_user() could be productive in finding infoleaks.
Unfortunately, due to the various issues outlined in the patch notes, it
doesn't seem like it is. Perhaps these checks are useful to put in just
to future proof ourselves against these sorts of issues, though.

Anyway, here's the code. Thoughts welcome!

Tycho

Tycho Andersen (4):
  expression.h: update comment to include other cast types
  move name-based analysis before linearization
  add a check for copy_to_user() address spaces
  check copy_to_user() sizes

 expression.h                           |   2 +-
 sparse.c                               | 327 ++++++++++++++++++++++---
 validation/copy_to_user.c              |  31 +++
 validation/copy_to_user_sizes.c        |  53 ++++
 validation/copy_to_user_sizes_inline.c |  29 +++
 5 files changed, 405 insertions(+), 37 deletions(-)
 create mode 100644 validation/copy_to_user.c
 create mode 100644 validation/copy_to_user_sizes.c
 create mode 100644 validation/copy_to_user_sizes_inline.c

-- 
2.19.1
