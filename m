Date: Tue, 6 Jun 2017 09:45:52 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20170606074552.GA10432@kroah.com>
References: <20170605034757.4803-1-Jason@zx2c4.com>
 <CAHmME9oXmZD2X8hSicVgAZRbaoBNUwRK-16Ekz2JAkNcZE+_dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9oXmZD2X8hSicVgAZRbaoBNUwRK-16Ekz2JAkNcZE+_dg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH RFC v2 0/8] get_random_bytes_wait family of APIs
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 01:47:25AM +0200, Jason A. Donenfeld wrote:
> As this RFC series matures, all the changes are in this branch here, to look at:
> 
> https://git.zx2c4.com/linux-dev/log/?h=jd/rng-blocker
> 
> Ted -- there's one, in particular, that should probably be picked up
> regardless of the rest, and that's "random: invalidate batched entropy
> after crng init". Hopefully though, we can develop that in relation
> with the rest and make this a proper series.

If it's needed no matter what, can you make it the first patch in the
series?  And does it need to go to any older kernels as well?

thanks,

greg k-h
