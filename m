From: "Tobin C. Harding" <me@tobin.cc>
Date: Mon, 18 Dec 2017 10:53:29 +1100
Message-Id: <1513554812-13014-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 0/3] kallsyms: don't leak address
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Tycho Andersen <tycho@tycho.ws>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <daniel@iogearbox.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

This set plugs a kernel address leak that occurs if kallsyms symbol
look up fails. This set was prompted by a leaking address found using
scripts/leaking_addresses.pl on a PowerPC machine in the wild.

Patch set does not change behaviour when KALLSYMS is not defined
(suggested by Linus).

RFC has been in flight for 3 weeks with no negative response.

Patch 1 - return error code if symbol look up fails.
Patch 2 - print <no-symbol> to buffer if symbol look up returns an error.
Patch 3 - maintain current behaviour in ftrace.

Patch 3 (the ftrace stuff) is untested.

thanks,
Tobin.

Tobin C. Harding (3):
  kallsyms: don't leak address when symbol not found
  vsprintf: print <no-symbol> if symbol not found
  trace: print address if symbol not found

 include/linux/kernel.h           |  2 ++
 kernel/kallsyms.c                |  6 ++++--
 kernel/trace/trace.h             | 24 ++++++++++++++++++++++++
 kernel/trace/trace_events_hist.c |  6 +++---
 lib/vsprintf.c                   | 18 +++++++++++++++---
 5 files changed, 48 insertions(+), 8 deletions(-)

-- 
2.7.4
