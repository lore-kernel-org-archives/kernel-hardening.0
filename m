Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 22 Jun 2011 20:13:02 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110622161302.GB10365@albatros>
References: <20110622095341.GA3353@albatros>
 <20110622153742.GA18983@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622153742.GA18983@suse.de>
Subject: [kernel-hardening] Re: [PATCH] kernel: escape non-ASCII and control characters in
 printk()
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Greg,

On Wed, Jun 22, 2011 at 08:37 -0700, Greg KH wrote:
> On Wed, Jun 22, 2011 at 01:53:41PM +0400, Vasiliy Kulikov wrote:
> > This patch escapes all characters outside of allowed '\n' plus 0x20-0x7E
> > charset passed to printk().
> > 
> > There are numerous printk() instances with user supplied input as "%s"
> > data, and unprivileged user may craft log messages with substrings
> > containing control characters via these printk()s.  Control characters
> > might fool root viewing the logs via tty.
> 
> There are "numerous" places this could happen?

>From where I'm working now: warn_setuid_and_fcaps_mixed(),
get_file_caps().  task->comm is not filtered and sometimes it is used in
log entries related to the process.  I don't know a global policy of
filtering such user supplied strings and didn't spot such filtering
(however, maybe I've missed it somewhere).  It's MUCH simplier to filter
it in one place rather than hunt after the callers all over the kernel.

>  Shouldn't this be
> handled by the viewers of the log file and not the kernel itself?

What viewers?  Do you mean syslog implementation?  IMO it's not its
duty, it logs what it was fed.  It should be entiely app's care to
maintain consisten logs, syslog might not know precise log structure.
What should syslog do if app's log structure changes?

> And what could these control characters cause to be "fooled"?

E.g. line up:

ALERT!
^[1AUseless line.

TTY will interpret it as a single line "Useless line", ALERT will be
fully losen.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
