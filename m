From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 26 Jan 2018 13:31:58 +0100
Message-Id: <20180126123158.9575-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9p7QdAZf2NR4fkheRFVUoH1a27rmRcOnzkSS+nE5gJ63Q@mail.gmail.com>
References: <CAHmME9p7QdAZf2NR4fkheRFVUoH1a27rmRcOnzkSS+nE5gJ63Q@mail.gmail.com>
Subject: [kernel-hardening] [PATCH v2] cpu: do not leak vulnerabilities to unprivileged users
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, gnomes@lxorguk.ukuu.org.uk
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
job slightly less easy. While we're at it, we clean up the leak in dmesg
too.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
v2 handles dmesg too.

 arch/x86/kernel/cpu/bugs.c | 1 -
 drivers/base/cpu.c         | 6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 390b3dc3d438..e512ae82f201 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -230,7 +230,6 @@ static void __init spectre_v2_select_mitigation(void)
 	}
 
 	spectre_v2_enabled = mode;
-	pr_info("%s\n", spectre_v2_strings[mode]);
 
 	/*
 	 * If neither SMEP or KPTI are available, there is a risk of
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
