Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 2 Jul 2011 20:33:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <20110702203323.03462aef@lxorguk.ukuu.org.uk>
In-Reply-To: <20110702164243.GB26232@openwall.com>
References: <20110626194618.GA21740@elte.hu>
	<20110626202518.GA4915@albatros>
	<20110626220126.GA24004@elte.hu>
	<20110627083633.GA5846@albatros>
	<20110627104058.45e93c41@pyx>
	<20110627183829.GA16033@albatros>
	<BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com>
	<20110701120059.GL20990@elte.hu>
	<20110701125411.GA21551@albatros>
	<20110701152051.763fd594@lxorguk.ukuu.org.uk>
	<20110702164243.GB26232@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
To: Solar Designer <solar@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Vasiliy Kulikov <segoon@openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

> > Your syslog daemon appears to need improvement
> 
> syslogd definitely should (and does) perform escaping of control chars
> for logs written through it.
> 
> > and that would be the right fix for dmesg etc.
> 
> How?  We can't realistically expect everyone to stop invoking dmesg
> directly.  Moreover, this is sometimes useful, although someone who is

No but you could make "dmesg" do filtering.

Alan
