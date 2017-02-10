From: william.c.roberts@intel.com
Date: Fri, 10 Feb 2017 15:49:56 -0800
Message-Id: <1486770596-15526-1-git-send-email-william.c.roberts@intel.com>
Subject: [kernel-hardening] [PATCH v3] checkpatch: add warning on invalid %p extensions
To: linux-kernel@vger.kernel.org, joe@perches.com, apw@canonical.com
Cc: keescook@chromium.org, kernel-hardening@lists.openwall.com, William Roberts <william.c.roberts@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: William Roberts <william.c.roberts@intel.com>

The kernel supports %p extensions as documented in
Documentation/printk-formats.txt. Warn on possibly
improper use of non-extension characters.

One issue would be the usage of %pk when %pK should have
been used. This has a side-effect of appearing to work
alright, but does not respect the kptr_restrict setting
as %pK does.

Sample output:
WARNING: Invalid vsprintf pointer extension '%pk'
+			printk(KERN_INFO "Could not allocate IRQ %d for PCI Applicom device. %pk\n", dev->irq, pci_get_class); // NOT OK

improved-by: joe@perches.com

Signed-off-by: William Roberts <william.c.roberts@intel.com>
---
 scripts/checkpatch.pl | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 982c52c..dfc1c11 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6096,6 +6096,15 @@ sub process {
 			      "recursive locking is bad, do not use this ever.\n" . $herecurr);
 		}
 
+	# check for vsprintf extension %p<foo> misuses
+	if ($line =~ /\b$logFunctions\s*\(.*$String/) {
+		my $format = get_quoted_string($line, $rawline);
+		if ($format =~ /(\%[\*\d\.]*p(?![\WFfSsBKRraEhMmIiUDdgVCbGN]).)/) {
+			WARN("VSPRINTF_POINTER_EXTENSION",
+			     "Invalid vsprintf pointer extension '$1'\n" . $herecurr);
+		}
+	}
+
 # check for lockdep_set_novalidate_class
 		if ($line =~ /^.\s*lockdep_set_novalidate_class\s*\(/ ||
 		    $line =~ /__lockdep_no_validate__\s*\)/ ) {
-- 
2.7.4
