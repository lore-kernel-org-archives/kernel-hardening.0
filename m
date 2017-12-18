From: "Tobin C. Harding" <me@tobin.cc>
Date: Tue, 19 Dec 2017 09:29:05 +1100
Message-Id: <1513636145-30033-4-git-send-email-me@tobin.cc>
In-Reply-To: <1513636145-30033-1-git-send-email-me@tobin.cc>
References: <1513636145-30033-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH v3 3/3] doc: add documentation on printing kernel addresses
To: Jonathan Corbet <corbet@lwn.net>
Cc: "Tobin C. Harding" <me@tobin.cc>, Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, Joe Perches <joe@perches.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hashing addresses printed with printk specifier %p was implemented
recently. During development a number of issues were raised regarding
leaking kernel addresses to userspace. Other documentation was updated but
security/self-protection missed out.

Add self-protection documentation regarding printing kernel addresses.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 Documentation/security/self-protection.rst | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/security/self-protection.rst b/Documentation/security/self-protection.rst
index 60c8bd8b77bf..0f53826c78b9 100644
--- a/Documentation/security/self-protection.rst
+++ b/Documentation/security/self-protection.rst
@@ -270,6 +270,21 @@ attacks, it is important to defend against exposure of both kernel memory
 addresses and kernel memory contents (since they may contain kernel
 addresses or other sensitive things like canary values).
 
+Kernel addresses
+----------------
+
+Printing kernel addresses to userspace leaks sensitive information about
+the kernel memory layout. Care should be exercised when using any printk
+specifier that prints the raw address, currently %px, %p[ad], (and %p[sSb]
+in certain circumstances [*]).  Any file written to using one of these
+specifiers should be readable only by privileged processes.
+
+Kernels 4.14 and older printed the raw address using %p. As of 4.15-rc1
+addresses printed with the specifier %p are hashed before printing.
+
+[*] If KALLSYMS is enabled and symbol lookup fails, the raw address is
+printed. If KALLSYMS is not enabled the raw address is printed.
+
 Unique identifiers
 ------------------
 
-- 
2.7.4
