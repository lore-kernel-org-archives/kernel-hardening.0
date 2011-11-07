Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 7 Nov 2011 23:01:12 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111107190112.GA3732@albatros>
References: <20111107174522.GA2317@albatros>
 <9718.1320689192@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9718.1320689192@turing-police.cc.vt.edu>
Subject: [kernel-hardening] Re: [PATCH] proc: restrict access to /proc/interrupts
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

(cc'ed LSM@, kernel-hardening and Linus)

On Mon, Nov 07, 2011 at 13:06 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 07 Nov 2011 21:45:22 +0400, Vasiliy Kulikov said:
> > /proc/interrupts contains the number of emitted interrupts, which
> > should not be world readable.  The information about keyboard
> > interrupts number may be used to learn the precise number of characters in
> > users' passwords by simply watching the changes of number of emitted
> > interrupts during the life of gksu-like programs.
> > 
> > The PoC is publicly available at:
> > 
> > http://www.openwall.com/lists/oss-security/2011/11/07/9
> 
> This doesn't close the hole entirely.  You can still figure it out by
> watching the files in /dev/pts/ and /dev/tty* for changes in last-modify
> time.

Good point, thanks.  Also I've missed /proc/stat - it contains the same
interrupt counters.


> This whack-a-mole  "turn off permissions on generally useful files because
> there's an exposure" really has to stop.

I dissagree with you.  If not pay an attention to historical procfs
flaws, they will never be fixed.  If we know some subsystem leaks much
private information because of some historical incidents, we still must
fix it.  If some subsystem has flaws here and there, it probably needs
a redesign or at least more accurate audit.


> On probably the vast majority of
> Linux systems, it's an embedded or a laptop/desktop, and if you have a
> malicious user running code on it already, the fact they can find out how many
> characters are in the password is the *least* of your problems.

Sure, but 2 notes here.

First, the number of characters is indeed not really harmful, but the
precise timings can provide additional information, which can be matched
against the statistical information about how much time it takes to move
fingers between different keys.  This can be used to gain a valuable
probabilistic information about the password characters, and running the
attack several times can result in the _precise_ passwords learning.  The
details of the attack can be found here:

https://db.usenix.org/event/sec09/tech/full_papers/zhang.pdf


Second, ability to protect local users from each other is a core
feature of multiuser systems.  One user must not get private keys of
other users, must not be able to listen ttys of other users, etc.  The
issue with side channel attacks is much more complex (e.g. it's really
hard to design a scheduler to remove all possible indirect infoleaks via
schedule delays), but the issue in question is not so tricky, quite the
opposite - relaxed permissions.


> This sort of thing needs to be done as part of an overall security model
> (in other words, something like Smack or SELinux should be moderating
> the accesses

Huh?  Do you claim that current Linux doesn't implement the multiuser
system _by design_?  Do you say every distro that doesn't use any LSMs
(like Debian) is actually not a true multiuser system?  Or am I missing
your point?


> in a more fine-grained manner than "chmod it to 0").

What's wrong with old good DAC?  You can create a group "sysinfo", do
"chown sysinfo /proc/interrupts", and add the permitted users to the
group.  If you need to give different access levels to different interrupts,
you need another /proc/interrupts design, it does nothing with DAC vs. LSM.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
