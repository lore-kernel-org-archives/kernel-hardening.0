Date: Mon, 23 Jan 2017 09:36:19 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170123083619.GA32010@kroah.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
 <20170118103031.GB15169@kroah.com>
 <2236FBA76BA1254E88B949DDB74E612B41C417BD@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C417BD@IRSMSX102.ger.corp.intel.com>
Subject: [kernel-hardening] Re: [RFCv2 PATCH 00/18] refcount_t API + usage
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "keescook@chromium.org" <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "peterz@infradead.org" <peterz@infradead.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "dwindsor@gmail.com" <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 23, 2017 at 07:52:17AM +0000, Reshetova, Elena wrote:
> > Then comes the real work :)
> > 
> > You will need to break up the remaining patches into "one-per-type" and
> > start submitting them to the various submaintainers for inclusion.  
> 
> Could you please elaborate more on "one-per-type"? Sorry if the question is
> too basic, but I could not find any proper explanations anywhere now. 

One patch per atomic_t variable that you change to refcount_t.

> If I run get_maintainer.pl, it sometimes produces rather big list (like it was the
> case with atomic changes for example) and for a big patch like for example networking
> it might not be straightforward to determine how to break it up properly. 

I doubt that you will have a "touch the whole network stack" patch if
you break it up into one-per-variable, but I don't really know.  See
what it looks like when you are done.

> If there any BKMs or generic heuristics that people use in this case? 

"BKM"?  What's that

> Does it help to send it to a general subsystem maintainer and mailing list first
> for a look and ask how they prefer it to be broken up?

Again, one per variable should be fine.  Then send all of the patches
for a specific subsystem (i.e. wireless drivers) to that list and
maintainer for the subsystem and individual driver authors.  I'm sure
that others at Intel can help you out with this, it should be documented
pretty well somewhere in your internal system :)

good luck!

greg k-h
