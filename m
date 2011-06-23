Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 23 Jun 2011 14:36:05 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
Message-ID: <20110623133605.GA28333@srcf.ucam.org>
References: <20110622095341.GA3353@albatros>
 <20110622153742.GA18983@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622153742.GA18983@suse.de>
Subject: [kernel-hardening] Re: [PATCH] kernel: escape non-ASCII and control characters in
 printk()
To: Greg KH <gregkh@suse.de>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 22, 2011 at 08:37:42AM -0700, Greg KH wrote:
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

USB product identifiers?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
