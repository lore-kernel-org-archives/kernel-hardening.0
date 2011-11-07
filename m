Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 7 Nov 2011 23:54:28 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111107195428.GA5362@albatros>
References: <20111107174522.GA2317@albatros>
 <9718.1320689192@turing-police.cc.vt.edu>
 <20111107190112.GA3732@albatros>
 <4EB82F08.8060209@zytor.com>
 <20111107192915.GA4690@albatros>
 <CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to
 /proc/interrupts
To: Eric Paris <eparis@parisplace.org>
Cc: kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 07, 2011 at 14:48 -0500, Eric Paris wrote:
> On Mon, Nov 7, 2011 at 2:29 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> > On Mon, Nov 07, 2011 at 11:18 -0800, H. Peter Anvin wrote:
> 
> > As to procfs, I see no real need of adding mode/group mount option for
> > global procfs files (/proc/interrupts, /proc/stat, etc.) - it can be
> > done by distro specific init scripts (chown+chmod).  I don't mind
> > against such an option for the convenience, though.
> 
> While possible, the chmod+chown 'solutions' just aren't as simple as
> you pretend.  Every time one creates a chroot environment and mounts
> /proc it has be manually fixed there as well.  Same thing with a
> container.

I admit I don't fully realize all possible containers' uses, but doesn't
procfs is mounted inside of containers for only restricted full-featured
Linux distros usermods with the whole init and init scripts set?  I
didn't see any consistent usages of procfs for other things, do they
exist?

Creating separate namespaces is very useful for additional daemon
restrictions like vsftpd does it, but procfs inside of such namespace is
obviously denied by design ;)


And as procfs is a one instance per pid namespace, it has the same
permissions in all mount points, so I see no problem with chroot
(however, I find chroot not very useful with procfs inside).

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
