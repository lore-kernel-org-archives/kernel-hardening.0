Date: Fri, 5 May 2017 21:06:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170506040641.GA32707@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [RFC 00/06] printk: add more new kernel pointer filter options.
To: kernel-hardening@lists.openwall.com, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

Here's a short patch series from Chris Fries and Dave Weinstein that
implement some new restrictions when printing out kernel pointers, as
well as the ability to whitelist kernel pointers where needed.

These patches are based on work from William Roberts, and also is
inspired by grsecurity's %pP to specifically whitelist a kernel pointer,
where it is always needed, like the last patch in the series shows, in
the UIO drivers (UIO requires that you know the address, it's a hardware
address, nothing wrong with seeing that...)

I haven't done much to this patch series, only forward porting it from
an older kernel release (4.4) and a few minor tweaks.  It applies
cleanly on top of 4.11 as well as Linus's current development tree
(10502 patches into the 4.12-rc1 merge window).  I'm posting it now for
comments if anyone sees anything wrong with this approach, or thinks the
things that are being whitelisted should not be?

thanks,

greg k-h

 Documentation/printk-formats.txt |   15 +++-
 Documentation/sysctl/kernel.txt  |   11 +++
 arch/arm64/kernel/traps.c        |    4 -
 drivers/uio/uio.c                |    4 -
 include/linux/kallsyms.h         |    2
 kernel/printk/printk.c           |    2
 kernel/sysctl.c                  |    6 -
 lib/vsprintf.c                   |  128 ++++++++++++++++++++++++++++-----------
 8 files changed, 123 insertions(+), 49 deletions(-)
