Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 2 Jul 2011 20:42:43 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110702164243.GB26232@openwall.com>
References: <20110626194618.GA21740@elte.hu> <20110626202518.GA4915@albatros> <20110626220126.GA24004@elte.hu> <20110627083633.GA5846@albatros> <20110627104058.45e93c41@pyx> <20110627183829.GA16033@albatros> <BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com> <20110701120059.GL20990@elte.hu> <20110701125411.GA21551@albatros> <20110701152051.763fd594@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701152051.763fd594@lxorguk.ukuu.org.uk>
Subject: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and control characters in printk()
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: kernel-hardening@lists.openwall.com, Vasiliy Kulikov <segoon@openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jul 01, 2011 at 03:20:51PM +0100, Alan Cox wrote:
> > $ dmesg | tail
> > ...
> > [16291.982492] init[21579]: segfault at 0 ip 00007f527186028a sp 00007fff08251dd8 error 4 in libc-2.11.1.so[7f52717d8000+17a000]
> > [16379.001357] fail[21586]: segfault at 0 ip 00007f332831028a sp 00007fffc52de568 error 4 in libc-2.11.1.so[7f3328288000+17a000]
> > $ 
> > (see 1234 => init change)
> > 
> > As you see here, the previous log entry was showed not as it was
> > initally logged.  Core dump message was chosen fully arbitrary, just to
> > show that some specific part of it can be "edited".
> 
> Your syslog daemon appears to need improvement

syslogd definitely should (and does) perform escaping of control chars
for logs written through it.

> and that would be the right fix for dmesg etc.

How?  We can't realistically expect everyone to stop invoking dmesg
directly.  Moreover, this is sometimes useful, although someone who is
aware of the risk and who cares about it would do "dmesg | less".  The
problem is that most people are not aware, and we can't change that.

> The other case is the actual printk direct to console case, particularly
> on a serial port. That one actually has more potential for actual
> annoyance.

Right.

Alexander
