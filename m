Date: Tue, 20 Jun 2017 19:38:36 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170620233836.75k5usug5w3xhwlw@thunk.org>
References: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
 <20170614224526.29076-1-Jason@zx2c4.com>
 <CAHmME9rv3EjOVF4LhYZ0VS2LYKjDr_-TxzNHvyE_mKZ_UX0+eA@mail.gmail.com>
 <20170620060344.ngbnzg2mz5hvq4kw@thunk.org>
 <CAHmME9oHZz44uQ1tq=M=Vrxc5NY-2r4xFjbwge-Hp=U-cCEYfQ@mail.gmail.com>
 <CAH8yC8kLHL80_i2WRssgE3chL3iU-6dwvdkM-MoaPx4mtjx-kg@mail.gmail.com>
 <CAHmME9rk-qrjJs6ZXQPoWV0sKBK_juq18tcE1h+pX8zSJJK1iQ@mail.gmail.com>
 <20170620093642.3ri6dct5qkf7vhuc@thunk.org>
 <CAHmME9oOUo-A-0NA5qPvcbTRf+xYKxmOtXb9fXVCmLwLcWPWug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9oOUo-A-0NA5qPvcbTRf+xYKxmOtXb9fXVCmLwLcWPWug@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] random: silence compiler warnings and fix race
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: noloader@gmail.com, tglx@breakpoint.cc, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 20, 2017 at 11:49:07AM +0200, Jason A. Donenfeld wrote:
> Uh, talk about a totally unnecessary punch... In case my last email
> wasn't clear, I fully recognize that `default y` is a tad too extreme,
> which is why from one of the earliest revisions in this series, I
> moved directly to the compromise solution (`depends DEBUG_KERNEL`)
> without even waiting for people to complain first.

The punch was in response to this statement, which I personally found
fairly infuriating:

>> I more or less agree with you that we should just turn this on for all
>> users and they'll just have to live with the spam and report odd
>> entries, and overtime we'll fix all the violations.

There seems to be a fundamental misapprehension that it will be easy
to "fix all the violations".  For certain hardware types, this is
not easy, and the "eh, let them get spammed until we get around to
fixing it" attitude is precisely what I was pushing back against.

There's a certain amount of privilege for those of us who are using
x86 systems with built-in hardware random number generators, and cycle
counters, where the problem is much easier to solve.  But for other
platforms, it really, REALLY isn't that easy to fix.

One solution that might be acceptable is to simply print a *single*
warning, the first time some piece of kernel code tries to get
randomness before the CRNG is initialized.  And that's it.  If it's
only a single dmesg line, then we probably don't need to hide it
behind a #ifdef.  That might satisfy the security-obsessed who want to
rub users' noses in the face that their kernel is doing something
potentially insecure and there is nothing they can do about it.  But
since it's also a single line in the syslog, it's not actively
annoying.

The #ifdef will allow the current behaviour where we suppress
duplicates, but we warn for every attempt to get randomness.  That we
can default to no, since it will only be people who are trying to
audit calls to see if the real fix is to switch the call to
prandom_u32, because the use case really was't security/crypto
sensitive.

As I have said before, ultimately I think the only real solution to
this whole mess is to allow the bootloader to read entropy from the
boot device (or maybe some NVRAM or battery-backed memory), which is
then overwritten as early as possible in the boot process with new
random data.  This is what OpenBSD does, but OpenBSD has a much easier
job because they only have to support a small set of architectures.
We will need to do this for each bootloader that is used by Linux,
which is a pretty large set.  But ultimately, it solves *all* the
problems, including getting entropy for KASLR, which needs the
randomness super-early in the boot process, long before we have any
hope of initializing the entropy pool from environmental noise.

So personally, I think this focus on trying to warn/spam users is not
particularly useful.  If we can mute the warnings to those people who
want to play whack-a-mole, it's not harmful, but for those who think
that futzing with get_random_* calls is the right approach, personally
I'm really not convinced.  Of course, the kernel is a volunteer
project, so ultimately all a maintainer can do is to say no to
patches, and not command people to work on things that he or she
wishes.  I *can* try to pursude people about what the right way to go
is, because doing something that involves boot loaders is going to
require a huge amount of effort from many people.  It's certainly not
anything I or anyone else can do by him or herself.

	      	     	      	    - Ted
