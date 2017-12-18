From: "Tobin C. Harding" <me@tobin.cc>
Date: Tue, 19 Dec 2017 09:29:04 +1100
Message-Id: <1513636145-30033-3-git-send-email-me@tobin.cc>
In-Reply-To: <1513636145-30033-1-git-send-email-me@tobin.cc>
References: <1513636145-30033-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH v3 2/3] doc: update kpt_restrict documentation
To: Jonathan Corbet <corbet@lwn.net>
Cc: "Tobin C. Harding" <me@tobin.cc>, Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, Joe Perches <joe@perches.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Recently the behaviour of printk specifier %pK was changed. The
documentation does not currently mirror this.

Update documentation for sysctl kpt_restrict.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 Documentation/sysctl/kernel.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 63663039acb7..412314eebda6 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -391,7 +391,8 @@ kptr_restrict:
 This toggle indicates whether restrictions are placed on
 exposing kernel addresses via /proc and other interfaces.
 
-When kptr_restrict is set to (0), the default, there are no restrictions.
+When kptr_restrict is set to 0 (the default) the address is hashed before
+printing. (This is the equivalent to %p.)
 
 When kptr_restrict is set to (1), kernel pointers printed using the %pK
 format specifier will be replaced with 0's unless the user has CAP_SYSLOG
-- 
2.7.4
