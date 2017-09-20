MIME-Version: 1.0
In-Reply-To: <27444.1505835505@warthog.procyon.org.uk>
References: <CAHmME9rjrz2Pn39ay3myApBeBtQAPNt0C+NvmFoV28NeT4_zLg@mail.gmail.com>
 <20170917115217.15805-1-Jason@zx2c4.com> <27444.1505835505@warthog.procyon.org.uk>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 20 Sep 2017 16:56:06 +0200
Message-ID: <CAHmME9pSfXZC6QGsGs6Qax9q8QeKxGJSJonA8gXyYDqjvTRY=A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v6] security/keys: rewrite all of big_key crypto
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Eric Biggers <ebiggers3@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, security@kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Sep 19, 2017 at 5:38 PM, David Howells <dhowells@redhat.com> wrote:
> Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
>> And, some error paths forgot to zero out sensitive
>> material, so this patch changes a kfree into a kzfree.
>
> Can you split that out into a separate preparatory patch?
>
> Also, I recommend limiting the lines in your patch description to 75 chars
> lest you get people who run checkpatch on everything pestering you ;-)

No problem. Will split that out, then fix the description, and
resubmit as v7. Coming your way shortly.
