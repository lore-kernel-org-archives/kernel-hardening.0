Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1477511274.2263.135.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Wed, 26 Oct 2016 21:47:54 +0200
In-Reply-To: <1477507968.2263.125.camel@cvidal.org>
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
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC v2 PATCH 00/13] HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com, "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: David Windsor <dave@progbits.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

> BTW, I just looked to the generic implementation of atomic64. It seems
> quite understandable: methods use spinlock to access/modify to the
> value of an atomic64 variable. It seems possible to check the value
> before the increment/decrements and if the resulting value is 0, but
> the value before the operation was different of -1 or 1, is that an
> overflow just happened (well, it is not exactly right, but this is the
> global idea). Hence, we revert the change, release the lock, and kill
> the process.
> 
> If this idea is correct, it would avoid specific implementation of
> protected version of atomic64 for architecture with
> GENERIC_ATOMIC64. And case (3) would be easily protected. What do you
> think?

What I am saying here is quite confusing. Here is a cleaner
explanation:

 * the generic atomic64 method enter and takes the lock
 * before making the operation, check v->counter > INT_MAX - value (ifadd) or check v->counter < INT_MIN - value (if sub)
 * if the previous check is true, release the lock and kill the process
 * otherwise, let the operation process.

Obviously, if this approach is not wrong, there will be a significant
overhead, but it happens only on CONFIG_GENERIC_ATOMIC64 &&
CONFIG_HARDENED_ATOMIC.

Thanks,

Colin
