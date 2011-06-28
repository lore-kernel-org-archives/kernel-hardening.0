Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110627183829.GA16033@albatros>
References: <20110623152137.GA2536@albatros> <20110626103915.GB11093@elte.hu>
 <20110626165409.GA2584@albatros> <20110626182628.GA20158@elte.hu>
 <20110626190622.GB4217@albatros> <20110626194618.GA21740@elte.hu>
 <20110626202518.GA4915@albatros> <20110626220126.GA24004@elte.hu>
 <20110627083633.GA5846@albatros> <20110627104058.45e93c41@pyx> <20110627183829.GA16033@albatros>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Jun 2011 12:30:14 -0700
Message-ID: <BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and control characters in printk()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 27, 2011 at 11:38 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>
> Sure, I don't propose it anymore (v2 goes without it).

What point would you like to filter things at?

I really think that user space should do its own filtering - nobody
does a plain 'cat' on dmesg. Or if they do, they really have
themselves to blame.

And afaik, we don't do any escape sequence handling at the console
level either, so you cannot mess up the console with control
characters.

And the most dangerous character seems to be one that you don't
filter: the one we really do react to is '\n', and you could possibly
make confusing log messages by embedding a newline in your string and
then trying to make the rest look like something bad (say, an oops).

So I'm not entirely convinced about this filtering at all.

                     Linus
