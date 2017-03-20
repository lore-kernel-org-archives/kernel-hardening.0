From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Date: Mon, 20 Mar 2017 17:55:22 +1100
Message-Id: <20170320065522.14839-1-andrew.donnellan@au1.ibm.com>
Subject: [kernel-hardening] [PATCH] gcc-plugins: update architecture list in documentation
To: keescook@chromium.org, re.emese@gmail.com, kernel-hardening@lists.openwall.com
Cc: linuxppc-dev@lists.ozlabs.org
List-ID: <kernel-hardening.lists.openwall.com>

Commit 65c059bcaa73 ("powerpc: Enable support for GCC plugins") enabled GCC
plugins on powerpc, but neglected to update the architecture list in the
docs. Rectify this.

Fixes: 65c059bcaa73 ("powerpc: Enable support for GCC plugins")
Signed-off-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
---
 Documentation/gcc-plugins.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/gcc-plugins.txt b/Documentation/gcc-plugins.txt
index 891c69464434..433eaefb4aa1 100644
--- a/Documentation/gcc-plugins.txt
+++ b/Documentation/gcc-plugins.txt
@@ -18,8 +18,8 @@ because gcc versions 4.5 and 4.6 are compiled by a C compiler,
 gcc-4.7 can be compiled by a C or a C++ compiler,
 and versions 4.8+ can only be compiled by a C++ compiler.
 
-Currently the GCC plugin infrastructure supports only the x86, arm and arm64
-architectures.
+Currently the GCC plugin infrastructure supports only the x86, arm, arm64 and
+powerpc architectures.
 
 This infrastructure was ported from grsecurity [6] and PaX [7].
 
-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
