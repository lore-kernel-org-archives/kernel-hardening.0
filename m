From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [PATCH 2/2] net: rds: drop VLA in rds_walk_conn_path_info()
Date: Sun, 11 Mar 2018 22:07:50 +0100
Message-Id: <1520802470-17374-2-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1520802470-17374-1-git-send-email-s.mesoraca16@gmail.com>
References: <1520802470-17374-1-git-send-email-s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Santosh Shilimkar <santosh.shilimkar@oracle.com>
List-ID: <kernel-hardening.lists.openwall.com>

Avoid VLA[1] by using an already allocated buffer passed
by the caller.

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 net/rds/connection.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index f80792c..abef75d 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -578,9 +578,9 @@ static void rds_walk_conn_path_info(struct socket *sock, unsigned int len,
 				    struct rds_info_iterator *iter,
 				    struct rds_info_lengths *lens,
 				    int (*visitor)(struct rds_conn_path *, void *),
+				    u64 *buffer,
 				    size_t item_len)
 {
-	u64  buffer[(item_len + 7) / 8];
 	struct hlist_head *head;
 	struct rds_connection *conn;
 	size_t i;
@@ -649,8 +649,11 @@ static void rds_conn_info(struct socket *sock, unsigned int len,
 			  struct rds_info_iterator *iter,
 			  struct rds_info_lengths *lens)
 {
+	u64 buffer[(sizeof(struct rds_info_connection) + 7) / 8];
+
 	rds_walk_conn_path_info(sock, len, iter, lens,
 				rds_conn_info_visitor,
+				buffer,
 				sizeof(struct rds_info_connection));
 }
 
-- 
1.9.1
