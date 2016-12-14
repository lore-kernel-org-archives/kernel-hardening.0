Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161214185000.GA3930@kroah.com>
References: <20161214185000.GA3930@kroah.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 14 Dec 2016 22:28:18 +0100
Message-ID: <CAHmME9pq=1hZirN6uwM5Tgrp5iG5mqmXw37gQYxFzcJ4Kkj9dQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC 0/4] make call_usermodehelper a bit more "safe"
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Greg,

On Wed, Dec 14, 2016 at 7:50 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> So, anyone have any better ideas?  Is this approach worth it?  Or should
> we just go down the "whitelist" path?

I think your approach is generally better than the whitelist path. But
maybe there's yet a third approach that involves futzing with page
permissions at runtime. I think grsec does something similar with
read_mostly function pointer structs. Namely, they make them read-only
const, and then temporarily twiddle the page permissions if it needs
to be changed while disabling preemption. There could be a particular
class of data that needs to be "opened" and "closed" in order to
modify. Seems like these strings would be a good use of that.

Jason
