MIME-Version: 1.0
In-Reply-To: <32200.1506350639@warthog.procyon.org.uk>
References: <20170920145839.27511-1-Jason@zx2c4.com> <20170920145839.27511-2-Jason@zx2c4.com>
 <32200.1506350639@warthog.procyon.org.uk>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 25 Sep 2017 18:38:13 +0200
Message-ID: <CAHmME9qUnYHYvgExmscQ91D-hsQApSk6FzmBG0cSUraLbQNYRQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v7 2/2] security/keys: rewrite all of big_key crypto
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Eric Biggers <ebiggers3@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, security@kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 25, 2017 at 4:43 PM, David Howells <dhowells@redhat.com> wrote:
> Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
>> +     /* no ->update(); don't add it without changing big_key_crypt() nonce */
>
> Should update be a problem.  It's should be a complete payload replacement -
> kind of like unlink and add, but keeping the same key ID and description.

Not sure I parsed your message correctly, but that comment there was a
suggestion from Eric several months ago when I first posted it. The
idea is that the key shouldn't be reused with the same nonce, so in
case somebody ambitious comes along and tries to add an .update
function, they'll be reminded to take this into account. Alternatively
they might choose to just generate a new key, which is fine too.
Either way, it's a useful warning to have in place.
