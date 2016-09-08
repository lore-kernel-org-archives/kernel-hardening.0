Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 8 Sep 2016 15:35:59 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <20160908223558.GA11742@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] pty: make ptmx file ops read-only after init
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The ptmx_fops structure is only changed during init, so mark it as such.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/tty/pty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 51e0d32883ba..a23fa5ed1d67 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -800,7 +800,7 @@ out_free_file:
 	return retval;
 }
 
-static struct file_operations ptmx_fops;
+static struct file_operations ptmx_fops __ro_after_init;
 
 static void __init unix98_pty_init(void)
 {
-- 
2.7.4


-- 
Kees Cook
Nexus Security
