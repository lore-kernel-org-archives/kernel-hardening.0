Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <4EB843FF.5080201@zytor.com>
References: <20111107174522.GA2317@albatros> <9718.1320689192@turing-police.cc.vt.edu>
 <20111107190112.GA3732@albatros> <4EB82F08.8060209@zytor.com>
 <20111107192915.GA4690@albatros> <CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com>
 <4EB83674.3040207@zytor.com> <20111107201120.GA5775@albatros> <4EB843FF.5080201@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 7 Nov 2011 13:23:16 -0800
Message-ID: <CA+55aFwYGivYFZTLprSB+oDm3E4MG0s3PEQabs166v6YRL5u-Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to /proc/interrupts
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Eric Paris <eparis@parisplace.org>, kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 7, 2011 at 12:47 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> You didn't really get my point. =A0There are global nodes which are
> dynamic, and more importantly the *set* changes across the system life.
> =A0A global policy option is a lot easier to deal with for the vast
> majority of users who don't need fine grain control.

I want *one* global policy that the kernel would actually know about:
is the user physically at the machine right now.

Sadly, I don't think the kernel has any good way to figure that out
automatically.

Because quite frankly, a lot of the /proc files should be "root or
desktop user". If you control the hardware, you should damn well be
able to see the interrupt counts in order to do bug reports etc
without having to 'sudo' or similar.

I realize that pam & co could give us this info, or we could just add
a new capability flag, but I think this is something where the kernel
really could just do the RightThing(tm) automatically, and screw the
crazy login managers, odd policies (I really don't believe that adding
magic selinux rules actually improves security all that much, because
it's too painful and too hard to know for any normal user).

The person in front of the hardware really *is* fundamentally special.

Right now all the distros do magic things with the audio device
because they know the person in front of the machine is special. But
all those things are ad-hoc per device, and never cover things like
random /proc files etc.

               Linus
