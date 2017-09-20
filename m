MIME-Version: 1.0
In-Reply-To: <1882458.VgLOd8kIdz@tauon.chronox.de>
References: <CAHmME9rjrz2Pn39ay3myApBeBtQAPNt0C+NvmFoV28NeT4_zLg@mail.gmail.com>
 <2545404.XUVGGHhd0i@tauon.chronox.de> <CAHmME9pLF7cdm3RuOa-k8knsikNwU-5BVsnoHNEYw-xpuhW0tg@mail.gmail.com>
 <1882458.VgLOd8kIdz@tauon.chronox.de>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 20 Sep 2017 16:09:46 +0200
Message-ID: <CAHmME9qUPR0KTyr0TgiCA38-trMu1s_0C2uYq8u-S=kAWByZqQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v6] security/keys: rewrite all of big_key crypto
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Eric Biggers <ebiggers3@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, security@kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Sep 20, 2017 at 4:06 PM, Stephan Mueller <smueller@chronox.de> wrote:
>> Section 3 shows an attack with repeated nonces, which we don't do here.
>
> Maybe I miss a point here, but zero IVs is no repetition of nonces?

If there's a fresh key each time, then no, it's not a repetition.

This patch uses a fresh random key for every encryption.
