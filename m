Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFyBsU_sxUuuNBMFUQonWOtfoW9AMk=vn=KLTKrkXVv+MA@mail.gmail.com>
References: <CAHmME9qk+Z8CdhTFQnTkwT8S-n56tzi77-uAV3dNigcGMQx7uQ@mail.gmail.com>
 <CA+55aFyBsU_sxUuuNBMFUQonWOtfoW9AMk=vn=KLTKrkXVv+MA@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 14 Dec 2016 00:36:22 +0100
Message-ID: <CAHmME9rZAS_77=DsD2LRM=77PWua8B_ZPNxQSvr-2dAZht3faA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3] siphash: add cryptographically secure hashtable function
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <ak@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, George Spelvin <linux@horizon.com>, Scott Bauer <sbauer@eng.utah.edu>, Andy Lutomirski <luto@amacapital.net>, Greg KH <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers3@gmail.com>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, "Daniel J . Bernstein" <djb@cr.yp.to>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Linus,

On Tue, Dec 13, 2016 at 8:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Yeah,. the TCP sequence number md5_transform() cases are likely the
> best example of something where siphash might be good. That tends to
> be really just a couple words of data (the address and port info) plus
> the net_secret[] hash. I think they currently simply just fill in the
> fixed-sized 64-byte md5-round area.
>
> I wonder it's worth it to have a special spihash version that does
> that same "fixed 64-byte area" thing.

What happens in MD5 the hash function is that it first initializes its
initial 128-bit hash to a magic constant, and then reads 64 bytes at a
time from the input and calls md5_transform on that, which each time
manipulates that 128-bit value from its starting value. At the end of
the input, some special padding is applied for small final blocks,
some finalization, and then the resultant hash is whatever that
128-bit value is at the end of the process.

What the tcp stack does with secure_tcp_sequence_number function in
net/core/secure_seq.c, and a variety of other places, is to just
supply that 128-bit initial value not with the magic constant, but
instead with saddr||daddr||sport||dport||net_secret[15] and then calls
md5_transform on the 64-byte long term secret random value
(net_secret). From the resultant 128-bit value, they take the first
32-bits. In addition to being rather heavy weight, this strikes me as
cryptographically a bit dubious too. But that's where your "fixed
64-byte area" notion comes from.

Siphash makes things a lot more simple than that. Since siphash is a
PRF and not a mere hash function, it takes an explicit secret key
parameter, which would be net_secret, some input data, which would be
saddr||daddr||sport||dport, and then spits out a 64-bit number, 32
bits of which would be used as the sequence number.

seq_num = seq_scale(siphash24(saddr||daddr||sport||dport, net_secret));

A lot simpler, faster, and actually secure.


> But please talk to the netwotrking people. Maybe that's the proper way
> to get this merged?

I had hoped to do it the lazy way, and just have it just wind up in
lib/. But I suppose you and Greg are of course right, and I should
submit this with a real usage. So I'll do that, and resubmit in
another thread as a series to LKML and netdev.

Thanks for your feedback!

Jason
