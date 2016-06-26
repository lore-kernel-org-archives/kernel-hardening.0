Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 26 Jun 2016 17:36:43 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160626173643.c05fd4d559ee9214ad1253c6@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH] Automate make rule generation for gcc plugin objects
To: keescook@chromium.org
Cc: mmarek@suse.com, linux-kbuild@vger.kernel.org, kernel-hardening@lists.openwall.com, pageexec@freemail.hu
List-ID: <kernel-hardening.lists.openwall.com>


Reported-by: PaX Team <pageexec@freemail.hu>
Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 scripts/gcc-plugins/Makefile | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
index a3f8ca4a..898449d 100644
--- a/scripts/gcc-plugins/Makefile
+++ b/scripts/gcc-plugins/Makefile
@@ -20,9 +20,6 @@ endif
 
 $(HOSTLIBS)-y := $(GCC_PLUGIN)
 always := $($(HOSTLIBS)-y)
-
-cyc_complexity_plugin-objs := cyc_complexity_plugin.o
-sancov_plugin-objs := sancov_plugin.o
-latent_entropy_plugin-objs := latent_entropy_plugin.o
+$(foreach p,$($(HOSTLIBS)-y:%.so=%),$(eval $(p)-objs := $(p).o))
 
 clean-files += *.so
-- 
2.8.1
