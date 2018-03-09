From: Andreas Christoforou <andreaschristofo@gmail.com>
Subject: [PATCH] net: ipv6: xfrm6_state: remove VLA usage
Date: Fri,  9 Mar 2018 14:21:46 +0200
Message-Id: <1520598106-3271-1-git-send-email-andreaschristofo@gmail.com>
To: keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, Andreas Christoforou <andreaschristofo@gmail.com>, Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The kernel would like to have all stack VLA usage removed[1].

Signed-off-by: Andreas Christoforou <andreaschristofo@gmail.com>
---
 net/ipv6/xfrm6_state.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/xfrm6_state.c b/net/ipv6/xfrm6_state.c
index b15075a..45c0d98 100644
--- a/net/ipv6/xfrm6_state.c
+++ b/net/ipv6/xfrm6_state.c
@@ -62,7 +62,12 @@ __xfrm6_sort(void **dst, void **src, int n, int (*cmp)(void *p), int maxclass)
 {
 	int i;
 	int class[XFRM_MAX_DEPTH];
-	int count[maxclass];
+	int *count;
+
+	count = kcalloc(maxclass + 1, sizeof(*count), GFP_KERNEL);
+
+	if (!count)
+		return -ENOMEM;
 
 	memset(count, 0, sizeof(count));
 
@@ -80,6 +85,7 @@ __xfrm6_sort(void **dst, void **src, int n, int (*cmp)(void *p), int maxclass)
 		src[i] = NULL;
 	}
 
+	kfree(count);
 	return 0;
 }
 
-- 
2.7.4
