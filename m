Date: Sat, 10 Jun 2017 18:43:20 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Message-ID: <20170610214319.GA20743@khazad-dum.debian.net>
References: <20170610025912.6499-1-Jason@zx2c4.com>
 <20170610025912.6499-4-Jason@zx2c4.com>
 <CAOtvUMf-85pqz81c9BGHL8zWj+NrSz6wa4XypB8KKtgJDHzBvQ@mail.gmail.com>
 <CAHmME9qc30mB3vcqO1Zv8PA5w6bO4UuWfqeh-uPn986JUjGf7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9qc30mB3vcqO1Zv8PA5w6bO4UuWfqeh-uPn986JUjGf7Q@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 3/6] ccree: use constant time memory comparison for macs
 and tags
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, Linux kernel mailing list <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, 10 Jun 2017, Jason A. Donenfeld wrote:
> That's fine. As I mentioned, I really have no clue what this code's
> trying to do. If this is just part of some test that doesn't deal with
> actual messages that could be forged, then of course there's nothing
> that needs to be done and this can be NAKd.

Well, it is *testing* things, so you might want to use whatever the
module(s) will actually use.  Maybe test with both?

-- 
  Henrique Holschuh
