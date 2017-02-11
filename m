From: "Roberts, William C" <william.c.roberts@intel.com>
Date: Sat, 11 Feb 2017 01:32:39 +0000
Message-ID: <476DC76E7D1DF2438D32BFADF679FC562305DC7B@ORSMSX103.amr.corp.intel.com>
References: <1486755469-21573-1-git-send-email-william.c.roberts@intel.com>
	 <1486757549.2192.20.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C559@ORSMSX103.amr.corp.intel.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C5BA@ORSMSX103.amr.corp.intel.com>
 <1486766996.2192.30.camel@perches.com>  
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH] checkpatch: add warning on %pk instead of %pK usage
To: Joe Perches <joe@perches.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

<snip>
> > By "normal" I'm referring to things that call into pointer(), just
> > casually looking I see bstr_printf vsnprintf kvasprintf, which would
> > be easy enough to add
> >
> > > What do you think is missing?  sn?printf ? That's easy to add.
> >
> > The problem starts to get hairy when we think of how often folks roll
> > their own logging macros (see some small sampling at the end).
> >
> > I think we would want to add DEBUG DBG and sn?printf and maybe
> > consider dropping the \b on the regex so it's a bit more matchy but
> > still shouldn't end up matching on any ASM as you pointed out in the V2=
 nack.
> >
> > Ill break this down into:
> > 1. the patch as I know you'll take it, as you wrote it :-P 2. Adding
> > to the logging macros 3. exploring making it less matchy

-Kees and Andrew they likely don't care about the rest of this...

I have been working up a regex (I suck at these) to match C functions that =
have an invalid
%p format string and take arguments:
http://www.regexr.com/3f92k

This could be a way to get better coverage in a more generic approach, thou=
ghts?
