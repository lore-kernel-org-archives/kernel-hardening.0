From: Matt Brown <matt@nmatt.com>
Date: Mon, 17 Apr 2017 02:07:04 -0400
Message-Id: <20170417060706.28674-3-matt@nmatt.com>
In-Reply-To: <20170417060706.28674-1-matt@nmatt.com>
References: <20170417060706.28674-1-matt@nmatt.com>
Subject: [kernel-hardening] [PATCH 2/4] add tiocsti_restrict variable
To: jmorris@namei.org, gregkh@linuxfoundation.org, akpm@linux-foundation.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Matt Brown <matt@nmatt.com>
List-ID: <kernel-hardening.lists.openwall.com>

adding extern variable tiocsti_restrict to allow it to be included
in sysctl

Signed-off-by: Matt Brown <matt@nmatt.com>
---
 include/linux/tty.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 1017e904..7011102 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -342,6 +342,8 @@ struct tty_file_private {
 	struct list_head list;
 };
 
+extern int tiocsti_restrict;
+
 /* tty magic number */
 #define TTY_MAGIC		0x5401
 
-- 
2.10.2
