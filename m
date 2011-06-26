Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 27 Jun 2011 00:25:18 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110626202518.GA4915@albatros>
References: <20110623152137.GA2536@albatros>
 <20110626103915.GB11093@elte.hu>
 <20110626165409.GA2584@albatros>
 <20110626182628.GA20158@elte.hu>
 <20110626190622.GB4217@albatros>
 <20110626194618.GA21740@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110626194618.GA21740@elte.hu>
Subject: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 26, 2011 at 21:46 +0200, Ingo Molnar wrote:
> > > > > Also, i think it would be better to make this opt-out, i.e. 
> > > > > exclude the handful of control characters that are harmful 
> > > > > (such as backline and console escape), instead of trying to 
> > > > > include the known-useful ones.
> > > > 
> > > > Do you see any issue with the check above?
> > > 
> > > There were clear problems with the first version you posted and 
> > > that's enough proof to request the exclusion of known-dangerous 
> > > characters instead of including known-useful characters.
> > 
> > It doesn't proof anything.  If I/someone else did a mistake with 
> > blacklisting would you say it is enough proof to request the 
> > inclusion of well-known allowed characters?
> 
> No, because the problems such a mistake causes are not equivalent: it 
> would have been far more harmful to not print out the *very real* 
> product names written in some non-US language than to accidentally 
> include some control character you did not think of.

???

Not "not print", but print in "crypted" form.  The information is
still not lost, you can obviously restore it to the original form, with
some effort, but possible.  Compare it with the harm of log spoofing -
it is not "restorable".


> > > A black list is well-defined: it disables the display of certain 
> > > characters because they are *known to be dangerous*.
> > 
> > What do you do with dangerous characters that are *not yet known* 
> > to be dangerous?
> 
> I'm ready to act on facts only.

The *fact* is you/anybody/everybody might not know all bad things.  If
you just don't care because it is yet unknown then you will be
vulnerable as soon as it disclosured.


> Also, i really prefer the policy of 
> acting on known dangers instead of being afraid of the unknown.

Do you know the principle "Attacks always get better, never worse"?  If
you are protected against only of known attack, you will be vulnerable
to *every* danger not known to you.

Maybe you don't know, but it is really possible to be protected against
some *yet unknown* attack techniques.  (The assessment of what attacks it
protects against is undefined too, though.)  And upstream Linux is *already*
protected against some *yet unknown* bugs, not the whole bug classes,
but at least small kinds of it.


> > > A white list on the other hand does it the wrong way around: it 
> > > tries to put the 'burden of proof' on the useful, good guys - and 
> > > that's counter-productive really.
> > 
> > Really?  I think strict API definition is productive, unlike using 
> > it in cases where it looks like working, but creating tricky and 
> > obscure bugs.
> 
> You werent really creating a well-defined API here, were you?

No, I was - only ascii chars and \n are allowed.  In v2 all ascii chars,
the upper charset and 2 control chars are allowed.  Rather clear, IMO.


-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
