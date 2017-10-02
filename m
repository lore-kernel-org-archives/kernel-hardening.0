Date: Mon, 2 Oct 2017 10:01:11 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20171002170111.GA6713@gmail.com>
References: <CAMuHMdWd3ttH7Zdpo=bodkOBw2xiyeX_R9MhPf=Bcf0-QLhOiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWd3ttH7Zdpo=bodkOBw2xiyeX_R9MhPf=Bcf0-QLhOiQ@mail.gmail.com>
Subject: [kernel-hardening] Re: Modular BIG_KEYS (was: Re: [PATCH v4] security/keys: rewrite all
 of big_key crypto)
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ilhan Gurel <ilhan.gurel@gmail.com>, security@kernel.org, stable <stable@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 02, 2017 at 09:14:36AM +0200, Geert Uytterhoeven wrote:
> Now this has hit mainline, the "BIG_KEYS" Kconfig symbol appeared on my
> radar. Is there any reason this cannot be tristate?
> 
> The help text says:
> 
>     This option provides support for holding large keys within the kernel
>     (for example Kerberos ticket caches).  The data may be stored out to
>     swapspace by tmpfs.
> 
>     If you are unsure as to whether this is required, answer N.
> 
> So to save kernel size, I wan't to save N, but for a distro kernel that might
> have Kerberos users, you currently need to say Y, while M would be nicer.
> 
> The symbol seems to just control the build of security/keys/big_key.c,
> which could use module_init() in the modular case.
> I'm not sending a patch to change BIG_KEYS from bool to tristate, as this is
> crypto, and I don't understand the full implications.
> 

It's possible to have a key type in a module.  In fact, some of the existing key
types such as key_type_rxrpc can already be modular.  But I don't think it
really works as intended currently because there is no autoloading of key type
modules.  That is, if big_key was a module and you tried to add a key of type
"big_key", the big_key module would *not* be automatically loaded, so the call
would return -ENODEV.  This could be fixed, I believe.

(I also still need to convince myself that there aren't any race conditions in
key type unregistering.  It's a little weird how it changes the key type to the
".dead" key type, rather than pinning the key type in memory while it's still
used.)

Eric
