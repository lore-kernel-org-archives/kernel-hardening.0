Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 8 Nov 2011 21:41:54 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111108174154.GA21436@albatros>
References: <4EB83674.3040207@zytor.com>
 <20111107201120.GA5775@albatros>
 <4EB843FF.5080201@zytor.com>
 <CA+55aFwYGivYFZTLprSB+oDm3E4MG0s3PEQabs166v6YRL5u-Q@mail.gmail.com>
 <4EB84F05.1000704@zytor.com>
 <CA+55aFxFNaRuTx-0vx+RhrkavrcNDiDh5jxcRyWPy8-QZHGD9A@mail.gmail.com>
 <20111107232132.2c6880a5@lxorguk.ukuu.org.uk>
 <20111107232750.GA4854@kroah.com>
 <20111108091121.GA10198@albatros>
 <20111108132326.214bcaf8@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108132326.214bcaf8@lxorguk.ukuu.org.uk>
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to
 /proc/interrupts
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Eric Paris <eparis@parisplace.org>, kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 08, 2011 at 13:23 +0000, Alan Cox wrote:
> > /proc/{interrupts,stat} are 0444, which may be used by local attacker to
> > learn statistical information about user's keystrokes, including the
> > passwords.
> 
> So the distro can chmod it 0400

Sorry, but I miss the logic.  Why do you think it's better to leave the
known unsecure defaults and rely on distros fix the permissions?  Why
not restrict it to the secure defaults and leave the decision who to
trust (i.e. all users, only current user, nobody) to distros?  The
decision has to be done either way, but in the 1st case the harm of lack
of chmod is much more significant.


> > /dev/pts/* and /dev/tty* leak the same timing information in inode's
> > atime and mtime.
> 
> That one is trickier. I don't think it is a real leak because the last
> update timing info is in seconds granularity so is pretty useless for
> that.

No, I see the precise counters:

S=''; while :; do N=`stat -L /dev/pts/3 | sed -n 5p`; [ "$N" != "$S" ] && echo "$N"; S=$N;  done

Access: 2011-11-08 21:25:41.219869215 +0400
Access: 2011-11-08 21:25:41.249869259 +0400
Access: 2011-11-08 21:25:41.289869313 +0400
Access: 2011-11-08 21:25:41.329869368 +0400
Access: 2011-11-08 21:25:41.369869433 +0400
Access: 2011-11-08 21:25:41.399869479 +0400
Access: 2011-11-08 21:25:41.439869532 +0400
Access: 2011-11-08 21:25:41.479869591 +0400
Access: 2011-11-08 21:25:41.519869655 +0400
Access: 2011-11-08 21:25:41.549869697 +0400


> The atime/mtime behaviour is however required ABI and used by
> applications so can't simply go away.

Sure, we cannot remove atime/mtime from struct stat for ttys, but we can
leave these fields zero (or equal to any const sane date) if we know
that the tty owner and the process belong to different security domains
(euid check or smth. like may_ptrace()).  The quesion here is: are there
users of checking time counters of _foreign_ ttys?  If no, leaving these
counters blank will not break anything.


> > Do we want to restrict permissions of interrupts/stat and remove atime
> > and mtime from ttys and relax these permissions when revoke() is introduced?
> 
> revoke makes no difference I can see to either of these, they appear to
> be a completely unrelated discussion.

/proc/$PID/* will certainly benefit from revoke() - all ptrace check
could be made at open time, not on every read()/write() invocation.

/proc/* will benefit from revoke() if the permission logic is
implemented as Linus wants to see it - as dynamically re-chown'ed files,
which invalidate old fds on re'chown.

tty issue is indeed unrelated, sorry for the confusion.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
