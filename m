Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 14 Dec 2016 19:25:00 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161214192459.GA16972@leverpostej>
References: <20161214185000.GA3930@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161214185000.GA3930@kroah.com>
Subject: Re: [kernel-hardening] [RFC 0/4] make call_usermodehelper a bit more
 "safe"
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Gengjia Chen <chengjia4574@gmail.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>


Hi,

On Wed, Dec 14, 2016 at 10:50:00AM -0800, Greg KH wrote:
> The issue is that if you end up getting write access to kernel memory,
> if you change the string '/sbin/hotplug' to point to
> '/home/hacked/my_binary', then the next uevent that the system makes
> will call this binary instead of the "trusted" one.
> 
> It does this by moving the location of the binary to be in read-only
> memory.  This works for a number of call_usermodehelper strings, as they
> are specified at build or configuration time.  But, some subsystems have
> the option to let userspace change the value at runtime, so those values
> can't live in read-only memory. 

> So, anyone have any better ideas?  Is this approach worth it?  Or should
> we just go down the "whitelist" path?

As a general note, I believe the write-rarely / mostly-ro [1] stuff is
meant to cater for this case, but I haven't heard anything on that front
recently (and there doesn't appear to be anything on the KSPP TODO
page).

If that does cater for this case, and if we're able to implement that
generically, that might be nicer than locking down the set of binaries
at build time.

Chen, are you still looking at implementing write-rarely support?

Thanks,
Mark.

[1] http://www.openwall.com/lists/kernel-hardening/2016/11/16/3
