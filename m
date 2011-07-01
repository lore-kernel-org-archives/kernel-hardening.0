Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 1 Jul 2011 15:49:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <20110701154947.133c30f5@lxorguk.ukuu.org.uk>
In-Reply-To: <20110701143757.GA22567@albatros>
References: <20110626165409.GA2584@albatros>
	<20110626182628.GA20158@elte.hu>
	<20110626190622.GB4217@albatros>
	<20110626194618.GA21740@elte.hu>
	<20110626202518.GA4915@albatros>
	<20110626220126.GA24004@elte.hu>
	<20110627083633.GA5846@albatros>
	<20110627104058.45e93c41@pyx>
	<20110627183829.GA16033@albatros>
	<BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com>
	<20110701143757.GA22567@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

>  of the multiline feature.  Intoducing new "%S" format for single lines
>  makes little sense as there are tons of printk() calls that should be
>  already restricted to one line.

You don't need a new format string surely. Your expectation for printk is 

"multiple new lines are cool providing they are in the format string"

So that bit isn't hard to deal with, 

You make vprintk take an extra arg (trusted/untrusted args)
You make printk pass 'untrusted'
You make %s quote the arguments for control codes if untrusted is set but
you don't mangle format string controls.

End of problem ?

At which point your attacker has more work to do but given a long string
yawns and stars using the right number of spaces for the likely 80 col
screen :)
