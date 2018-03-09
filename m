MIME-Version: 1.0
In-Reply-To: <1520598106-3271-1-git-send-email-andreaschristofo@gmail.com>
References: <1520598106-3271-1-git-send-email-andreaschristofo@gmail.com>
From: Mathias Krause <minipli@googlemail.com>
Date: Fri, 9 Mar 2018 13:49:07 +0100
Message-ID: <CA+rthh9g3gcgTt8jbcRrVUK=Lagnz8HWJJLERwSbMi++3VqS1A@mail.gmail.com>
Subject: Re: [PATCH] net: ipv6: xfrm6_state: remove VLA usage
Content-Type: text/plain; charset="UTF-8"
To: Andreas Christoforou <andreaschristofo@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 9 March 2018 at 13:21, Andreas Christoforou
<andreaschristofo@gmail.com> wrote:
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
>         int i;
>         int class[XFRM_MAX_DEPTH];
> -       int count[maxclass];
> +       int *count;
> +
> +       count = kcalloc(maxclass + 1, sizeof(*count), GFP_KERNEL);
> +
> +       if (!count)
> +               return -ENOMEM;
>
>         memset(count, 0, sizeof(count));
>
> @@ -80,6 +85,7 @@ __xfrm6_sort(void **dst, void **src, int n, int (*cmp)(void *p), int maxclass)
>                 src[i] = NULL;
>         }
>
> +       kfree(count);
>         return 0;
>  }

Instead of dynamically allocating and freeing memory here, shouldn't
we just get rid of the maxclass parameter and use XFRM_MAX_DEPTH as
size for the count[] array, too?

Cheers,
Mathias
