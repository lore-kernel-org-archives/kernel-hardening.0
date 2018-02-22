From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH 1/2] gcc-plugins: Update cgraph_create_edge for gcc-8
Date: Thu, 22 Feb 2018 15:14:41 -0800
Message-Id: <20180222231442.29507-2-labbott@redhat.com>
In-Reply-To: <20180222231442.29507-1-labbott@redhat.com>
References: <20180222231442.29507-1-labbott@redhat.com>
To: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Cc: Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>


gcc-8 changed the API for cgraph_create_edge. Update accordingly.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 scripts/gcc-plugins/gcc-common.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/gcc-plugins/gcc-common.h b/scripts/gcc-plugins/gcc-common.h
index f46750053377..42c55c29157f 100644
--- a/scripts/gcc-plugins/gcc-common.h
+++ b/scripts/gcc-plugins/gcc-common.h
@@ -723,8 +723,14 @@ static inline const char *get_decl_section_name(const_tree decl)
 #define varpool_get_node(decl) varpool_node::get(decl)
 #define dump_varpool_node(file, node) (node)->dump(file)
 
+#if BUILDING_GCC_VERSION >= 8000
+#define cgraph_create_edge(caller, callee, call_stmt, count, nest) \
+	(caller)->create_edge((callee), (call_stmt), (count))
+#else
 #define cgraph_create_edge(caller, callee, call_stmt, count, freq, nest) \
 	(caller)->create_edge((callee), (call_stmt), (count), (freq))
+
+#endif
 #define cgraph_create_edge_including_clones(caller, callee, old_call_stmt, call_stmt, count, freq, nest, reason) \
 	(caller)->create_edge_including_clones((callee), (old_call_stmt), (call_stmt), (count), (freq), (reason))
 
-- 
2.14.3
