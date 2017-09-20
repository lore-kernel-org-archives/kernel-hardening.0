Date: Wed, 20 Sep 2017 17:03:29 +0200
From: Solar Designer <solar@openwall.com>
Message-ID: <20170920150329.GA7017@openwall.com>
References: <20170524155751.424-1-riel@redhat.com> <20170919171600.GA31441@openwall.com> <1505906284.3490.5.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1505906284.3490.5.camel@opteya.com>
Subject: Re: [kernel-hardening] [PATCH v2 0/5] stackprotector: ascii armor the stack canary
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, danielmicay@gmail.com, tytso@mit.edu, keescook@chromium.org, hpa@zytor.com, luto@amacapital.net, mingo@kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, linux-sh@vger.kernel.org, ysato@users.sourceforge.jp, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Sep 20, 2017 at 01:18:04PM +0200, Yann Droneaud wrote:
> Le mardi 19 septembre 2017 ?? 19:16 +0200, Solar Designer a ??crit :
> >
> > We could put/require a NUL in the middle of the canary,
> > but with the full canary being only 64-bit at most that would also
> > make some attacks easier.
> 
> Are you suggesting to randomly select which byte to set to 0 in each
> canary ?

Definitely not.  That's only 8 different possibilities per canary, and
the weakest one will affect exploitability in each scenario.  So that
would be a fairly clear change to the worse.

I suggest that we make no further changes at this time, unless someone
comes up with an idea that would clearly hurt exploitation more than it
helps exploitation, overall across different scenarios.

Alexander
