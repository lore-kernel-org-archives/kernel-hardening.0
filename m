Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 14 Dec 2016 15:16:29 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20161214231629.GA23558@kroah.com>
References: <20161214185000.GA3930@kroah.com>
 <CAHmME9pq=1hZirN6uwM5Tgrp5iG5mqmXw37gQYxFzcJ4Kkj9dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pq=1hZirN6uwM5Tgrp5iG5mqmXw37gQYxFzcJ4Kkj9dQ@mail.gmail.com>
Subject: Re: [kernel-hardening] [RFC 0/4] make call_usermodehelper a bit more
 "safe"
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 14, 2016 at 10:28:18PM +0100, Jason A. Donenfeld wrote:
> Hi Greg,
> 
> On Wed, Dec 14, 2016 at 7:50 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > So, anyone have any better ideas?  Is this approach worth it?  Or should
> > we just go down the "whitelist" path?
> 
> I think your approach is generally better than the whitelist path. But
> maybe there's yet a third approach that involves futzing with page
> permissions at runtime. I think grsec does something similar with
> read_mostly function pointer structs. Namely, they make them read-only
> const, and then temporarily twiddle the page permissions if it needs
> to be changed while disabling preemption. There could be a particular
> class of data that needs to be "opened" and "closed" in order to
> modify. Seems like these strings would be a good use of that.

Yes, but that's a much larger issue and if that feature ever lands, we
can switch these strings over to that functionality.

thanks,

greg k-h
