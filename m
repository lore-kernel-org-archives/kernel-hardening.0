From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [PATCH 1/2] net: rds: drop VLA in rds_for_each_conn_info()
Date: Sun, 11 Mar 2018 22:07:49 +0100
Message-Id: <1520802470-17374-1-git-send-email-s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Santosh Shilimkar <santosh.shilimkar@oracle.com>
List-ID: <kernel-hardening.lists.openwall.com>

Avoid VLA[1] by using an already allocated buffer passed
by the caller.

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 net/rds/connection.c | 2 +-
 net/rds/ib.c         | 3 +++
 net/rds/rds.h        | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 2da3176..f80792c 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -540,9 +540,9 @@ void rds_for_each_conn_info(struct socket *sock, unsigned int len,
 			  struct rds_info_iterator *iter,
 			  struct rds_info_lengths *lens,
 			  int (*visitor)(struct rds_connection *, void *),
+			  u64 *buffer,
 			  size_t item_len)
 {
-	uint64_t buffer[(item_len + 7) / 8];
 	struct hlist_head *head;
 	struct rds_connection *conn;
 	size_t i;
diff --git a/net/rds/ib.c b/net/rds/ib.c
index 50a88f3..02deee2 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -321,8 +321,11 @@ static void rds_ib_ic_info(struct socket *sock, unsigned int len,
 			   struct rds_info_iterator *iter,
 			   struct rds_info_lengths *lens)
 {
+	u64 buffer[(sizeof(struct rds_info_rdma_connection) + 7) / 8];
+
 	rds_for_each_conn_info(sock, len, iter, lens,
 				rds_ib_conn_info_visitor,
+				buffer,
 				sizeof(struct rds_info_rdma_connection));
 }
 
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 7301b9b..91ea08f 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -709,6 +709,7 @@ void rds_for_each_conn_info(struct socket *sock, unsigned int len,
 			  struct rds_info_iterator *iter,
 			  struct rds_info_lengths *lens,
 			  int (*visitor)(struct rds_connection *, void *),
+			  u64 *buffer,
 			  size_t item_len);
 
 __printf(2, 3)
-- 
1.9.1
