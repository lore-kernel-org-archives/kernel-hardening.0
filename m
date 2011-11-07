Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 7 Nov 2011 23:21:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <20111107232132.2c6880a5@lxorguk.ukuu.org.uk>
In-Reply-To: <CA+55aFxFNaRuTx-0vx+RhrkavrcNDiDh5jxcRyWPy8-QZHGD9A@mail.gmail.com>
References: <20111107174522.GA2317@albatros>
	<9718.1320689192@turing-police.cc.vt.edu>
	<20111107190112.GA3732@albatros>
	<4EB82F08.8060209@zytor.com>
	<20111107192915.GA4690@albatros>
	<CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com>
	<4EB83674.3040207@zytor.com>
	<20111107201120.GA5775@albatros>
	<4EB843FF.5080201@zytor.com>
	<CA+55aFwYGivYFZTLprSB+oDm3E4MG0s3PEQabs166v6YRL5u-Q@mail.gmail.com>
	<4EB84F05.1000704@zytor.com>
	<CA+55aFxFNaRuTx-0vx+RhrkavrcNDiDh5jxcRyWPy8-QZHGD9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to
 /proc/interrupts
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Vasiliy Kulikov <segoon@openwall.com>, Eric Paris <eparis@parisplace.org>, kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

> Why? Because the problem really isn't about opening the file. The
> problem is about any access: once you've opened the file, you *still*
> must not be able to read the data from it if you have logged out and
> somebody else has logged in. Think opening the microphone (which you
> *should* be able to do) and just keeping it open until the next user
> logs in.

We need minimal revocation stuff. This hasn't changed in years. You can
mostly work around it with SELinux but the underlying problem is that you
need a small controlled subset of revokable devices and objects and a
meaningful way to revoke them.

The latter is hard to do with a simple noddy model because there are
multi-user systems with multiple audio devices, multiple displays and the
like where the mapping is not a simple 'this list of objects is console'
but needs user space to do the work.

> Faking it with posix acl's is what the /dev/audio stuff tends to do.

The audio stuff mostly uses daemons to manage it. A bigger problem is
file system mounts. If you've got an old handle on /dev/cdrom you can
pass it down a socket to a background irritant that just does an eject
every five minutes. Students were doing this in SunOS 4 and I'm sure
still find it funny today.

> It's better than nothing, but it really isn't wonderful - because it's
> really not just about audio. And revoke doesn't work universally.

BSD invented revoke but never implemented it universally. It turns out
that this isn't a big problem. Right now we basically only have revoke
for tty devices but we don't need it for that much more. Revoke on disk
files and the like has simply never happened because its not a matter of
revoke being universal so much as universal revoke being universally
pointless.

Alan
