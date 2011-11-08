Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 8 Nov 2011 13:23:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <20111108132326.214bcaf8@lxorguk.ukuu.org.uk>
In-Reply-To: <20111108091121.GA10198@albatros>
References: <20111107192915.GA4690@albatros>
	<CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com>
	<4EB83674.3040207@zytor.com>
	<20111107201120.GA5775@albatros>
	<4EB843FF.5080201@zytor.com>
	<CA+55aFwYGivYFZTLprSB+oDm3E4MG0s3PEQabs166v6YRL5u-Q@mail.gmail.com>
	<4EB84F05.1000704@zytor.com>
	<CA+55aFxFNaRuTx-0vx+RhrkavrcNDiDh5jxcRyWPy8-QZHGD9A@mail.gmail.com>
	<20111107232132.2c6880a5@lxorguk.ukuu.org.uk>
	<20111107232750.GA4854@kroah.com>
	<20111108091121.GA10198@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to
 /proc/interrupts
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Eric Paris <eparis@parisplace.org>, kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

> /proc/{interrupts,stat} are 0444, which may be used by local attacker to
> learn statistical information about user's keystrokes, including the
> passwords.

So the distro can chmod it 0400

> /dev/pts/* and /dev/tty* leak the same timing information in inode's
> atime and mtime.

That one is trickier. I don't think it is a real leak because the last
update timing info is in seconds granularity so is pretty useless for
that. The atime/mtime behaviour is however required ABI and used by
applications so can't simply go away.

> Do we want to restrict permissions of interrupts/stat and remove atime
> and mtime from ttys and relax these permissions when revoke() is introduced?

revoke makes no difference I can see to either of these, they appear to
be a completely unrelated discussion.
