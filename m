Date: Tue, 24 Apr 2018 16:46:51 -0700
From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 ipsec-next] xfrm: remove VLA usage in __xfrm6_sort()
Message-ID: <20180424234651.GA30225@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Andreas Christoforou <andreaschristofo@gmail.com>, kernel-hardening@lists.openwall.com, Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

In the quest to remove all stack VLA usage removed from the kernel[1],
just use XFRM_MAX_DEPTH as already done for the "class" array. In one
case, it'll do this loop up to 5, the other caller up to 6.

[1] https://lkml.org/lkml/2018/3/7/621

Co-developed-by: Andreas Christoforou <andreaschristofo@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v3:
- adjust Subject and commit log (Steffen)
- use "= { }" instead of memset() (Stefano)
- reorder variables (Stefano)
v2:
- use XFRM_MAX_DEPTH for "count" array (Steffen and Mathias).
---
 net/ipv6/xfrm6_state.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/xfrm6_state.c b/net/ipv6/xfrm6_state.c
index 16f434791763..eeb44b64ae7f 100644
--- a/net/ipv6/xfrm6_state.c
+++ b/net/ipv6/xfrm6_state.c
@@ -60,9 +60,9 @@ xfrm6_init_temprop(struct xfrm_state *x, const struct xfrm_tmpl *tmpl,
 static int
 __xfrm6_sort(void **dst, void **src, int n, int (*cmp)(void *p), int maxclass)
 {
-	int i;
+	int count[XFRM_MAX_DEPTH] = { };
 	int class[XFRM_MAX_DEPTH];
-	int count[maxclass];
+	int i;
 
 	memset(count, 0, sizeof(count));
 
-- 
2.7.4


-- 
Kees Cook
Pixel Security
