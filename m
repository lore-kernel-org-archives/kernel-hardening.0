Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 27 Jun 2011 12:36:33 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110627083633.GA5846@albatros>
References: <20110623152137.GA2536@albatros>
 <20110626103915.GB11093@elte.hu>
 <20110626165409.GA2584@albatros>
 <20110626182628.GA20158@elte.hu>
 <20110626190622.GB4217@albatros>
 <20110626194618.GA21740@elte.hu>
 <20110626202518.GA4915@albatros>
 <20110626220126.GA24004@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110626220126.GA24004@elte.hu>
Subject: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 27, 2011 at 00:01 +0200, Ingo Molnar wrote:
> * Vasiliy Kulikov <segoon@openwall.com> wrote:
> > On Sun, Jun 26, 2011 at 21:46 +0200, Ingo Molnar wrote:
> > > No, because the problems such a mistake causes are not equivalent: it 
> > > would have been far more harmful to not print out the *very real* 
> > > product names written in some non-US language than to accidentally 
> > > include some control character you did not think of.
> > 
> > ???
> > 
> > Not "not print", but print in "crypted" form.  The information is 
> > still not lost, you can obviously restore it to the original form, 
> > with some effort, but possible.  Compare it with the harm of log 
> > spoofing - it is not "restorable".
> 
> The harm of 'potential' log spoofing affecting exactly zero known 
> users right now,

???

A potential thing affects all users that *can be* affected by actual
log spoofing.  This is what the word "potential" means.

Analogy: if some privilege escalation bug is found in some very core
code then all users iteracting with an untrusted security domains
(local users, network, etc.) being able to exploit it would be affected.
It is silly to say that nobody is affected because you just don't know
any such cases of this bug exploitation in the past.


> > > > > A black list is well-defined: it disables the display of 
> > > > > certain characters because they are *known to be dangerous*.
> > > > 
> > > > What do you do with dangerous characters that are *not yet known* 
> > > > to be dangerous?
> > > 
> > > I'm ready to act on facts only.
> > 
> > The *fact* is you/anybody/everybody might not know all bad things.  
> > If you just don't care because it is yet unknown then you will be 
> > vulnerable as soon as it disclosured.
> 
> Erm, do you claim that it's not possible to know which characters are 
> dangerous and which ones not?

A sample:

Is BEL dangerous?  I can imagine 200 BELs/scrolls down would hang a
slow tty by a considerable amount of time without ^C ability to kill the
log viewer.  On the rest ttys it is harmless.  Even Alan wanted to add
it to the white list, not just exclude from the black list.


If someone skilled in the TTY codes provides us the full analysis of tty
code table with *a proof* what codes are harmfull (in the sense of
logging) and what are not, the question would be closed.  I'm not
skilled it in, I'd not try to do it (maybe the manpage is incomplete?).
I've reported just the *known for sure* farmfull sequence (the first
report of cntrl chars harm belogs to Solar Designer and dates to 2006:
http://lists.openwall.net/linux-kernel/2006/08/22/29).


> > > Also, i really prefer the policy of acting on known dangers 
> > > instead of being afraid of the unknown.
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > Do you know the principle "Attacks always get better, never worse"?  
> > If you are protected against only of known attack, you will be 
> > vulnerable to *every* danger not known to you.
> > 
> > Maybe you don't know, but it is really possible to be protected 
> > against some *yet unknown* attack techniques.  (The assessment of 
> > what attacks it protects against is undefined too, though.)  And 
> > upstream Linux is *already* protected against some *yet unknown* 
> > bugs, not the whole bug classes, but at least small kinds of it.
> 
> This claim is silly - do you claim some 'unknown bug' in the ASCII 
> printout space?

You were talking about dangers in general, I'm answering about it in
general too.


> Cannot you be bothered to enumerate the known 'bad' control and 
> escape characters?

Note it is not bad characters, but character sequences.  You cannot just
grep for bad substrings because of KERN_CONT (because the black list means
everything not denied is permitted, and breaking ctrl sequence is then
permitted, right?), so you have to define a state machine for this
filtering (if you want to filter just only bad charsequences).  It looks
too complicated for me for this little thing - just to write to a log
with user supplied data.  But you say it is simplier and safer, maybe
you will do it?


> You *clearly* did not consider the full utility spectrum in the first 
> version of the patch

Sure, that's why maintainers exist and they should be competent to
ack/nak the solution that does/doesn't fit the actual needs.

BTW, it has happened because of missing clear conversions about what
characters printk() can be fed.  In the comment the encoding is not
mentioned, only "See also: printf(3)", which might be related to format
strings only.

Also '\n' problem with multiline messages wouldn't arrise if printk()
was clearly declared as a function logging exactly one line.


> > > > > A white list on the other hand does it the wrong way around: 
> > > > > it tries to put the 'burden of proof' on the useful, good 
> > > > > guys - and that's counter-productive really.
> > > > 
> > > > Really?  I think strict API definition is productive, unlike 
> > > > using it in cases where it looks like working, but creating 
> > > > tricky and obscure bugs.
> > > 
> > > You werent really creating a well-defined API here, were you?
> > 
> > No, I was - only ascii chars and \n are allowed.  In v2 all ascii 
> > chars, the upper charset and 2 control chars are allowed.  Rather 
> > clear, IMO.
> 
> Please enumerate the space you excluded

All control characters except space chars (tabs and \n) are not needed
for the log purposes, they define the cursor position, output colors,
and tty modes.  All this is not needed for log purposes, it is a cynical
log, not a cristmas tree.


> and the reason for exclusion.

Note that *you* want to define a black list with a clear denied
semantics, I want to do the reverse - to define the allowed semantics,
which additionally implies better API semantics understanding.  I don't
need to enumerate all evils, I'm evading it by defining what one can do
for sure.


I don't understand why you so resist to define API more clear to avoid
other possible problems in the future.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
