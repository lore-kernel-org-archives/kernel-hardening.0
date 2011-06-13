Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 13 Jun 2011 11:07:00 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110613070700.GA22659@openwall.com>
References: <20110613064252.GB3877@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613064252.GB3877@albatros>
Subject: Re: [kernel-hardening] destroy unused shmem segments
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Mon, Jun 13, 2011 at 10:42:52AM +0400, Vasiliy Kulikov wrote:
> Is it some additional "safety" check or a workaround for some dubious
> race?

Neither.  IIRC, I thought that this was needed, and not as a workaround,
nor because of a race.  However, your analysis appears to be correct to
me.  This leaves us with the following three possibilities:

- The extra code was never needed.  This is unlikely because I was
adding those pieces of code based on my testing results.

- The extra code was needed for some older kernel version (maybe older
than 2.4), then forward-ported (not carefully enough to spot this).
(Most CONFIG_HARDEN_* features 2.4.x-ow date back to my patches for 2.0.)

- We're missing something now.

I think that you don't need to figure out which it is.  Rather, you
need to implement the functionality for 3.0 and test it.  Then do it for
RHEL6/OpenVZ as well.

> I see no explicit need of such freeing cycle in do_exit().

Yes, it appears so from your analysis.

Thanks,

Alexander
