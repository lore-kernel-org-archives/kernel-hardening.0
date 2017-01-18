Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 18 Jan 2017 10:03:40 +0100
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Message-ID: <20170118090340.GB2043@kroah.com>
References: <2236FBA76BA1254E88B949DDB74E612B41C3BD08@IRSMSX102.ger.corp.intel.com>
 <CAGXu5jJe0F_z5unvTg7y1myka+AP7Qn5mShEw9DS2M+c=NqpBA@mail.gmail.com>
 <CAGXu5jLC-drraZ3D5bj3_rO4LEFiUhutHHw7U8AfDyAEHg+xtg@mail.gmail.com>
 <20170112051114.GG20972@linaro.org>
 <20170112085714.GC3081@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C3DB77@IRSMSX102.ger.corp.intel.com>
 <CAGXu5j+g1L5Cpphy0Sgr6+KGmaAT6PPcP3ujkuQ9eHmDbreWEA@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41C3E295@IRSMSX102.ger.corp.intel.com>
 <CAEXv5_gNAF17wAtppEcDsfscK484G4R6WoMTd-jyFneRvDo9RQ@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41C3E725@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C3E725@IRSMSX102.ger.corp.intel.com>
Subject: Re: [kernel-hardening] [RFC PATCH 08/19] kernel, mm: convert from
 atomic_t to refcount_t
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: David Windsor <dwindsor@gmail.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "ishkamiel@gmail.com" <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 18, 2017 at 08:41:17AM +0000, Reshetova, Elena wrote:
> > Do you have any particular workload that you've been testing these with?
> 
> No, we only tested the full boot, that's why I would like to understand how to test more. 
> I think it is not so much about the workload, but about testing
> different configuration.  Like for example, when AKASHI Takahiro run
> the patches on top on NFS rootfs, it has shown the issue we haven't
> seen in our case.  You can imagine how many of such cases are still
> hiding given the number of configurations and drivers that get active
> in runtime. 

That is why you need to post the patches so that the subsystem
maintainers can review them!  They are the ones that know the code the
best, why you all don't want to let them at least review the changes is
beyond me...

greg k-h
