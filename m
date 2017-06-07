From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170607042219.GC594@zzz>
References: <20170607042219.GC594@zzz> <20170606215129.26388-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29550.1496820669.1@warthog.procyon.org.uk>
Date: Wed, 07 Jun 2017 08:31:09 +0100
Message-ID: <29551.1496820669@warthog.procyon.org.uk>
Subject: [kernel-hardening] Re: [PATCH v2] security/keys: rewrite all of big_key crypto
To: Eric Biggers <ebiggers3@gmail.com>
Cc: dhowells@redhat.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Eric Biggers <ebiggers3@gmail.com> wrote:

> but I skipped the big_key type because it was one of the more obscure key
> types (and frankly I have no idea what, if anything, actually uses it)

Kerberos can use it.

David
