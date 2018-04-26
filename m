Date: Thu, 26 Apr 2018 10:33:06 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH v4 ipsec-next] xfrm: remove VLA usage in __xfrm6_sort()
Message-ID: <20180426083306.uwhew63btnoalbxw@gauss3.secunet.de>
References: <20180425144639.GA38350@beast>
 <20180425165852.6c7460c2@epycfail>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20180425165852.6c7460c2@epycfail>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Andreas Christoforou <andreaschristofo@gmail.com>, kernel-hardening@lists.openwall.com, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 25, 2018 at 04:58:52PM +0200, Stefano Brivio wrote:
> On Wed, 25 Apr 2018 07:46:39 -0700
> Kees Cook <keescook@chromium.org> wrote:
> 
> > In the quest to remove all stack VLA usage removed from the kernel[1],
> > just use XFRM_MAX_DEPTH as already done for the "class" array. In one
> > case, it'll do this loop up to 5, the other caller up to 6.
> > 
> > [1] https://lkml.org/lkml/2018/3/7/621
> > 
> > Co-developed-by: Andreas Christoforou <andreaschristofo@gmail.com>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> > v4:
> > - actually remove memset(). :)
> > v3:
> > - adjust Subject and commit log (Steffen)
> > - use "= { }" instead of memset() (Stefano)
> > v2:
> > - use XFRM_MAX_DEPTH for "count" array (Steffen and Mathias).
> > ---
> 
> Acked-by: Stefano Brivio <sbrivio@redhat.com>

Applied to ipsec-next, thanks everyone!
