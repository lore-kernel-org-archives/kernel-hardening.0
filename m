Reply-To: kernel-hardening@lists.openwall.com
References: <20161028172710.GA10309@amd>
 <d2f7dc1d-12ab-de12-cf73-7565fc27f5f7@gruss.cc> <20161029194224.GB3827@amd>
From: Daniel Gruss <daniel@gruss.cc>
Message-ID: <5f5741d5-0695-6a56-6c05-ebdaaa896f54@gruss.cc>
Date: Sat, 29 Oct 2016 22:05:16 +0200
MIME-Version: 1.0
In-Reply-To: <20161029194224.GB3827@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Pavel Machek <pavel@ucw.cz>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 29.10.2016 21:42, Pavel Machek wrote:
> Congratulations. Now I'd like to take away your toys :-).

I'm would like you to do that, but I'm very confident you're not 
successful the way your starting ;)

> Not in my testing.

Have you tried music/video reencoding? Games? Anything that works with a 
decent amount of memory but not too much hard disk i/o?
Numbers are very clear there...

> First, I'm not at all sure lowest CPU speed would
> make any difference at all

It would. I've seen many bitflips but none where the CPU operated in the 
lower frequency range.

> Second, going to lowest clock speed will reduce performance

As does the countermeasure you propose...

> No, sorry, not going to play this particular whack-a-mole game.

But you are already with the countermeasure you propose...

> Linux is designed for working hardware, and with bit flips, something is
> going to break. (Does Flip Feng Shui really depend on dedup?)

Deduplication should be disabled not because of bit flips but because of 
information leakage (deduplication attacks, cache side-channel attacks, ...)

Yes, Flip Feng Shui requires deduplication and does not work without.
Disabling deduplication is what the authors recommend as a countermeasure.

> But it will be nowhere near complete fix, right?
>
> Will fix user attacking kernel, but not user1 attacking user2. You
> could put each "user" into separate 2MB region, but then you'd have to
> track who needs go go where. (Same uid is not enough, probably "can
> ptrace"?)

Exactly. But preventing user2kernel is already a good start, and you 
would prevent that without any doubt and without any cost.

user2user is something else to think about and more complicated because 
you have shared libraries + copy on write --> same problems as 
deduplication. I think it might make sense to discuss whether separating 
by uids or even pids would be viable.

> That'll still let remote server gain permissons of local user running
> web server... using javascript exploit right?  And that's actually
> attack that I find most scary. Local user to root exploit is bad, but
> getting permissions of web browser from remote web server is very,
> very, very bad.

Rowhammer.js skips the browser... it goes JS to full phys. memory 
access. Anyway, preventing Rowhammer from JS should be easy because even 
the slightest slow down should be enough to prevent any Rowhammer attack 
from JS.

>> That is a simple fix that does not cost any runtime performance.
>
> Simple? Not really, I'm afraid. Feel free to try to implement it.

I had a student who already implemented this in another OS, I'm 
confident it can be done in Linux as well...


Cheers,
Daniel
