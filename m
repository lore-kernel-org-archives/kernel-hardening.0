Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 15 Jun 2016 00:19:26 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160615001926.74e2c18cbefe799b0a0c2dcb@gmail.com>
In-Reply-To: <20160615001754.f9e986cf961d1466f5e086dc@gmail.com>
References: <20160615001754.f9e986cf961d1466f5e086dc@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v3 1/4] Add support for passing gcc plugin arguments
To: kernel-hardening@lists.openwall.com
Cc: pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, tytso@mit.edu, akpm@linux-foundation.org, linux-mm@kvack.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, paulmck@linux.vnet.ibm.com, mingo@redhat.com, tglx@linutronix.de, bart.vanassche@sandisk.com, davem@davemloft.net
List-ID: <kernel-hardening.lists.openwall.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 scripts/Makefile.gcc-plugins | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 5e22b60..da7f86c 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -19,7 +19,7 @@ ifdef CONFIG_GCC_PLUGINS
     endif
   endif
 
-  GCC_PLUGINS_CFLAGS := $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y))
+  GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
 
   export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN SANCOV_PLUGIN
 
-- 
2.8.1
