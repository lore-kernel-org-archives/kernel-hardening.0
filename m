Date: Wed, 1 Feb 2017 12:05:11 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170201200511.GA25426@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH] randstruct: deal with char array casts
To: Brad Spengler <spender@grsecurity.net>
Cc: PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

In continuing to poke at upstreaming randstruct, I noticed build warnings
that exist even under a normal grsecurity build:

fs/nfs/namespace.c: In function ‘nfs_do_submount’:
fs/nfs/namespace.c:261:6: note: found mismatched struct pointer types: ‘struct vfsmount’ and ‘char’

  mnt = (struct vfsmount *)devname;
      ^

devname is a char *:

        devname = nfs_devname(dentry, page, PAGE_SIZE);
        mnt = (struct vfsmount *)devname;

net/unix/af_unix.c: In function ‘unix_skb_scm_eq’:
net/unix/af_unix.c:1634:31: note: found mismatched struct pointer types: ‘struct unix_skb_parms’ and ‘char’

  const struct unix_skb_parms *u = &UNIXCB(skb);
                               ^

UNIXCB is:

#define UNIXCB(skb)     (*(struct unix_skb_parms *)&((skb)->cb))

And ->cb is:

        char                    cb[48] __aligned(8);

Both of these are kind of crazy casts, but it looks like they'd always be
"safe" under randomized structure layout (in that it's being cast out of a
character array). This silences the specific case and updates the warnings
to be more specific.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/gcc-plugins/randomize_layout_plugin.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index 71911c828aae..1f62fabc1141 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -664,7 +664,7 @@ static void check_bad_casts_in_constructor(tree var, tree init)
 
 		if (!lookup_attribute("randomize_performed", TYPE_ATTRIBUTES(val_type)))
 			continue;
-		inform(DECL_SOURCE_LOCATION(var), "found mismatched struct pointer types: %qT and %qT\n", TYPE_MAIN_VARIANT(field_type), TYPE_MAIN_VARIANT(val_type));
+		inform(DECL_SOURCE_LOCATION(var), "found mismatched constructor struct pointer types: %qT and %qT\n", TYPE_MAIN_VARIANT(field_type), TYPE_MAIN_VARIANT(val_type));
 	}
 }
 
@@ -830,10 +830,13 @@ static unsigned int find_bad_casts_execute(void)
 				continue;
 
 			if (TREE_CODE(ptr_rhs_type) != RECORD_TYPE) {
+				/* Ignore casts from char arrays. */
+				if (ptr_rhs_type == char_type_node)
+					continue;
 #ifndef __DEBUG_PLUGIN
 				if (lookup_attribute("randomize_performed", TYPE_ATTRIBUTES(ptr_lhs_type)))
 #endif
-				inform(gimple_location(stmt), "found mismatched struct pointer types: %qT and %qT\n", ptr_lhs_type, ptr_rhs_type);
+				inform(gimple_location(stmt), "found mismatched rhs struct pointer types: %qT and %qT\n", ptr_lhs_type, ptr_rhs_type);
 				continue;
 			}
 
@@ -856,7 +859,7 @@ static unsigned int find_bad_casts_execute(void)
 #ifndef __DEBUG_PLUGIN
 				if (lookup_attribute("randomize_performed", TYPE_ATTRIBUTES(op0_type)))
 #endif
-				inform(gimple_location(stmt), "found mismatched struct pointer types: %qT and %qT\n", ptr_lhs_type, op0_type);
+				inform(gimple_location(stmt), "found mismatched op0 struct pointer types: %qT and %qT\n", ptr_lhs_type, op0_type);
 			} else {
 				const_tree ssa_name_var = SSA_NAME_VAR(rhs1);
 				/* skip bogus type casts introduced by container_of */
@@ -866,7 +869,7 @@ static unsigned int find_bad_casts_execute(void)
 #ifndef __DEBUG_PLUGIN
 				if (lookup_attribute("randomize_performed", TYPE_ATTRIBUTES(ptr_rhs_type)))
 #endif
-				inform(gimple_location(stmt), "found mismatched struct pointer types: %qT and %qT\n", ptr_lhs_type, ptr_rhs_type);
+				inform(gimple_location(stmt), "found mismatched ssa struct pointer types: %qT and %qT\n", ptr_lhs_type, ptr_rhs_type);
 			}
 
 		}
-- 
2.7.4


-- 
Kees Cook
Pixel Security
