Date: Tue, 30 Jan 2018 16:11:38 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH] leaking_addresses: add 32-bit support
Message-ID: <20180130051138.GA4924@eros>
References: <1517201477-12326-1-git-send-email-me@tobin.cc>
 <1517283889.29097.1.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1517283889.29097.1.camel@gmail.com>
To: kaiwan.billimoria@gmail.com
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 30, 2018 at 09:14:49AM +0530, kaiwan.billimoria@gmail.com wrote:
> Hi Tobin,
> 
> On Mon, 2018-01-29 at 15:51 +1100, Tobin C. Harding wrote:
> > Currently script only supports x86_64 and ppc64.  It would be nice to be
> > able to scan 32-bit machines also.  We can add support for
> > 32-bit architectures by modifying how we check for false positives,
> > taking advantage of the page offset used by the kernel, and using the
> > correct regular expression.
> > 
> > Support for 32-bit machines is enabled by the observation the kernel
> > addresses on 32-bit machines are larger than the page offset.  We can
> > use this to filter false positives when scanning the kernel for leaking
> > addresses.
> > 
> > Programmatic determination of the running architecture is not
> > immediately obvious.  We therefore provide a flag to enable scanning of
> > 32-bit kernels.  Also we can check the kernel config file for the offset
> > and if not found default to 0xc0000000.  A command line option to parse
> > in the page offset is also provided.  We do automatically detect
> > architecture if running on ix86.
> > 
> > Add support for 32-bit kernels.  Add a command line option for page
> > offset.
> > 
> > Suggested-by: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
> > Signed-off-by: Tobin C. Harding <me@tobin.cc>
> > ---
> > 
> > The basis for this patch has been in development for a while by Kaiwan
> > but didn't get finished before the merge window opened.  I'd like to
> > fast track this and get it to Linus this merge window (considering
> > Spectre/Meltdown).  I have finished this work off and added the
> > Suggested-by tag.  Kaiwan I hope you are not upset by this, extra
> > ordinary circumstances seemed to require this action.
> Definitely not; I understand and am glad you're on it a 100%. Apologies
> that I couldn't work on this right now.. will try and keep track too.

Thanks for the response.

	Tobin
