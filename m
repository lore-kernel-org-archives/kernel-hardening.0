Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 8 Nov 2011 00:19:08 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111107201908.GA5827@albatros>
References: <20111107174522.GA2317@albatros>
 <9718.1320689192@turing-police.cc.vt.edu>
 <20111107190112.GA3732@albatros>
 <4EB82F08.8060209@zytor.com>
 <14202.1320696659@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14202.1320696659@turing-police.cc.vt.edu>
Subject: [kernel-hardening] Re: [PATCH] proc: restrict access to /proc/interrupts
To: Valdis.Kletnieks@vt.edu
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 07, 2011 at 15:10 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 07 Nov 2011 11:18:32 PST, "H. Peter Anvin" said:
> 
> > I would like to propose that we add a mount option to procfs, and
> > possibly sysfs, called, say, admingrp.  These kinds of files then get
> > restricted to the admingrp (defaulting to gid 0 if no admingrp is
> > provided).  Historically on Unix there has been a group of people
> > (usually "adm", but sometimes "log") who are allowed to read (but not
> > write) the log files, which also contains potentially sensitive information.
> 
> Probably should be a two part - mount with 'gid=NNN', and then a
> perm=027 or whatever, to be treated similar to a umask.  So 027
> would allow root to do anything, would disable write for the gid= group,
> and turn it off completely for others.  Less paranoid sites could mount
> it with perm=002.
> 
> Does that cover most of the use cases?

At the time of Linux 2.0-2.4 in Owl patch there was a plain on/off
configure option - 022 / 066 umask.  Currently procfs restriction is
implemented in Grsecurity with the same all-or-nothing approach.
Brad Spengler told me that there were no user complains about the lack of
flexibility :-)   So, I agree that we don't need anything more complex.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
