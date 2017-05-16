Date: Tue, 16 May 2017 16:41:04 +0200
From: Petr Mladek <pmladek@suse.com>
Message-ID: <20170516144104.GA8621@pathway.suse.cz>
References: <20170506040641.GA32707@kroah.com>
 <20170506040747.GF32707@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170506040747.GF32707@kroah.com>
Subject: [kernel-hardening] Re: [RFC 5/6] lib: vsprintf: Add "%paP", "%padP" options
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri 2017-05-05 21:07:47, Greg KH wrote:
> From: Chris Fries <cfries@google.com>
> 
> Add %paP and %padP for physical address that need to always be shown
> regardless of kptr restrictions.
> 
> Cc: William Roberts <william.c.roberts@intel.com>
> Cc: Dave Weinstein <olorin@google.com>
> Signed-off-by: Chris Fries <cfries@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  Documentation/printk-formats.txt | 10 ++++++----
>  lib/vsprintf.c                   | 12 +++++++++---
>  2 files changed, 15 insertions(+), 7 deletions(-)

This patch should update also the section about
kptr_restrict in Documentation/sysctl/kernel.txt.
It should mention that the trailing P allows to see
pointers also for %pa, and %p[rR] formats when
the level is 4.

Best Regards,
Petr
