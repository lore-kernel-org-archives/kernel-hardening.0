Date: Wed, 4 Oct 2017 10:55:53 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20171004085553.GB28247@kroah.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <1506816410-10230-5-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1506816410-10230-5-git-send-email-me@tobin.cc>
Subject: Re: [kernel-hardening] [RFC V2 4/6] lib: vsprintf: default
 kptr_restrict to the maximum value
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Oct 01, 2017 at 11:06:48AM +1100, Tobin C. Harding wrote:
> Set the initial value of kptr_restrict to the maximum
> setting rather than the minimum setting, to ensure that
> early boot logging is not leaking information.
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
