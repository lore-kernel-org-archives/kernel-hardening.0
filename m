From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Date: Tue, 06 Jun 2017 19:57:37 +0200
Message-ID: <4135129.tBEIWBxXuR@tauon.chronox.de>
In-Reply-To: <20170606170319.5eva2yoxxeru5p74@thunk.org>
References: <20170606005108.5646-1-Jason@zx2c4.com> <CAHmME9q0N3KgWU4XMDmzNjd0EF_HWROBquwXMYXxfssx_VoghA@mail.gmail.com> <20170606170319.5eva2yoxxeru5p74@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [kernel-hardening] Re: [PATCH v3 04/13] crypto/rng: ensure that the RNG is ready before using
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Eric Biggers <ebiggers3@gmail.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>
List-ID: <kernel-hardening.lists.openwall.com>

Am Dienstag, 6. Juni 2017, 19:03:19 CEST schrieb Theodore Ts'o:

Hi Theodore,

> On Tue, Jun 06, 2017 at 02:34:43PM +0200, Jason A. Donenfeld wrote:
> > Yes, I agree whole-heartedly.  A lot of people have proposals for
> > fixing the direct idea of entropy gathering, but for whatever reason,
> > Ted hasn't merged stuff. I think Stephan (CCd) rewrote big critical
> > sections of the RNG, called LRNG, and published a big paper for peer
> > review and did a lot of cool engineering, but for some reason this
> > hasn't been integrated. I look forward to movement on this front in
> > the future, if it ever happens. Would be great.
> 
> So it's not clear what you mean by Stephan's work.  It can be
> separated into multiple pieces; one is simply using a mechanism which
> can be directly mapped to NIST's DRBG framework.  I don't believe this
> actually adds any real security per se, but it can make it easier to
> get certification for people who care about getting FIPS
> certification.  Since I've seen a lot of snake oil and massive waste
> of taxpayer and industry dollars by FIPS certification firms, it's not
> a thing I particularly find particularly compelling.
> 
> The second bit is "Jitter Entropy".  The problem I have with that is
> there isn't any convincing explanation about why it can't be predicted
> to some degree of accuracy with someone who understands what's going
> on with Intel's cache architecture.  (And this isn't just me, I've
> talked to people who work at Intel and they are at best skeptical of
> the whole idea.)

My LRNG approach covers many more concerns rather than just using the Jitter 
RNG or using the DRBG. Using the Jitter RNG should just beef up the lacking 
entropy at boot time. Irrespective of what you think of it, it will not 
destroy existing entropy. Using the DRBG should allow crypto offloading and 
provides a small API for other users to plug in their favorite DRNG (like the 
ChaCha20 DRNG).

I think I mentioned several times already which are the core concerns I have. 
But allow me to re-iterate them again as I have not seen any answer so far:

- There is per definition a high correlation between interrupts and HID/block 
device events. The legacy /dev/random by far weights HID/block device noise 
higher in entropy than interrupts and awards interrupts hardly any entropy. 
But let us face it, HID and block devices are just a "derivative" of 
interrupts. Instead of weighting HID/block devices higher than interrupts, we 
should get rid of them when counting entropy and focus on interrupts. 
Interrupts fare very well even in virtualized environments where the legacy /
dev/random hardly collects any entropy. Note, this interrupt behavior in 
virtual environments was the core motivation for developing the LRNG.

- By not having such collision problems and the related low validations of 
entropy from interrupts, a much faster initialization with sufficient entropy 
is possible. This is now visible with the current initialization of the 
ChaCha20 part of the legacy /dev/random. That comes, however, at the cost that 
HID/disk events happening before the ChaCha20 is initialized are affected by 
the aforementioned correlation. Just to say it again, correlation destroys 
entropy.

- The entropy estimate is based on first, second and third derivative of 
Jiffies. As Jiffies hardly contribute any entropy per event, using this number 
for an entropy estimation for an event is just coincidence that the legacy /
dev/random underestimates entropy. And then using such coincidential estimates 
to apply an asymptotic calculation how much the entropy estimator is 
increased, is not really helpful.

- The entropy transport within the legacy /dev/random allows small quantums 
(down to 8 bit minimums) of entropy to be transported. Such approach is a 
concern which can be illustrated with a pathological analogy (I understand 
that this pathological case is not present for the legacy /dev/random, but it 
illustrates the problem with small quantities of entropy). Assume that only 
one bit of entropy is conveyed from input_pool to blocking_pool during each 
read operation by an attacker from /dev/random (and assume that the attacker 
an read that one bit). Now, if 128 bits of entropy are transported with 128 
individual transactions where the attacker can read data from the RNG between 
each transport, the final crypto strength is only 2 * 128 bits and not 2^128 
bits. Thus, transports of entropy should be done in larger quantities (like 
128 bits at least).

- The DRNGs are fully testable by itself. The DRBG is tested using the kernel 
crypto API's testmgr using blessed test vectors. The ChaCha20 DRNG is 
implemented such that it can be extracted in a user space app to study it 
further (such extraction of the ChaCha20 into a standalone DRNG is provided at 
[1]).

I tried to address those issues in the LRNG.

Finally, I am very surprised that I get hardly any answers on patches to 
random.c let alone that any changes to random.c will be applied at all.

Lastly, it is very easy to call an approach (JitterRNG) flawed, but I would 
like to see some back-up of such claim after the analysis that is provided on 
that topic. This analysis refers to the wait states between individual CPU 
components as the root of the noise knowing that the ISA != the hardware CPU 
instruction set and the evidence collected on various different CPUs.

[1] https://github.com/smuellerDD/chacha20_drng

Ciao
Stephan
