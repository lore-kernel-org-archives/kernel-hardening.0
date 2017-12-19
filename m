From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed, 20 Dec 2017 08:39:21 +1100
Message-Id: <1513719564-13249-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH v3 0/3] kallsyms: don't leak address
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Tycho Andersen <tycho@tycho.ws>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <daniel@iogearbox.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, Joe Perches <joe@perches.com>
List-ID: <kernel-hardening.lists.openwall.com>

This set plugs a kernel address leak that occurs if kallsyms symbol
look up fails. This set was prompted by a leaking address found using
scripts/leaking_addresses.pl on a PowerPC machine in the wild.

$ perl scripts/leaking_addresses.pl		[address sanitized]
...
/proc/8025/task/8025/stack: [<0000000000000000>] 0xc0000001XXXXXXXX

$ uname -r
4.4.0-79-powerpc64-smp


Patch set does not change behaviour when KALLSYMS is not defined
(suggested by Linus).

Comments on version 1 indicated that current behaviour may be useful for
debugging. This version adds a kernel command-line parameter in order to
be able to preserve current behaviour (print raw address if kallsyms
symbol look up fails). (Command-line parameter suggested by Steve.)

New command-line parameter is documented only in the kernel-doc for
kallsyms functions sprint_symbol() and sprint_symbol_no_offset(). Is
this sufficient? Perhaps an entry in printk-formats.txt also?

Patch 1 - return error code if symbol look up fails unless new
	  command-line parameter 'insecure_print_all_symbols' is enabled.
Patch 2 - print <symbol not found> to buffer if symbol look up returns
	  an error.
Patch 3 - maintain current behaviour in ftrace.

thanks,
Tobin.

v3:
 - Remove const string and use ternary operator (suggested by Joe
   Perches) 

v2:
 - Add kernel command-line parameter.
 - Remove unnecessary function.
 - Fix broken ftrace code (and actually build and test ftrace code).

All code tested.

Tobin C. Harding (3):
  kallsyms: don't leak address when symbol not found
  vsprintf: print <symbol not found> if symbol not found
  trace: print address if symbol not found

 kernel/kallsyms.c                | 31 +++++++++++++++++++++++++------
 kernel/trace/trace.h             | 24 ++++++++++++++++++++++++
 kernel/trace/trace_events_hist.c |  6 +++---
 kernel/trace/trace_output.c      |  2 +-
 lib/vsprintf.c                   |  9 +++++----
 5 files changed, 58 insertions(+), 14 deletions(-)

-- 
2.7.4
