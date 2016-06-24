Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 24 Jun 2016 14:10:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <20160624061046.GB16850@gondor.apana.org.au>
References: <cover.1466741835.git.luto@kernel.org>
 <9a1ddd10d96898f8a2c94c3f3d37073c73ba50c9.1466741835.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a1ddd10d96898f8a2c94c3f3d37073c73ba50c9.1466741835.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH v4 01/16] bluetooth: Switch SMP to
 crypto_cipher_encrypt_one()
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Marcel Holtmann <marcel@holtmann.org>, Gustavo Padovan <gustavo@padovan.org>, Johan Hedberg <johan.hedberg@gmail.com>, "David S. Miller" <davem@davemloft.net>, linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 23, 2016 at 09:22:56PM -0700, Andy Lutomirski wrote:
> SMP does ECB crypto on stack buffers.  This is complicated and
> fragile, and it will not work if the stack is virtually allocated.
> 
> Switch to the crypto_cipher interface, which is simpler and safer.
> 
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Gustavo Padovan <gustavo@padovan.org>
> Cc: Johan Hedberg <johan.hedberg@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-bluetooth@vger.kernel.org
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
