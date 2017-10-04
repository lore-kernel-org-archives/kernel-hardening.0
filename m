Date: Wed, 4 Oct 2017 10:58:12 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20171004085812.GF28247@kroah.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <1506816410-10230-6-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1506816410-10230-6-git-send-email-me@tobin.cc>
Subject: Re: [kernel-hardening] [RFC V2 5/6] lib: vsprintf: add "%paP",
 "%papP", and "%padP" specifiers
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Oct 01, 2017 at 11:06:49AM +1100, Tobin C. Harding wrote:
> Add %papP and %padP for address types that need to always be shown
> regardless of kptr restrictions. Add %paP is a synonym for %papP, this
> is inline with current implementation (%pa is a synonym for %pap).
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
