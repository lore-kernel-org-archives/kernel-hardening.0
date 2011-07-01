Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 1 Jul 2011 18:37:57 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110701143757.GA22567@albatros>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 28, 2011 at 12:30 -0700, Linus Torvalds wrote:
> And the most dangerous character seems to be one that you don't
> filter: the one we really do react to is '\n', and you could possibly
> make confusing log messages by embedding a newline in your string and
> then trying to make the rest look like something bad (say, an oops).

Btw, I've already outlined this problem in patch v1 comment, but
received no single comment on the suggested 2 possible ways:

http://www.openwall.com/lists/kernel-hardening/2011/06/22/2

"This patch does nothing with crafted "%s" data with '\n' inside.  It
 allows unprivileged user to craft arbitrary log messages via breaking
 log lines boundaries.  It is a bit tricky to fix it compatible way.
 Limiting "%s" to one line in vscnprintf() would break legitimate users
 of the multiline feature.  Intoducing new "%S" format for single lines
 makes little sense as there are tons of printk() calls that should be
 already restricted to one line.

 Proposals about '\n' inside of '%s" are welcome."

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
