From: "Tobin C. Harding" <me@tobin.cc>
Date: Sun,  1 Oct 2017 11:06:48 +1100
Message-Id: <1506816410-10230-5-git-send-email-me@tobin.cc>
In-Reply-To: <1506816410-10230-1-git-send-email-me@tobin.cc>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [RFC V2 4/6] lib: vsprintf: default kptr_restrict to the maximum value
To: Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

Set the initial value of kptr_restrict to the maximum
setting rather than the minimum setting, to ensure that
early boot logging is not leaking information.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 lib/vsprintf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 0271223..e009325 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -396,7 +396,7 @@ struct printf_spec {
 #define FIELD_WIDTH_MAX ((1 << 23) - 1)
 #define PRECISION_MAX ((1 << 15) - 1)
 
-int kptr_restrict __read_mostly;
+int kptr_restrict __read_mostly = 4; /* maximum setting */
 
 /*
  * return non-zero if we should cleanse pointers for %p and %pK specifiers.
-- 
2.7.4
