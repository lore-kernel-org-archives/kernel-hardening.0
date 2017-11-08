From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed,  8 Nov 2017 14:37:32 +1100
Message-Id: <1510112259-11572-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 0/7] scripts/leaking_addresses: add summary report
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

This series includes changes submitted as

[PATCH v4 ] scripts: add leaking_addresses.pl

before I realize Linus had merged v3.

Does some clean up and implements changes suggested by Petr Mladek and Kees
Cook.

Adds printing a summary report instead of raw results as suggested by Linus
Torvalds.

thanks,
Tobin.

Tobin C. Harding (7):
  scripts/leaking_addresses: use tabs not spaces
  scripts/leaking_addresses: remove dead code
  scripts/leaking_addresses: remove command line options
  scripts/leaking_addresses: add reporting
  scripts/leaking_addresses: add emailing results
  scripts/leaking_addresses: fix comment typo
  scripts/leaking_addresses: don't parse usbmon

 scripts/leaking_addresses.pl | 351 ++++++++++++++++++++++++++++++-------------
 1 file changed, 250 insertions(+), 101 deletions(-)
 mode change 100755 => 100644 scripts/leaking_addresses.pl

-- 
2.7.4
