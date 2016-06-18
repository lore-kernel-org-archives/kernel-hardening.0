Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 18 Jun 2016 11:01:18 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <20160618180118.GA32456@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] kbuild: no gcc-plugins during cc-option tests
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Emese Revfy <re.emese@gmail.com>, Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Emese Revfy <re.emese@gmail.com>

The gcc-plugins arguments should not be included when performing
cc-option tests.

Steps to reproduce:
1) make mrproper
2) make defconfig
3) enable GCC_PLUGINS, GCC_PLUGIN_CYC_COMPLEXITY
4) enable FUNCTION_TRACER (it will select other options as well)
5) make && make modules

Build errors:
MODPOST 18 modules
ERROR: "__fentry__" [net/netfilter/xt_nat.ko] undefined!
ERROR: "__fentry__" [net/netfilter/xt_mark.ko] undefined!
ERROR: "__fentry__" [net/netfilter/xt_addrtype.ko] undefined!
ERROR: "__fentry__" [net/netfilter/xt_LOG.ko] undefined!
ERROR: "__fentry__" [net/netfilter/nf_nat_sip.ko] undefined!
ERROR: "__fentry__" [net/netfilter/nf_nat_irc.ko] undefined!
ERROR: "__fentry__" [net/netfilter/nf_nat_ftp.ko] undefined!
ERROR: "__fentry__" [net/netfilter/nf_nat.ko] undefined!

Reported-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Emese Revfy <re.emese@gmail.com>
[kees: renamed variable, clarified commit message]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
I can carry this in my kspp tree for -next
---
 scripts/Kbuild.include | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 0f82314621f2..f585766989c2 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -108,16 +108,19 @@ as-option = $(call try-run,\
 as-instr = $(call try-run,\
 	printf "%b\n" "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -x assembler -o "$$TMP" -,$(2),$(3))
 
+# Do not attempt to build with gcc plugins during cc-option tests.
+CC_OPTION_CFLAGS = $(filter-out $(GCC_PLUGINS_CFLAGS),$(KBUILD_CFLAGS))
+
 # cc-option
 # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
 
 cc-option = $(call try-run,\
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -x c /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) $(KBUILD_CPPFLAGS) $(CC_OPTION_CFLAGS) $(1) -c -x c /dev/null -o "$$TMP",$(1),$(2))
 
 # cc-option-yn
 # Usage: flag := $(call cc-option-yn,-march=winchip-c6)
 cc-option-yn = $(call try-run,\
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -x c /dev/null -o "$$TMP",y,n)
+	$(CC) $(KBUILD_CPPFLAGS) $(CC_OPTION_CFLAGS) $(1) -c -x c /dev/null -o "$$TMP",y,n)
 
 # cc-option-align
 # Prefix align with either -falign or -malign
@@ -127,7 +130,7 @@ cc-option-align = $(subst -functions=0,,\
 # cc-disable-warning
 # Usage: cflags-y += $(call cc-disable-warning,unused-but-set-variable)
 cc-disable-warning = $(call try-run,\
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -W$(strip $(1)) -c -x c /dev/null -o "$$TMP",-Wno-$(strip $(1)))
+	$(CC) $(KBUILD_CPPFLAGS) $(CC_OPTION_CFLAGS) -W$(strip $(1)) -c -x c /dev/null -o "$$TMP",-Wno-$(strip $(1)))
 
 # cc-name
 # Expands to either gcc or clang
-- 
2.7.4


-- 
Kees Cook
Chrome OS & Brillo Security
