Subject: [PATCH v6 13/13] x86/spectre: report get_user mitigation for
 spectre_v1
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Jan 2018 17:03:21 -0800
Message-ID: <151727420158.33451.11658324346540434635.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151727412964.33451.17213780323040673404.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151727412964.33451.17213780323040673404.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jslaby@suse.cz>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Reflect the presence of get_user(), __get_user(), and 'syscall'
protections in sysfs. The expectation is that new and better tooling
will allow the kernel to grow more usages of array_index_nospec(), for
now, only claim mitigation for __user pointer de-references.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/kernel/cpu/bugs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 390b3dc3d438..06f1d4c5ec6b 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -269,7 +269,7 @@ ssize_t cpu_show_spectre_v1(struct device *dev,
 {
 	if (!boot_cpu_has_bug(X86_BUG_SPECTRE_V1))
 		return sprintf(buf, "Not affected\n");
-	return sprintf(buf, "Vulnerable\n");
+	return sprintf(buf, "Mitigation: __user pointer sanitization\n");
 }
 
 ssize_t cpu_show_spectre_v2(struct device *dev,
