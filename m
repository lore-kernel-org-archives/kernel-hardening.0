MIME-Version: 1.0
In-Reply-To: <CAOtvUMf-85pqz81c9BGHL8zWj+NrSz6wa4XypB8KKtgJDHzBvQ@mail.gmail.com>
References: <20170610025912.6499-1-Jason@zx2c4.com> <20170610025912.6499-4-Jason@zx2c4.com>
 <CAOtvUMf-85pqz81c9BGHL8zWj+NrSz6wa4XypB8KKtgJDHzBvQ@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat, 10 Jun 2017 12:54:01 +0200
Message-ID: <CAHmME9qc30mB3vcqO1Zv8PA5w6bO4UuWfqeh-uPn986JUjGf7Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 3/6] ccree: use constant time memory comparison for macs
 and tags
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hey Gilad,

That's fine. As I mentioned, I really have no clue what this code's
trying to do. If this is just part of some test that doesn't deal with
actual messages that could be forged, then of course there's nothing
that needs to be done and this can be NAKd.

Jason
