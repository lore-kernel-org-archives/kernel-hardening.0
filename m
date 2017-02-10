From: william.c.roberts@intel.com
Date: Fri, 10 Feb 2017 11:37:49 -0800
Message-Id: <1486755469-21573-1-git-send-email-william.c.roberts@intel.com>
Subject: [kernel-hardening] [PATCH] checkpatch: add warning on %pk instead of %pK usage
To: linux-kernel@vger.kernel.org, joe@perches.com, apw@canonical.com
Cc: keescook@chromium.org, kernel-hardening@lists.openwall.com, William Roberts <william.c.roberts@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: William Roberts <william.c.roberts@intel.com>

Sample output:
WARNING: %pk is close to %pK, did you mean %pK?.
\#20: FILE: drivers/char/applicom.c:230:
+			printk(KERN_INFO "Could not allocate IRQ %d for PCI Applicom device. %pk\n", dev->irq, pci_get_class);

Signed-off-by: William Roberts <william.c.roberts@intel.com>
---
 scripts/checkpatch.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 982c52c..f20f5c5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6096,6 +6096,12 @@ sub process {
 			      "recursive locking is bad, do not use this ever.\n" . $herecurr);
 		}
 
+# check for bad %pK usage
+		if ($rawline =~ /\%pk/) {
+			WARN("FORMAT SPECIFIER",
+			      "%pk is close to %pK, did you mean %pK?.\n" . $herecurr);
+		}
+
 # check for lockdep_set_novalidate_class
 		if ($line =~ /^.\s*lockdep_set_novalidate_class\s*\(/ ||
 		    $line =~ /__lockdep_no_validate__\s*\)/ ) {
-- 
2.7.4
