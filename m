MIME-Version: 1.0
In-Reply-To: <707C1A6E-D79A-45BC-A868-A78289A327EC@holtmann.org>
References: <20170606174804.31124-1-Jason@zx2c4.com> <20170606174804.31124-13-Jason@zx2c4.com>
 <20170608030631.ywmldxzehtumeqd3@thunk.org> <7B079482-B436-4FE7-A752-9518606F15AB@holtmann.org>
 <CAHmME9rEcAZop80q47n1h3PP9hx5-X6R0w-SD2nDxZZLsJOQYw@mail.gmail.com> <707C1A6E-D79A-45BC-A868-A78289A327EC@holtmann.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 8 Jun 2017 19:34:01 +0200
Message-ID: <CAHmME9oKYuOR-5cWF94yv41hfXArWUWyGM3wRtY8NyQPY=5J=w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v4 12/13] bluetooth/smp: ensure RNG is properly seeded
 before ECDH use
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, "Gustavo F. Padovan" <gustavo@padovan.org>, Johan Hedberg <johan.hedberg@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 8, 2017 at 7:05 PM, Marcel Holtmann <marcel@holtmann.org> wrote=
:
> on a powered down controller, you can not do any crypto. SMP is only duri=
ng a connection and the RPAs are only generated when needed. So yes, doing =
this once in hci_power_on is plenty. However we might want to limit this to=
 LE capable controllers since for BR/EDR only controllers this is not neede=
d. For A2MP I need to check that we need the random numbers seeded there. H=
owever this hidden behind the high speed feature.

Okay so it sounds like certain controllers will use this and certain
won't, and so it might be slightly complicated to follow the mouse
through the tube ideally. In that case, I'd recommend continuing with
this current patchset, which just adds the wait (which is a no-op if
it's already seeded) close to the actual call sites.

Can you review that patch and give your Signed-off-by if it looks good?

Jason
