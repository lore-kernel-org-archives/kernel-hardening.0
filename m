MIME-Version: 1.0
In-Reply-To: <20170608003116.zgznzb37ms7wj4vl@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com> <20170606174804.31124-5-Jason@zx2c4.com>
 <20170608003116.zgznzb37ms7wj4vl@thunk.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 8 Jun 2017 02:50:09 +0200
Message-ID: <CAHmME9qbt70Oc0h_zfGqdrfTbrVsY4aUM-oUjpWHsU7PO7DZww@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v4 04/13] security/keys: ensure RNG is seeded before use
To: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, David Safford <safford@us.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 8, 2017 at 2:31 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> I'm guessing you changed key_alloc_serial() to return an int back when
> you were thinking that you might use get_random_bytes_wait(), which
> could return -ERESTARTSYS.
>
> Now that you're not doing this, but using get_random_u32() instead,
> there's no point to change the function signature of
> key_alloc_serial() and add an error check in key_alloc() that will
> never fail, right?  That's just adding a dead code path.  Which the
> compiler can probably optimize away, but why make the code slightly
> harder to read than necessasry?

Good catch, and thanks for reading these so thoroughly that you caught
the churn artifacts. Do you want me to clean this up and resubmit, or
are you planning on adjusting it in the dev branch?
