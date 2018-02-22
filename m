From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH 2/2] gcc-plugins: stackleak: Update for gcc-8
Date: Thu, 22 Feb 2018 15:14:42 -0800
Message-Id: <20180222231442.29507-3-labbott@redhat.com>
In-Reply-To: <20180222231442.29507-1-labbott@redhat.com>
References: <20180222231442.29507-1-labbott@redhat.com>
To: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Cc: Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>


- Use the new cgraph_create_edge API
- Account for the change in type for get_frame_size

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 scripts/gcc-plugins/stackleak_plugin.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/stackleak_plugin.c
index 6fc991c98d8b..4ea2fdb987e6 100644
--- a/scripts/gcc-plugins/stackleak_plugin.c
+++ b/scripts/gcc-plugins/stackleak_plugin.c
@@ -69,8 +69,13 @@ static void stackleak_check_alloca(gimple_stmt_iterator *gsi)
 	node = cgraph_get_create_node(check_function_decl);
 	gcc_assert(node);
 	frequency = compute_call_stmt_bb_frequency(current_function_decl, bb);
+#if BUILDING_GCC_VERSION >= 8000
+	cgraph_create_edge(cgraph_get_node(current_function_decl), node,
+			check_alloca, bb->count, bb->loop_depth);
+#else
 	cgraph_create_edge(cgraph_get_node(current_function_decl), node,
 			check_alloca, bb->count, frequency, bb->loop_depth);
+#endif
 }
 
 static void stackleak_add_instrumentation(gimple_stmt_iterator *gsi, bool after)
@@ -94,8 +99,13 @@ static void stackleak_add_instrumentation(gimple_stmt_iterator *gsi, bool after)
 	node = cgraph_get_create_node(track_function_decl);
 	gcc_assert(node);
 	frequency = compute_call_stmt_bb_frequency(current_function_decl, bb);
+#if BUILDING_GCC_VERSION >= 8000
+	cgraph_create_edge(cgraph_get_node(current_function_decl), node,
+			track_stack, bb->count, bb->loop_depth);
+#else
 	cgraph_create_edge(cgraph_get_node(current_function_decl), node,
 			track_stack, bb->count, frequency, bb->loop_depth);
+#endif
 }
 
 static bool is_alloca(gimple stmt)
@@ -203,6 +213,18 @@ static unsigned int stackleak_tree_instrument_execute(void)
 	return 0;
 }
 
+
+#if BUILDING_GCC_VERSION >= 8000
+bool check_frame_size()
+{
+	return maybe_ge(get_frame_size(), track_frame_size);
+}
+#else
+bool check_frame_size()
+{
+	return get_frame_size() >= track_frame_size;
+}
+#endif
 /*
  * Work with the RTL representation of the code.
  * Remove the unneeded track_stack() calls from the functions which don't
@@ -215,7 +237,7 @@ static unsigned int stackleak_final_execute(void)
 	if (cfun->calls_alloca)
 		return 0;
 
-	if (get_frame_size() >= track_frame_size)
+	if (check_frame_size())
 		return 0;
 
 	/*
-- 
2.14.3
