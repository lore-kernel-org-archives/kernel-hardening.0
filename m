Reply-To: kernel-hardening@lists.openwall.com
From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Date: Wed,  2 Nov 2016 17:52:41 +1100
Message-Id: <20161102065241.985-1-andrew.donnellan@au1.ibm.com>
Subject: [kernel-hardening] [PATCH] MAINTAINERS: add GCC plugins Makefile
To: kernel-hardening@lists.openwall.com, linux-kbuild@vger.kernel.org
Cc: re.emese@gmail.com, keescook@chromium.org, mmarek@suse.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Signed-off-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4012c2f..76049e0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5202,6 +5202,7 @@ L:	kernel-hardening@lists.openwall.com
 S:	Maintained
 F:	scripts/gcc-plugins/
 F:	scripts/gcc-plugin.sh
+F:	scripts/Makefile.gcc-plugins
 F:	Documentation/gcc-plugins.txt
 
 GCOV BASED KERNEL PROFILING
-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
