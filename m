Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 18 Sep 2011 22:12:39 -0700
From: Kees Cook <kees@ubuntu.com>
Message-ID: <20110919051239.GY6573@outflux.net>
References: <CAEXv5_itbaNAjUNeDS9uW45YDrbG6zzUAi7Ei-n85ZgSQQLJ6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXv5_itbaNAjUNeDS9uW45YDrbG6zzUAi7Ei-n85ZgSQQLJ6Q@mail.gmail.com>
Subject: [kernel-hardening] Re: Sysctl for set_kernel_text_r[wo]
To: David Windsor <dwindsor@gmail.com>
Cc: ubuntu-hardened@lists.ubuntu.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi David,

On Sun, Sep 18, 2011 at 09:42:59PM -0400, David Windsor wrote:
> I am looking into adding a sysctl that enables toggling of
> set_kernel_text_rw, set_kernel_text_ro.  It appears that the only
> caller of these methods is ftrace, which can rather easily be disabled
> when these methods are unavailable.

It would be really nice to be able to wipe these functions out. I really
dislike that they are available as such perfect ROP targets.

> I'm afraid I'm overlooking something major here.  It seems that such a
> control would have been added much earlier if it was actually as
> simple as adding a guard variable, mutable via a sysctl, allowing
> access to this interface.

I haven't spent too much time looking into it, but I was under the
impression that the module loader used some of the underlying functions
too. Have you checked those code paths?

-Kees

-- 
Kees Cook
