Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 11 Nov 2016 12:35:16 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161111123516.GF11945@leverpostej>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <1478809488-18303-10-git-send-email-elena.reshetova@intel.com>
 <20161110214810.GH17134@arm.com>
 <2236FBA76BA1254E88B949DDB74E612B41BFF6AA@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BFF6AA@IRSMSX102.ger.corp.intel.com>
Subject: Re: [kernel-hardening] RE: [RFC v4 PATCH 09/13] drivers: identify
 wrapping atomic usage (part 1/2)
To: kernel-hardening@lists.openwall.com
Cc: Will Deacon <will.deacon@arm.com>, "keescook@chromium.org" <keescook@chromium.org>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "peterz@infradead.org" <peterz@infradead.org>, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 11, 2016 at 08:57:18AM +0000, Reshetova, Elena wrote:
> On Thu, Nov 10, 2016 at 10:24:44PM +0200, Elena Reshetova wrote:
> > From: David Windsor <dwindsor@gmail.com>
> > 
> > In some cases atomic is not used for reference counting and therefore 
> > should be allowed to overflow.
> > Identify such cases and make a switch to non-hardened atomic version.
> > 
> > This might need more fine-grained split between different drivers.

> >  88 files changed, 491 insertions(+), 459 deletions(-)

> >How did you decide that all of these need to wrap? Code inspection?
> 
> Yes. The initial set was taken from Grsecurity/PaX code and while
> moving the code we manually checked each change. 

That being the case, it would be good if you could provide some
{driver,subsystem}-specific rationale in the commit messages when this
is split. i.e. describe what the atomics are acutally used for, and why
wrapping is (or is not) safe.

> Certainly there are things that are missed here and that's why it
> needs more review. 
> Also, we were planning to break this patch even further by related
> drivers, so we can take it to relevant people for review also. 

I think that's necessary for any reasonable review to happen. Hopefully
there are subsystem-specific idioms for related drivers that make this
possible.

Thanks,
Mark.
