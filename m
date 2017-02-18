From: Colin King <colin.king@canonical.com>
Date: Sat, 18 Feb 2017 23:50:01 +0000
Message-Id: <20170218235001.20276-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH] gcc-plugins: fix spelling mistake: "unkown" -> "unknown"
To: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in error message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 scripts/gcc-plugins/initify_plugin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gcc-plugins/initify_plugin.c b/scripts/gcc-plugins/initify_plugin.c
index 56ed878..2ed998a 100644
--- a/scripts/gcc-plugins/initify_plugin.c
+++ b/scripts/gcc-plugins/initify_plugin.c
@@ -1846,7 +1846,7 @@ __visible int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gc
 			continue;
 		}
 
-		error(G_("unkown option '-fplugin-arg-%s-%s'"), plugin_name, argv[i].key);
+		error(G_("unknown option '-fplugin-arg-%s-%s'"), plugin_name, argv[i].key);
 	}
 
 	register_callback(plugin_name, PLUGIN_INFO, NULL, &initify_plugin_info);
-- 
2.10.2
