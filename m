Date: Fri, 9 Mar 2018 14:02:20 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] net: ipv6: xfrm6_state: remove VLA usage
Message-ID: <20180309130220.is5i4qu3fdcmyngq@gauss3.secunet.de>
References: <1520598106-3271-1-git-send-email-andreaschristofo@gmail.com>
 <CA+rthh9g3gcgTt8jbcRrVUK=Lagnz8HWJJLERwSbMi++3VqS1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+rthh9g3gcgTt8jbcRrVUK=Lagnz8HWJJLERwSbMi++3VqS1A@mail.gmail.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: Andreas Christoforou <andreaschristofo@gmail.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 09, 2018 at 01:49:07PM +0100, Mathias Krause wrote:
> On 9 March 2018 at 13:21, Andreas Christoforou
> <andreaschristofo@gmail.com> wrote:
> > The kernel would like to have all stack VLA usage removed[1].
> >
> > Signed-off-by: Andreas Christoforou <andreaschristofo@gmail.com>
> > ---
> >  net/ipv6/xfrm6_state.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/ipv6/xfrm6_state.c b/net/ipv6/xfrm6_state.c
> > index b15075a..45c0d98 100644
> > --- a/net/ipv6/xfrm6_state.c
> > +++ b/net/ipv6/xfrm6_state.c
> > @@ -62,7 +62,12 @@ __xfrm6_sort(void **dst, void **src, int n, int (*cmp)(void *p), int maxclass)
> >  {
> >         int i;
> >         int class[XFRM_MAX_DEPTH];
> > -       int count[maxclass];
> > +       int *count;
> > +
> > +       count = kcalloc(maxclass + 1, sizeof(*count), GFP_KERNEL);
> > +
> > +       if (!count)
> > +               return -ENOMEM;
> >
> >         memset(count, 0, sizeof(count));
> >
> > @@ -80,6 +85,7 @@ __xfrm6_sort(void **dst, void **src, int n, int (*cmp)(void *p), int maxclass)
> >                 src[i] = NULL;
> >         }
> >
> > +       kfree(count);
> >         return 0;
> >  }
> 
> Instead of dynamically allocating and freeing memory here, shouldn't
> we just get rid of the maxclass parameter and use XFRM_MAX_DEPTH as
> size for the count[] array, too?

Right, that's the way to go. Aside from that, allocating
with GFP_KERNEL is definitely wrong here.
