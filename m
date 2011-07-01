Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 1 Jul 2011 15:20:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <20110701152051.763fd594@lxorguk.ukuu.org.uk>
In-Reply-To: <20110701125411.GA21551@albatros>
References: <20110626182628.GA20158@elte.hu>
	<20110626190622.GB4217@albatros>
	<20110626194618.GA21740@elte.hu>
	<20110626202518.GA4915@albatros>
	<20110626220126.GA24004@elte.hu>
	<20110627083633.GA5846@albatros>
	<20110627104058.45e93c41@pyx>
	<20110627183829.GA16033@albatros>
	<BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com>
	<20110701120059.GL20990@elte.hu>
	<20110701125411.GA21551@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and
 control characters in printk()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

> $ dmesg | tail
> ...
> [16291.982492] init[21579]: segfault at 0 ip 00007f527186028a sp 00007fff08251dd8 error 4 in libc-2.11.1.so[7f52717d8000+17a000]
> [16379.001357] fail[21586]: segfault at 0 ip 00007f332831028a sp 00007fffc52de568 error 4 in libc-2.11.1.so[7f3328288000+17a000]
> $ 
> (see 1234 => init change)
> 
> As you see here, the previous log entry was showed not as it was
> initally logged.  Core dump message was chosen fully arbitrary, just to
> show that some specific part of it can be "edited".

Your syslog daemon appears to need improvement and that would be the
right fix for dmesg etc.

The other case is the actual printk direct to console case, particularly
on a serial port. That one actually has more potential for actual
annoyance.
