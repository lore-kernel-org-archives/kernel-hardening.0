Return-Path: <SRS0=LJpm=64=lists.openwall.com=kernel-hardening-return-18798-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F13D1C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 17:31:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3E59F206D8
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 17:31:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="N1/XdDHF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E59F206D8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18798-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7934 invoked by uid 550); 14 May 2020 17:31:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32575 invoked from network); 14 May 2020 17:21:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1589476851;
	bh=ikf0Vp4M3S8wf9kpA/SaCsaALn3lIT48+uJW12r/eB4=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N1/XdDHFUuFjNYK/Z9QgCbOd99c4TlV6L0iW/fQ2X+Z4ANvRSrVgEIfm3LRe211ZL
	 hWNQ499H2ut35MiUWzDF5ECXI9KKZ2IiOPx6XunpNgk8d9Y47q1Elb3lkAx2Zfu3Fe
	 izfPq4Gn4kAPX3UG7WcIbuQrxlO+Hp3klm9agBWE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Thu, 14 May 2020 19:20:37 +0200
From: Oscar Carter <oscar.carter@gmx.com>
To: Kees Cook <keescook@chromium.org>
Cc: Oscar Carter <oscar.carter@gmx.com>,
	kernel-hardening@lists.openwall.com
Subject: Re: Get involved in the KSPP
Message-ID: <20200514172037.GA3127@ubuntu>
References: <20200509122007.GA5356@ubuntu>
 <202005110912.3A26AF11@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202005110912.3A26AF11@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:lDe6E8QpSSloS6SZvCrLfqG0NnL3g0GtHVf9jMliLfZZowN/Ptk
 4QGMiSI9ErZAby9tQ9MW63ROdvqRWzdTSI8FYkNnOjmvaCKeqUrRyWxI63XlBUgOKsmIvrv
 0dq5JkNxrQka1LIBeoF0Pva0Prrab9CRQc3q4wPyVzw5ZSS3nS5tJqbPIKdBTdanHp1g5kl
 Ql8CoOYBcoduUvfmK47yg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Tqia1oiB8DU=:vQrZfJ9Ip+twdfueggTg14
 0I+kr1aAOlgd6402cgiZ4FJI4jHDmCblfMjm3YxMM909OR6WEUI8jPV702zuIOXSKzC4X3PZ9
 u77RXJYj9kkF/AeBl+MjnyxQf8qBH6h+t9ff9tqdrkHjqA0+5VvKlDGsctj8UBDwA25fw6uyV
 tGCUapxBAfxq8v+W2va8u+xDDnJRV0Rf1gJdpouHaRxCevU1/tfmQ9A6f14N9U2wmjLGGAVen
 esvHMajCkEtCy12aYw3GPBedfzHDNDbVoBIwu2MrkR6tHoG078gya1bQ/lXwlMgKleE3XxXgn
 1WeaCOO0AwnuNkTtY64rodIcilBegQMHGB3wwVcmUvxGWfXm+CXVVzGwTbTMBz3ALKlVlLlKN
 IaYViOLg+nyTc0INXXIPIaQNpqcMag/dsboWTfcYQ6Gkli7gDen15nKq4Ziqe1jhjCZDPFp4i
 ghIJnEaD1bNgpbyV7kD1FDt/kc6ODlV+PCc7DWPkp78SPeMGZvybEmHRKN4iM4YPRB3ka5LCj
 3T2O2aokkAR4CvRXDkgPMlLB9P0Pb3mAn4hS9rIF6NTqAvbVhZSZ8upF3zlT7uoT8OHe1sUXy
 MmzwtMoqWztWwuSKd1NNlJA7Rp3+8TnV27vC9pN4xXjVt/BOwwer/Ybod+KtiE99qTKxz55ip
 k4H4+6apZ3ixHlkdz+IdYr/ebVPP7cH0FlzvyRP53dvjrYVC3iM+W0HsHGi5KVbr2rNS9XxW1
 j8AnmC7NLtOatU32kvDaTFuwN6+uRnkoXH1r47xdIgkCnnWSGlHMORwF959fgx96PnGA3Kiri
 k35W05A8gzChc2sVd0IG3QmGmIfqwk1BKNjUE+owKNj3pkaL+DrzxWdWcRhrrvEC5ENzYUEgl
 AvL0q95rr6N0oInejRt4PmOHTDgUtbVHA6fUq0ih1QVqAq6OJ/4fsnmBIwufGmQrpsh2apaLU
 OMmttez0wnG09qVGXyAeVNw8CkNLcMOJGAxMYHTrMuY8UZ26Yhe1cU6OR2MlZJynkWf+3qpX7
 5QX1me3jg4gC+IeQVOXGO84/yd4EGesvtR8/EuJFq2I5XgohkhwKeRDb0FBnJb5sNhFIA3/KY
 u8mRQyiFloft4ctkMeKwgkeWTeXHM5UinTJr/fg5Tyv4v1StDS+X8u0fU3EVxrK6/uzaaT9jY
 Wmvk8zPMBxsp5/nD5PCK8v1bCRsE40NHzmnVKv5ejXF3J0YWO523i6LSP3TwFdSBlK4S8DFFC
 PTqeznSPclwwx5kg7
Content-Transfer-Encoding: quoted-printable

On Mon, May 11, 2020 at 09:15:18AM -0700, Kees Cook wrote:
> On Sat, May 09, 2020 at 02:20:08PM +0200, Oscar Carter wrote:
> > Hi, my name is Oscar. I would like to get involved in the kernel self =
protection
> > project because I love the software security and I think this is one o=
f the most
> > challenging fields.
>
> Hi Oscar! Welcome to the mailing list. :)

Hi, thanks for the welcome.

> > I have experience in microcrontrollers and working with low level soft=
ware, but
> > my experience with the linux kernel development is a few commits in th=
e staging
> > area.
> >
> > For now, and due to my low experience with the linux kernel code and s=
oftware
> > security, I do not care about the area and task to be done. What I pre=
tend is to
> > help this great community and improve my knowledge and skills in this
> > challenging field.
> >
> > So, I would like to know if I can be assigned to some task that suits =
me. I've
> > taken a look at https://github.com/KSPP/linux/issues but I don't know =
which task
> > to choose and if someone else is working on it.
>
> There's "good first issue" label that might help you choose things:
> https://github.com/KSPP/linux/labels/good%20first%20issue

I saw it, but even so it's difficult to me to choose with my knowledge abo=
ut
this field. Sorry.

> One mostly mechanical bit of work would be this:
> https://github.com/KSPP/linux/issues/20
> There are likely more fixes needed to build the kernel with
> -Wcast-function-type (especially on non-x86 kernels). So that would let
> you learn about cross-compiling, etc.
>
> Let us know what you think!

Great. This task seems good to me. I'm already working on it but I would l=
ike to
know if it's correct to compile my work against the master branch of Linus=
 tree
or if there is some other better branch and tree.

> Take care,
>
> --
> Kees Cook

Thanks for your advices and comments.

Oscar Carter
