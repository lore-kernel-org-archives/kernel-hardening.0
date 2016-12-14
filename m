Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 14 Dec 2016 10:50:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20161214185000.GA3930@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [RFC 0/4] make call_usermodehelper a bit more "safe"
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi all,

Here's a proof-of-concept patch series that tries to work to address the
issue of call_usermodehelper being abused to have the kernel call any
userspace binary with full root permissions.

The issue is that if you end up getting write access to kernel memory,
if you change the string '/sbin/hotplug' to point to
'/home/hacked/my_binary', then the next uevent that the system makes
will call this binary instead of the "trusted" one.

It does this by moving the location of the binary to be in read-only
memory.  This works for a number of call_usermodehelper strings, as they
are specified at build or configuration time.  But, some subsystems have
the option to let userspace change the value at runtime, so those values
can't live in read-only memory.  To resolve this I've created a new
configuration option, CONFIG_READONLY_USERMODEHELPER to make those
options not able to be changed.

Yes, this changes existing functionality, but I'm willing to bet that
almost no one ever changes these binary locations, or if they do, they
can set them to the "correct" location at built time.

This all happens in the last patch of the series.  Note, I haven't
caught all places in the kernel that has these options, the messiest
being coredumps, which I haven't addressed yet, and is going to be a
pain.

This last patch is hacky, and I'm not really happy about it, so I'm
posting it here as an RFC to see what others think.

As a contrast, grsec does try to mitigate this same problem, but it does
so by looking at the location of the binary that is about to be run, and
only allowing a small whitelist of directories that are "allowed" to be
used.  That's a much simpler solution, but also feels hacky to me in a
way given that it's a whitelist and encompasses whole system directories
(i.e. /sbin/).  My patchset requires that each caller of
call_usermodehelper be audited, which is a pain, and will be needed to
be watched out for for new users, which also isn't any good.

So, anyone have any better ideas?  Is this approach worth it?  Or should
we just go down the "whitelist" path?

Note, the first 3 patches in this series will be submitted for inclusion
either way, as they are good cleanups, and change no functionality at
all, and resolve this issue automatically for some subsystems with no
downside.

thanks,

greg k-h
