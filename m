From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170920145839.27511-2-Jason@zx2c4.com>
References: <20170920145839.27511-2-Jason@zx2c4.com> <20170920145839.27511-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32199.1506350639.1@warthog.procyon.org.uk>
Date: Mon, 25 Sep 2017 15:43:59 +0100
Message-ID: <32200.1506350639@warthog.procyon.org.uk>
Subject: [kernel-hardening] Re: [PATCH v7 2/2] security/keys: rewrite all of big_key crypto
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, ebiggers3@gmail.com, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, security@kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> +	/* no ->update(); don't add it without changing big_key_crypt() nonce */

Should update be a problem.  It's should be a complete payload replacement -
kind of like unlink and add, but keeping the same key ID and description.

David
