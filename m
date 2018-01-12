From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Jan 2018 16:48:08 -0800
Message-ID: <151571808858.27429.12915543823772169761.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v2 19/19] net: mpls: prevent bounds-check bypass via
 speculative execution
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, tglx@linutronix.de, torvalds@linux-foundation.org, "David S. Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Static analysis reports that 'index' may be a user controlled value that
is used as a data dependency reading 'rt' from the 'platform_label'
array.  In order to avoid potential leaks of kernel memory values, block
speculative execution of the instruction stream that could issue further
reads based on an invalid 'rt' value.

Based on an original patch by Elena Reshetova.

Eric notes:
"
    When val is a pointer not an integer.
    Then
            array2[val] = y;
            /* or */
            y = array2[va];

    Won't happen.

            val->field;

    Will happen.

    Which looks similar.  However the address space of pointers is too
    large.  Making it impossible for an attack to know where to look in
    the cache to see if "val->field" happened.  At least on the
    assumption that val is an arbitrary value.

    Further mpls_forward is small enough the entire scope of "rt" the
    value read possibly past the bound check is auditable without too
    much trouble.  I have looked and I don't see anything that could
    possibly allow the value of "rt" to be exfitrated.  The problem
    continuing to be that it is a pointer and the only operation on the
    pointer besides derferencing it is testing if it is NULL.

    Other types of timing attacks are very hard if not impossible
    because any packet presenting with a value outside the bounds check
    will be dropped.  So it will hard if not impossible to find
    something to time to see how long it took to drop the packet.
"

The motivation of resending this patch despite the NAK is to
continue a community wide discussion on the bar for judging Spectre
changes. I.e. is any user controlled speculative pointer in the
kernel a pointer too far, especially given the current array_ptr()
implementation.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 net/mpls/af_mpls.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 8ca9915befc8..c92b1033adc2 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -8,6 +8,7 @@
 #include <linux/ipv6.h>
 #include <linux/mpls.h>
 #include <linux/netconf.h>
+#include <linux/nospec.h>
 #include <linux/vmalloc.h>
 #include <linux/percpu.h>
 #include <net/ip.h>
@@ -77,12 +78,13 @@ static void rtmsg_lfib(int event, u32 label, struct mpls_route *rt,
 static struct mpls_route *mpls_route_input_rcu(struct net *net, unsigned index)
 {
 	struct mpls_route *rt = NULL;
+	struct mpls_route __rcu **platform_label =
+		rcu_dereference(net->mpls.platform_label);
+	struct mpls_route __rcu **rtp;
 
-	if (index < net->mpls.platform_labels) {
-		struct mpls_route __rcu **platform_label =
-			rcu_dereference(net->mpls.platform_label);
-		rt = rcu_dereference(platform_label[index]);
-	}
+	rtp = array_ptr(platform_label, index, net->mpls.platform_labels);
+	if (rtp)
+		rt = rcu_dereference(*rtp);
 	return rt;
 }
 
