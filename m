Date: Thu, 18 May 2017 16:12:03 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170518141203.GB23654@kroah.com>
References: <20170506040641.GA32707@kroah.com>
 <20170506040656.GB32707@kroah.com>
 <20170516115811.GA7297@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170516115811.GA7297@pathway.suse.cz>
Subject: [kernel-hardening] Re: [RFC 1/6] lib: vsprintf: additional kernel pointer filtering
 options
To: Petr Mladek <pmladek@suse.com>
Cc: kernel-hardening@lists.openwall.com, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 16, 2017 at 01:58:11PM +0200, Petr Mladek wrote:
> On Fri 2017-05-05 21:06:56, Greg KH wrote:
> > From: Dave Weinstein <olorin@google.com>
> > 
> > Add the kptr_restrict setting of 3 which results in both
> > %p and %pK values being replaced by zeros.
> > 
> > Add an additional %pP value inspired by the Grsecurity
> > option which explicitly whitelists pointers for output.
> > 
> > This patch is based on work by William Roberts
> > <william.c.roberts@intel.com>
> > 
> > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> > index e3bf4e0f10b5..f4e11dade1ab 100644
> > --- a/lib/vsprintf.c
> > +++ b/lib/vsprintf.c
> > @@ -395,6 +395,16 @@ struct printf_spec {
> >  #define FIELD_WIDTH_MAX ((1 << 23) - 1)
> >  #define PRECISION_MAX ((1 << 15) - 1)
> >  
> > +int kptr_restrict __read_mostly;
> > +
> > +/*
> > + * Always cleanse %p and %pK specifiers
> > + */
> > +static inline int kptr_restrict_always_cleanse_pointers(void)
> 
> The name of the function is very long and still confusing.
> It uses the word "always" but there are many types of pointers
> that are not cleared with this condition, for example %pP, %pa.
> 
> Do we need this helper function at all? It is used
> a weird way, see below.

Thanks for the comments, I'll revise this for the next version, thanks
so much for the review, much appreciated.

thanks,

greg k-h
