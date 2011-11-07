Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 7 Nov 2011 23:45:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <20111107234516.34a58be6@lxorguk.ukuu.org.uk>
In-Reply-To: <4BA97845-BA47-47F3-A923-9B24AB7306E9@mit.edu>
References: <4EB82F08.8060209@zytor.com>
	<20111107192915.GA4690@albatros>
	<CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com>
	<4EB83674.3040207@zytor.com>
	<20111107201120.GA5775@albatros>
	<4EB843FF.5080201@zytor.com>
	<CA+55aFwYGivYFZTLprSB+oDm3E4MG0s3PEQabs166v6YRL5u-Q@mail.gmail.com>
	<4EB84F05.1000704@zytor.com>
	<CA+55aFxFNaRuTx-0vx+RhrkavrcNDiDh5jxcRyWPy8-QZHGD9A@mail.gmail.com>
	<20111107232132.2c6880a5@lxorguk.ukuu.org.uk>
	<20111107232750.GA4854@kroah.com>
	<4BA97845-BA47-47F3-A923-9B24AB7306E9@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to
 /proc/interrupts
To: Theodore Tso <tytso@mit.edu>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Vasiliy Kulikov <segoon@openwall.com>, Eric Paris <eparis@parisplace.org>, kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

> Yup.   But if revoke has come up, I'd like to remind folks that there are good uses of it besides just tty devices that receive hangup events.   Having the modem connection disappear and the USB device disappear isn't all that different from a conceptual point of view.

And for USB tty which actually treat them the same and do exactly this 8)

Alan
