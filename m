Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 12 Mar 2018 03:03:34 +0000
Message-ID: <lsq.1520823814.204619237@decadent.org.uk>
Subject: [PATCH 3.2 089/104] x86/spectre: Report get_user mitigation for
 spectre_v1
In-Reply-To: <lsq.1520823814.606620518@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@linux.intel.com, Dan Williams <dan.j.williams@intel.com>, kernel-hardening@lists.openwall.com, Jiri Slaby <jslaby@suse.cz>, torvalds@linux-foundation.org, gregkh@linuxfoundation.org, Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

3.2.101-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit edfbae53dab8348fca778531be9f4855d2ca0360 upstream.

Reflect the presence of get_user(), __get_user(), and 'syscall' protections
in sysfs. The expectation is that new and better tooling will allow the
kernel to grow more usages of array_index_nospec(), for now, only claim
mitigation for __user pointer de-references.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arch@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
Cc: gregkh@linuxfoundation.org
Cc: torvalds@linux-foundation.org
Cc: alan@linux.intel.com
Link: https://lkml.kernel.org/r/151727420158.33451.11658324346540434635.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/bugs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -433,7 +433,7 @@ ssize_t cpu_show_spectre_v1(struct sysde
 {
 	if (!boot_cpu_has_bug(X86_BUG_SPECTRE_V1))
 		return sprintf(buf, "Not affected\n");
-	return sprintf(buf, "Vulnerable\n");
+	return sprintf(buf, "Mitigation: __user pointer sanitization\n");
 }
 
 ssize_t cpu_show_spectre_v2(struct sysdev_class *dev,
