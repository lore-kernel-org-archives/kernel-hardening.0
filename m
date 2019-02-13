Date: Thu, 14 Feb 2019 07:30:33 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH 3/3] leaking_addresses: Expand tilde in output file name
Message-ID: <20190213203033.GB31743@eros.localdomain>
References: <20190207225026.11723-1-tobin@kernel.org>
 <20190207225026.11723-4-tobin@kernel.org>
 <6aed136f16e8451dbcfa97f90c04438f@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6aed136f16e8451dbcfa97f90c04438f@AcuMS.aculab.com>
To: David Laight <David.Laight@aculab.com>
Cc: "'Tobin C. Harding'" <tobin@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Tycho Andersen <tycho@tycho.ws>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 13, 2019 at 03:56:47PM +0000, David Laight wrote:
> From: Tobin C. Harding
> > Sent: 07 February 2019 22:50
> > 
> > Currently if user passes an output file to the script via
> > --output-raw we do not handle expansion of tilde.
> > 
> > Use perl function glob() to expand tilde in output file name.
> 
> What happens if glob() returns multiple files?
> I'm guessing that it can...

Thanks for taking a look at this David.  Surely glob() cannot return
multiple values when expanding tilde?  If someone passes a '*' into the
command as an input/output file then they are clearly mad :)


thanks,
Tobin.
