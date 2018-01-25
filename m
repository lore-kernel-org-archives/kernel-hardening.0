From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 25 Jan 2018 13:04:01 +0100
Message-Id: <20180125120401.30596-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH] cpu: do not leak vulnerabilities to unprivileged users
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

While it's public information if the CPU in general has spectre/meltdown
bugs, it probably shouldn't be as globally obvious to all unprivileged
users whether or not the kernel is doing something to mitigate those
bugs. While an attacker can obviously probe and try, there frequently is
a trade-off attackers make of how much probing around they're willing to
do versus the certainty of an attack working, in order to reduce
detection. By making it loud and clear that the kernel _is_ vulnerable,
we're simply aiding the trade-off calculations attackers have to make
when choosing which vectors to target.

So, this patch changes the permissions to 0400 to make the attacker's
job slightly less easy.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/base/cpu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index d99038487a0d..a3a8e008f957 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -531,9 +531,9 @@ ssize_t __weak cpu_show_spectre_v2(struct device *dev,
 	return sprintf(buf, "Not affected\n");
 }
 
-static DEVICE_ATTR(meltdown, 0444, cpu_show_meltdown, NULL);
-static DEVICE_ATTR(spectre_v1, 0444, cpu_show_spectre_v1, NULL);
-static DEVICE_ATTR(spectre_v2, 0444, cpu_show_spectre_v2, NULL);
+static DEVICE_ATTR(meltdown, 0400, cpu_show_meltdown, NULL);
+static DEVICE_ATTR(spectre_v1, 0400, cpu_show_spectre_v1, NULL);
+static DEVICE_ATTR(spectre_v2, 0400, cpu_show_spectre_v2, NULL);
 
 static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_meltdown.attr,
-- 
2.16.1
