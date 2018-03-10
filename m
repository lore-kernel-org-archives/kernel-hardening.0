Date: Sat, 10 Mar 2018 09:43:27 +0100
From: Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH v2] net: ipv6: xfrm6_state: remove VLA usage
Message-ID: <20180310094327.685d181d@epycfail>
In-Reply-To: <1520667645-21975-1-git-send-email-andreaschristofo@gmail.com>
References: <1520667645-21975-1-git-send-email-andreaschristofo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Andreas Christoforou <andreaschristofo@gmail.com>
Cc: keescook@chromium.org, kernel-hardening@lists.openwall.com, Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, 10 Mar 2018 09:40:44 +0200
Andreas Christoforou <andreaschristofo@gmail.com> wrote:

> diff --git a/net/ipv6/xfrm6_state.c b/net/ipv6/xfrm6_state.c
> index b15075a..270a53a 100644
> --- a/net/ipv6/xfrm6_state.c
> +++ b/net/ipv6/xfrm6_state.c
> @@ -62,7 +62,7 @@ __xfrm6_sort(void **dst, void **src, int n, int (*cmp)(void *p), int maxclass)
>  {
>  	int i;
>  	int class[XFRM_MAX_DEPTH];
> -	int count[maxclass];
> +	int count[XFRM_MAX_DEPTH];
>  
>  	memset(count, 0, sizeof(count));

Can you perhaps initialize 'count' instead of calling memset(), now?

-- 
Stefano
