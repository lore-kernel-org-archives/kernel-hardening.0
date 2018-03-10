From: Andreas Christoforou <andreaschristofo@gmail.com>
Subject: [PATCH v2] net: ipv6: xfrm6_state: remove VLA usage
Date: Sat, 10 Mar 2018 09:40:44 +0200
Message-Id: <1520667645-21975-1-git-send-email-andreaschristofo@gmail.com>
To: keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, Andreas Christoforou <andreaschristofo@gmail.com>, Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The kernel would like to have all stack VLA usage removed[1].
Instead of dynamic allocation, just use XFRM_MAX_DEPTH
as already done for the "class" array, but as per feedback,
I will not drop maxclass because that changes the behavior.
In one case, it'll do this loop up to 5, the other
caller up to 6.

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Andreas Christoforou <andreaschristofo@gmail.com>
---
v2:
- use XFRM_MAX_DEPTH for "count" array (Steffen and Mathias).
---
 net/ipv6/xfrm6_state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/xfrm6_state.c b/net/ipv6/xfrm6_state.c
index b15075a..270a53a 100644
--- a/net/ipv6/xfrm6_state.c
+++ b/net/ipv6/xfrm6_state.c
@@ -62,7 +62,7 @@ __xfrm6_sort(void **dst, void **src, int n, int (*cmp)(void *p), int maxclass)
 {
 	int i;
 	int class[XFRM_MAX_DEPTH];
-	int count[maxclass];
+	int count[XFRM_MAX_DEPTH];
 
 	memset(count, 0, sizeof(count));
 
-- 
2.7.4
