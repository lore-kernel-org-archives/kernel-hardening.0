MIME-Version: 1.0
In-Reply-To: <20170606074552.GA10432@kroah.com>
References: <20170605034757.4803-1-Jason@zx2c4.com> <CAHmME9oXmZD2X8hSicVgAZRbaoBNUwRK-16Ekz2JAkNcZE+_dg@mail.gmail.com>
 <20170606074552.GA10432@kroah.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 6 Jun 2017 14:24:33 +0200
Message-ID: <CAHmME9rAH5Qj5naSOWEMSaaR7YrP03UnYzeoQJA-0QF9jnPaRg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH RFC v2 0/8] get_random_bytes_wait family of APIs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 6, 2017 at 9:45 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> If it's needed no matter what, can you make it the first patch in the
> series?  And does it need to go to any older kernels as well?

I believe it does belong in older kernels too. I'll work out precisely
which one those are and note it in the commit, which I'll order as the
first in the series and Cc to stable@. This is, of course, pending
Ted's review.
