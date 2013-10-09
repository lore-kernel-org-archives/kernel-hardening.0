Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1381330676.2050.9.camel@joe-AO722>
From: Joe Perches <joe@perches.com>
Date: Wed, 09 Oct 2013 07:57:56 -0700
In-Reply-To: <52553A8D.4090906@gmail.com>
References: <5254A034.5020700@gmail.com>
	 <1381279758.23937.42.camel@joe-AO722> <1381282200.23937.45.camel@joe-AO722>
		 <5254B787.6080700@gmail.com> <1381284056.23937.49.camel@joe-AO722>
	 <5254BDD0.7040001@gmail.com> <52553A8D.4090906@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2] vsprintf: Check real user/group id for %pK
To: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: Ryan Mallon <rmallon@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com, Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com, Kees Cook <keescook@chromium.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W.
 Biederman" <ebiederm@xmission.com>, George Spelvin <linux@horizon.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2013-10-09 at 07:14 -0400, Dan Rosenberg wrote:
> isn't the default value of kptr_restrict 0 now, unless I'm missing
> something? If I recall it was 1 when originally written, and then
> changed to 0 at some point. Could the documentation be updated to
> reflect that?

Yeah, the default got changed by
---------------------------
commit 411f05f123cbd7f8aa1edcae86970755a6e2a9d9
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu May 12 23:00:28 2011 +0200

kptr_restrict has been triggering bugs in apps such as perf, and it also makes
the system less useful by default, so turn it off by default.
---------------------------

Maybe this:
---
 Documentation/sysctl/kernel.txt | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

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
 
