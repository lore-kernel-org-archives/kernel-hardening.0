Message-ID: <1486757549.2192.20.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Fri, 10 Feb 2017 12:12:29 -0800
In-Reply-To: <1486755469-21573-1-git-send-email-william.c.roberts@intel.com>
References: <1486755469-21573-1-git-send-email-william.c.roberts@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] checkpatch: add warning on %pk instead of %pK usage
To: william.c.roberts@intel.com, linux-kernel@vger.kernel.org, apw@canonical.com, Andew Morton <akpm@linux-foundation.org>
Cc: keescook@chromium.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2017-02-10 at 11:37 -0800, william.c.roberts@intel.com wrote:
> From: William Roberts <william.c.roberts@intel.com>
> 
> Sample output:
> WARNING: %pk is close to %pK, did you mean %pK?.
> \#20: FILE: drivers/char/applicom.c:230:
> +			printk(KERN_INFO "Could not allocate IRQ %d for PCI Applicom device. %pk\n", dev->irq, pci_get_class);

There isn't a single instance of this in the kernel tree.

Maybe if this is really useful, then all the %p<foo> extensions
should be enumerated and all unknown uses should have warnings.

Something like:

---
 scripts/checkpatch.pl | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ad5ea5c545b2..8a90b457e8b5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -5305,6 +5305,15 @@ sub process {
 			}
 		}
 
+# check for vsprintf extension %p<foo> misuses
+		if ($line =~ /\b$logFunctions\s*\(.*$String/) {
+			my $format = get_quoted_string($line, $rawline);
+			if ($format =~ /(\%[\*\d\.]*p(?![\WFfSsBKRraEhMmIiUDdgVCbGN]).)/) {
+				WARN("VSPRINTF_POINTER_EXTENSION",
+				     "Invalid vsprintf pointer extension '$1'\n" . $herecurr);
+			}
+		}
+
 # check for logging continuations
 		if ($line =~ /\bprintk\s*\(\s*KERN_CONT\b|\bpr_cont\s*\(/) {
 			WARN("LOGGING_CONTINUATION",
