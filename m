From: Kees Cook <keescook@chromium.org>
Date: Thu,  6 Apr 2017 14:18:20 -0700
Message-Id: <1491513513-84351-6-git-send-email-keescook@chromium.org>
In-Reply-To: <1491513513-84351-1-git-send-email-keescook@chromium.org>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 05/18] af_unix: Use designated initializers
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Prepare to mark sensitive kernel structures for randomization by making
sure they're using designated initializers. These were identified during
allyesconfig builds of x86, arm, and arm64, and the initializer fixes
were extracted from grsecurity. In this case, NULL initialize with { }
instead of undesignated NULLs.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 928691c43408..6a7fe7660551 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -996,7 +996,7 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	unsigned int hash;
 	struct unix_address *addr;
 	struct hlist_head *list;
-	struct path path = { NULL, NULL };
+	struct path path = { };
 
 	err = -EINVAL;
 	if (sunaddr->sun_family != AF_UNIX)
-- 
2.7.4
