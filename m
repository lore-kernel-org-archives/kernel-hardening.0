Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 3 Jul 2011 13:23:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <20110703132311.3c184354@lxorguk.ukuu.org.uk>
In-Reply-To: <20110703100131.GA2472@albatros>
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
	<20110703100131.GA2472@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

> Also, the problem with CSI code is still here.  It cannot be filtered
> because it is a valid byte inside of UTF-8 character.  For a console
> with IUTF bit set all dangerous characters are filtered, but for the
> rest they are not.  As at the stage of vscnprintf the presence of IUTF
> bit is not clear, users of non-IUTF console should still use "| less" or
> similar.  Obviously, \n is filtered for all consoles.

This is why the filter pattern has to come from the console. Your patch
also for example doesn't fix anything on a 7bit serial console.. only the
hardware driver really knows what the filter rules are.

Looks a very good starting point though, and the embedded \n's mostly
want fixing up anyway.
