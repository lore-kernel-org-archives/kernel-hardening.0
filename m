From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [PATCH] net: llc: drop VLA in llc_sap_mcast()
Date: Sun, 11 Mar 2018 22:12:04 +0100
Message-Id: <1520802724-17509-1-git-send-email-s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Rientjes <rientjes@google.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, Salvatore Mesoraca <s.mesoraca16@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Avoid a VLA[1] by using a real constant expression instead of a variable.
The compiler should be able to optimize the original code and avoid using
an actual VLA. Anyway this change is useful because it will avoid a false
positive with -Wvla, it might also help the compiler generating better
code.

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 net/llc/llc_sap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/llc/llc_sap.c b/net/llc/llc_sap.c
index d90928f..a7f7b8f 100644
--- a/net/llc/llc_sap.c
+++ b/net/llc/llc_sap.c
@@ -394,8 +394,9 @@ static void llc_sap_mcast(struct llc_sap *sap,
 			  const struct llc_addr *laddr,
 			  struct sk_buff *skb)
 {
-	int i = 0, count = 256 / sizeof(struct sock *);
-	struct sock *sk, *stack[count];
+	int i = 0;
+	struct sock *sk;
+	struct sock *stack[256 / sizeof(struct sock *)];
 	struct llc_sock *llc;
 	struct hlist_head *dev_hb = llc_sk_dev_hash(sap, skb->dev->ifindex);
 
@@ -408,7 +409,7 @@ static void llc_sap_mcast(struct llc_sap *sap,
 			continue;
 
 		sock_hold(sk);
-		if (i < count)
+		if (i < ARRAY_SIZE(stack))
 			stack[i++] = sk;
 		else {
 			llc_do_mcast(sap, skb, stack, i);
-- 
1.9.1
