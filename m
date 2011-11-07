Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 7 Nov 2011 23:29:15 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111107192915.GA4690@albatros>
References: <20111107174522.GA2317@albatros>
 <9718.1320689192@turing-police.cc.vt.edu>
 <20111107190112.GA3732@albatros>
 <4EB82F08.8060209@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB82F08.8060209@zytor.com>
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to
 /proc/interrupts
To: kernel-hardening@lists.openwall.com
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 07, 2011 at 11:18 -0800, H. Peter Anvin wrote:
> On 11/07/2011 11:01 AM, Vasiliy Kulikov wrote:
> > 
> > What's wrong with old good DAC?  You can create a group "sysinfo", do
> > "chown sysinfo /proc/interrupts", and add the permitted users to the
> > group.  If you need to give different access levels to different interrupts,
> > you need another /proc/interrupts design, it does nothing with DAC vs. LSM.
> > 
> 
> I would like to propose that we add a mount option to procfs, and
> possibly sysfs, called, say, admingrp.

Similar proposals:

(procfs for /proc/$PID/* permissions, sorry about different threads)
https://lkml.org/lkml/2011/6/15/172
https://lkml.org/lkml/2011/6/15/174
https://lkml.org/lkml/2011/6/15/173
https://lkml.org/lkml/2011/6/15/177
https://lkml.org/lkml/2011/6/15/175
https://lkml.org/lkml/2011/6/15/176

(change uid/gid for newly created sysfs objects)
https://lkml.org/lkml/2011/5/18/272


As to procfs, I see no real need of adding mode/group mount option for
global procfs files (/proc/interrupts, /proc/stat, etc.) - it can be
done by distro specific init scripts (chown+chmod).  I don't mind
against such an option for the convenience, though.


> The current Linux trend seems to be do instead force those users to
> become root constantly, which is *not* helping the situation.

Agreed.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
