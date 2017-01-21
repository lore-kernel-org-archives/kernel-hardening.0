Date: Sun, 22 Jan 2017 00:41:05 +0100
From: Solar Designer <solar@openwall.com>
Message-ID: <20170121234105.GA22967@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] Disable and lock Silicon Debug feature on modern Intel CPUs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

If anyone is looking for a tiny kernel hardening task, this may be one.

OpenBSD just got this a week ago:

https://freshbsd.org/commit/openbsd/f16aad7b540921691f7841ef8ccbb7e7ca22dfd1

"Disable and lock Silicon Debug feature on modern Intel CPUs

This implements one of the countermeasures against using Direct
Connect Interface (DCI) to debug CPUs via USB3 mentioned in the
"Tapping into the core" talk at the 33c3: identify and disable
the Silicon Debug feature found in Haswell and newer CPUs."

(and I stole the first line of the commit message for this message's
Subject - well, at least I do it with this attribution).

Silicon Debug should probably be disabled and locked by default, but
there should be a kernel parameter to avoid this.

The rationale to do this is to provide a tiny bit of protection against
some physical attacks on booted up and decrypted yet locked laptops,
while also allowing the system owner's intentional use of Silicon Debug.

As far as I can tell, so far Linux only got the CPUID feature bit:

http://lists.openwall.net/linux-kernel/2015/07/19/228

and presumably reporting due to arch/x86/kernel/cpu/mkcapflags.sh.

FreeBSD and NetBSD also seem to have just a check for the bit and
its reporting, also since 2015.

Alexander
