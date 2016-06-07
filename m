Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue,  7 Jun 2016 14:57:03 -0700
Message-Id: <1465336628-18219-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 0/5] lkdtm: add usercopy and rodata, fix atomic
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Jiri Slaby <jslaby@suse.cz>, Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This adds several new tests to lkdtm.

To test non-executability of .rodata, lkdtm's build method shifted
around a bit requiring a source file rename. But after some objcopy
magic, there is now an architecture-agnostic way to write functions
into .rodata.

The atomic under/overflow test was split so that each case could be
individually tested.

The biggest addition are the usercopy tests (in preparation for
CONFIG_HARDENED_USERCOPY, based on grsecurity/PaX's PAX_USERCOPY).
This tests both directions (copy_to_from, copy_from_user) of the
three error conditions that are checked for: wrong object size,
wrong stack frame, and wrong object markings.

Unless anyone has blocking comments, I'll send a pull to Greg
for this to land in -next soon.

-Kees
