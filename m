Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 8 Nov 2011 13:11:21 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111108091121.GA10198@albatros>
References: <20111107192915.GA4690@albatros>
 <CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com>
 <4EB83674.3040207@zytor.com>
 <20111107201120.GA5775@albatros>
 <4EB843FF.5080201@zytor.com>
 <CA+55aFwYGivYFZTLprSB+oDm3E4MG0s3PEQabs166v6YRL5u-Q@mail.gmail.com>
 <4EB84F05.1000704@zytor.com>
 <CA+55aFxFNaRuTx-0vx+RhrkavrcNDiDh5jxcRyWPy8-QZHGD9A@mail.gmail.com>
 <20111107232132.2c6880a5@lxorguk.ukuu.org.uk>
 <20111107232750.GA4854@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107232750.GA4854@kroah.com>
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to
 /proc/interrupts
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Eric Paris <eparis@parisplace.org>, kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 07, 2011 at 15:27 -0800, Greg KH wrote:
> So, what do we really need revoke() for these days?

revoke() of /proc/$PID/* descriptors would also solve the issue of
keeping them across exec() of setuid/setgid binaries:

https://lkml.org/lkml/2011/2/7/368

Currently there are explicit calls to lock_trace()/unlock_trace(), which
(1) pollute the code and (2) significantly slow it down.


So, where are we now?  We tend to agree revoke() is needed, but what to
do before it is implemented?  In the context of this thread I see the
following problems:

/proc/{interrupts,stat} are 0444, which may be used by local attacker to
learn statistical information about user's keystrokes, including the
passwords.

/dev/pts/* and /dev/tty* leak the same timing information in inode's
atime and mtime.


Do we want to restrict permissions of interrupts/stat and remove atime
and mtime from ttys and relax these permissions when revoke() is introduced?


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
