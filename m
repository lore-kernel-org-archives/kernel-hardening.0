From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 May 2017 13:17:10 -0700
Message-Id: <1495829844-69341-7-git-send-email-keescook@chromium.org>
In-Reply-To: <1495829844-69341-1-git-send-email-keescook@chromium.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH v2 06/20] randstruct: Whitelist UNIXCB cast
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Hannes Frederic Sowa <hannes@stressinduktion.org>, "Signed-off-by : David S . Miller" <davem@davemloft.net>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
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

Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/gcc-plugins/randomize_layout_plugin.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index e126ac7874af..bf110915a5aa 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -43,6 +43,8 @@ struct whitelist_entry {
 };
 
 static const struct whitelist_entry whitelist[] = {
+	/* unix_skb_parms via UNIXCB() buffer */
+	{ "net/unix/af_unix.c", "unix_skb_parms", "char" },
 	/* walk struct security_hook_heads as an array of struct list_head */
 	{ "security/security.c", "list_head", "security_hook_heads" },
 	{ }
-- 
2.7.4
