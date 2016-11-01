Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 1 Nov 2016 13:35:42 +0200
From: Hans Liljestrand <ishkamiel@gmail.com>
Message-ID: <20161101113542.rofdy3cbgt6c3cvp@thigreal>
References: <1477914225-11298-1-git-send-email-elena.reshetova@intel.com>
 <1477914225-11298-2-git-send-email-elena.reshetova@intel.com>
 <1477993456.2236.7.camel@cvidal.org>
 <2236FBA76BA1254E88B949DDB74E612B41BFACA1@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BFACA1@IRSMSX102.ger.corp.intel.com>
Subject: Re: [kernel-hardening] [RFC v3 PATCH 01/13] Add architecture
 independent hardened atomic base
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, "keescook@chromium.org" <keescook@chromium.org>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 01, 2016 at 10:59:03AM +0000, Reshetova, Elena wrote:
> >Hi Elena,
> 
> Hi!
> 
> <snip>
> 
> > diff --git a/include/linux/types.h b/include/linux/types.h index 
> > baf7183..b47a7f8 100644
> > --- a/include/linux/types.h
> > +++ b/include/linux/types.h
> > @@ -175,10 +175,27 @@ typedef struct {
> >  	int counter;
> >  } atomic_t;
> >  
> > +#ifdef CONFIG_HARDENED_ATOMIC
> > +typedef struct {
> > +	int counter;
> > +} atomic_wrap_t;
> > +#else
> > +typedef atomic_t atomic_wrap_t;
> > +#endif
> > +
> >  #ifdef CONFIG_64BIT
> >  typedef struct {
> >  	long counter;
> >  } atomic64_t;
> > +
> > +#ifdef CONFIG_HARDENED_ATOMIC
> > +typedef struct {
> > +	long counter;
> > +} atomic64_wrap_t;
> > +#else
> > +typedef atomic64_t atomic64_wrap_t;
> > +#endif
> > +
> >  #endif
> >  
> 
> >I still think it would be a good idea to always distinct atomic*_wrap_t and atomic_t. Otherwise, it is possible to mix those two types without getting any error, if CONFIG_HARDENED_ATOMIC is disabled (no big deal in that case, since there is no protection anyways, but it is quite unclean...). What do you think?
> 
> Yes, now after we hopefully have all the coverage done and other issues resolved, it might be time to address this. 
> But I am not 100% sure what is the proper way. Defining the same struct type as for hardening case?

Hi Colin, Elena,

Wouldn't that also necessitate that we provide implementations for the wrap
functions? As it is now, we can just define the _wrap functions as macros
pointing the plain functions, but if the types are distinct that wouldn't work
(which, if I understand correctly, is the whole point).

So then we'd need to add default implementations for the _wrap functions. And
wouldn't those essentially have to use the arch implemented plain function to
ensure it actually works in all cases?

So I'm not disagreeing with you, I'm just not clear on the proper/clean way to
approach this either.

Thanks,
-hans

> 
> Best Regards,
> Elena.
