Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <4EB84F05.1000704@zytor.com>
References: <20111107174522.GA2317@albatros> <9718.1320689192@turing-police.cc.vt.edu>
 <20111107190112.GA3732@albatros> <4EB82F08.8060209@zytor.com>
 <20111107192915.GA4690@albatros> <CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com>
 <4EB83674.3040207@zytor.com> <20111107201120.GA5775@albatros>
 <4EB843FF.5080201@zytor.com> <CA+55aFwYGivYFZTLprSB+oDm3E4MG0s3PEQabs166v6YRL5u-Q@mail.gmail.com>
 <4EB84F05.1000704@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 7 Nov 2011 15:07:42 -0800
Message-ID: <CA+55aFxFNaRuTx-0vx+RhrkavrcNDiDh5jxcRyWPy8-QZHGD9A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to /proc/interrupts
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Eric Paris <eparis@parisplace.org>, kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 7, 2011 at 1:35 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> I was going to say "let's just have the login manager add a group to the
> desktop user's permission set" but then I realized that this would be
> really bad because of setgid files.
>
> Which exposes a real problem with chgrp and setgid files overall.

No, the problem is more fundamental, and this is simply not something
you should try to solve with traditional unix permissions.

Why? Because the problem really isn't about opening the file. The
problem is about any access: once you've opened the file, you *still*
must not be able to read the data from it if you have logged out and
somebody else has logged in. Think opening the microphone (which you
*should* be able to do) and just keeping it open until the next user
logs in.

Or do the same with /proc/interrupts.

Your "oops, you can get your group permissions back with a setgrp
binary" example case is just a trivial case of the much bigger
picture: access has to be actively *revoked*.

Sure, you can still do it in user space, but it gets really hacky
really quickly. You need to do some magic random permission logic,
*and* you need to add revoke support for every single file that ends
up being affected.

It's just a broken model.

So I really think it would be much better to just have a per-user flag
that says "this user has access to the physical machine", and that
flag gets tested not only on open but on reads etc of the appropriate
/proc files. It really is a kind of "temporary admin privileges",
where "admin" is much weaker than root, but does mean that you have
access to whatever directly attached devices
(sound/video/keyboard/whatever), and that you can examine machine
state (ie a lot of the "sensitive" /proc stuff, like slabinfo and
interrupts and /proc/status etc).

Trying to fake it with groups is wrong. It's much *better* to fake it
with POSIX ACL's (which don't have the setgrp issue you mention), but
that still ends up being problematic wrt revoke etc.

Faking it with posix acl's is what the /dev/audio stuff tends to do.
It's better than nothing, but it really isn't wonderful - because it's
really not just about audio. And revoke doesn't work universally.

Practically speaking, I suspect we are going to be at the mercy of
distros getting things like this right, with these kinds of user-level
hacks. But I think it's sad.

               Linus
