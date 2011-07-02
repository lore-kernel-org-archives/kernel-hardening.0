Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 2 Jul 2011 12:10:22 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110702081022.GA2755@albatros>
References: <20110626190622.GB4217@albatros>
 <20110626194618.GA21740@elte.hu>
 <20110626202518.GA4915@albatros>
 <20110626220126.GA24004@elte.hu>
 <20110627083633.GA5846@albatros>
 <20110627104058.45e93c41@pyx>
 <20110627183829.GA16033@albatros>
 <BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com>
 <20110701143757.GA22567@albatros>
 <20110701154947.133c30f5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701154947.133c30f5@lxorguk.ukuu.org.uk>
Subject: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jul 01, 2011 at 15:49 +0100, Alan Cox wrote:
> >  of the multiline feature.  Intoducing new "%S" format for single lines
> >  makes little sense as there are tons of printk() calls that should be
> >  already restricted to one line.
> 
> You don't need a new format string surely. Your expectation for printk is 
> 
> "multiple new lines are cool providing they are in the format string"
> 
> So that bit isn't hard to deal with, 
> 
> You make vprintk take an extra arg (trusted/untrusted args)

Not vprintk, but vscnprintf(), vsnprintf() and string() because
vprintk() is used in tens of places besides of printk().  Or better
implement _vscnprintf(.., bool untrusted) and 

vscnprintf(...) { return _vscnprintf(..., false); }

to leave current users of it as is.

But yes, I got the idea.


> You make printk pass 'untrusted'
> You make %s quote the arguments for control codes

What to do with CSI?  It is a valid byte inside of a UTF-8 string.
Parsing a supplied string assuming it is UTF-8 string and filtering CSI
iff it is not a part of UTF-8 symbol is something a bit ugly IMO.


Greg - do you know any devices supplying multibyte strings, but not in
UTF-8 encoding?  If yes, then CSI filtering is a bad idea :\


> At which point your attacker has more work to do but given a long string
> yawns and stars using the right number of spaces for the likely 80 col
> screen :)

Yeah, but introducing some artificial limit for string length is IMO
more harmfull: there is no universal limit for all situations, somewhere
the resulting string is already 70 chars and even 20 bytes would
overflow the col;  in rare cases a string of 50 bytes might be still
acceptable.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
