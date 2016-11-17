Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 17 Nov 2016 13:59:32 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
In-Reply-To: <20161117101642.GG3142@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1611171353150.2913@hadrien>
References: <20161111174630.GO3117@twins.programming.kicks-ass.net> <CAGXu5j+_wdv_vn=Us-i=bvCwCGk5Ks_gpoK9bHja4dDNUZi9eQ@mail.gmail.com> <20161111201704.GQ3117@twins.programming.kicks-ass.net> <CAGXu5jJG0LUxLPtqr79PG=RmWgV96sy2j7dQKr9yvjadzrc3Ag@mail.gmail.com>
 <1479228602.4622.64.camel@redhat.com> <CAGXu5j+eA9wPMpM18iiD0RVX7UZVoLRn8JBKG2d8b3FF5+vwKw@mail.gmail.com> <1479316156.21171.30.camel@redhat.com> <2236FBA76BA1254E88B949DDB74E612B41C1196C@IRSMSX102.ger.corp.intel.com> <20161117083718.GA3142@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1611171035480.2913@hadrien> <20161117101642.GG3142@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Peter Zijlstra <peterz@infradead.org>
Cc: Julia Lawall <julia.lawall@lip6.fr>, "Reshetova, Elena" <elena.reshetova@intel.com>, Rik van Riel <riel@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, David Windsor <dave@progbits.org>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

With the options

--all-includes --include-headers --include-headers-for-types -I
/var/julia/linux-next/include -I /var/julia/linux-next/include/drm -I
/var/julia/linux-next/include/uapi --use-idutils

with 9 parallel jobs, I get 20 occurrences that have to be checked
manually due to insufficient type information in 1.5 minutes elapsed time.

Replacing --all-includes with --recursive-includes increases the elapsed
time to over 12 minutes but give only 9 occurrences that have to be
checked.

--include-headers-for-types does some caching of header file information.
Make coccicheck by default achieves paralellism by starting a thread for
each file, which eliminates the benefit of caching.  One then also needs
the argument --chunksize N, for perhaps N = 20, to get some benefit from
the caching.

julia
