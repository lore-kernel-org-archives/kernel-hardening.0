From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 67/92] x86/spectre: Report get_user mitigation for spectre_v1
Date: Fri,  9 Feb 2018 14:39:36 +0100
Message-Id: <20180209133936.100956467@linuxfoundation.org>
In-Reply-To: <20180209133931.211869118@linuxfoundation.org>
References: <20180209133931.211869118@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, torvalds@linux-foundation.org, alan@linux.intel.com, David Woodhouse <dwmw@amazon.co.uk>
List-ID: <kernel-hardening.lists.openwall.com>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>


(cherry picked from commit edfbae53dab8348fca778531be9f4855d2ca0360)

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
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -296,7 +296,7 @@ ssize_t cpu_show_spectre_v1(struct devic
 {
 	if (!boot_cpu_has_bug(X86_BUG_SPECTRE_V1))
 		return sprintf(buf, "Not affected\n");
-	return sprintf(buf, "Vulnerable\n");
+	return sprintf(buf, "Mitigation: __user pointer sanitization\n");
 }
 
 ssize_t cpu_show_spectre_v2(struct device *dev,
