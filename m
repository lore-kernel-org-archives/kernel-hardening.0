Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20170608030631.ywmldxzehtumeqd3@thunk.org>
Date: Thu, 8 Jun 2017 07:04:12 +0200
Content-Transfer-Encoding: quoted-printable
Message-Id: <7B079482-B436-4FE7-A752-9518606F15AB@holtmann.org>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-13-Jason@zx2c4.com>
 <20170608030631.ywmldxzehtumeqd3@thunk.org>
Subject: [kernel-hardening] Re: [PATCH v4 12/13] bluetooth/smp: ensure RNG is properly seeded
 before ECDH use
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, "Gustavo F. Padovan" <gustavo@padovan.org>, Johan Hedberg <johan.hedberg@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Ted,

>> This protocol uses lots of complex cryptography that relies on =
securely
>> generated random numbers. Thus, it's important that the RNG is =
actually
>> seeded before use. Fortuantely, it appears we're always operating in
>> process context (there are many GFP_KERNEL allocations and other
>> sleeping operations), and so we can simply demand that the RNG is =
seeded
>> before we use it.
>>=20
>> We take two strategies in this commit. The first is for the library =
code
>> that's called from other modules like hci or mgmt: here we just =
change
>> the call to get_random_bytes_wait, and return the result of the wait =
to
>> the caller, along with the other error codes of those functions like
>> usual. Then there's the SMP protocol handler itself, which makes many
>> many many calls to get_random_bytes during different phases. For =
this,
>> rather than have to change all the calls to get_random_bytes_wait and
>> propagate the error result, it's actually enough to just put a single
>> call to wait_for_random_bytes() at the beginning of the handler, to
>> ensure that all the subsequent invocations are safe, without having =
to
>> actually change them. Likewise, for the random address changing
>> function, we'd rather know early on in the function whether the RNG
>> initialization has been interrupted, rather than later, so we call
>> wait_for_random_bytes() at the top, so that later on the call to
>> get_random_bytes() is acceptable.
>=20
> Do we need to do all of this?  Bluetooth folks, is it fair to assume
> that hci_power_on() has to be called before any bluetooth functions
> can be done?  If so, adding a wait_for_random_bytes() in
> hci_power_on() might be all that is necessary.

yes, there are plenty of commands needed before a controller becomes =
usable. When plugging in new Bluetooth hardware, we have to power it up =
and read the initial settings and configuration out of.

Also all the cryptographic features only apply to LE enabled =
controllers. The classic BR/EDR controllers have this all in hardware. =
So if you are not LE enabled, then there is not even a point in waiting =
for any seeding. However that said, also all LE controllers have an =
extra random number function we could call if we need extra seeding. We =
never bothered to hook this up since we thought that the kernel has =
enough sources.

Regards

Marcel
