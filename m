Reply-To: kernel-hardening@lists.openwall.com
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Wed, 26 Oct 2016 08:56:42 +0200
Message-Id: <20161026065654.19166-7-mic@digikod.net>
In-Reply-To: <20161026065654.19166-1-mic@digikod.net>
References: <20161026065654.19166-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [RFC v4 06/18] fs: Constify path_is_under()'s arguments
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Mack <daniel@zonque.org>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Kees Cook <keescook@chromium.org>, Paul Moore <pmoore@redhat.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Will Drewry <wad@chromium.org>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, netdev@vger.kernel.org, cgroups@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
List-ID: <kernel-hardening.lists.openwall.com>

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c     | 2 +-
 include/linux/fs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index e6c234b1a645..4d80a5066a1f 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2997,7 +2997,7 @@ bool is_path_reachable(struct mount *mnt, struct dentry *dentry,
 	return &mnt->mnt == root->mnt && is_subdir(dentry, root->dentry);
 }
 
-bool path_is_under(struct path *path1, struct path *path2)
+bool path_is_under(const struct path *path1, const struct path *path2)
 {
 	bool res;
 	read_seqlock_excl(&mount_lock);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 16d2b6e874d6..abbaf162f70e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2709,7 +2709,7 @@ extern struct file * open_exec(const char *);
  
 /* fs/dcache.c -- generic fs support functions */
 extern bool is_subdir(struct dentry *, struct dentry *);
-extern bool path_is_under(struct path *, struct path *);
+extern bool path_is_under(const struct path *, const struct path *);
 
 extern char *file_path(struct file *, char *, int);
 
-- 
2.9.3
