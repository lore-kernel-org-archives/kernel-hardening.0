Date: Wed, 28 Mar 2018 16:59:31 -0500
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [patch 3/8] rslib: Add SPDX identifiers
Message-ID: <20180328215931.GW23207@gate.crashing.org>
References: <20180328205138.301218351@linutronix.de> <20180328205554.496966175@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180328205554.496966175@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, Kate Stewart <kstewart@linuxfoundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 28, 2018 at 10:51:41PM +0200, Thomas Gleixner wrote:
> The Reed-Solomon library is based on code from Phil Karn who granted
> permission to import it into the kernel under the GPL V2.
> 
> See commit 15b5423757a7 ("Shared Reed-Solomon ECC library") in the history
> git tree at: git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
> 
>   ...
>   The encoder/decoder code is lifted from the GPL'd userspace RS-library
>   written by Phil Karn. I modified/wrapped it to provide the different
>   functions which we need in the MTD/NAND code.
>   ...    
>   Signed-Off-By: Thomas Gleixner <tglx@linutronix.de>
>   Signed-Off-By: David Woodhouse <dwmw2@infradead.org>
>   "No objections at all. Just keep the authorship notices." -- Phil Karn
> 
> Add the proper SPDX identifiers according to
> Documentation/process/license-rules.rst.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Kate Stewart <kstewart@linuxfoundation.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Segher Boessenkool <segher@kernel.crashing.org>

if you want that for the changes I did in d7e5a5462f68 .

Cheers,


Segher
