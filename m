Date: Sat, 3 Jun 2017 01:04:33 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170603050433.4xpvloul25s47f2z@thunk.org>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
 <20170602172616.47qcxav6adq52nmk@thunk.org>
 <CAHmME9oS_GCRMLf7EF8XBGwjdjohcRz4rzZiWr5ZDUurTj8A7Q@mail.gmail.com>
 <20170602190734.6zll7zc5hr66oacl@thunk.org>
 <CAHmME9oLHP85ENr5aZgKsTSrxiUWoQ_pfv7C6XYxmcoxPfq3Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHmME9oLHP85ENr5aZgKsTSrxiUWoQ_pfv7C6XYxmcoxPfq3Ew@mail.gmail.com>
Subject: [kernel-hardening] Re: get_random_bytes returns bad randomness before seeding is
 complete
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Stephan Mueller <smueller@chronox.de>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jun 03, 2017 at 01:58:25AM +0200, Jason A. Donenfeld wrote:
> Hi Ted,
> 
> Based on the tone of your last email, before I respond to your
> individual points....

May I gently point out that *your* tone that started this whole thread
has been pretty terrible?   Quoting your your first message:

   "Yes, yes, you have arguments for why you're keeping this
   pathological, but you're still wrong, and this api is still a bug."

This kind of "my shit doesn't stink, but yours does", is not
particularly useful if you are trying to have a constructive
discussion.  If you think the /dev/urandom question wasn't appropriate
to discuss in this thread, then why the *hell* did you bring it up
*first*?

The reason why I keep harping on this is because I'm concerned about
an absolutist attitude towards technical design, where the good is the
enemy of the perfect, and where bricking machines in the pursuit of
cryptographic perfection is considered laudable.  Yes, if you apply
thermite to the CPU and the hard drives, the system will be secure.
But it also won't be terribly useful.

And to me, the phrase "you're still wrong" doesn't seem to admit any
concessions towards acknowledging that there might be another side to
the security versus usability debate.  And I'd ***really*** rather not
waste my time trying to work with someone who doesn't care about
usability, because my focus is in practical engineering, which means
if no one uses the system, or can use the system, then I consider it a
failure, even if it is 100% secure.  And this is true no matter
whether we're talking about /dev/urandom or some enhancement to
get_random_bytes().

> Do you have any opinions on the issue of what the most flexible API
> would be? There are a lot of varieties of wait_event. The default one
> is uninterruptable, but as Stephan and Herbert saw when they were
> working on this was that it could be dangerous in certain
> circumstances not to allow interruption. So probably we'd want an
> interruptable variety. But then maybe we want to support the other
> wait_event_* modes too, like killable, timeout, hrtimeout, io, and so
> on. There's a huge list. These are all implemented as macros in
> wait.h, and I don't really want to have a different get_random_bytes_*
> function that corresponds to _each_ of these wait_event_* functions,
> since that'd be overwhelming.

We're going to have to look at a representative sample of the call
sites to figure this out.  The simple case is where the call site is
only run in response to a userspace system call.  There, blocking
makes perfect sense.  I'm just not sure there are many callers of
get_random_ bytes() where this is the case.

There are definitely quite a few callsites of get_random_bytes() where
the caller is in the middle of an interrupt service routine, or is
holding spinlock.  There, we are *not* allowed to block.  So any kind
of blocking interface isn't going to be allowed; the async callback is
the only thing which is guaranteed to work, in fact.  Mercifully, many
of these are cases where prandom_u32() makes sense.

> So I was thinking maybe a simple flag and a timeout param could work:

When would a timeout be useful?  If you are using get_random_bytes()
for security reasons, does the security reason go away after 15
seconds?  Or even 30 seconds?

> > Or maybe we can then help figure out what percentage of the callsites
> > can be fixed with a synchronous interface, and fix some number of them
> > just to demonstrate that the synchronous interface does work well.
> 
> I was planning on doing this to at least a couple callsites in my
> upcoming patch series that adds the synchronous interface. It seems
> like the right way to see if the API is good or not.

This is absolutely the right approach.  See my above comments about
why there may not be that many places where a synchronous interface
will work out.  And I'm going to be rather surprised if there are
places where having a timeout parameter will be helpful.  But I could
be wrong; let's see if we can find cases where we (a) need secure
bytes, (b) are allowed to block, and (c) where a timeout would make
sense.

> Right. In my initial email I proposed a distinction:
> 
> - External module loading is usually in a different process context,
> so multiple modules can be attempted to be loaded at the same time. In
> this case, it is probably safe to block in request_module.
> - Built-in modules are loaded ± linearly, from init/main.c, so these
> really can't block each other. For this, I was thinking of introducing
> an rnginit section, to add to the list of things like lateinit. The
> rnginit drivers would be loaded _after_ the RNG has initialized, so
> that they don't get blocked.

... except that we already have an order in which drivers are added,
so moving a driver to the rnginit section might mean that some kernel
module that depends on that driver being loaded also needs to be moved
after rnginit.  We already have the following initcall levels:

static char *initcall_level_names[] __initdata = {
	"early",
	"core",
	"postcore",
	"arch",
	"subsys",
	"fs",
	"device",
	"late",
};

If we move a caller of get_random_bytes() from say, "fs" to after
"rnginit", that may break things.

Also, it is possible that we may have architectures, without
fine-grained clocks, where we don't initialize the rng until after
userspace as sharted running.  So it's not clear adding a rnginit
section makes sense.  Even if we put it as late as possible --- say,
after "late", what do we do if don't have the CRNG fully
negotiated after the last of the "late" drivers have been run?

	   	     	     	 - Ted
