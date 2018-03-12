Date: Mon, 12 Mar 2018 13:24:03 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH v2] net: ipv6: xfrm6_state: remove VLA usage
Message-ID: <20180312122403.tkav5d3plfll63vp@gauss3.secunet.de>
References: <1520667645-21975-1-git-send-email-andreaschristofo@gmail.com>
 <20180310094327.685d181d@epycfail>
 <CAGXu5jKwWRzK8EJOo2zraxi9ghQ7an5d4yr8ktGa+ijWX_aJZA@mail.gmail.com>
 <20180310192644.3fcbb69d@epycfail>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20180310192644.3fcbb69d@epycfail>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Andreas Christoforou <andreaschristofo@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 10, 2018 at 07:26:44PM +0100, Stefano Brivio wrote:
> On Sat, 10 Mar 2018 09:18:46 -0800
> Kees Cook <keescook@chromium.org> wrote:
> 
> > On Sat, Mar 10, 2018 at 12:43 AM, Stefano Brivio <sbrivio@redhat.com> wrote:
> > > On Sat, 10 Mar 2018 09:40:44 +0200
> > > Andreas Christoforou <andreaschristofo@gmail.com> wrote:
> > >  
> > >> diff --git a/net/ipv6/xfrm6_state.c b/net/ipv6/xfrm6_state.c
> > >> index b15075a..270a53a 100644
> > >> --- a/net/ipv6/xfrm6_state.c
> > >> +++ b/net/ipv6/xfrm6_state.c
> > >> @@ -62,7 +62,7 @@ __xfrm6_sort(void **dst, void **src, int n, int (*cmp)(void *p), int maxclass)
> > >>  {
> > >>       int i;
> > >>       int class[XFRM_MAX_DEPTH];
> > >> -     int count[maxclass];
> > >> +     int count[XFRM_MAX_DEPTH];
> > >>
> > >>       memset(count, 0, sizeof(count));  
> > >
> > > Can you perhaps initialize 'count' instead of calling memset(), now?  
> > 
> > Do you mean:
> > 
> > int count[XFRM_MAX_DEPTH] = { };
> > 
> > instead of the memset()?
> 
> Yep.
> 
> > I thought the compiler would resolve these both to the same thing?
> 
> Yes, for all practical purposes. With gcc 7.3.0 for x86_64, starting
> from -O1, it's exactly the same. With e.g. gcc 4.4.7, even with -O3,
> they can be a bit different depending on context.
> 
> > The former looks better though! :)
> 
> Yep! :)

If Andreas does a v3 anyway, please also consider to trim the subject
line to something like:

xfrm: remove VLA usage in __xfrm6_sort()
