Date: Sat, 21 Apr 2018 00:51:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/2] crypto: removing various VLAs
Message-ID: <20180420165143.mwcxwkf6j7ddckdt@gondor.apana.org.au>
References: <1523282087-22128-1-git-send-email-s.mesoraca16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1523282087-22128-1-git-send-email-s.mesoraca16@gmail.com>
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 09, 2018 at 03:54:45PM +0200, Salvatore Mesoraca wrote:
> v2:
> 	As suggested by Herbert Xu, the blocksize and alignmask checks
> 	have been moved to crypto_check_alg.
> 	So, now, all the other separate checks are not necessary.
> 	Also, the defines have been moved to include/crypto/algapi.h.
> 
> v1:
> 	As suggested by Laura Abbott[1], I'm resending my patch with
> 	MAX_BLOCKSIZE and MAX_ALIGNMASK defined in an header, so they
> 	can be used in other places.
> 	I took this opportunity to deal with some other VLAs not
> 	handled in the old patch.
> 
> [1] http://lkml.kernel.org/r/4e536889-439a-49e6-dd95-2d4286913202@redhat.com
> 
> Salvatore Mesoraca (2):
>   crypto: api - laying defines and checks for statically allocated
>     buffers
>   crypto: remove several VLAs
> 
>  crypto/algapi.c         | 10 ++++++++++
>  crypto/cfb.c            |  7 +++----
>  crypto/cipher.c         |  3 ++-
>  crypto/ctr.c            |  4 ++--
>  crypto/cts.c            |  5 +++--
>  crypto/pcbc.c           |  5 +++--
>  include/crypto/algapi.h |  8 ++++++++
>  7 files changed, 31 insertions(+), 11 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
