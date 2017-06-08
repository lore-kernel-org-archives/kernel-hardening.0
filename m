Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAHmME9rEcAZop80q47n1h3PP9hx5-X6R0w-SD2nDxZZLsJOQYw@mail.gmail.com>
Date: Thu, 8 Jun 2017 19:05:25 +0200
Content-Transfer-Encoding: quoted-printable
Message-Id: <707C1A6E-D79A-45BC-A868-A78289A327EC@holtmann.org>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-13-Jason@zx2c4.com>
 <20170608030631.ywmldxzehtumeqd3@thunk.org>
 <7B079482-B436-4FE7-A752-9518606F15AB@holtmann.org>
 <CAHmME9rEcAZop80q47n1h3PP9hx5-X6R0w-SD2nDxZZLsJOQYw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v4 12/13] bluetooth/smp: ensure RNG is properly seeded
 before ECDH use
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, "Gustavo F. Padovan" <gustavo@padovan.org>, Johan Hedberg <johan.hedberg@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Jason,

>> yes, there are plenty of commands needed before a controller becomes =
usable.
>=20
> That doesn't clearly address with precision what Ted was wondering.
> Specifically, the inquiry is: can you confirm with certainty whether
> or not all calls to get_random_bytes() in the bluetooth directory are
> *necessarily* going to come after a call to hci_power_on()?

on a powered down controller, you can not do any crypto. SMP is only =
during a connection and the RPAs are only generated when needed. So yes, =
doing this once in hci_power_on is plenty. However we might want to =
limit this to LE capable controllers since for BR/EDR only controllers =
this is not needed. For A2MP I need to check that we need the random =
numbers seeded there. However this hidden behind the high speed feature.

Regards

Marcel
