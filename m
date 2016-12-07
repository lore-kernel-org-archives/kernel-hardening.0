Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 7 Dec 2016 14:21:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161207132112.GF3107@twins.programming.kicks-ass.net>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
 <20161201191543.GG3124@twins.programming.kicks-ass.net>
 <CAEXv5_isZ__znAw5vvE_srdP+irJW=TnUy2jQZxM33ZCAg037A@mail.gmail.com>
 <20161201230328.GS3045@worktop.programming.kicks-ass.net>
 <CAEXv5_i18GY0g=QL4McDFqPQWiBU9Powhzxz7USPfh0DTEp36w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXv5_i18GY0g=QL4McDFqPQWiBU9Powhzxz7USPfh0DTEp36w@mail.gmail.com>
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: David Windsor <dwindsor@gmail.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 01, 2016 at 06:20:55PM -0500, David Windsor wrote:

> Then are we decided that overflow protection is going to be opt-in?

The wholesale rape of atomic_t as proposed earlier is not going to
happen.

That results in a terrible and inconsistent API, which will only lead to
more terrible code.
