Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Thu, 17 Nov 2016 09:04:44 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C13F55@IRSMSX102.ger.corp.intel.com>
References: <CAEXv5_j22xaH4cfVztp58XJxCo8UDut44ei_0Rhv_FUbfHDwsQ@mail.gmail.com>
 <CAGXu5jJ0h6+r7T1bcrzVW0gF3Jis1shDbxcpxXR9sniD0B+74A@mail.gmail.com>
 <20161111174630.GO3117@twins.programming.kicks-ass.net>
 <CAGXu5j+_wdv_vn=Us-i=bvCwCGk5Ks_gpoK9bHja4dDNUZi9eQ@mail.gmail.com>
 <20161111201704.GQ3117@twins.programming.kicks-ass.net>
 <CAGXu5jJG0LUxLPtqr79PG=RmWgV96sy2j7dQKr9yvjadzrc3Ag@mail.gmail.com>
 <1479228602.4622.64.camel@redhat.com>
 <CAGXu5j+eA9wPMpM18iiD0RVX7UZVoLRn8JBKG2d8b3FF5+vwKw@mail.gmail.com>
 <1479316156.21171.30.camel@redhat.com>
 <2236FBA76BA1254E88B949DDB74E612B41C1196C@IRSMSX102.ger.corp.intel.com>
 <20161117083718.GA3142@twins.programming.kicks-ass.net>
In-Reply-To: <20161117083718.GA3142@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: RE: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, David Windsor <dave@progbits.org>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "Julia.Lawall@lip6.fr" <Julia.Lawall@lip6.fr>
List-ID: <kernel-hardening.lists.openwall.com>

> I have a coccinelle rule now that found about 15 usages of it.=20

>Right, so can coccinelle detect the call_rcu/free call that is conditional=
 on the dec_and_test when its hidden inside a few function calls?

Yes, it can. However, I haven't expanded the rule yet to cover cases when "=
hidden inside a few function calls" goes outside of one .c or .h file. Cocc=
inelle supports that, but I have to experiment fist if it doesn't bring mor=
e false positives that current setup.=20

>Also, we should really have a "make spatch" target so that we can run the =
thing concurrently with -j80 or somesuch, because as is coccinelle is unbea=
rably slow.

The currents rules are very simple, the full run on the whole tree even wit=
hout any pre-indexing, multithreading and etc. takes around 1 min only. =20
