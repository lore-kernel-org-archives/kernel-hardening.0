Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110703221031.15cc2278@lxorguk.ukuu.org.uk>
References: <20110626190622.GB4217@albatros> <20110626194618.GA21740@elte.hu>
 <20110626202518.GA4915@albatros> <20110626220126.GA24004@elte.hu>
 <20110627083633.GA5846@albatros> <20110627104058.45e93c41@pyx>
 <20110627183829.GA16033@albatros> <BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com>
 <20110701143757.GA22567@albatros> <20110701154947.133c30f5@lxorguk.ukuu.org.uk>
 <20110703100131.GA2472@albatros> <CA+55aFz08cObjcHxxZ-FQexP56hwHvML+c+UULQitKMum3MoTA@mail.gmail.com>
 <20110703221031.15cc2278@lxorguk.ukuu.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 3 Jul 2011 14:34:39 -0700
Message-ID: <CA+55aFwWkfYQbdgxYg3Wo-9o1XqPQcOPt9=u1E0zeMzZe30R9w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and control characters in printk()
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jul 3, 2011 at 2:10 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> In which case we can't do it because we need \n in proc content so that's
> a complete and utter non starter.

You didn't read the original email I sent, did you?

For people who _want_ the unsafe versions with \n and other control
characters, they'd use a "raw string" format. Something like our
extended "%p" formats. Maybe '%p[]' - we could allow extensions later
that describe which characters to escape inside the brackets (for
example, we currently have ad-hoc escaping of things like pathnames:
with '/' not being legal in a path component)

The point being that that way it would be (a) safe by default (b)
require _thought_ when you actually wanted to print control characters
and (c) be easily greppable too.

                           Linus
