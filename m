Date: Wed, 4 Oct 2017 10:55:42 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20171004085542.GA28247@kroah.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <1506816410-10230-2-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1506816410-10230-2-git-send-email-me@tobin.cc>
Subject: Re: [kernel-hardening] [RFC V2 1/6] lib: vsprintf: additional kernel
 pointer filtering options
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Oct 01, 2017 at 11:06:45AM +1100, Tobin C. Harding wrote:
> Add the kptr_restrict setting of 3 which results in both
> %p and %pK values being replaced by zeros.
> 
> Add an additional %pP value inspired by the Grsecurity
> option which explicitly whitelists pointers for output.
> 
> Amend scripts/checkpatch.pl to handle %pP.
> 
> This patch is based on work by William Roberts
> <william.c.roberts@intel.com>
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
