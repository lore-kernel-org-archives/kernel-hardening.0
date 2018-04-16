Date: Tue, 17 Apr 2018 00:13:48 +0200
From: Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH v2] net: ipv6: xfrm6_state: remove VLA usage
Message-ID: <20180417001348.5a2df7c7@epycfail>
In-Reply-To: <1520667645-21975-1-git-send-email-andreaschristofo@gmail.com>
References: <1520667645-21975-1-git-send-email-andreaschristofo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Andreas Christoforou <andreaschristofo@gmail.com>
Cc: keescook@chromium.org, kernel-hardening@lists.openwall.com, Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Andreas,

On Sat, 10 Mar 2018 09:40:44 +0200
Andreas Christoforou <andreaschristofo@gmail.com> wrote:

> The kernel would like to have all stack VLA usage removed[1].
> Instead of dynamic allocation, just use XFRM_MAX_DEPTH
> as already done for the "class" array, but as per feedback,
> I will not drop maxclass because that changes the behavior.
> In one case, it'll do this loop up to 5, the other
> caller up to 6.
> 
> [1] https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Andreas Christoforou <andreaschristofo@gmail.com>
> ---
> v2:
> - use XFRM_MAX_DEPTH for "count" array (Steffen and Mathias).
> ---
>  net/ipv6/xfrm6_state.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
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
>  

I hope this didn't get too confusing. In the end, the change I proposed
for this patch was simply to drop the memset and initialize 'count'
like:

	int count[XFRM_MAX_DEPTH] = { };

and perhaps, while at it, move this before 'int i', for coding style
reasons.

When you re-post, please also take care of Steffen's comment. He
proposed to change the subject to:

	xfrm: remove VLA usage in __xfrm6_sort()

Note that you should give an indication of which tree this patch should
be applied to, by including this in the subject. The current subject
doesn't specify it, it should have been:

	[PATCH v2 ipsec-next] ...

Please see Documentation/networking/netdev-FAQ.txt for the difference
between net and net-next, as the same distinction applies for ipsec and
ipsec-next trees. Thanks.

-- 
Stefano
