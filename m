Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 22 Jun 2011 08:37:42 -0700
From: Greg KH <gregkh@suse.de>
Message-ID: <20110622153742.GA18983@suse.de>
References: <20110622095341.GA3353@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622095341.GA3353@albatros>
Subject: [kernel-hardening] Re: [PATCH] kernel: escape non-ASCII and control characters in
 printk()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 22, 2011 at 01:53:41PM +0400, Vasiliy Kulikov wrote:
> This patch escapes all characters outside of allowed '\n' plus 0x20-0x7E
> charset passed to printk().
> 
> There are numerous printk() instances with user supplied input as "%s"
> data, and unprivileged user may craft log messages with substrings
> containing control characters via these printk()s.  Control characters
> might fool root viewing the logs via tty.

There are "numerous" places this could happen?  Shouldn't this be
handled by the viewers of the log file and not the kernel itself?

And what could these control characters cause to be "fooled"?

greg k-h
