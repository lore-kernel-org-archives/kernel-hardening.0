Date: Wed,  8 May 2019 17:37:36 +0200
In-Reply-To: <20190508153736.256401-1-glider@google.com>
Message-Id: <20190508153736.256401-5-glider@google.com>
Mime-Version: 1.0
References: <20190508153736.256401-1-glider@google.com>
Subject: [PATCH 4/4] net: apply __GFP_NOINIT to AF_UNIX sk_buff allocations
From: Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
To: akpm@linux-foundation.org, cl@linux.com, keescook@chromium.org, labbott@redhat.com
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, yamada.masahiro@socionext.com, jmorris@namei.org, serge@hallyn.com, ndesaulniers@google.com, kcc@google.com, dvyukov@google.com, sspatil@android.com, rdunlap@infradead.org, jannh@google.com, mark.rutland@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

Add sock_alloc_send_pskb_noinit(), which is similar to
sock_alloc_send_pskb(), but allocates with __GFP_NOINIT.
This helps reduce the slowdown on hackbench in the init_on_alloc mode
from 6.84% to 3.45%.

Slowdown for the initialization features compared to init_on_free=0,
init_on_alloc=0:

hackbench, init_on_free=1:  +7.71% sys time (st.err 0.45%)
hackbench, init_on_alloc=1: +3.45% sys time (st.err 0.86%)

Linux build with -j12, init_on_free=1:  +8.34% wall time (st.err 0.39%)
Linux build with -j12, init_on_free=1:  +24.13% sys time (st.err 0.47%)
Linux build with -j12, init_on_alloc=1: -0.04% wall time (st.err 0.46%)
Linux build with -j12, init_on_alloc=1: +0.50% sys time (st.err 0.45%)

The slowdown for init_on_free=0, init_on_alloc=0 compared to the
baseline is within the standard error.

Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Sandeep Patil <sspatil@android.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
---
 include/net/sock.h |  5 +++++
 net/core/sock.c    | 29 +++++++++++++++++++++++++----
 net/unix/af_unix.c | 13 +++++++------
 3 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 341f8bafa0cf..64bfc4fd7940 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1612,6 +1612,11 @@ struct sk_buff *sock_alloc_send_skb(struct sock *sk, unsigned long size,
 struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 				     unsigned long data_len, int noblock,
 				     int *errcode, int max_page_order);
+struct sk_buff *sock_alloc_send_pskb_noinit(struct sock *sk,
+					    unsigned long header_len,
+					    unsigned long data_len,
+					    int noblock, int *errcode,
+					    int max_page_order);
 void *sock_kmalloc(struct sock *sk, int size, gfp_t priority);
 void sock_kfree_s(struct sock *sk, void *mem, int size);
 void sock_kzfree_s(struct sock *sk, void *mem, int size);
diff --git a/net/core/sock.c b/net/core/sock.c
index bd03e3a52f9d..8aabcb25fc6a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2187,9 +2187,11 @@ static long sock_wait_for_wmem(struct sock *sk, long timeo)
  *	Generic send/receive buffer handlers
  */
 
-struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
-				     unsigned long data_len, int noblock,
-				     int *errcode, int max_page_order)
+struct sk_buff *sock_alloc_send_pskb_internal(struct sock *sk,
+					      unsigned long header_len,
+					      unsigned long data_len,
+					      int noblock, int *errcode,
+					      int max_page_order, gfp_t gfp)
 {
 	struct sk_buff *skb;
 	long timeo;
@@ -2218,7 +2220,7 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 		timeo = sock_wait_for_wmem(sk, timeo);
 	}
 	skb = alloc_skb_with_frags(header_len, data_len, max_page_order,
-				   errcode, sk->sk_allocation);
+				   errcode, sk->sk_allocation | gfp);
 	if (skb)
 		skb_set_owner_w(skb, sk);
 	return skb;
@@ -2229,8 +2231,27 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 	*errcode = err;
 	return NULL;
 }
+
+struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
+				     unsigned long data_len, int noblock,
+				     int *errcode, int max_page_order)
+{
+	return sock_alloc_send_pskb_internal(sk, header_len, data_len,
+		noblock, errcode, max_page_order, /*gfp*/0);
+}
 EXPORT_SYMBOL(sock_alloc_send_pskb);
 
+struct sk_buff *sock_alloc_send_pskb_noinit(struct sock *sk,
+					    unsigned long header_len,
+					    unsigned long data_len,
+					    int noblock, int *errcode,
+					    int max_page_order)
+{
+	return sock_alloc_send_pskb_internal(sk, header_len, data_len,
+		noblock, errcode, max_page_order, /*gfp*/__GFP_NOINIT);
+}
+EXPORT_SYMBOL(sock_alloc_send_pskb_noinit);
+
 struct sk_buff *sock_alloc_send_skb(struct sock *sk, unsigned long size,
 				    int noblock, int *errcode)
 {
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index ddb838a1b74c..9a45824c3c48 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1627,9 +1627,9 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 		BUILD_BUG_ON(SKB_MAX_ALLOC < PAGE_SIZE);
 	}
 
-	skb = sock_alloc_send_pskb(sk, len - data_len, data_len,
-				   msg->msg_flags & MSG_DONTWAIT, &err,
-				   PAGE_ALLOC_COSTLY_ORDER);
+	skb = sock_alloc_send_pskb_noinit(sk, len - data_len, data_len,
+					  msg->msg_flags & MSG_DONTWAIT, &err,
+					  PAGE_ALLOC_COSTLY_ORDER);
 	if (skb == NULL)
 		goto out;
 
@@ -1824,9 +1824,10 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 
 		data_len = min_t(size_t, size, PAGE_ALIGN(data_len));
 
-		skb = sock_alloc_send_pskb(sk, size - data_len, data_len,
-					   msg->msg_flags & MSG_DONTWAIT, &err,
-					   get_order(UNIX_SKB_FRAGS_SZ));
+		skb = sock_alloc_send_pskb_noinit(sk, size - data_len, data_len,
+						  msg->msg_flags & MSG_DONTWAIT,
+						  &err,
+						  get_order(UNIX_SKB_FRAGS_SZ));
 		if (!skb)
 			goto out_err;
 
-- 
2.21.0.1020.gf2820cf01a-goog
