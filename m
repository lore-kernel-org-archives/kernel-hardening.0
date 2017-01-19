Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 19 Jan 2017 11:18:28 -0800
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20170119191828.GA104949@gmail.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
 <20170118215247.GA129388@gmail.com>
 <20170119091952.GH6485@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170119091952.GH6485@twins.programming.kicks-ass.net>
Subject: Re: [kernel-hardening] [RFCv2 PATCH 00/18] refcount_t API + usage
To: Peter Zijlstra <peterz@infradead.org>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 19, 2017 at 10:19:52AM +0100, Peter Zijlstra wrote:
> On Wed, Jan 18, 2017 at 01:52:47PM -0800, Eric Biggers wrote:
> > There seems to be a lot of focus on converting things to use refcount_t but much
> > less focus on providing a refcount_t implementation that actually meets the
> > performance and security goals of the feature.
> 
> And here you go again... :-(
> 
> The refcount_t implementation does meet the security goals afaict, it
> has full saturation semantics, which means an overflow bug gets turned
> into a resource leak.
> 
> That covers the entirely of the security goal. If there is more, you'll
> need to spell it out.
> 
> As for performance, you didn't reply to my earlier email on the subject.
> 
> > Notably, the proposed patchset
> > provides no information about why the proposed implementation was chosen over
> > the PaX implementation (note that I'm talking about the actual implementation of
> > safe reference counts, not the atomic_t/atomic_unchecked_t division) which as
> > I've already mentioned is much more efficient (less bloated and faster) while
> > still meeting the security goal.
> 
> You again failed to reply to my last email on the subject. The initial
> PaX thing was broken as heck, only later did you mention it got fixed. I
> told you we could change to that for x86 if it could be proven to be
> equivalent.
> 
> If you want to expedite matters, provide said proof.
> 
> The scheme does not make sense for LL/SC based architectures though, so
> its not something that belongs in generic code.
> 
> > I'm especially worried that people will be put
> > in a position where they need to take performance concerns into account when
> > deciding whether to use refcount_t or not.
> 
> First show a place where refcounting is performance critical, then we
> can see how much effort is required.
> 
> > And the patch even still includes
> > the "don't allow incrementing a zero refcount" check which AFAICS is bogus from
> > a security perspective.
> 
> Because use-after-free isn't a security problem, right? Reference
> counting semantics are fairly clear that 0 means it is, or is going to
> be, free()'ed. How does allowing to increment at that point make any
> sense?
> 
> > Even if you and Peter disagree with the comments that I and also PaX Team have
> > made, the patch must at least explain the design decisions made.
> 
> It was constructed as a generic atomic with saturation semantics because
> what was said PaX had was broken as hell (note, I have myself never
> looked at PaX code and have only seen what was sent me as derived code).
> If that later got fixed, or the derived code was buggy or whatever, your
> earlier email was the first I heard of that, and that was well after I
> wrote refcount_t.
> 
> So the design decision was broken vs not-broken.
> 
> Also, refcount_t is written using generic primitives (not arch
> specific), to avoid arch dependencies and provide a common
> implementation to determine semantics. That does not mean architectures
> cannot implement their own later on (matching semantics).
> 
> Also, I agree GCC does a very poor job generating code from it. But
> again, I've not had a report where refcounting is performance critical.
> I've also been very busy with other work and haven't spend much if any
> time on this since your last email.
> 
> If you want something done, contribute.

First of all if you are going to complain about not replying to emails, much
more important is the fact that you didn't reply to PaX Team, who as I hope
you're aware is the author of the grsecurity/PaX feature this whole thing is
based on, and therefore has far more experience with it than anyone else here
(and yes people really do use grsecurity).  And since PaX Team doesn't usually
contribute to "upstream" discussions, people really should listen when he
does.

This was already covered by both me and PaX Team, but forbidding incrementing a
0 refcount does not provide any real security benefit because it does not
prevent use-after-frees; it only detects them after they have already occurred
and had the opportunity to be exploited.  Of course, it's a nice-to-have for
debugging purposes.  But it's not part of the exploit mitigation and is not
free, so it shouldn't really be on by default.  Again this is supposed to be a
security feature, not a debugging feature.

Also I already explained how the latest PaX solution does not appear to be racy,
at least not in a way that defeats the mitigation.  I am suggesting that this
solution be considered, and it does not help if by your own admission you refuse
to even read the PaX code.  Note that there documentation for PAX_REFCOUNT,
which I strongly suggest that people read (though a couple parts are
out-of-date): https://forums.grsecurity.net/viewtopic.php?f=7&t=4173

With regards to performance and bloat, the important thing is not really
benchmarking of this one feature, but rather the general approach that is taken
with these exploit mitigations.  Checked reference counts is only one potential
mitigation of many.  While it prevents an important class of use-after-free
bugs, the vast majority of bugs that it does not prevent, and there are many
other different kinds of mitigations that can be implemented, each with their
own performance impact.  Take a look at the kinds of things that are in
grsecurity for some examples.  The problem is that the performance cost and code
bloat adds up for all these mitigations, and if they are not implemented
efficiently then we quickly get a point where people start disabling, rejecting,
or patching out mitigations to get their performance back, which defeats the
point.

(I also find it amusing that as soon as I try to contribute, I get accused of
not contributing!  Anyway, Elena already seems to be working on driving the
patches forward, and review is what I have time for now.  And note that this is
already implemented in grsecurity, so in my opinion the lack of code isn't
really the problem here...)

Eric
