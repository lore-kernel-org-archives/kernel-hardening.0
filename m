Date: Sat, 6 Jan 2018 12:37:39 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20180106013739.GA17325@eros>
References: <1515193172-20279-1-git-send-email-me@tobin.cc>
 <CAGXu5jJ1SfKmTtwN6JS42cXWN6v=pPrEyfcdJRH+=MTmh5hPKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ1SfKmTtwN6JS42cXWN6v=pPrEyfcdJRH+=MTmh5hPKQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] leaking_addresses: add files to skip
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, kaiwan.billimoria@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 05, 2018 at 04:11:07PM -0800, Kees Cook wrote:
> On Fri, Jan 5, 2018 at 2:59 PM, Tobin C. Harding <me@tobin.cc> wrote:
> > Script currently times out when parsing the following files:
> >
> >         /proc/kallsyms
> >         /proc/sched_debug
> >         /proc/PID/smaps
> 
> Seems like kallsyms would be one to absolutely scan... it shouldn't
> cause hangs either.

Haven't we fixed kallsyms now? Do you mean that we should be checking to
see if the scanned kernel has been patched to include the kallsysms
fixes in 4.14? If so perhaps we should add functionality to just check
the first line for an address and warn if one is found. No real reason
to include ever address in kallsyms in the output.

Script doesn't hang but it times out with the default timer (10 seconds). 

thanks,
Tobin.
