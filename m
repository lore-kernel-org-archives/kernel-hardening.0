MIME-Version: 1.0
In-Reply-To: <20170608081919.zbtwdjl32vbvd7jt@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com> <20170606174804.31124-14-Jason@zx2c4.com>
 <20170608081919.zbtwdjl32vbvd7jt@thunk.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 8 Jun 2017 14:01:51 +0200
Message-ID: <CAHmME9rjhdsXiQgJh-qNz9ato3PYL8XHMwHO+GNmZCVpc2YNsw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v4 13/13] random: warn when kernel uses unseeded randomness
To: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 8, 2017 at 10:19 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> At the very least we probably should do a logical "uniq" on the output
> (e.g., if we have complained about the previous callsite, don't whinge
> about it again).

That seems okay to me.
