Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 11 Jul 2011 06:37:20 +0000
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20110711063719.GA12579@localhost.ucw.cz>
References: <20110622095341.GA3353@albatros> <20110622153742.GA18983@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622153742.GA18983@suse.de>
Subject: [kernel-hardening] Re: [PATCH] kernel: escape non-ASCII and control characters in
	printk()
To: Greg KH <gregkh@suse.de>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed 2011-06-22 08:37:42, Greg KH wrote:
> On Wed, Jun 22, 2011 at 01:53:41PM +0400, Vasiliy Kulikov wrote:
> > This patch escapes all characters outside of allowed '\n' plus 0x20-0x7E
> > charset passed to printk().
> > 
> > There are numerous printk() instances with user supplied input as "%s"
> > data, and unprivileged user may craft log messages with substrings
> > containing control characters via these printk()s.  Control characters
> > might fool root viewing the logs via tty.
> 
> There are "numerous" places this could happen?  Shouldn't this be
> handled by the viewers of the log file and not the kernel itself?

well, currently cat /proc/kmsg is bad idea on multiuser system... right?

> And what could these control characters cause to be "fooled"?

terminals are powerful (or shall we say insecure?) these days. Including replies.

cat /proc/kmsg can result in something like "9q" be added to the next
bash command. It would not surprise me if nastier stuff was possible
with some xterm variant.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
