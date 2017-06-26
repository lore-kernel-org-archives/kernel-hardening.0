Message-ID: <1498440189.26123.85.camel@haakon3.risingtidesystems.com>
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Sun, 25 Jun 2017 18:23:09 -0700
In-Reply-To: <2639082.PtrrGWOPPL@positron.chronox.de>
References: <20170606174804.31124-1-Jason@zx2c4.com>
	 <CAHmME9rU_H6Jq7ArjDq1yByrYf1P7nyC4Y8tqkzG585U39MFLg@mail.gmail.com>
	 <02d60ed4-4207-dd7d-8826-0f9f7f4e966d@suse.com>
	 <2639082.PtrrGWOPPL@positron.chronox.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] Re: [PATCH v4 06/13] iscsi: ensure RNG is
 seeded before use
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc: Lee Duncan <lduncan@suse.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, Chris Leech <cleech@redhat.com>, open-iscsi@googlegroups.com, target-devel <target-devel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Stephan, Lee & Jason,

(Adding target-devel CC')

Apologies for coming late to the discussion.  Comments below.

On Sun, 2017-06-18 at 10:04 +0200, Stephan Müller wrote:
> Am Samstag, 17. Juni 2017, 05:45:57 CEST schrieb Lee Duncan:
> 
> Hi Lee,
> 
> > In your testing, how long might a process have to wait? Are we talking
> > seconds? Longer? What about timeouts?
> >
> 
> In current kernels (starting with 4.8) this timeout should clear within a few 
> seconds after boot.
> 
> In older kernels (pre 4.8), my KVM takes up to 90 seconds to reach that 
> seeding point. I have heard that on IBM System Z this trigger point requires 
> minutes to be reached.
> 

I share the same concern as Lee wrt to introducing latency into the
existing iscsi-target login sequence.

Namely in the use-cases where a single node is supporting ~1K unique
iscsi-target IQNs, and fail-over + re-balancing of IQNs where 100s of
login attempts are expected to occur in parallel.

If environments exist that require non trivial amounts of time for RNG
seeding to be ready for iscsi-target usage, then enforcing this
requirement at iscsi login time can open up problems, especially when
iscsi host environments may be sensitive to login timeouts, I/O
timeouts, et al.

That said, I'd prefer to simply wait for RNG to be seeded at modprobe
iscsi_target_mod time, instead of trying to enforce randomness during
login.

This way, those of use who have distributed storage platforms can know
to avoid putting a node into a state to accept iscsi-target IQN export
migration, before modprobe iscsi_target_mod has successfully loaded and
RNG seeding has been confirmed.

WDYT..?
