Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 26 Jun 2011 20:26:28 +0200
From: Ingo Molnar <mingo@elte.hu>
Message-ID: <20110626182628.GA20158@elte.hu>
References: <20110623152137.GA2536@albatros>
 <20110626103915.GB11093@elte.hu>
 <20110626165409.GA2584@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110626165409.GA2584@albatros>
Subject: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Vasiliy Kulikov <segoon@openwall.com> wrote:

> > Also, i think it would be better to make this opt-out, i.e. 
> > exclude the handful of control characters that are harmful (such 
> > as backline and console escape), instead of trying to include the 
> > known-useful ones.
> 
> Do you see any issue with the check above?

There were clear problems with the first version you posted and 
that's enough proof to request the exclusion of known-dangerous 
characters instead of including known-useful characters.

> > The whole non-ASCII-languages issue would not have happened if 
> > such an approach was taken.
> >
> > It's also the better approach for the kernel: we handle known 
> > harmful things and are permissive otherwise.
> 
> I hope it is not a universal tip for the whole kernel development. 
> Black lists are almost always suck.
> 
> Could you instantly answer without reading the previous discussion 
> what control characters are harmful, what are sometimes harmful (on 
> some ttys), and what are always safe and why (or even answer why it 
> is harmful at all)?  I'm not a tty guy and I have to read 
> console_codes(4) or similar docs to answer this question, the 
> majority of kernel devs might have to read the docs too.
> 
> Writing the black list implies the full knowledge of _all_ possible 
> malformed input values, which is somewhat hard to achieve (or even 
> impossible).  Some developers might not be interested in learning 
> such details, but still interested in how this API can be used.

The point is to protect against known harm and not to turn it into 
"lets disable things broadly, just in case something unusual is 
harmful" kind of voodoo programming.

And yes, i very much expect someone *restricting* Linux utility to 
have *full* knowledge of the topic involved.

> Quite the contrary, the allowed values set makes sense to the 
> developer and more stricktly defines the API in question.  
> Discussing the API goals and reaching the consensus about its usage 
> is much more productive.  It might catch some wrong and dangerous 
> API misuses.  If the allowed set becomes too strict one day, no 
> problem - just explicitly relax the check.  If you lose some value 
> in the black list (e.g. it becomes known that some control char 
> sequence can be used to fake the logs), the miss significance would 
> be higher.
> 
> And from the cynical point of view the white list is simply smaller 
> and cleaner than the black list.

A black list is well-defined: it disables the display of certain 
characters because they are *known to be dangerous*.

A white list on the other hand does it the wrong way around: it tries 
to put the 'burden of proof' on the useful, good guys - and that's 
counter-productive really.

I don't mind protecting against known threats, with emphasis on 
'known'.

Thanks,

	Ingo
