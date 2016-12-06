Reply-To: kernel-hardening@lists.openwall.com
From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Date: Tue,  6 Dec 2016 17:27:58 +1100
Message-Id: <20161206062800.21800-1-andrew.donnellan@au1.ibm.com>
Subject: [kernel-hardening] [PATCH 1/3] gcc-plugins: fix definition of DISABLE_LATENT_ENTROPY_PLUGIN
To: linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com, keescook@chromium.org, re.emese@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com
List-ID: <kernel-hardening.lists.openwall.com>

The variable DISABLE_LATENT_ENTROPY_PLUGIN is defined when
CONFIG_PAX_LATENT_ENTROPY is set. This is leftover from the original PaX
version of the plugin code and doesn't actually exist. Change the condition
to depend on CONFIG_GCC_PLUGIN_LATENT_ENTROPY instead.

Fixes: 38addce8b600 ("gcc-plugins: Add latent_entropy plugin")
Signed-off-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
---
 scripts/Makefile.gcc-plugins | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 060d2cb..26c67b7 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -8,7 +8,7 @@ ifdef CONFIG_GCC_PLUGINS
 
   gcc-plugin-$(CONFIG_GCC_PLUGIN_LATENT_ENTROPY)	+= latent_entropy_plugin.so
   gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_LATENT_ENTROPY)	+= -DLATENT_ENTROPY_PLUGIN
-  ifdef CONFIG_PAX_LATENT_ENTROPY
+  ifdef CONFIG_GCC_PLUGIN_LATENT_ENTROPY
     DISABLE_LATENT_ENTROPY_PLUGIN			+= -fplugin-arg-latent_entropy_plugin-disable
   endif
 
-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
