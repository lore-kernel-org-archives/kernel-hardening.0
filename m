Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110702203323.03462aef@lxorguk.ukuu.org.uk>
References: <20110626194618.GA21740@elte.hu> <20110626202518.GA4915@albatros>
 <20110626220126.GA24004@elte.hu> <20110627083633.GA5846@albatros>
 <20110627104058.45e93c41@pyx> <20110627183829.GA16033@albatros>
 <BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com> <20110701120059.GL20990@elte.hu>
 <20110701125411.GA21551@albatros> <20110701152051.763fd594@lxorguk.ukuu.org.uk>
 <20110702164243.GB26232@openwall.com> <20110702203323.03462aef@lxorguk.ukuu.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 2 Jul 2011 13:34:33 -0700
Message-ID: <CA+55aFx6ShKkDjt=xdLPY1iVr4u06DMs41g-6HEqsPO8NhZAjA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and control characters in printk()
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Solar Designer <solar@openwall.com>, kernel-hardening@lists.openwall.com, Vasiliy Kulikov <segoon@openwall.com>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jul 2, 2011 at 12:33 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> No but you could make "dmesg" do filtering.

So I really hate doing the filtering at the level that the original
patch did, but I would _not_ mind doing the filtering at "vsnprintf()"
time.

Even without some magic "safe" flag, in fact.

So I would not even be opposed to "%s" just doing filtering (including
considering "\n" to be a control character) by default. So "\n" would
be ok in the format string (where it is pretty common), but not for
%s.

For kernel uses that really want raw strings, we could have a %p
sequence, the way we handle other special formats.

However, that would be a patch that would need a lot more testing,
since we'd have to find the users that really do want control
characters.

                              Linus
