From: "Tobin C. Harding" <me@tobin.cc>
Date: Fri,  8 Dec 2017 09:27:53 +1100
Message-Id: <1512685676-21933-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 0/3] doc: update printk documentation
To: Jonathan Corbet <corbet@lwn.net>
Cc: "Tobin C. Harding" <me@tobin.cc>, Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This set merges two previous patch attempts

[PATCH v2] doc: convert printk-formats.txt to rst
[PATCH] docs: add documentation on printing kernel addresses

And adds patch amending docs for sysctl kptr_restrict

Applies on top of

commit: "ae64f9bd1d36 Linux 4.15-rc2"

(Doesn't apply on top of Jon's docs-next tree (at time of writing at
rc-1) because of commit made to lib/vsprintf.c)

thanks,
Tobin.

Tobin C. Harding (3):
  doc: convert printk-formats.txt to rst
  doc: update kpt_restrict documentation
  doc: add documentation on printing kernel addresses

 Documentation/00-INDEX                             |   2 -
 Documentation/core-api/index.rst                   |   1 +
 .../printk-formats.rst}                            | 268 +++++++++++----------
 Documentation/security/self-protection.rst         |  15 ++
 Documentation/sysctl/kernel.txt                    |   3 +-
 lib/vsprintf.c                                     | 155 +++++-------
 6 files changed, 213 insertions(+), 231 deletions(-)
 rename Documentation/{printk-formats.txt => core-api/printk-formats.rst} (59%)

-- 
2.7.4
