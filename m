From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 May 2017 13:17:12 -0700
Message-Id: <1495829844-69341-9-git-send-email-keescook@chromium.org>
In-Reply-To: <1495829844-69341-1-git-send-email-keescook@chromium.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH v2 08/20] randstruct: Whitelist NIU struct page overloading
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, "David S . Miller" <davem@davemloft.net>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The NIU ethernet driver intentionally stores a page struct pointer on
top of the "mapping" field. Whitelist this case:

drivers/net/ethernet/sun/niu.c: In function ‘niu_rx_pkt_ignore’:
drivers/net/ethernet/sun/niu.c:3402:10: note: found mismatched ssa struct pointer types: ‘struct page’ and ‘struct address_space’

    *link = (struct page *) page->mapping;
    ~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/gcc-plugins/randomize_layout_plugin.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index 5f4e59a78eeb..f777ead58ba8 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -43,6 +43,8 @@ struct whitelist_entry {
 };
 
 static const struct whitelist_entry whitelist[] = {
+	/* NIU overloads mapping with page struct */
+	{ "drivers/net/ethernet/sun/niu.c", "page", "address_space" },
 	/* unix_skb_parms via UNIXCB() buffer */
 	{ "net/unix/af_unix.c", "unix_skb_parms", "char" },
 	/* big_key payload.data struct splashing */
-- 
2.7.4
