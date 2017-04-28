Date: Fri, 28 Apr 2017 18:18:40 +0200
From: Sabrina Dubroca <sd@queasysnail.net>
Message-ID: <20170428161840.GA30423@bistromath.localdomain>
References: <20170425155215.4835-1-Jason@zx2c4.com>
 <20170425184734.26563-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20170425184734.26563-1-Jason@zx2c4.com>
Subject: [kernel-hardening] Re: [PATCH v6 1/5] skbuff: return -EMSGSIZE in skb_to_sgvec to
 prevent overflow
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, David.Laight@aculab.com, kernel-hardening@lists.openwall.com, davem@davemloft.net
List-ID: <kernel-hardening.lists.openwall.com>

2017-04-25, 20:47:30 +0200, Jason A. Donenfeld wrote:
> This is a defense-in-depth measure in response to bugs like
> 4d6fa57b4dab ("macsec: avoid heap overflow in skb_to_sgvec"). While
> we're at it, we also limit the amount of recursion this function is
> allowed to do. Not actually providing a bounded base case is a future
> diaster that we can easily avoid here.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Changes v5->v6:
>   * Use unlikely() for the rare overflow conditions.
>   * Also bound recursion, since this is a potential disaster we can avert.
> 
>  net/core/skbuff.c | 31 ++++++++++++++++++++++++-------
>  1 file changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index f86bf69cfb8d..24fb53f8534e 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3489,16 +3489,22 @@ void __init skb_init(void)
>   *	@len: Length of buffer space to be mapped
>   *
>   *	Fill the specified scatter-gather list with mappings/pointers into a
> - *	region of the buffer space attached to a socket buffer.
> + *	region of the buffer space attached to a socket buffer. Returns either
> + *	the number of scatterlist items used, or -EMSGSIZE if the contents
> + *	could not fit.
>   */

One small thing here: since you're touching this comment, could you
move it next to skb_to_sgvec, since that's the function it's supposed
to document?

Thanks!

>  static int
> -__skb_to_sgvec(struct sk_buff *skb, struct scatterlist *sg, int offset, int len)
> +__skb_to_sgvec(struct sk_buff *skb, struct scatterlist *sg, int offset, int len,
> +	       unsigned int recursion_level)

-- 
Sabrina
