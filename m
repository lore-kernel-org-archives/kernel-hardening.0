Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20111107192915.GA4690@albatros>
References: <20111107174522.GA2317@albatros>
	<9718.1320689192@turing-police.cc.vt.edu>
	<20111107190112.GA3732@albatros>
	<4EB82F08.8060209@zytor.com>
	<20111107192915.GA4690@albatros>
Date: Mon, 7 Nov 2011 14:48:15 -0500
Message-ID: <CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com>
From: Eric Paris <eparis@parisplace.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to /proc/interrupts
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 7, 2011 at 2:29 PM, Vasiliy Kulikov <segoon@openwall.com> wrote=
:
> On Mon, Nov 07, 2011 at 11:18 -0800, H. Peter Anvin wrote:

> As to procfs, I see no real need of adding mode/group mount option for
> global procfs files (/proc/interrupts, /proc/stat, etc.) - it can be
> done by distro specific init scripts (chown+chmod). =A0I don't mind
> against such an option for the convenience, though.

While possible, the chmod+chown 'solutions' just aren't as simple as
you pretend.  Every time one creates a chroot environment and mounts
/proc it has be manually fixed there as well.  Same thing with a
container.  Sure if /proc were something that was only ever mounted
one time on a box it wouldn't be so bad, but that's not the case.....
