Date: Thu, 19 Apr 2018 15:55:51 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [patch V2 3/8] rslib: Add SPDX identifiers
Message-ID: <20180419135551.GA16862@kroah.com>
References: <20180419100441.548834519@linutronix.de>
 <20180419100935.011090923@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180419100935.011090923@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, Kate Stewart <kstewart@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 19, 2018 at 12:04:44PM +0200, Thomas Gleixner wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
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
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Kate Stewart <kstewart@linuxfoundation.org>
> Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Segher Boessenkool <segher@kernel.crashing.org>
> Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Anton Vorontsov <anton@enomsg.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Colin Cross <ccross@android.com>
> Cc: Andrew Morton <akpm@linuxfoundation.org>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Alasdair Kergon <agk@redhat.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
