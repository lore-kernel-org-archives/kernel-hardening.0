Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 18 Feb 2012 08:18:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20120218161849.GA4176@kroah.com>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>
 <20120216204515.GH20420@outflux.net>
 <20120217002405.GB7746@kroah.com>
 <20120217075945.GA2831@albatros>
 <20120217175445.GC29902@kroah.com>
 <20120217193719.GA4187@albatros>
 <20120217233908.GA24047@dztty>
 <CAL1RGDWM0C26YR+GGbguRQd0R3HoPJ5QVyEFkLGFfPqs6wb5Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1RGDWM0C26YR+GGbguRQd0R3HoPJ5QVyEFkLGFfPqs6wb5Mg@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
To: Roland Dreier <roland@purestorage.com>
Cc: Djalal Harouni <tixxdz@opendz.org>, Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>, linux-kernel@vger.kernel.org, David Windsor <dwindsor@gmail.com>, pageexec@freemail.hu, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 17, 2012 at 05:44:57PM -0800, Roland Dreier wrote:
> On Fri, Feb 17, 2012 at 3:39 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >> 2) what to do with architectures-loosers?
> > There is lib/atomic64.c but with a static hashed array of raw_spinlocks.
> 
> Even leaving aside performance impact of atomic64_t (and probably
> in most cases the performance of kref is not important at all), it is
> unfortunate to bloat the size from 4 bytes to 8 bytes.
> 
> It seems much better to have some out-of-line code for overflow
> checking rather than increasing the size of every data structure
> that embeds a kref.

Please realize that kref is an in-line structure now.

> Greg, I'm not sure why you're opposed to adding this checking...
> it's pretty clear that buggy error paths that forget to do a put are
> pretty common and will continue to be common in new code, and
> making them harder to exploit seems pretty sane to me.
> 
> What's the downside?

The downside is that there has not even been a patch sent for any of
this.  Combine that with a lack of understanding about reference
counting and atomic_t usages in the kernel, and the whole thing is ripe
for misunderstanding and confusion.

greg k-h
