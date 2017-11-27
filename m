From: "Tobin C. Harding" <me@tobin.cc>
Date: Tue, 28 Nov 2017 09:30:16 +1100
Message-Id: <1511821819-5496-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [RFC 0/3] kallsyms: don't leak address when printing symbol
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Tycho Andersen <tycho@tycho.ws>
List-ID: <kernel-hardening.lists.openwall.com>

This is an RFC for two reasons.

1) I don't know who this patch set may break?
2) Patch set includes a function that is not called. Function is there
   to facilitate fixing breakages.

_If_ no one gets broken then we can remove the unused function.

Thanks for looking at this.

Currently if a pointer is printed using %p[ssB] and the symbol is not
found (kallsyms_lookup() fails) then we print the actual address. This
potentially leaks kernel addresses. We could instead print something
_safe_. If kallsyms is made to return an error then callers of
sprint_symbol() can decide what to do.

In the case of vsprintf we can print '<no-symbol>' (patch 2).

In the case of trace we want the address so we can check the return code
and print the address if no symbol is found (patch 3).

Design for this set loosely suggested by Steve Rostedt (so as not to
break ftrace).


Patch 1 and 2 tested, patch 3 (trace stuff) untested :)

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
