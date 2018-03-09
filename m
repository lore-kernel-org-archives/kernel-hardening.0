Subject: Re: [PATCH] net: ipv6: xfrm6_state: remove VLA usage
References: <1520598106-3271-1-git-send-email-andreaschristofo@gmail.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <168b5c29-b037-cf5d-1383-4dfffab44e55@cogentembedded.com>
Date: Fri, 9 Mar 2018 21:35:21 +0300
MIME-Version: 1.0
In-Reply-To: <1520598106-3271-1-git-send-email-andreaschristofo@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Andreas Christoforou <andreaschristofo@gmail.com>, keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hello!

On 03/09/2018 03:21 PM, Andreas Christoforou wrote:

> The kernel would like to have all stack VLA usage removed[1].
> 
> Signed-off-by: Andreas Christoforou <andreaschristofo@gmail.com>
> ---
>  net/ipv6/xfrm6_state.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/xfrm6_state.c b/net/ipv6/xfrm6_state.c
> index b15075a..45c0d98 100644
> --- a/net/ipv6/xfrm6_state.c
> +++ b/net/ipv6/xfrm6_state.c
> @@ -62,7 +62,12 @@ __xfrm6_sort(void **dst, void **src, int n, int (*cmp)(void *p), int maxclass)
>  {
>  	int i;
>  	int class[XFRM_MAX_DEPTH];
> -	int count[maxclass];
> +	int *count;
> +
> +	count = kcalloc(maxclass + 1, sizeof(*count), GFP_KERNEL);
> +

  Empty line not needed here.

> +	if (!count)
> +		return -ENOMEM;
>  
>  	memset(count, 0, sizeof(count));
>  
[...]

MBR, Sergei
