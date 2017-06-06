MIME-Version: 1.0
In-Reply-To: <20170606205851.GA65728@gmail.com>
References: <20170606173900.29279-1-Jason@zx2c4.com> <20170606205851.GA65728@gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 6 Jun 2017 23:31:31 +0200
Message-ID: <CAHmME9p1VDaLL_0VRQU1Q3fxFtwvFNgfFQPOOGOuRyW8kY=41A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] security/keys: rewrite all of big_key crypto
To: Eric Biggers <ebiggers3@gmail.com>
Cc: keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, security@kernel.org, stable@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 6, 2017 at 10:58 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> No need to select CRYPTO_AEAD; it's already selected by CRYPTO_GCM.

Ack.

>
> Actually I just noticed another bug, which I suppose you might as well fix too.
> Because different big_keys may be added or read concurrently, and each is
> encrypted using a different encryption key, it's not safe to use a global
> 'crypto_aead'.  Instead, a separate crypto_aead must be created for each key, or
> for each encryption/decryption, or else a mutex needs to be held during each
> rekeying and encryption/decryption.  For what it's worth, I recently fixed a
> similar bug for the "encrypted" key type:
> https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/commit/?h=keys-fixes&id=69307a05d4d58f4c29aa7e9d83dc59d63e28c382

I noticed that too, but I cynically supposed the flaw in the old code
could carry over to the new code without too much difficulty... But
sure, I'll fix this.

This is a real flaw with the crypto API, IMHO. It seems like the key
should be part of the request rather than the tfm. I understand some
primitives can do per-key precomputations, but still, this is a real
wart.

Will be fixed in the next revision.

>
> memset(req_on_stack, 0, sizeof(req_on_stack));
> memzero_explicit(req_on_stack, sizeof(req_on_stack));

I didn't really want to do sizeof with a VLA, but actually, it looks
like gcc does the right thing, so I'll make that change.

> It isn't "aligned" anymore --- instead, it's leaving room for the authentiation
> tag.  I don't think it even needs to be zeroed, does it?  Can you update the
> code and comments below this?

Ack.

> I think these fixes are going to have to be done separately from the switch to
> get_random_bytes_wait().  Just make it use get_random_bytes() for now, and
> switch it to get_random_bytes_wait() later in a separate patch.

Blah, I really dislike doing that. Can I just roll it into the RNG
patchset, and then it'll go into Ted's tree with DavidH's sign-off?

> Please also add a brief comment that anyone who might try to add an update()
> method will find, e.g.:
>
> struct key_type key_type_big_key = {
> [...]
>         .describe               = big_key_describe,
>         .read                   = big_key_read,
>         /* no ->update() yet; don't add it without changing big_key_crypt() */
> };
>
> Otherwise someone will add one, and the crypto will be broken again.

Great idea, again.

Thanks a bunch for the review!

Jason
