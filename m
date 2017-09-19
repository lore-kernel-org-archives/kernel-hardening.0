From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170917115217.15805-1-Jason@zx2c4.com>
References: <20170917115217.15805-1-Jason@zx2c4.com> <CAHmME9rjrz2Pn39ay3myApBeBtQAPNt0C+NvmFoV28NeT4_zLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27443.1505835505.1@warthog.procyon.org.uk>
Date: Tue, 19 Sep 2017 16:38:25 +0100
Message-ID: <27444.1505835505@warthog.procyon.org.uk>
Subject: [kernel-hardening] Re: [PATCH v6] security/keys: rewrite all of big_key crypto
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, ebiggers3@gmail.com, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, security@kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> And, some error paths forgot to zero out sensitive
> material, so this patch changes a kfree into a kzfree.

Can you split that out into a separate preparatory patch?

Also, I recommend limiting the lines in your patch description to 75 chars
lest you get people who run checkpatch on everything pestering you ;-)

David
