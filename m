Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 27 Jul 2011 12:15:49 +1000
From: NeilBrown <neilb@suse.de>
Message-ID: <20110727121549.67a84d18@notabene.brown>
In-Reply-To: <20110726144848.GA7133@albatros>
References: <1310759683.30257.123.camel@moss-pluto>
	<20110721140936.632d2c8b@notabene.brown>
	<20110721124830.GA1325@openwall.com>
	<CA+55aFy4ybatb0McQr2f4A56ympZVLqK2sbp2=73idu58_4RxQ@mail.gmail.com>
	<20110721193939.GA3914@openwall.com>
	<20110725171423.GA3739@albatros>
	<20110725234013.GB24110@openwall.com>
	<20110726104713.37273143@notabene.brown>
	<20110726011629.GA24610@openwall.com>
	<20110726141118.32f948e0@notabene.brown>
	<20110726144848.GA7133@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [patch v2] move RLIMIT_NPROC check from set_user() to
 do_execve_common()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Solar Designer <solar@openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Willy Tarreau <w@1wt.eu>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 26 Jul 2011 18:48:48 +0400 Vasiliy Kulikov <segoon@openwall.com>
wrote:

> Neil, Solar,
> 
> On Tue, Jul 26, 2011 at 14:11 +1000, NeilBrown wrote:
> > I don't really see that failing mmap is any more hackish than failing execve.
> > 
> > Both are certainly hacks.  It is setuid that should fail, but that is
> > problematic.
> > 
> > We seem to agree that it is acceptable to delay the failure until the process
> > actually tries to run some code for the user.  I just think that
> > mapping-a-file-for-exec is a more direct measure of "trying to run some code
> > for the user" than "execve" is.
> > 
> > So they are both hacks, but one it more thorough than the other.  In the
> > world of security I would hope that "thorough" would win.
> 
> Well, I don't mind against something more generic than the check in
> execve(), however, the usefulness of the check in mmap() is unclear to
> me.  You want to make more programs fail after setuid(), but does mmap
> stops really many programs?  Do you know any program doing mmap/dlopen
> after setuid() call?  What if the program will not do any mmap/dlopen
> and e.g. start to handle network connections or do some computations?
> I suppose the latter case is much more often than mmap/dlopen.

I think I didn't make myself clear.
I don't mean we should intercept the mmap system call.

I mean we could intercept the internal kernel function do_mmap_pgoff.

This is used by the mmap system call but also (and more importantly) by the
execve system call and the uselib system call.

So any attempt to map a file and execute the code in that file - whether via
exec or via mapping a shared object - will go through do_mmap_pgoff.

So if we disable do_mmap_pgoff() requests which ask for execute permission
when a setuid has caused RLIMIT_NPROC to be exceeded, then we catch every
attempt to run the user's code as the user.

I won't catch a situation where an interpreter is already loaded into the
root-owned process and the setuid is followed by loading a script and running
that, it is isn't perfect.  But I think it is more general than just trapping
in execve.

NeilBrown
