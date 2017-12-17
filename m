From: "Tobin C. Harding" <me@tobin.cc>
Date: Mon, 18 Dec 2017 09:30:04 +1100
Message-Id: <1513549807-20287-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH v2 0/3] doc: update printk documentation
To: Jonathan Corbet <corbet@lwn.net>
Cc: "Tobin C. Harding" <me@tobin.cc>, Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This set converts printk-formats.txt -> core-api/printk-formats.rst

We also update the documentation around printing kernel addresses.

For v2 I have attempted to toe the line more in regards to 'make as
few changes as possible to complete the conversion'.

This is my first documentation conversion. Please do be hard on this
patch series. I'd like to get it _realy_ correct so that future
conversions will require less review effort. Also if there are any
peculiarities to patching docs (as apposed to C files) please say so.

Thank you for the time already given to reviewing previous versions.

thanks,
Tobin.

v2:
 - Remove conversion/inclusion of kernel-docs from lib/vsprintf.c
 - Add '<>' around file name (in section 'Thanks').
 - Remove a few more double back ticks.	
 - Remove unnecessary [style] edits.

Tobin C. Harding (3):
  doc: convert printk-formats.txt to rst
  doc: update kpt_restrict documentation
  doc: add documentation on printing kernel addresses

 Documentation/00-INDEX                             |   2 -
 Documentation/core-api/index.rst                   |   1 +
 .../printk-formats.rst}                            | 271 +++++++++++----------
 Documentation/security/self-protection.rst         |  15 ++
 Documentation/sysctl/kernel.txt                    |   3 +-
 5 files changed, 158 insertions(+), 134 deletions(-)
 rename Documentation/{printk-formats.txt => core-api/printk-formats.rst} (57%)

-- 
2.7.4
