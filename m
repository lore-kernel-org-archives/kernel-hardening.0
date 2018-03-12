Date: Mon, 12 Mar 2018 17:05:49 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH v2] staging: vchiq_arm: Clear VLA warning
Message-ID: <20180312060549.GH8631@eros>
References: <1520818673-14084-1-git-send-email-me@tobin.cc>
 <20180312054613.GG8631@eros>
 <1166411830.411906.1520834284931@email.1und1.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1166411830.411906.1520834284931@email.1und1.de>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Eric Anholt <eric@anholt.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tycho Andersen <tycho@tycho.ws>, driverdev-devel@linuxdriverproject.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 12, 2018 at 06:58:04AM +0100, Stefan Wahren wrote:
> Hi Tobin,
> 
> > "Tobin C. Harding" <me@tobin.cc> hat am 12. März 2018 um 06:46 geschrieben:
> > 
> > 
> > On Mon, Mar 12, 2018 at 12:37:53PM +1100, Tobin C. Harding wrote:
> > > The kernel would like to have all stack VLA usage removed[1].  The array
> > > here is fixed (declared with a const variable) but it appears like a VLA
> > > to the compiler.  Also, currently we are putting 768 bytes on the
> > > stack.  This function is only called on the error path so performance is
> > > not critical, let's just allocate the memory instead of using the
> > > stack.  This saves stack space and removes the VLA build warning.
> > > 
> > > kmalloc a buffer for dumping state instead of using the stack.
> > > 
> > > [1]: https://lkml.org/lkml/2018/3/7/621
> > > 
> > > Signed-off-by: Tobin C. Harding <me@tobin.cc>
> > > ---
> > 
> > Drop this please, leaks memory.
> 
> except from the leak, did you test this patch on a RPi?

No I didn't, but I can have a go at it.  Will try before doing v3.

thanks,
Tobin.
