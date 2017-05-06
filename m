Message-ID: <1494067716.4633.8.camel@hellion.org.uk>
From: Ian Campbell <ijc@hellion.org.uk>
Date: Sat, 06 May 2017 11:48:36 +0100
In-Reply-To: <20170506040720.GD32707@kroah.com>
References: <20170506040641.GA32707@kroah.com>
	 <20170506040720.GD32707@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] [RFC 3/6] lib: vsprintf: physical address
 kernel pointer filtering options
To: Greg KH <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2017-05-05 at 21:07 -0700, Greg KH wrote:
> From: Dave Weinstein <olorin@google.com>
> 
> Add the kptr_restrict setting of 4 which results in %pa and
> %p[rR] values being replaced by zeros.

Given that '%pa' is:
 * - 'a[pd]' For address types [p] phys_addr_t, [d] dma_addr_t and derivatives
 *           (default assumed to be phys_addr_t, passed by reference)

what is the thread model which hiding physical addresses from attackers
protects against? I can see why virtual addresses would be obviously
dangerous but physical addresses seem less obvious and I didn't see it
spelled out in any of the commit messages or added comments in the
thread.

I think a comment somewhere would be useful for people who are trying
to decide if they should use %pa vs %paP etc.

Ian.
