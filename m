From: David Howells <dhowells@redhat.com>
In-Reply-To: <20171002170111.GA6713@gmail.com>
References: <20171002170111.GA6713@gmail.com> <CAMuHMdWd3ttH7Zdpo=bodkOBw2xiyeX_R9MhPf=Bcf0-QLhOiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22432.1507021470.1@warthog.procyon.org.uk>
Date: Tue, 03 Oct 2017 10:04:30 +0100
Message-ID: <22433.1507021470@warthog.procyon.org.uk>
Subject: [kernel-hardening] Re: Modular BIG_KEYS (was: Re: [PATCH v4] security/keys: rewrite all of big_key crypto)
To: Eric Biggers <ebiggers3@gmail.com>
Cc: dhowells@redhat.com, Geert Uytterhoeven <geert@linux-m68k.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ilhan Gurel <ilhan.gurel@gmail.com>, security@kernel.org, stable <stable@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Eric Biggers <ebiggers3@gmail.com> wrote:

> (I also still need to convince myself that there aren't any race conditions
> in key type unregistering.  It's a little weird how it changes the key type
> to the ".dead" key type, rather than pinning the key type in memory while
> it's still used.)

Keys are converted to the dead type and their destructors called by the gc
whilst it holds a write lock on the key's semaphore, so keyctl() calls
shouldn't be a problem as they all hold a read-lock or a write-lock on the
content.

/proc/keys does things under the key_serial_lock and RCU, so if a key type's
->describe() function looks at the payload, then it should use RCU conditions.
Note that this doesn't affect the keyring_describe() as that only looks at a
value that is stored in the key struct - and the same for user_describe() and
big_key_describe().  asymmetric_key_describe(), OTOH...  Maybe the simplest
thing to do is to take key_serial_lock in key_garbage_collector() around the
code that changes the key type.

Inside the kernel, things are murkier as the kernel can reach inside a key
without taking the semaphore.  If it does so, it must use RCU or some other
mechanism to prevent the key payload from being destroyed under it.

With AF_RXRPC, I think I'm doing this wrong.  I think I need to move the
destruction of the key type to after I've unregistered the network namespace
handling as the latter destroys connections which might be using the key.

David
