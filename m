Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1477643844.2263.172.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Fri, 28 Oct 2016 10:37:24 +0200
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BF9479@IRSMSX102.ger.corp.intel.com>
References: <1476959131-6153-1-git-send-email-elena.reshetova@intel.com>
	 <20161020131350.GA18331@thigreal>
	 <CAGXu5jK1MNzM5Qi8o+HHekWm38n-WVPQ1Q3_EPpjYqE0kk8X0w@mail.gmail.com>
	 <20161025090559.eqsll3d7y2ifdaug@thigreal>
	 <1477415895.2263.43.camel@cvidal.org>
	 <CAEXv5_jk+2KOxL9UdZ5+6B8+JV2CBtNGi65a7ddtvxwUGmnPkA@mail.gmail.com>
	 <1477428836.2263.70.camel@cvidal.org>
	 <2236FBA76BA1254E88B949DDB74E612B41BF8C68@IRSMSX102.ger.corp.intel.com>
	 <1477471489.2263.107.camel@cvidal.org>
	 <2236FBA76BA1254E88B949DDB74E612B41BF8D57@IRSMSX102.ger.corp.intel.com>
	 <1477507968.2263.125.camel@cvidal.org>
	 <1477511274.2263.135.camel@cvidal.org>
	 <CAGXu5j+N8cm=4Wu8EmqXrEYXj-P4GwJX3fmKMcUM27zjEy+dig@mail.gmail.com>
	 <1477512469.2263.141.camel@cvidal.org>
	  <2236FBA76BA1254E88B949DDB74E612B41BF9479@IRSMSX102.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] [RFC v2 PATCH 00/13] HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Cc: David Windsor <dave@progbits.org>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Elena,

On Thu, 2016-10-27 at 12:00 +0000, Reshetova, Elena wrote:
> > 
> > I think this would be fine -- though I think it should be a distinct 
> > patch. Anything we can do to separate changes into logical chunks 
> > makes reviewing easier.
> > 
> > i.e. patch ordering could look like this:
> > 
> > - original series with HARDENED_ATOMIC depending on !GENERIC_ATOMIC64
> > - implementation of protection on GENERIC_ATOMIC64, removing above 
> > depends limitation
> > - ARM hardened atomic implementation
> 
> > 
> > Great!
> 
> > 
> > Elena, I will wait that you applies HARDENED_ATOMIC depending on 
> > !GENERIC_ATOMIC64, and I submit a new RFC with the implementation of protection on GENERIC_ATOMIC64 and a v2 of ARM port. Sounds good for everybody?
> 
> > 
> > Change pushed. Now it should be !GENERIC_ATOMIC64. Hopefully this for now concludes our state on atomic64* variables. 
> 

Thanks!

> > 
> > Now we are left with local_wrap_t problem still... But it doesn’t concern arm I think at all. 

Indeed, I never notice it (however, I try to make tiny build config,
since my laptop would take a looooong time to compile otherwise).

> 
> Ok, we managed to address this today finally hopefully in a non-ugly way. At least we are kind of happy with it. 
> So, from our side what we do today/tomorrow with Hans:
> 
> - finalize coverage on atomic64 and local wrap functions
> - add missing tests for atomic64 and local
> - rebase on top of latest linux-next
> - compile test and test run the whole thing in different combinations
> - send rfcv3 with also all atomic maintainers included for wider blame/feedback
> 
> Does it sound like a good plan for everyone?
> 

Sounds good for me!

FYI, I will probably takes a week or two before posting a new RFC
containing (1) the generic atomic64 part, and (2) a new version of the
ARM port, since I have some work to improve of the ARM port. I hope
this is ok!

Best Regards,

Colin
