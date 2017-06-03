Date: Sat, 3 Jun 2017 18:22:31 +0200
From: Solar Designer <solar@openwall.com>
Message-ID: <20170603162231.GA20590@openwall.com>
References: <20170603055351.16080-1-matt@nmatt.com> <20170603154707.GA19161@openwall.com> <20170603155920.GA25740@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170603155920.GA25740@kroah.com>
Subject: Re: [kernel-hardening] [PATCH v1 1/1] Add Trusted Path Execution as a stackable LSM
To: Greg KH <greg@kroah.com>
Cc: Matt Brown <matt@nmatt.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jun 03, 2017 at 05:59:20PM +0200, Greg KH wrote:
> But for those systems, and this feature as well, can't a "simple"
> apparmor policy do the exact same thing?  Also, I'm sure the SELinux can
> do this as well, but I don't know the config language there as well.
> 
> So I think this is already a feature that is supported, it just takes a
> bit more configuration work on the admin.

Yes, that's "a bit" more effort up to the point where almost(?) no one
would bother.  Sometimes simple features can reasonably co-exist with
more general frameworks that could also be used to achieve the effect.
So I don't view this as a sufficiently good argument against TPE as a
feature on its own.

Alexander
