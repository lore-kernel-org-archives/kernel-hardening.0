From: "Tobin C. Harding" <me@tobin.cc>
Date: Mon,  9 Oct 2017 13:59:05 +1100
Message-Id: <1507517945-27155-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH] lib/vsprintf: add default case to 'i' specifier
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

%pi leaks kernel addresses if incorrectly specified.

Currently the printk specifier %pi (%pI) contains a switch statement
without a default clause. The %pi specifier requires a subsequent
character (4, 6, or S) controlling the output. If the specifier is
incomplete the switch statement will fall through and print the variable
argument address in hex instead of the value of the argument (as an IP
address).

If uncaught this leaks kernel addresses into dmesg. We can return an
error string to make the bug visible and stop addresses leaking.

Add a default clause returning an error string, stops leaking addresses
and makes the buggy code

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 lib/vsprintf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 86c3385b9eb3..155702f05b14 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1775,6 +1775,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			default:
 				return string(buf, end, "(invalid address)", spec);
 			}}
+		default:
+			return string(buf, end, "(invalid specifier, form: %pi4)", spec);
 		}
 		break;
 	case 'E':
-- 
2.7.4
