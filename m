From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Jan 2018 16:47:13 -0800
Message-ID: <151571803370.27429.18342496227199960317.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v2 09/19] ipv6: prevent bounds-check bypass via speculative
 execution
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, tglx@linutronix.de, torvalds@linux-foundation.org, "David S. Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Static analysis reports that 'offset' may be a user controlled value
that is used as a data dependency reading from a raw6_frag_vec buffer.
In order to avoid potential leaks of kernel memory values, block
speculative execution of the instruction stream that could issue further
reads based on an invalid '*(rfv->c + offset)' value.

Based on an original patch by Elena Reshetova.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 net/ipv6/raw.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 761a473a07c5..0b7ceeb6f709 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -33,6 +33,7 @@
 #include <linux/skbuff.h>
 #include <linux/compat.h>
 #include <linux/uaccess.h>
+#include <linux/nospec.h>
 #include <asm/ioctls.h>
 
 #include <net/net_namespace.h>
@@ -725,17 +726,18 @@ static int raw6_getfrag(void *from, char *to, int offset, int len, int odd,
 		       struct sk_buff *skb)
 {
 	struct raw6_frag_vec *rfv = from;
+	char *rfv_buf;
 
-	if (offset < rfv->hlen) {
+	rfv_buf = array_ptr(rfv->c, offset, rfv->hlen);
+	if (rfv_buf) {
 		int copy = min(rfv->hlen - offset, len);
 
 		if (skb->ip_summed == CHECKSUM_PARTIAL)
-			memcpy(to, rfv->c + offset, copy);
+			memcpy(to, rfv_buf, copy);
 		else
 			skb->csum = csum_block_add(
 				skb->csum,
-				csum_partial_copy_nocheck(rfv->c + offset,
-							  to, copy, 0),
+				csum_partial_copy_nocheck(rfv_buf, to, copy, 0),
 				odd);
 
 		odd = 0;
