Return-Path: <SRS0=pJSH=BG=lists.openwall.com=kernel-hardening-return-19456-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77EE0C433F4
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Jul 2020 16:17:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9DC5D2073E
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Jul 2020 16:17:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="T8Sn3a8Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DC5D2073E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=zx2c4.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19456-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19466 invoked by uid 550); 27 Jul 2020 16:16:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18410 invoked from network); 27 Jul 2020 16:16:58 -0000
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
	:references:in-reply-to:from:date:message-id:subject:to:cc
	:content-type; s=mail; bh=yZ9s7iESSXllw2jFppVGJgSQSDc=; b=T8Sn3a
	8QgZwT7OBLiEk39YllHL8AHxegeWoSsgukQldc9TiwR4eHH+81jI/awj0HrXtBrg
	Y5UPc9Cc5BZJ8GrAprgs5NcK5vubz31d4jsM4x0gMeFEgDrVjUrRX41udJBHMNld
	d/Bx9892A78N/q/07Gl0nQui+mlF/IAoZIyvrYwHlA6vlD8ytQ/RkS4Lp/JjiVOo
	r0KIpueIg+d9HaYHBQI6Nj9saKViVpoxMt0rA2Xtk8fEZ2Ajc735rEzlQ3Gn8yTu
	4eFoXmxypskbeYUzua5Dmfrj+eDOvtFDSR0ScqE+ZC5nUsdiFsBW9DfS1UvXfi+f
	sWCgYlvemIgM0Wvg==
X-Gm-Message-State: AOAM533T0H9UFiaXjNfo7Ggb5HJ/4eSEvERmuYkQ3z8rq92D/AUTx+v3
	zPc5Dp/clEilowNjCzhdN+dbz9ErounM20UKqg4=
X-Google-Smtp-Source: ABdhPJxpUhiuwtuwnEaez1P/c+ZU0pwKxKQezmeTGc12hGP8McAl6Imm8qRtlhHrSqvTuhro7sF5xCj0r6Sl8qXVeP8=
X-Received: by 2002:a92:c804:: with SMTP id v4mr15897355iln.207.1595866604002;
 Mon, 27 Jul 2020 09:16:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200723060908.50081-1-hch@lst.de> <20200723060908.50081-13-hch@lst.de>
 <20200727150310.GA1632472@zx2c4.com> <20200727150601.GA3447@lst.de>
In-Reply-To: <20200727150601.GA3447@lst.de>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 27 Jul 2020 18:16:32 +0200
X-Gmail-Original-Message-ID: <CAHmME9ric=chLJayn7Erve7WBa+qCKn-+Gjri=zqydoY6623aA@mail.gmail.com>
Message-ID: <CAHmME9ric=chLJayn7Erve7WBa+qCKn-+Gjri=zqydoY6623aA@mail.gmail.com>
Subject: Re: [PATCH 12/26] netfilter: switch nf_setsockopt to sockptr_t
To: Christoph Hellwig <hch@lst.de>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, 
	Eric Dumazet <edumazet@google.com>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org, 
	linux-can@vger.kernel.org, dccp@vger.kernel.org, 
	linux-decnet-user@lists.sourceforge.net, linux-wpan@vger.kernel.org, 
	linux-s390@vger.kernel.org, mptcp@lists.01.org, lvs-devel@vger.kernel.org, 
	rds-devel@oss.oracle.com, linux-afs@lists.infradead.org, 
	tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jul 27, 2020 at 5:06 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Jul 27, 2020 at 05:03:10PM +0200, Jason A. Donenfeld wrote:
> > Hi Christoph,
> >
> > On Thu, Jul 23, 2020 at 08:08:54AM +0200, Christoph Hellwig wrote:
> > > diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
> > > index da933f99b5d517..42befbf12846c0 100644
> > > --- a/net/ipv4/ip_sockglue.c
> > > +++ b/net/ipv4/ip_sockglue.c
> > > @@ -1422,7 +1422,8 @@ int ip_setsockopt(struct sock *sk, int level,
> > >                     optname != IP_IPSEC_POLICY &&
> > >                     optname != IP_XFRM_POLICY &&
> > >                     !ip_mroute_opt(optname))
> > > -           err = nf_setsockopt(sk, PF_INET, optname, optval, optlen);
> > > +           err = nf_setsockopt(sk, PF_INET, optname, USER_SOCKPTR(optval),
> > > +                               optlen);
> > >  #endif
> > >     return err;
> > >  }
> > > diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
> > > index 4697d09c98dc3e..f2a9680303d8c0 100644
> > > --- a/net/ipv4/netfilter/ip_tables.c
> > > +++ b/net/ipv4/netfilter/ip_tables.c
> > > @@ -1102,7 +1102,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
> > >  }
> > >
> > >  static int
> > > -do_replace(struct net *net, const void __user *user, unsigned int len)
> > > +do_replace(struct net *net, sockptr_t arg, unsigned int len)
> > >  {
> > >     int ret;
> > >     struct ipt_replace tmp;
> > > @@ -1110,7 +1110,7 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
> > >     void *loc_cpu_entry;
> > >     struct ipt_entry *iter;
> > >
> > > -   if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
> > > +   if (copy_from_sockptr(&tmp, arg, sizeof(tmp)) != 0)
> > >             return -EFAULT;
> > >
> > >     /* overflow check */
> > > @@ -1126,8 +1126,8 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
> > >             return -ENOMEM;
> > >
> > >     loc_cpu_entry = newinfo->entries;
> > > -   if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
> > > -                      tmp.size) != 0) {
> > > +   sockptr_advance(arg, sizeof(tmp));
> > > +   if (copy_from_sockptr(loc_cpu_entry, arg, tmp.size) != 0) {
> > >             ret = -EFAULT;
> > >             goto free_newinfo;
> > >     }
> >
> > Something along this path seems to have broken with this patch. An
> > invocation of `iptables -A INPUT -m length --length 1360 -j DROP` now
> > fails, with
> >
> > nf_setsockopt->do_replace->translate_table->check_entry_size_and_hooks:
> >   (unsigned char *)e + e->next_offset > limit  ==>  TRUE
> >
> > resulting in the whole call chain returning -EINVAL. It bisects back to
> > this commit. This is on net-next.
>
> This is another use o sockptr_advance that Ido already found a problem
> in.  I'm looking into this at the moment..

I haven't seen Ido's patch, but it seems clear the issue is that you
want to call `sockptr_advance(&arg, sizeof(tmp))`, and adjust
sockptr_advance to take a pointer.

Slight concern about the whole concept:

Things are defined as

typedef union {
        void            *kernel;
        void __user     *user;
} sockptr_t;
static inline bool sockptr_is_kernel(sockptr_t sockptr)
{
        return (unsigned long)sockptr.kernel >= TASK_SIZE;
}

So what happens if we have some code like:

sockptr_t sp;
init_user_sockptr(&sp, user_controlled_struct.extra_user_ptr);
sockptr_advance(&sp, user_controlled_struct.some_big_offset);
copy_to_sockptr(&sp, user_controlled_struct.a_few_bytes,
sizeof(user_controlled_struct.a_few_bytes));

With the user controlling some_big_offset, he can convert the user
sockptr into a kernel sockptr, causing the subsequent copy_to_sockptr
to be a vanilla memcpy, after which a security disaster ensues.

Maybe sockptr_advance should have some safety checks and sometimes
return -EFAULT? Or you should always use the implementation where
being a kernel address is an explicit bit of sockptr_t, rather than
being implicit?
