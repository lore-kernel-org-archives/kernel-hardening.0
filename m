From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 May 2017 13:17:09 -0700
Message-Id: <1495829844-69341-6-git-send-email-keescook@chromium.org>
In-Reply-To: <1495829844-69341-1-git-send-email-keescook@chromium.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH v2 05/20] randstruct: Whitelist struct security_hook_heads cast
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, James Morris <james.l.morris@oracle.com>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The LSM initialization routines walk security_hook_heads as an array
of struct list_head instead of via names to avoid a ton of needless
source. Whitelist this to avoid the false positive warning from the
plugin:

security/security.c: In function ‘security_init’:
security/security.c:59:20: note: found mismatched op0 struct pointer types: ‘struct list_head’ and ‘struct security_hook_heads’

  struct list_head *list = (struct list_head *) &security_hook_heads;
                    ^

Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: James Morris <james.l.morris@oracle.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/gcc-plugins/randomize_layout_plugin.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index bccbec2af0e4..e126ac7874af 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -43,6 +43,8 @@ struct whitelist_entry {
 };
 
 static const struct whitelist_entry whitelist[] = {
+	/* walk struct security_hook_heads as an array of struct list_head */
+	{ "security/security.c", "list_head", "security_hook_heads" },
 	{ }
 };
 
-- 
2.7.4
