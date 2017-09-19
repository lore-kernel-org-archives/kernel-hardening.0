MIME-Version: 1.0
In-Reply-To: <20170919133959.5fgtioyonlsdyjf5@thunk.org>
References: <20170916130034.17706-1-Jason@zx2c4.com> <2681038.03lnYPhpsa@tauon.chronox.de>
 <CAHmME9p6uq0ELtgxB94bc4bUppa7UogWSEgj_9o8p2xXQfrz5A@mail.gmail.com> <20170919133959.5fgtioyonlsdyjf5@thunk.org>
From: Sandy Harris <sandyinchina@gmail.com>
Date: Tue, 19 Sep 2017 15:04:29 -0400
Message-ID: <CACXcFmmBzHu-9sCs+gJDbjeR4MTdOfMtUaBr+YjkwyfFquQMBA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v4] security/keys: rewrite all of
 big_key crypto
To: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Stephan Mueller <smueller@chronox.de>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Eric Biggers <ebiggers3@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ilhan Gurel <ilhan.gurel@gmail.com>, security@kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Sep 19, 2017 at 9:39 AM, Theodore Ts'o <tytso@mit.edu> wrote:

> On Mon, Sep 18, 2017 at 01:24:18PM +0200, Jason A. Donenfeld wrote:
>> Good luck with getting approval... While Ted and I have our
>> differences like any two kernel developers, I really tend agree with
>> him in his attitude about this FIPS silliness. ...
>
> Let me add one more reason why FIPS compliance for the kernel is just
> ***stupid***.  The way FIPS compliance works, you have to pay hundreds
> of thousands of dollars to a FIPS certification lab to certify a
> specific binary, complete with the exact build environment (compiler,
> binutils, etc.) used to build that kernel binary.
>
> The moment you need to make a change --- say, to fix a critical
> zero-day security bug --- this breaks the FIPS certification, ...
>
> You might say that FIPS certification != FIPS compliance.  Sure, but
> the only silly people who care about FIPS compliance also need FIPS
> certification, for the US Goverment signoff.

I do not think it is just the US that matters here. If I understand
Stefan correctly, one of his concerns is German (or EU?) gov't
standards that are somehow related. I'm very hazy on details.

I emphatically agree with Ted on some points here. Making
FIPS certification a goal for kernel development would be
really dumb. Having multiple RNGs available & compile-time
options to select among them also looks silly to me; we just
need one good one.

On the other hand, I do not see why the driver should not
use a FIPS-compliant PRNG where it can. This would make
things easier for anyone who does seek certification. One
of the big distro vendors? A gov't department or contractor
that wants to use Linux? A corporation's sys admin or
security reviewer? Stefan?

I cannot see much downside to this. Is the current PRNG
more efficient? More easily maintained? Is it still the case
that random(4) must use only hashes, not ciphers, to
avoid restrictions under export laws?
