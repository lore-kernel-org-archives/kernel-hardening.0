Date: Mon, 23 Apr 2018 21:13:24 -0600
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH 3/3] dh key: get rid of stack allocated array for zeroes
Message-ID: <20180424031324.GA3125@cisco>
References: <20180424010321.14739-1-tycho@tycho.ws>
 <20180424010321.14739-3-tycho@tycho.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180424010321.14739-3-tycho@tycho.ws>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 23, 2018 at 07:03:21PM -0600, Tycho Andersen wrote:
> We're interested in getting rid of all of the stack allocated arrays in
> the kernel: https://lkml.org/lkml/2018/3/7/621
> 
> This case is interesting, since we really just need an array of bytes that
> are zero. The loop already ensures that if the array isn't exactly the
> right size that enough zero bytes will be copied in. So, instead of
> choosing this value to be the size of the hash, let's just choose it to be
> 256, since that is a common size, is not to big, and will not result in too
> many extra iterations of the loop.
> 
> v2: split out from other patch, just hardcode array size instead of
>     dynamically allocating something the right size
> 
> Signed-off-by: Tycho Andersen <tycho@tycho.ws>
> CC: David Howells <dhowells@redhat.com>
> CC: James Morris <jmorris@namei.org>
> CC: "Serge E. Hallyn" <serge@hallyn.com>
> CC: Eric Biggers <ebiggers3@gmail.com>
> ---
>  security/keys/dh.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/security/keys/dh.c b/security/keys/dh.c
> index 9fecaea6c298..74f8a853872e 100644
> --- a/security/keys/dh.c
> +++ b/security/keys/dh.c
> @@ -162,8 +162,8 @@ static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
>  			goto err;
>  
>  		if (zlen && h) {
> -			u8 tmpbuffer[h];
> -			size_t chunk = min_t(size_t, zlen, h);
> +			u8 tmpbuffer[256];

Whoops, this should be 32, not 256. That shouldn't make any runtime
difference, but it'll closer match the allocation patterns from
before.

I'll let this sit for a bit and send v3.

Tycho
