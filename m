Date: Wed, 4 Oct 2017 10:58:05 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20171004085805.GE28247@kroah.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <1506816410-10230-4-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1506816410-10230-4-git-send-email-me@tobin.cc>
Subject: Re: [kernel-hardening] [RFC V2 3/6] lib: vsprintf: physical address
 kernel pointer filtering options
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Oct 01, 2017 at 11:06:47AM +1100, Tobin C. Harding wrote:
> Add the kptr_restrict setting of 4 which results in %pa and
> %p[rR] values being cleansed.
> 
> Address types printed with %pa are replaced by zeros. Resources printed
> with %p[rR] have the starting address replaced by zeros, resource size
> is still shown.
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
