From: Kees Cook <keescook@chromium.org>
Date: Thu,  6 Apr 2017 14:18:23 -0700
Message-Id: <1491513513-84351-9-git-send-email-keescook@chromium.org>
In-Reply-To: <1491513513-84351-1-git-send-email-keescook@chromium.org>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH 08/18] randstruct: Whitelist UNIXCB cast
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

This is another false positive in bad cast detection:

net/unix/af_unix.c: In function ‘unix_skb_scm_eq’:
net/unix/af_unix.c:1621:31: note: found mismatched rhs struct pointer types: ‘struct unix_skb_parms’ and ‘char’

  const struct unix_skb_parms *u = &UNIXCB(skb);
                               ^

UNIXCB is:

	#define UNIXCB(skb)     (*(struct unix_skb_parms *)&((skb)->cb))

And ->cb is:

	char                    cb[48] __aligned(8);

This is a rather crazy cast, but appears to be safe in the face of
randomization, so whitelist it in the plugin.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/gcc-plugins/randomize_layout_plugin.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index 63c654a00249..a2d7e933c33f 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -773,6 +773,15 @@ static bool type_name_eq(gimple stmt, const_tree type_tree, const char *wanted_n
 	case RECORD_TYPE:
 		type_name = TYPE_NAME_POINTER(type_tree);
 		break;
+	case INTEGER_TYPE:
+		if (TYPE_PRECISION(type_tree) == CHAR_TYPE_SIZE)
+			type_name = "char";
+		else {
+			inform(gimple_location(stmt), "found non-char INTEGER_TYPE cast comparison: %qT\n", type_tree);
+			debug_tree(type_tree);
+			return false;
+		}
+		break;
 	default:
 		inform(gimple_location(stmt), "unhandled cast comparison: %qT\n", type_tree);
 		debug_tree(type_tree);
@@ -864,7 +873,13 @@ static unsigned int find_bad_casts_execute(void)
 #ifndef __DEBUG_PLUGIN
 				if (lookup_attribute("randomize_performed", TYPE_ATTRIBUTES(ptr_lhs_type)))
 #endif
-				inform(gimple_location(stmt), "found mismatched rhs struct pointer types: %qT and %qT\n", ptr_lhs_type, ptr_rhs_type);
+				{
+					/* Whitelist unix_skb_parms via UNIXCB() */
+					if (whitelisted_cast(stmt, ptr_lhs_type, ptr_rhs_type, "unix_skb_parms", "char"))
+						continue;
+
+					inform(gimple_location(stmt), "found mismatched rhs struct pointer types: %qT and %qT\n", ptr_lhs_type, ptr_rhs_type);
+				}
 				continue;
 			}
 
-- 
2.7.4
