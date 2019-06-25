MIME-Version: 1.0
References: <CABgxDoLSzkVJ7Vh8mLiZySz6uS+VEu+GUxRqX8EWHKQDyz2fSg@mail.gmail.com>
 <201906200913.D2698BD0@keescook> <CABgxDoKQ4cnSS3p0sz8BgP65-R15U2Sr1AHVpU77ZGJu-Gvvvg@mail.gmail.com>
In-Reply-To: <CABgxDoKQ4cnSS3p0sz8BgP65-R15U2Sr1AHVpU77ZGJu-Gvvvg@mail.gmail.com>
From: Romain Perier <romain.perier@gmail.com>
Date: Tue, 25 Jun 2019 18:42:48 +0200
Message-ID: <CABgxDoKTC1=5P=rnLmGzAgFs704+occs4Gw+6WyU99r4HwFBHA@mail.gmail.com>
Subject: Re: Audit and fix all misuse of NLA_STRING: STATUS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

I have double checked.

See, https://salsa.debian.org/rperier-guest/linux-tree/raw/next/STATUS

Nothing worrying, it seems.

Regards,
Romain

Le ven. 21 juin 2019 =C3=A0 12:54, Romain Perier <romain.perier@gmail.com> =
a =C3=A9crit :
>
> Hi!
>
> Yeah, I have found some inconsistencies, but I am not 100% sure for
> all of these. I will double check and review the code closely.
> I keep you in touch.
>
> Regards,
> Romain
>
> Le jeu. 20 juin 2019 =C3=A0 18:15, Kees Cook <keescook@chromium.org> a =
=C3=A9crit :
> >
> > On Tue, Jun 18, 2019 at 07:56:42PM +0200, Romain Perier wrote:
> > > Hi !
> > >
> > > Here a first review, you can get the complete list here:
> > >
> > > https://salsa.debian.org/rperier-guest/linux-tree/raw/next/STATUS
> >
> > Cool! You identified three issues:
> >
> > net/netfilter/nfnetlink_cthelper.c:
> >         NF_CT_HELPER_NAME_LEN is used instead of NF_CT_EXP_POLICY_NAME_=
LEN
> >
> > net/netfilter/ipset/ip_set_list_set.c:
> >         IPSET_ATTR_NAME and IPSET_ATTR_NAMEREF both have a len of
> >         IPSET_MAXNAMELEN for a string of size IPSET_MAXNAMELEN
> >
> > net/openvswitch/conntrack.c:
> >         maxlen of NF_CT_HELPER_NAME_LEN with a string of size
> >         NF_CT_HELPER_NAME_LEN. maxlen of CTNL_TIMEOUT_NAME_MAX with a
> >         string of size CTNL_TIMEOUT_NAME_MAX
> >
> > I haven't looked closely at this myself yet, but I think the next step
> > would be to write patches for each of these. And while doing that, have
> > an eye toward thinking about how each case could be made more robust in
> > the future to avoid these kinds of flaws returning.
> >
> > Nice!
> >
> > --
> > Kees Cook
