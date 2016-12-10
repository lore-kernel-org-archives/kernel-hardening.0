Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161210053711.GB27951@gondor.apana.org.au>
References: <20161209230851.GB64048@google.com> <CALCETrW=+3u3P8Xva+0ck9=fr-mD6azPtTkOQ3uQO+GoOA6FcQ@mail.gmail.com>
 <20161210053711.GB27951@gondor.apana.org.au>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat, 10 Dec 2016 15:45:56 +0100
Message-ID: <CAHmME9pzT=bxuEVVGDOJkm2PaEAVjbo=8na7URy=g-1sKvv0yw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: Remaining crypto API regressions with CONFIG_VMAP_STACK
To: kernel-hardening@lists.openwall.com
Cc: Andy Lutomirski <luto@amacapital.net>, Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Lutomirski <luto@kernel.org>, Stephan Mueller <smueller@chronox.de>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Herbert,

On Sat, Dec 10, 2016 at 6:37 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> As for AEAD we never had a sync interface to begin with and I
> don't think I'm going to add one.

That's too bad to hear. I hope you'll reconsider. Modern cryptographic
design is heading more and more in the direction of using AEADs for
interesting things, and having a sync interface would be a lot easier
for implementing these protocols. In the same way many protocols need
a hash of some data, now protocols often want some particular data
encrypted with an AEAD using a particular key and nonce and AD. One
protocol that comes to mind is Noise [1].

I know that in my own [currently external to the tree] kernel code, I
just forego the use of the crypto API all together, and one of the
primary reasons for that is lack of a sync interface for AEADs. When I
eventually send this upstream, presumably everyone will want me to use
the crypto API, and having a sync AEAD interface would be personally
helpful for that. I guess I could always write the sync interface
myself, but I imagine you'd prefer having the design control etc.

Jason


[1] http://noiseprotocol.org/
