Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 23 Jul 2011 20:22:51 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110723162251.GA11485@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] base address for shared libs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

At least on rhel5/openvz kernels, 32-bit processes get their shared libs
loaded at different kinds of addresses on i686 vs. x86_64 kernels.

Here's an example:

32-bit kernel and userland (OpenVZ container):

$ ldd /bin/ls
        librt.so.1 => /lib/librt.so.1 (0x00a99000)
        libtermcap.so.2 => /lib/libtermcap.so.2 (0x00c1a000)
        libc.so.6 => /lib/libc.so.6 (0x0014d000)
        libpthread.so.0 => /lib/libpthread.so.0 (0x00617000)
        /lib/ld-linux.so.2 (0x0012e000)

64-bit kernel, 32-bit userland (OpenVZ container):

$ ldd /bin/ls
        librt.so.1 => /lib/librt.so.1 (0xb7fcf000)
        libtermcap.so.2 => /lib/libtermcap.so.2 (0xb7fca000)
        libc.so.6 => /lib/libc.so.6 (0xb7eae000)
        libpthread.so.0 => /lib/libpthread.so.0 (0xb7e5b000)
        /lib/ld-linux.so.2 (0xb7fe6000)

Notice how the 32-bit kernel produces addresses that are safer against
attacks via C strings (contain NULs).  This is the approach I used in
-ow patches (using 0x00110000 as the base address, considering vm86
needs for the first 1 MB + 64 KB).  I'd like 64-bit kernels to do the
same when running 32-bit binaries.

Can you please look into this and likely fix it for mainline, as well as
for rhel6/openvz when we're ready to move to those kernels?  A fix for
rhel5/openvz would also be welcome if it's easy to do.

Thanks,

Alexander
