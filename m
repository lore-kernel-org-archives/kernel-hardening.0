Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 8 Nov 2011 00:11:20 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111107201120.GA5775@albatros>
References: <20111107174522.GA2317@albatros>
 <9718.1320689192@turing-police.cc.vt.edu>
 <20111107190112.GA3732@albatros>
 <4EB82F08.8060209@zytor.com>
 <20111107192915.GA4690@albatros>
 <CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com>
 <4EB83674.3040207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB83674.3040207@zytor.com>
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to
 /proc/interrupts
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Paris <eparis@parisplace.org>, kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 07, 2011 at 11:50 -0800, H. Peter Anvin wrote:
> On 11/07/2011 11:48 AM, Eric Paris wrote:
> > On Mon, Nov 7, 2011 at 2:29 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> >> On Mon, Nov 07, 2011 at 11:18 -0800, H. Peter Anvin wrote:
> > 
> >> As to procfs, I see no real need of adding mode/group mount option for
> >> global procfs files (/proc/interrupts, /proc/stat, etc.) - it can be
> >> done by distro specific init scripts (chown+chmod).  I don't mind
> >> against such an option for the convenience, though.
> > 
> > While possible, the chmod+chown 'solutions' just aren't as simple as
> > you pretend.  Every time one creates a chroot environment and mounts
> > /proc it has be manually fixed there as well.  Same thing with a
> > container.  Sure if /proc were something that was only ever mounted
> > one time on a box it wouldn't be so bad, but that's not the case.....
> 
> Yes, for a filesystem that dynamically creates nodes, a static script
> just doesn't work well.  Control options do, like we have for devpts for
> example.

My statement was about static files - /proc/{interrupts,meminfo,stat,cpuinfo}.
They don't change during the system life.  /proc/$PID/* files are indeed
dymanic and the first link in my quoted email was about addition of such
mount options.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
