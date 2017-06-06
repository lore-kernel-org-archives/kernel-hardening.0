From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170606005108.5646-6-Jason@zx2c4.com>
References: <20170606005108.5646-6-Jason@zx2c4.com> <20170606005108.5646-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <26641.1496743729.1@warthog.procyon.org.uk>
Date: Tue, 06 Jun 2017 11:08:49 +0100
Message-ID: <26642.1496743729@warthog.procyon.org.uk>
Subject: [kernel-hardening] Re: [PATCH v3 05/13] security/keys: ensure RNG is seeded before use
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: dhowells@redhat.com, Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Mimi Zohar <zohar@linux.vnet.ibm.com>, David Safford <safford@us.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> +		key->serial = get_random_u32() >> 1;

If this may sleep, it must be interruptible.

David
