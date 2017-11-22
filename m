From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Wed, 22 Nov 2017 09:01:44 +0100
Message-Id: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
Subject: [kernel-hardening] [PATCH v3 0/2] Restrict dangerous open in sticky directories
To: linux-kernel@vger.kernel.org
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-fsdevel@vger.kernel.org, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

This patch-set introduces two separate features aimed at restricting
dangerous open in world or group writable sticky directories.
The purpose is to prevent exploitable bugs in user-space programs
that don't access sticky directories in the proper way.
The first patch prevents the O_CREAT open of FIFOs and regular files
in world or group writable sticky directories, if they already exists
and are owned by someone else.
The second patch prevents O_CREAT open in world or group writable
sticky when the O_EXCL flag is not set, even if the file doesn't
exist yet.
More details can be found in the respective commit messages.

Changes in v3:
	- Fixed format string for uid_t that is unsigned
	  (suggested by Jann Horn).
	- Stop checking if file's and parent dir's owners match in
	  may_create_no_excl. This will allow to discover potential
	  vulnerabilities more easily.

Salvatore Mesoraca (2):
  Protected FIFOs and regular files
  Protected O_CREAT open in sticky directories

 Documentation/sysctl/fs.txt |  66 +++++++++++++++++++++++++
 fs/namei.c                  | 117 ++++++++++++++++++++++++++++++++++++++++++--
 include/linux/fs.h          |   3 ++
 kernel/sysctl.c             |  27 ++++++++++
 4 files changed, 210 insertions(+), 3 deletions(-)

-- 
1.9.1
