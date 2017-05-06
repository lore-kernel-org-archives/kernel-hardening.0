Date: Fri, 5 May 2017 21:07:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170506040737.GE32707@kroah.com>
References: <20170506040641.GA32707@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170506040641.GA32707@kroah.com>
Subject: [kernel-hardening] [RFC 4/6] lib: vsprintf: default kptr_restrict to the maximum value
To: kernel-hardening@lists.openwall.com, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Dave Weinstein <olorin@google.com>

Set the initial value of kptr_restrict to the maximum
setting rather than the minimum setting, to ensure that
early boot logging is not leaking information.

Cc: William Roberts <william.c.roberts@intel.com>
Cc: Chris Fries <cfries@google.com>
Signed-off-by: Dave Weinstein <olorin@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/vsprintf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 75a49795fcae..404d477d4bd2 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -395,7 +395,7 @@ struct printf_spec {
 #define FIELD_WIDTH_MAX ((1 << 23) - 1)
 #define PRECISION_MAX ((1 << 15) - 1)
 
-int kptr_restrict __read_mostly;
+int kptr_restrict __read_mostly = 4;
 
 /*
  * Always cleanse %p and %pK specifiers
-- 
2.12.2
