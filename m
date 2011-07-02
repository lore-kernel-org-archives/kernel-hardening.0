Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 2 Jul 2011 08:08:01 -0700
From: Greg KH <gregkh@suse.de>
Message-ID: <20110702150801.GA14453@suse.de>
References: <20110626194618.GA21740@elte.hu>
 <20110626202518.GA4915@albatros>
 <20110626220126.GA24004@elte.hu>
 <20110627083633.GA5846@albatros>
 <20110627104058.45e93c41@pyx>
 <20110627183829.GA16033@albatros>
 <BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com>
 <20110701143757.GA22567@albatros>
 <20110701154947.133c30f5@lxorguk.ukuu.org.uk>
 <20110702081022.GA2755@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110702081022.GA2755@albatros>
Subject: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jul 02, 2011 at 12:10:22PM +0400, Vasiliy Kulikov wrote:
> Greg - do you know any devices supplying multibyte strings, but not in
> UTF-8 encoding?  If yes, then CSI filtering is a bad idea :\

USB is "supposed" to have UTF-16 strings, but there's devices out there
that have crazy stuff in them.  And of course, anyone can put anything
in the device string if they know how to write a bit of firmware, so we
have to watch out for that.  Hopefully we handle that properly in the
usb_string() function in the kernel but review of it is always nice to
have.

Other than that, I don't know of any multi-byte strings in devices at
the moment.  I haven't seen the Thunderbolt specs though, so who knows
what is coming next.

Hope this helps,

greg k-h
