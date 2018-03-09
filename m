Date: Fri, 9 Mar 2018 16:49:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH][RFC] rslib: Remove VLAs by setting upper bound on
 nroots
In-Reply-To: <20180309144613.GA48965@beast>
Message-ID: <alpine.DEB.2.21.1803091610120.1364@nanos.tec.linutronix.de>
References: <20180309144613.GA48965@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Segher Boessenkool <segher@kernel.crashing.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 9 Mar 2018, Kees Cook wrote:

> Avoid VLAs[1] by always allocating the upper bound of stack space
> needed. The existing users of rslib appear to max out at 32 roots,
> so use that as the upper bound.

I think 32 is plenty. Do we have actually a user with 32?

> Alternative: make init_rs() a true caller-instance and pre-allocate
> the workspaces. Will this need locking or are the callers already
> single-threaded in their use of librs?

init_rs() is an init function which needs to be invoked _before_ the
decoder/encoder can be used.

The way it works today that it can share the rs_control between users to
avoid duplicating the polynom arrays and the setup of them.

So we might change how rs_control works and allocate rs_control for each
invocation of init_rs(). That means we need two data structures:

Rename rs_control to rs_poly and just use that internaly for sharing the
polynom arrays.

rs_control then becomes:

struct rs_control {
	struct rs_poly	*poly;
	uint16_t	lamda[MAX_ROOTS + 1];
	....
	uint16_t	loc[MAX_ROOTS];
};

But as you said that requires serialization or separation at the usage
sites.

drivers/mtd/nand/* would either need a mutex or allocate one rs_control per
instance. Simple enough to do.

drivers/md/dm-verity-fec.c looks like it's allocating a dm control struct
for each worker thread, so that should just require allocating one
rs_control per worker then.

pstore only has an issue in case of OOPS. A simple solution would be to
allocate two rs_control structs, one for regular usage and one for the OOPS
case. Not sure if that covers all possible problems, so that needs more
thoughts.

Thanks,

	tglx
