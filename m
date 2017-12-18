From: "Tobin C. Harding" <me@tobin.cc>
Date: Tue, 19 Dec 2017 09:29:02 +1100
Message-Id: <1513636145-30033-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH v3 0/3] doc: update printk documentation
To: Jonathan Corbet <corbet@lwn.net>
Cc: "Tobin C. Harding" <me@tobin.cc>, Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, Joe Perches <joe@perches.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This set converts printk-formats.txt -> core-api/printk-formats.rst

We also update the documentation around printing kernel addresses.

This is my first documentation conversion. Please do be hard on this
patch series. I'd like to get it _really_ correct so that future
conversions will require less review effort. Also if there are any
peculiarities to patching docs (as apposed to C files) please say so.

Thank you for the time already given to reviewing previous versions.

thanks,
Tobin.

v3:
 - Update filename .txt -> .rst in lib/vsnprintf.c comment (Joe Perches)
 - Remove unnecessary commas (as suggested by Randy Dunlap)
 - Re-apply theory 'make as few changes as possible to complete the
   conversion'

v2:
 - Remove conversion/inclusion of kernel-docs from lib/vsprintf.c
 - Add '<>' around file name (in section 'Thanks').
 - Remove a few more double back ticks.	
 - Apply theory 'make as few changes as possible to complete the
   conversion' 

Tobin C. Harding (3):
  doc: convert printk-formats.txt to rst
  doc: update kpt_restrict documentation
  doc: add documentation on printing kernel addresses

 Documentation/00-INDEX                             |   2 -
 Documentation/core-api/index.rst                   |   1 +
 .../printk-formats.rst}                            | 229 +++++++++++----------
 Documentation/security/self-protection.rst         |  15 ++
 Documentation/sysctl/kernel.txt                    |   3 +-
 lib/vsprintf.c                                     |   3 +-
 6 files changed, 139 insertions(+), 114 deletions(-)
 rename Documentation/{printk-formats.txt => core-api/printk-formats.rst} (63%)

-- 
2.7.4
