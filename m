From: "Tobin C. Harding" <me@tobin.cc>
Date: Fri,  8 Dec 2017 09:27:55 +1100
Message-Id: <1512685676-21933-3-git-send-email-me@tobin.cc>
In-Reply-To: <1512685676-21933-1-git-send-email-me@tobin.cc>
References: <1512685676-21933-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 2/3] doc: update kpt_restrict documentation
To: Jonathan Corbet <corbet@lwn.net>
Cc: "Tobin C. Harding" <me@tobin.cc>, Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Recently the behaviour of printk specifier %pK was changed. The
documentation does not currently mirror this.

Update documentation for sysctl kpt_restrict.

Reported-by: Alexander Popov <alex.popov@linux.com>
Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 Documentation/sysctl/kernel.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 694968c7523c..1698cd2ef16b 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -377,7 +377,8 @@ kptr_restrict:
 This toggle indicates whether restrictions are placed on
 exposing kernel addresses via /proc and other interfaces.
 
-When kptr_restrict is set to (0), the default, there are no restrictions.
+When kptr_restrict is set to (0), the default, the address is hashed before
+printing. (This is the equivalent to %p.)
 
 When kptr_restrict is set to (1), kernel pointers printed using the %pK
 format specifier will be replaced with 0's unless the user has CAP_SYSLOG
-- 
2.7.4
