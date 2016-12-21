Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1482298164.8944.8.camel@edumazet-glaptop3.roam.corp.google.com>
From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 20 Dec 2016 21:29:24 -0800
In-Reply-To: <20161221032829.3031.qmail@ns.sciencehorizons.net>
References: <20161221032829.3031.qmail@ns.sciencehorizons.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: HalfSipHash Acceptable Usage
To: George Spelvin <linux@sciencehorizons.net>
Cc: tytso@mit.edu, ak@linux.intel.com, davem@davemloft.net, David.Laight@aculab.com, djb@cr.yp.to, ebiggers3@gmail.com, hannes@stressinduktion.org, Jason@zx2c4.com, jeanphilippe.aumasson@gmail.com, kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, luto@amacapital.net, netdev@vger.kernel.org, tom@herbertland.com, torvalds@linux-foundation.org, vegard.nossum@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2016-12-20 at 22:28 -0500, George Spelvin wrote:
> > I do not see why SipHash, if faster than MD5 and more secure, would be a
> > problem.
> 
> Because on 32-bit x86, it's slower.
> 
> Cycles per byte on 1024 bytes of data:
> 			Pentium	Core 2	Ivy
> 			4	Duo	Bridge
> SipHash-2-4		38.9	 8.3	 5.8
> HalfSipHash-2-4		12.7	 4.5	 3.2
> MD5			 8.3	 5.7	 4.7

So definitely not faster.

38 cycles per byte is a problem, considering IPV6 is ramping up.

But TCP session establishment on P4 is probably not a big deal.
Nobody would expect a P4 to handle gazillions of TCP flows (using a
32bit kernel)

What about SHA performance (syncookies) on P4 ?

Synfloods are probably the only case we might take care of for 2000-era
cpus.
