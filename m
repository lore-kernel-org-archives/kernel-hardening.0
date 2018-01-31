From: Cao jin <caoj.fnst@cn.fujitsu.com>
Subject: [PATCH] kbuild/gcc-plugin: drop randomize_layout_hash.h from targets
Date: Wed, 31 Jan 2018 14:57:31 +0800
Message-ID: <20180131065731.7511-1-caoj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Cc: re.emese@gmail.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

randomize_layout_hash.h is not used in plugin compilation, but locates in
include/generated/

Signed-off-by: Cao jin <caoj.fnst@cn.fujitsu.com>
---
 scripts/gcc-plugins/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
index e2ff425f4c7e..d3fff33cc996 100644
--- a/scripts/gcc-plugins/Makefile
+++ b/scripts/gcc-plugins/Makefile
@@ -25,7 +25,7 @@ cmd_create_randomize_layout_seed = \
   $(CONFIG_SHELL) $(srctree)/$(src)/gen-random-seed.sh $@ $(objtree)/include/generated/randomize_layout_hash.h
 $(objtree)/$(obj)/randomize_layout_seed.h: FORCE
 	$(call if_changed,create_randomize_layout_seed)
-targets = randomize_layout_seed.h randomize_layout_hash.h
+targets = randomize_layout_seed.h
 
 $(HOSTLIBS)-y := $(foreach p,$(GCC_PLUGIN),$(if $(findstring /,$(p)),,$(p)))
 always := $($(HOSTLIBS)-y)
-- 
2.14.3
