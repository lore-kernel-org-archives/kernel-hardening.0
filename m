Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 5 Jul 2011 21:49:22 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110705174922.GA6419@albatros>
References: <20110626202518.GA4915@albatros>
 <20110626220126.GA24004@elte.hu>
 <20110627083633.GA5846@albatros>
 <20110627104058.45e93c41@pyx>
 <20110627183829.GA16033@albatros>
 <BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com>
 <20110701143757.GA22567@albatros>
 <20110701154947.133c30f5@lxorguk.ukuu.org.uk>
 <20110703100131.GA2472@albatros>
 <CA+55aFz08cObjcHxxZ-FQexP56hwHvML+c+UULQitKMum3MoTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz08cObjcHxxZ-FQexP56hwHvML+c+UULQitKMum3MoTA@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and
 control characters in printk()
To: kernel-hardening@lists.openwall.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jul 03, 2011 at 10:42 -0700, Linus Torvalds wrote:
> So saying "%s is for pure 7-bit ASCII with no control codes" is
> annoying, but would really fix it.

Hmm..  It breaks usb UTF-8 strings for sure.  I see some printks in
debugging code.  There might be other users of UTF-8 strings fed to
printk().

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
