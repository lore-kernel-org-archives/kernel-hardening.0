From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 May 2017 13:17:11 -0700
Message-Id: <1495829844-69341-8-git-send-email-keescook@chromium.org>
In-Reply-To: <1495829844-69341-1-git-send-email-keescook@chromium.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH v2 07/20] randstruct: Whitelist big_key path struct overloading
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, David Howells <dhowells@redhat.com>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The big_key payload structure intentionally stores a struct path in
two void pointers to avoid header soup. Whitelist this case:

security/keys/big_key.c: In function ‘big_key_read’:
security/keys/big_key.c:293:16: note: found mismatched rhs struct pointer types: ‘struct path’ and ‘void *’

   struct path *path = (struct path *)&key->payload.data[big_key_path];
                ^~~~

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/gcc-plugins/randomize_layout_plugin.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index bf110915a5aa..5f4e59a78eeb 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -45,6 +45,8 @@ struct whitelist_entry {
 static const struct whitelist_entry whitelist[] = {
 	/* unix_skb_parms via UNIXCB() buffer */
 	{ "net/unix/af_unix.c", "unix_skb_parms", "char" },
+	/* big_key payload.data struct splashing */
+	{ "security/keys/big_key.c", "path", "void *" },
 	/* walk struct security_hook_heads as an array of struct list_head */
 	{ "security/security.c", "list_head", "security_hook_heads" },
 	{ }
-- 
2.7.4
