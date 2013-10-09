Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1381360187.2050.44.camel@joe-AO722>
From: Joe Perches <joe@perches.com>
Date: Wed, 09 Oct 2013 16:09:47 -0700
In-Reply-To: <5255DBD8.30005@gmail.com>
References: <5255D023.2030907@gmail.com>
	 <1381356014.2050.28.camel@joe-AO722> <5255D2FD.6050705@gmail.com>
	 <1381356861.2050.33.camel@joe-AO722> <5255D7D4.8050204@gmail.com>
	 <1381358030.2050.36.camel@joe-AO722> <5255DBD8.30005@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v3a] vsprintf: Check real user/group id for %pK
To: Ryan Mallon <rmallon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com, Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Kees Cook <keescook@chromium.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, George Spelvin <linux@horizon.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Some setuid binaries will allow reading of files which have read
permission by the real user id. This is problematic with files which
use %pK because the file access permission is checked at open() time,
but the kptr_restrict setting is checked at read() time. If a setuid
binary opens a %pK file as an unprivileged user, and then elevates
permissions before reading the file, then kernel pointer values may be
leaked.

This happens for example with the setuid pppd application on Ubuntu
12.04:

  $ head -1 /proc/kallsyms
  00000000 T startup_32

  $ pppd file /proc/kallsyms
  pppd: In file /proc/kallsyms: unrecognized option 'c1000000'

This will only leak the pointer value from the first line, but other
setuid binaries may leak more information.

Fix this by adding a check that in addition to the current process
having CAP_SYSLOG, that effective user and group ids are equal to the
real ids. If a setuid binary reads the contents of a file which uses
%pK then the pointer values will be printed as NULL if the real user
is unprivileged.

Update the sysctl documentation to reflect the changes, and also
correct the documentation to state the kptr_restrict=0 is the default.

Original-patch-by: Ryan Mallon <rmallon@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
On Thu, 2013-10-10 at 09:42 +1100, Ryan Mallon wrote:
> If it was noisy, it would indicate a bunch of broken kernel code which
> needs fixing :-).

Or maybe a single kernel source line but
you'd still have a filled up log file.

Changes in V3a:

Do the in_irq tests only when kptr_restrict is 1.
Document the %pK mechanism in vsnprintf
Add missing documentation for %pV and %pNF too

 Documentation/sysctl/kernel.txt | 17 ++++++++--------
 lib/vsprintf.c                  | 43 ++++++++++++++++++++++++++++-------------
 2 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 9d4c1d1..c17d5ca 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -289,14 +289,15 @@ Default value is "/sbin/hotplug".
 
 kptr_restrict:
 
-This toggle indicates whether restrictions are placed on
-exposing kernel addresses via /proc and other interfaces.  When
-kptr_restrict is set to (0), there are no restrictions.  When
-kptr_restrict is set to (1), the default, kernel pointers
-printed using the %pK format specifier will be replaced with 0's
-unless the user has CAP_SYSLOG.  When kptr_restrict is set to
-(2), kernel pointers printed using %pK will be replaced with 0's
-regardless of privileges.
+This toggle indicates whether restrictions are placed on exposing kernel
+addresses via /proc and other interfaces.
+
+When kptr_restrict is set to (0), the default, there are no restrictions.
+When kptr_restrict is set to (1), kernel pointers printed using the %pK
+format specifier will be replaced with 0's unless the user has CAP_SYSLOG
+and effective user and group ids are equal to the real ids.
+When kptr_restrict is set to (2), kernel pointers printed using %pK will
+be replaced with 0's regardless of privileges.
 
 ==============================================================
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 26559bd..3efcf29 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 #include <linux/ioport.h>
 #include <linux/dcache.h>
+#include <linux/cred.h>
 #include <net/addrconf.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
@@ -1301,21 +1302,34 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			va_end(va);
 			return buf;
 		}
-	case 'K':
-		/*
-		 * %pK cannot be used in IRQ context because its test
-		 * for CAP_SYSLOG would be meaningless.
-		 */
-		if (kptr_restrict && (in_irq() || in_serving_softirq() ||
-				      in_nmi())) {
-			if (spec.field_width == -1)
-				spec.field_width = default_width;
-			return string(buf, end, "pK-error", spec);
+	case 'K':		/* see: Documentation/sysctl/kernel.txt */
+		switch (kptr_restrict) {
+		case 0:			/* None (default) */
+			break;
+		case 1: {		/* Restricted */
+			const struct cred *cred;
+
+			if (in_irq() || in_serving_softirq() || in_nmi()) {
+				/*
+				 * This cannot be used in IRQ context because
+				 * the test for CAP_SYSLOG would be meaningless
+				 */
+				if (spec.field_width == -1)
+					spec.field_width = default_width;
+				return string(buf, end, "pK-error", spec);
+			}
+			cred = current_cred();
+			if (!has_capability_noaudit(current, CAP_SYSLOG) ||
+			    !uid_eq(cred->euid, cred->uid) ||
+			    !gid_eq(cred->egid, cred->gid))
+				ptr = NULL;
+			break;
 		}
-		if (!((kptr_restrict == 0) ||
-		      (kptr_restrict == 1 &&
-		       has_capability_noaudit(current, CAP_SYSLOG))))
+		case 2:			/* Never - Always emit 0 */
+		default:
 			ptr = NULL;
+			break;
+		}
 		break;
 	case 'N':
 		switch (fmt[1]) {
@@ -1574,6 +1588,9 @@ qualifier:
  * %piS depending on sa_family of 'struct sockaddr *' print IPv4/IPv6 address
  * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
  *   case.
+ * %pV recurse and output a struct va_format (const char *fmt, va_list *)
+ * %pK output a kernel address or 0 depending on sysctl kptr_restrict
+ * %pNF output a netdev_features_t
  * %*ph[CDN] a variable-length hex string with a separator (supports up to 64
  *           bytes of the input)
  * %n is ignored
