From: "Tobin C. Harding" <me@tobin.cc>
Date: Sun,  1 Oct 2017 11:06:44 +1100
Message-Id: <1506816410-10230-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
To: Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

Version 2 of Greg's patch series with changes made as suggested by comments to V1.

Applies on top of Linus' current development tree

a8c964eacb21288b2dbfa9d80cee5968a3b8fb21

V1 cover letter:

Here's a short patch series from Chris Fries and Dave Weinstein that
implements some new restrictions when printing out kernel pointers, as
well as the ability to whitelist kernel pointers where needed.

These patches are based on work from William Roberts, and also are
inspired by grsecurity's %pP to specifically whitelist a kernel pointer,
where it is always needed, like the last patch in the series shows, in
the UIO drivers (UIO requires that you know the address, it's a hardware
address, nothing wrong with seeing that...)

I haven't done much to this patch series, only forward porting it from
an older kernel release (4.4) and a few minor tweaks. [snip]

V1 -> V2:

* Renamed function kptr_restrict_always_cleanse_pointers() to
  kptr_restrict_cleanse_kernel_pointers() (as suggested by Petr Mladek).

* Re-ordered switch statement (within pointer()) to place default at the end
  of the statement (as suggested by Petr Mladek).

* Updated Documentation/printk-formats.txt (as suggested by Joe Perches).

* Updated Documentation/sysctl/kernel.txt (as suggested by Petr Mladek).

Suggestion by Ian Campbell to add comments on the threat model being mitigated
by use of %pa vs %paP etc is not implemented because I do not know the threat
model (I'm only the janitor). Happy to add them if someone writes them.

thanks,
Tobin.

Tobin C. Harding (6):
  lib: vsprintf: additional kernel pointer filtering options
  lib: vsprintf: whitelist stack traces
  lib: vsprintf: physical address kernel pointer filtering options
  lib: vsprintf: default kptr_restrict to the maximum value
  lib: vsprintf: add "%paP", "%papP", and "%padP" specifiers
  drivers: uio: un-restrict sysfs pointers for UIO

 Documentation/printk-formats.txt |  27 ++++++++--
 Documentation/sysctl/kernel.txt  |   9 ++++
 arch/arm64/kernel/traps.c        |   4 +-
 drivers/uio/uio.c                |   4 +-
 kernel/printk/printk.c           |   2 +-
 kernel/sysctl.c                  |   2 +-
 lib/vsprintf.c                   | 114 +++++++++++++++++++++++++++++----------
 scripts/checkpatch.pl            |   2 +-
 8 files changed, 124 insertions(+), 40 deletions(-)

-- 
2.7.4
