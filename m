Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1476115319.2329.108.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BDCAF6@IRSMSX102.ger.corp.intel.com>
References: <1476016472.2329.38.camel@cvidal.org>
	 <CE954033-54F3-47AE-9788-B26B9CE45401@gmail.com>
	 <1476040182.2329.72.camel@cvidal.org> <20161009193731.GD14666@pc.thejh.net>
	 <2236FBA76BA1254E88B949DDB74E612B41BDCAF6@IRSMSX102.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2016 18:01:59 +0200
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] self introduction
To: kernel-hardening@lists.openwall.com
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

> This branch to be precise:
> https://github.com/ereshetova/linux-stable/tree/hardened_atomic_on_next
>
> This is where the latest code for linux-next is hosted now and where
> we work with David and Hans.
> > 
> > > 
> > > Please contact me if you have any questions; I'd be glad to help!
> > 
> > I actually have question. :-) As far as I understand, PAX_REFCOUNT
> > [1] is mainly a x86-only
>
> >
> > No, PAX_REFCOUNT also supports a bunch of other architectures. As
> > far as I can tell from a quick look: ARM, MIPS, PowerPC and SPARC.
> 
> Yes, just in our patch series we only made implementation for x86.
> But if you look into Grsecurity/PaX patches, it has support for
> others implemented.

OK, got it! Thanks for this clarification.

So, I will try to start to port PAX_REFCOUNT arm-specific features to
hardened_atomic_on_next, and keep you in touch. Is there a deadline?
(4.10 / 5.0 merge window?)

Just to be sure, the patch [1] and documentation [2] of PaX are still
up-to-date, or there is another references I missed?

Thanks

Colin

[1] https://pax.grsecurity.net/pax-linux-3.6-201210022100.patch
[2] https://forums.grsecurity.net/viewtopic.php?f=7&t=4173
