Reply-To: kernel-hardening@lists.openwall.com
Date: 21 Dec 2016 13:07:22 -0500
Message-ID: <20161221180722.564.qmail@ns.sciencehorizons.net>
From: "George Spelvin" <linux@sciencehorizons.net>
In-Reply-To: <CA+55aFy8fNOxw3bnwkX1S46jKnW6i26mueaiuOsScyN3kFJp+A@mail.gmail.com>
Subject: [kernel-hardening] Re: HalfSipHash Acceptable Usage
To: linux@sciencehorizons.net, torvalds@linux-foundation.org
Cc: ak@linux.intel.com, davem@davemloft.net, David.Laight@aculab.com, djb@cr.yp.to, ebiggers3@gmail.com, eric.dumazet@gmail.com, hannes@stressinduktion.org, Jason@zx2c4.com, jeanphilippe.aumasson@gmail.com, kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, luto@amacapital.net, netdev@vger.kernel.org, tom@herbertland.com, tytso@mit.edu, vegard.nossum@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

Linus wrote:
>> How much does kernel_fpu_begin()/kernel_fpu_end() cost?
>
> It's now better than it used to be, but it's absolutely disastrous
> still. We're talking easily many hundreds of cycles. Under some loads,
> thousands.

I think I've been thoroughly dissuaded, but just to clarify one thing
that resembles a misunderstanding:

> In contrast, in reality, especially with things like "do it once or
> twice per incoming packet", you'll easily hit the absolute worst
> cases, where not only does it take a few hundred cycles to save the FP
> state, you'll then return to user space in between packets, which
> triggers the slow-path return code and reloads the FP state, which is
> another few hundred cycles plus.

Everything being discussed is per-TCP-connection overhead, *not* per
packet.  (Twice for outgoing connections, because one is to generate
the ephemeral port number.)

I know you know this, but I don't want anyone spectating to be confused
about it.
