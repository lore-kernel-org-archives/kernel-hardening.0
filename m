Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20170610025912.6499-6-Jason@zx2c4.com>
Date: Sat, 10 Jun 2017 15:49:28 +0200
Content-Transfer-Encoding: 7bit
Message-Id: <85B759DF-F6A8-46C3-89E6-C8AFDEA1E907@holtmann.org>
References: <20170610025912.6499-1-Jason@zx2c4.com>
 <20170610025912.6499-6-Jason@zx2c4.com>
Subject: [kernel-hardening] Re: [PATCH 5/6] bluetooth/smp: use constant time memory comparison
 for secret values
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, "Gustavo F. Padovan" <gustavo@padovan.org>, Johan Hedberg <johan.hedberg@gmail.com>, linux-bluetooth@vger.kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Jason,

> This file is filled with complex cryptography. Thus, the comparisons of
> MACs and secret keys and curve points and so forth should not add timing
> attacks, which could either result in a direct forgery, or, given the
> complexity, some other type of attack.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Gustavo Padovan <gustavo@padovan.org>
> Cc: Johan Hedberg <johan.hedberg@gmail.com>
> Cc: linux-bluetooth@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
> net/bluetooth/smp.c | 39 ++++++++++++++++++++-------------------
> 1 file changed, 20 insertions(+), 19 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel
