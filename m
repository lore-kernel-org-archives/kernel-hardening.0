Date: Wed, 10 Apr 2019 15:17:26 +0200
In-Reply-To: <20190410131726.250295-1-glider@google.com>
Message-Id: <20190410131726.250295-4-glider@google.com>
Mime-Version: 1.0
References: <20190410131726.250295-1-glider@google.com>
Subject: [PATCH 3/3] net: make sk_prot_alloc() work with CONFIG_INIT_ALL_HEAP
From: Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
To: yamada.masahiro@socionext.com, jmorris@namei.org, serge@hallyn.com
Cc: linux-security-module@vger.kernel.org, linux-kbuild@vger.kernel.org, ndesaulniers@google.com, kcc@google.com, dvyukov@google.com, keescook@chromium.org, sspatil@android.com, labbott@redhat.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Rename sk_prot_clear_nulls() to sk_prot_clear() and introduce an extra
init_byte parameter to be passed to memset() when initializing struct sock.
In the case CONFIG_INIT_ALL_HEAP is on, initialize newly created struct
sock with 0xAA.

Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: David S. Miller <davem@davemloft.net>
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
Cc: linux-security-module@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
---
 include/net/sock.h | 8 ++++----
 net/core/sock.c    | 5 +++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 8de5ee258b93..a49c1f1c71c1 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1044,13 +1044,13 @@ struct module;
 
 /*
  * caches using SLAB_TYPESAFE_BY_RCU should let .next pointer from nulls nodes
- * un-modified. Special care is taken when initializing object to zero.
+ * un-modified. Special care is taken when initializing object.
  */
-static inline void sk_prot_clear_nulls(struct sock *sk, int size)
+static inline void sk_prot_clear(struct sock *sk, int size, int init_byte)
 {
 	if (offsetof(struct sock, sk_node.next) != 0)
-		memset(sk, 0, offsetof(struct sock, sk_node.next));
-	memset(&sk->sk_node.pprev, 0,
+		memset(sk, init_byte, offsetof(struct sock, sk_node.next));
+	memset(&sk->sk_node.pprev, init_byte,
 	       size - offsetof(struct sock, sk_node.pprev));
 }
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 782343bb925b..1ad855e99512 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1601,8 +1601,9 @@ static struct sock *sk_prot_alloc(struct proto *prot, gfp_t priority,
 		sk = kmem_cache_alloc(slab, priority & ~__GFP_ZERO);
 		if (!sk)
 			return sk;
-		if (priority & __GFP_ZERO)
-			sk_prot_clear_nulls(sk, prot->obj_size);
+		if (GFP_INIT_ALWAYS_ON || (priority & __GFP_ZERO))
+			sk_prot_clear(sk, prot->obj_size,
+				      INITMEM_FILL_BYTE(priority));
 	} else
 		sk = kmalloc(prot->obj_size, priority);
 
-- 
2.21.0.392.gf8f6787159e-goog
