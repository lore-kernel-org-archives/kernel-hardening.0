MIME-Version: 1.0
From: Sandy Harris <sandyinchina@gmail.com>
Date: Wed, 6 Sep 2017 14:37:51 -0400
Message-ID: <CACXcFm=9WzW4H+7u6M6QTF=LzYUx+GKMVndvPj+z2QhzJote3w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] ME and PSP
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Recently a few things have been revealed about how to disable the
Intel Management Engine (ME).

http://blog.ptsecurity.com/2017/08/disabling-intel-me.html
https://www.theregister.co.uk/2017/08/29/intel_management_engine_can_be_disabled/

I have not seen anything on disabling the similar AMD feature called
PSP. Either appears to be a huge security hazard -- a device you have
little choice but to trust but that you have little control over, that
operates below the level of the main CPU & OS, that has access to
everything & that is Turing complete so it can do anything.

By the time a hardened kernel loads, it may be too late to prevent ME
entirely, but are there other things the kernel could do? Issue a
syslog warning? Monitor ME activity somehow? Restrict its access to
the network so at least external attacks are blocked?

There are several different utilities to reduce ME danger, though I
have not looked at details & I have the impression most do not disable
it completely. Will current hardened kernels run on a system with ME
disabled? Is that tested?

The best summary of the issue I have seen -- though it is neither
up-to-date nor devoted to only the one issue is:
https://blog.invisiblethings.org/papers/2015/x86_harmful.pdf

There has been discussion on the Qubes users list:
https://groups.google.com/forum/#!forum/qubes-users

The only plausible solutions suggested there boil down to not using
recent x86 chips at all. Either use older Intel/AMD parts without the
feature or go to IBM Power CPUs.

No-one has mentioned ARM in that discussion & I am not sure where they
would fit in.
