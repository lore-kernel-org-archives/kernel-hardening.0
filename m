Message-ID: <1512619918.17323.66.camel@gmail.com>
From: kaiwan.billimoria@gmail.com
Date: Thu, 07 Dec 2017 09:41:58 +0530
In-Reply-To: <20171206230117.GI11835@eros>
References: <1512455204.17323.20.camel@gmail.com>
	 <20171206040437.GB11835@eros> <1512561090.17323.32.camel@gmail.com>
	 <20171206230117.GI11835@eros>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3] scripts: leaking_addresses: add support for 32-bit
 kernel addresses
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Alexander Kapshuk <alexander.kapshuk@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2017-12-07 at 10:01 +1100, Tobin C. Harding wrote:
> On Wed, Dec 06, 2017 at 05:21:30PM +0530, kaiwan.billimoria@gmail.com wrote:
> > On Wed, 2017-12-06 at 15:04 +1100, Tobin C. Harding wrote:
> > > 
> > Sure, lets try for a generic ver!
> 
> Cool.
> 
> > Thanks for your help on this..
> 
> No problem.
> 
> > As your experience woth the R Pi shows, we may have to just resort to building a
> > generic framework of sorts, letting folks "plugin" appropriate "truth values"
> > for their particular platform; this way, we support as much as we can for now
> > and, going forward, it's generic.
> > As of right now though, am unsure what this "generic framework" is..
> 
> ATM the best I can come up with is having two flags
> 
> --page-offset-32bit=0xc0000000 (exactly as we have now)
> --32-bit
> 
> Now for the klunky bit, I can only see two options
> 
> 1. Default to 64 bit, for 32 bit scan require one of the above options
> to be set.

Yes, agreed..
> 
> 2. Parse config file for all architectures, if CONFIG_PAGE_OFFSET is set
> us it.
> 
> I particularly don't like option 2. If we can find a reliable way to get
> the architecture the we have a better option. At the moment the method
> we use relies on the architecture of the machine that the Perl binary
> was built on (AFAICT).
> 
> (/usr/bin/arch does not work on RPi either)

Right, reg arch: nor on some of the Yocto platforms I tested.
> 
> I'm happy with option 1 unless there is a better proposal.
> thanks,
> Tobin.

Okay, I can start working on the approach above. So, that implies that the
is_supported_architecture sub (and it's descendants) are now redundant, correct?

Also, I think we can perhaps still make use of the 'uname -m' to advantage:

1. A scenario: the user runs the script with no options; we default to 64-bit.
But, the platform is actually 32-bit. So, we run a sanity check regardless - if
we find that the platform is indeed 32-bit but the user has not run with the
--32-bit (or --page-offset-32bit) option switch(es), we could:
   - (a) emit a noisy Warning message to stderr and continue, ("batch mode"), OR
   - (b) fail, with the error message and a failure code.

Of course if we go with (a), the results will be meaningless; so, just failing might be better.
Again, I realize that all this will only work if detection of 32-bit actually works!
I'll take a stab at this..

2. Modify the show_detected_architecture sub to use it (for 'debug' case).

What do you think?

Thanks,
Kaiwan.
