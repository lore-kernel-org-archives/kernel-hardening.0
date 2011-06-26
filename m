Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 26 Jun 2011 23:06:22 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110626190622.GB4217@albatros>
References: <20110623152137.GA2536@albatros>
 <20110626103915.GB11093@elte.hu>
 <20110626165409.GA2584@albatros>
 <20110626182628.GA20158@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110626182628.GA20158@elte.hu>
Subject: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 26, 2011 at 20:26 +0200, Ingo Molnar wrote:
> > > Also, i think it would be better to make this opt-out, i.e. 
> > > exclude the handful of control characters that are harmful (such 
> > > as backline and console escape), instead of trying to include the 
> > > known-useful ones.
> > 
> > Do you see any issue with the check above?
> 
> There were clear problems with the first version you posted and 
> that's enough proof to request the exclusion of known-dangerous 
> characters instead of including known-useful characters.

It doesn't proof anything.  If I/someone else did a mistake with
blacklisting would you say it is enough proof to request the inclusion
of well-known allowed characters?


> A black list is well-defined: it disables the display of certain 
> characters because they are *known to be dangerous*.

What do you do with dangerous characters that are *not yet known* to be
dangerous?


> A white list on the other hand does it the wrong way around: it tries 
> to put the 'burden of proof' on the useful, good guys - and that's 
> counter-productive really.

Really?  I think strict API definition is productive, unlike using it
in cases where it looks like working, but creating tricky and obscure
bugs.

Yes, drawing multicolor logs is funny, but ...egrrr...  printk() is not
written for these things.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
