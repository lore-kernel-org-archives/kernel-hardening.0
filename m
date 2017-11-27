From: "Tobin C. Harding" <me@tobin.cc>
Date: Tue, 28 Nov 2017 09:30:17 +1100
Message-Id: <1511821819-5496-2-git-send-email-me@tobin.cc>
In-Reply-To: <1511821819-5496-1-git-send-email-me@tobin.cc>
References: <1511821819-5496-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [RFC 1/3] kallsyms: don't leak address when symbol not found
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Tycho Andersen <tycho@tycho.ws>, Daniel Borkmann <daniel@iogearbox.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, "David S. Miller" <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Currently if kallsyms_lookup() fails to find the symbol then the address
is printed. This potentially leaks sensitive information. Instead of
printing the address we can return an error, giving the calling code the
option to print the address or print some sanitized message.

Return error instead of printing address to argument buffer. Leave
buffer in a sane state.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 kernel/kallsyms.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 531ffa984bc2..4bfa4ee3ce93 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -394,8 +394,10 @@ static int __sprint_symbol(char *buffer, unsigned long address,
 
 	address += symbol_offset;
 	name = kallsyms_lookup(address, &size, &offset, &modname, buffer);
-	if (!name)
-		return sprintf(buffer, "0x%lx", address - symbol_offset);
+	if (!name) {
+		buffer[0] = '\0';
+		return -1;
+	}
 
 	if (name != buffer)
 		strcpy(buffer, name);
-- 
2.7.4
