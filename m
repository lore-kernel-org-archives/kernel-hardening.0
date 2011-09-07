Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 7 Sep 2011 13:34:11 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110907093411.GA4752@albatros>
References: <20110812102954.GA3496@albatros>
 <20110812105824.GA7141@openwall.com>
 <20110825171934.GA3044@albatros>
 <20110902182929.GA23848@openwall.com>
 <20110903111849.GA2743@albatros>
 <20110903235728.GD29169@openwall.com>
 <20110905124647.GA10247@albatros>
 <20110906050554.GA3889@openwall.com>
 <20110907090900.GA3910@albatros>
 <20110907093036.GA17693@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907093036.GA17693@openwall.com>
Subject: Re: [kernel-hardening] [RFC] x86, mm: start mmap allocation for
 libs from low addresses
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Wed, Sep 07, 2011 at 13:30 +0400, Solar Designer wrote:
> > +#ifdef CONFIG_VM86
> > +/*
> > + * Don't touch any memory that can be addressed by vm86 apps.
> > + * Reserve the first 1 MiB + 64 kb.
> > + */
> > +#define ASCII_ARMOR_MIN_ADDR 0x00110000
> > +#else
> > +/* No special users of low addresses.  Start just after mmap_min_addr. */
> > +#define ASCII_ARMOR_MIN_ADDR 0
> > +#endif
> 
> What if mmap_min_addr set really low, or is even 0?  I think we want to
> skip low addresses even if processes are permitted to use those.
> (Permitted does not mean encouraged.)  So how about ASCII_ARMOR_MIN_ADDR
> 0x19000 (100 KB) when !CONFIG_VM86?

Are you talking about safety with NULL pointer dereferencing?


> > +	/* We ALWAYS start from the beginning as base addresses
> > +	 * with zero high bits is a valued resource */
> 
> s/valued/scarce and valuable/
> 
> > +		 * If kernel.randomize_va_space < 2, the executable is build as
> 
> s/build/built/

Right, thank you!

-- 
Vasiliy
