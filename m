Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
From: Vasiliy Kulikov <segoon@openwall.com>
Date: Wed, 15 Jun 2011 17:57:56 +0400
Message-Id: <1308146276-12750-1-git-send-email-segoon@openwall.com>
Subject: [kernel-hardening] [RFC 0/5 v3] procfs: introduce hidepid=, hidenet=, gid= mount options
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>
List-ID: <kernel-hardening.lists.openwall.com>

This patch series adds support of procfs mount options and adds
mount options to restrict /proc/<pid>/ directories to owners and
/proc/<pid>/net/* to root.  Additional group may be defined via
gid=, and this group will be privileged to study others /proc/<pid>/
and networking information.

Similar features are implemented for old kernels in -ow patches (for
Linux 2.2 and 2.4) and for Linux 2.6 in -grsecurity, but both of them
are implemented as configure options, not cofigurable in runtime, with
changes of gid of /proc/<pid>/, and without backward-compatible
/proc/<pid>/net/* handling.


The first patch introduces mount option parsing without any new options.
The second patch adds options of /proc/<pid>/ restrictions.
The third patch makes net_create() globally visible.
The fourth patch adds options of /proc/<pid>/net/ restrictions.
The fifth patch adds documentations for options above.

Vasiliy Kulikov (5):
  procfs: parse mount options
  procfs: add hidepid= and gid= mount options
  net: restore net_create and make it globally visible
  procfs: Add hidenet/nohidenet procfs mount options.
  procfs: add documentation for procfs mount options

 Documentation/filesystems/proc.txt |   51 ++++++++++++++++++++++
 fs/proc/base.c                     |   62 ++++++++++++++++++++++++++-
 fs/proc/inode.c                    |   20 +++++++++
 fs/proc/internal.h                 |    1 +
 fs/proc/proc_net.c                 |   26 +++++++++++
 fs/proc/root.c                     |   83 +++++++++++++++++++++++++++++++++++-
 include/linux/pid_namespace.h      |    3 +
 include/net/net_namespace.h        |    2 +
 net/core/net_namespace.c           |   12 +++--
 9 files changed, 253 insertions(+), 7 deletions(-)
