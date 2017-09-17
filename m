Date: Sat, 16 Sep 2017 23:04:57 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20170917060457.GB10599@zzz.localdomain>
References: <20170916130034.17706-1-Jason@zx2c4.com>
 <20170916130533.23036-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170916130533.23036-1-Jason@zx2c4.com>
Subject: [kernel-hardening] Re: [PATCH v5] security/keys: rewrite all of big_key crypto
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, security@kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Jason,

On Sat, Sep 16, 2017 at 03:05:33PM +0200, Jason A. Donenfeld wrote:
> -
> -		ret = big_key_gen_enckey(enckey);
> -		if (ret)
> -			goto err_enckey;
> +		ret = get_random_bytes_wait(enckey, ENC_KEY_SIZE);
> +		if (unlikely(ret))
> +			goto error;

This should jump to 'err_enckey', otherwise it will leak 'enckey'.

Otherwise the changes all look good; after fixing the above, feel free to add my
Reviewed-by.  Yes, AES-GCM is the right choice here.  It is, however, almost
certainly the case that if someone can modify your swap partition, they can
already own your system in many other ways, so the "authenticated" portion of
"authenticated encryption" may not actually buy much in this situation :-)

The patch is a little long and perhaps should be split into several patches,
each of which fixes one bug; but see what David thinks.

I should also note, that while there definitely were some inadmissible bugs
here, the support for encrypting big_key's was only added recently, in the v4.7
kernel.  And obviously not encrypting at all is at least as much as a
"vulnerability" as using weak encryption.  I'm also a little skeptical that
people actually care enough about big_key's for it to be worthwhile to mark a
rewrite like this for stable, though I suppose it wouldn't be *too* hard to at
least cherry-pick this to 4.9 if you wanted.  (There is a small conflict so
you'd have to send the backport yourself after this goes into mainline.)

Eric
