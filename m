MIME-Version: 1.0
Sender: geert.uytterhoeven@gmail.com
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 2 Oct 2017 09:14:36 +0200
Message-ID: <CAMuHMdWd3ttH7Zdpo=bodkOBw2xiyeX_R9MhPf=Bcf0-QLhOiQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Modular BIG_KEYS (was: Re: [PATCH v4] security/keys: rewrite all of
 big_key crypto)
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, ebiggers3@gmail.com, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ilhan Gurel <ilhan.gurel@gmail.com>, security@kernel.org, stable <stable@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Jason,

On Sat, Sep 16, 2017 at 3:00 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> This started out as just replacing the use of crypto/rng with
> get_random_bytes_wait, so that we wouldn't use bad randomness at boot time.
> But, upon looking further, it appears that there were even deeper
> underlying cryptographic problems, and that this seems to have been
> committed with very little crypto review. So, I rewrote the whole thing,
> trying to keep to the conventions introduced by the previous author, to
> fix these cryptographic flaws.
>
> It makes no sense to seed crypto/rng at boot time and then keep
> using it like this, when in fact there's already get_random_bytes_wait,
> which can ensure there's enough entropy and be a much more standard way
> of generating keys. Since this sensitive material is being stored untrusted,
> using ECB and no authentication is simply not okay at all. I find it
> surprising and a bit horrifying that this code even made it past basic
> crypto review, which perhaps points to some larger issues. This patch
> moves from using AES-ECB to using AES-GCM. Since keys are uniquely generated
> each time, we can set the nonce to zero. There was also a race condition in
> which the same key would be reused at the same time in different threads. A
> mutex fixes this issue now. And, some error paths forgot to zero out sensitive
> material, so this patch changes a kfree into a kzfree.
>
> So, to summarize, this commit fixes the following vulnerabilities:
>
>   * Low entropy key generation, allowing an attacker to potentially
>     guess or predict keys.
>   * Unauthenticated encryption, allowing an attacker to modify the
>     cipher text in particular ways in order to manipulate the plaintext,
>     which is is even more frightening considering the next point.
>   * Use of ECB mode, allowing an attacker to trivially swap blocks or
>     compare identical plaintext blocks.
>   * Key re-use.
>   * Faulty memory zeroing.
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

> --- a/security/keys/Kconfig
> +++ b/security/keys/Kconfig
> @@ -45,10 +45,8 @@ config BIG_KEYS
>         bool "Large payload keys"
>         depends on KEYS
>         depends on TMPFS
> -       depends on (CRYPTO_ANSI_CPRNG = y || CRYPTO_DRBG = y)
>         select CRYPTO_AES
> -       select CRYPTO_ECB
> -       select CRYPTO_RNG
> +       select CRYPTO_GCM
>         help
>           This option provides support for holding large keys within the kernel
>           (for example Kerberos ticket caches).  The data may be stored out to

Now this has hit mainline, the "BIG_KEYS" Kconfig symbol appeared on my
radar. Is there any reason this cannot be tristate?

The help text says:

    This option provides support for holding large keys within the kernel
    (for example Kerberos ticket caches).  The data may be stored out to
    swapspace by tmpfs.

    If you are unsure as to whether this is required, answer N.

So to save kernel size, I wan't to save N, but for a distro kernel that might
have Kerberos users, you currently need to say Y, while M would be nicer.

The symbol seems to just control the build of security/keys/big_key.c,
which could use module_init() in the modular case.
I'm not sending a patch to change BIG_KEYS from bool to tristate, as this is
crypto, and I don't understand the full implications.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
