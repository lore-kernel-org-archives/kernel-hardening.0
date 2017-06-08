MIME-Version: 1.0
In-Reply-To: <7B079482-B436-4FE7-A752-9518606F15AB@holtmann.org>
References: <20170606174804.31124-1-Jason@zx2c4.com> <20170606174804.31124-13-Jason@zx2c4.com>
 <20170608030631.ywmldxzehtumeqd3@thunk.org> <7B079482-B436-4FE7-A752-9518606F15AB@holtmann.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 8 Jun 2017 14:03:28 +0200
Message-ID: <CAHmME9oOPyw_GFGQykt+quxeHV3jNMUx1P+Us1NhNrMPvKUrNg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v4 12/13] bluetooth/smp: ensure RNG is properly seeded
 before ECDH use
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, "Gustavo F. Padovan" <gustavo@padovan.org>, Johan Hedberg <johan.hedberg@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 8, 2017 at 7:04 AM, Marcel Holtmann <marcel@holtmann.org> wrote:
>> Do we need to do all of this?  Bluetooth folks, is it fair to assume
>> that hci_power_on() has to be called before any bluetooth functions
>> can be done?  If so, adding a wait_for_random_bytes() in
>> hci_power_on() might be all that is necessary.

Maybe, but that could hassle bluetooth users who don't want to use any
of the fancy bluetooth crypto and don't want to bother waiting for
their RNG to initialize.
