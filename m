MIME-Version: 1.0
In-Reply-To: <2681038.03lnYPhpsa@tauon.chronox.de>
References: <20170916130034.17706-1-Jason@zx2c4.com> <2681038.03lnYPhpsa@tauon.chronox.de>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 18 Sep 2017 13:24:18 +0200
Message-ID: <CAHmME9p6uq0ELtgxB94bc4bUppa7UogWSEgj_9o8p2xXQfrz5A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v4] security/keys: rewrite all of big_key crypto
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Eric Biggers <ebiggers3@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ilhan Gurel <ilhan.gurel@gmail.com>, security@kernel.org, stable@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>

Hello Stephan,

I realize you have your Linux RNG project, which is a very worthwhile
goal that I support you in. I hope you're eventually successful, and I
apologize for not being more available in the last 2.5 months to chime
in on that patchset thread you posted.

However, your message to this thread here is a completely
inappropriate and nonsensical hijacking, which makes me entirely
question your overall judgement.

(David -- please don't let such hijacking derail or delay these
critical vulnerability fixes from landing.)

> This change is a challenge. The use of the kernel crypto API's DRNG has been
> made to allow FIPS 140-2 compliance. Otherwise, the entire key generation
> logic will not be using the right(TM) DRNG. Thus, I would not suggest to
> replace that for a stable tree.

Complete and utter nonsense. This patch has a history (this is already
v6), and it's pretty obvious from prior discussion and conclusion that
the only reason "crypto/rng" was used for this is because the original
author just had no idea what he was doing (thus leading to using ECB
as well). Besides, from what RNG do you think the seed for that was
generated?

> Note, I am currently working on a pluggable DRNG apporach for /dev/random and
> /dev/urandom to be able to get rid of the use of the kernel crypto API's DRNG
> API. It is ready and I will air that solution shortly.

Good to hear you're still working on that project.

> Yet, it needs work to
> be integrated upstream (and approval from Ted Tso).

Good luck with getting approval... While Ted and I have our
differences like any two kernel developers, I really tend agree with
him in his attitude about this FIPS silliness. It's unlikely you're
going to be able to shovel this stuff into random.c, and I think doing
so will undermine your entire LRNG effort.

> An SP800-90A-compliant DRNG must be used in those circumstances.

Again, complete and utter unsubstantiated nonsense.

> Then I would recommend to leave it as is or hear complaints from other users.

What a poor lack of judgement.

I get it -- this FIPS compliance backwardness is something you're keen
about. But don't start hijacking every thread that involves randomness
with a demand to replace calls to get_random_bytes with wrappers in
outdated, flawed, government compliance crypto API key expanders. From
a cryptographic point of view it's a ridiculous demand. And from an
engineering point of view, it's a ridiculous demand too, for if
get_random_bytes already returned FIPS-compliant randomness, you
wouldn't be writing this email here.

Instead, if you want your FIPS garbage in the Linux RNG, take your
battle for that over to random.c. I'll oppose you to the end on it,
but at the very least it will the the appropriate venue for that
discussion. In the meantime, stop hijacking this thread.

Thanks,
Jason

PS: apologies for what's probably perceived as an unfriendly and
overly hostile tone of this email. It's not my intention to alienate
you, but I do feel necessary in these circumstances to write as
directly as possible.
