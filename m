From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 26 Sep 2017 16:14:31 +0200
Message-Id: <1506435273-8428-1-git-send-email-s.mesoraca16@gmail.com>
Subject: [kernel-hardening] [RFC v2 0/2] Restrict dangerous open in sticky directories
To: linux-kernel@vger.kernel.org
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org, Salvatore Mesoraca <s.mesoraca16@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This patch-set introduces two separate features aimed at restricting
dangerous open in world or group writable sticky directories.
The purpose is to prevent exploitable bugs in user-space programs
that don't access sticky directories in the proper way.
The first patch prevents the O_CREAT open of FIFOs and regular files
in world or group writable sticky directories if they already exists
and are owned by someone else.
The second patch prevents O_CREAT open in world or group writable
sticky when the O_EXCL flag is not set, even if the file doesn't
exist yet.
More details can be found in respective commit messages.

Salvatore Mesoraca (2):
  Protected FIFOs and regular files
  Protected O_CREAT open in sticky directory

 Documentation/sysctl/fs.txt |  66 +++++++++++++++++++++++++
 fs/namei.c                  | 118 ++++++++++++++++++++++++++++++++++++++++++--
 include/linux/fs.h          |   3 ++
 kernel/sysctl.c             |  27 ++++++++++
 4 files changed, 211 insertions(+), 3 deletions(-)

-- 
1.9.1
