MIME-Version: 1.0
In-Reply-To: <20170603050433.4xpvloul25s47f2z@thunk.org>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
 <20170602172616.47qcxav6adq52nmk@thunk.org> <CAHmME9oS_GCRMLf7EF8XBGwjdjohcRz4rzZiWr5ZDUurTj8A7Q@mail.gmail.com>
 <20170602190734.6zll7zc5hr66oacl@thunk.org> <CAHmME9oLHP85ENr5aZgKsTSrxiUWoQ_pfv7C6XYxmcoxPfq3Ew@mail.gmail.com>
 <20170603050433.4xpvloul25s47f2z@thunk.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat, 3 Jun 2017 14:30:40 +0200
Message-ID: <CAHmME9rwKneq0C5GYPSWamGRT0775=-Xw3pyq6uxJXJyyBtr1g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: get_random_bytes returns bad randomness before seeding is complete
To: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Stephan Mueller <smueller@chronox.de>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jun 3, 2017 at 7:04 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> has been pretty terrible?
> This kind of "my shit doesn't stink, but yours does", is not
> The reason why I keep harping on this is because I'm concerned about
> an absolutist attitude towards technical design, where the good is the

Moving past that, did you see the [PATCH RCF 0/3] series I posted
yesterday? Would be helpful to have your feedback on that approach and
implementation strategy. Since it seems like you're preferring
cleaning up things individually, rather than the systemic rnginit
solution I initially proposed, I moved forward with implementing an
RFC-version of that. I'm pretty sure so quickly compromising and going
with what I perceived you thought was best is a strong indication that
there isn't an, "absolutist attitude towards technical design".
However, if you do somehow find evidence of that kind of claim in my
[PATCH] set, please do bring it up, and I'll try to adjust to be more
pleasing.

> We're going to have to look at a representative sample of the call
> sites to figure this out.  The simple case is where the call site is
> only run in response to a userspace system call.  There, blocking
> makes perfect sense.  I'm just not sure there are many callers of
> get_random_ bytes() where this is the case.

In the patch series I sent earlier, the reason I split things into
wait_for_random_bytes, which just blocks until the pool is ready, and
then the convenience combiner of get_random_bytes_wait, which calls
wait_for_random_bytes and then get_random_bytes, is because I was
thinking there might be a few places where we can't actually sleep
during the get_random_bytes call, due to in_interrupt() or whatever,
but that there's some process-context area that's _always_ called
before get_random_bytes, like a userspace configuration API or an
ioctl, so we could simply put a call to wait_for_random_bytes, and
then be sure that all calls to get_random_bytes after that are safe.

I guess I'll see in practice if this is actually a useful way of doing
it, once I dig in and start modifying representative call sites.

> When would a timeout be useful?  If you are using get_random_bytes()
> for security reasons, does the security reason go away after 15
> seconds?  Or even 30 seconds?

I was thinking that returning to userspace with -ETIMEDOUT or
something might be more desirable in some odd situations (which ones?)
than just waiting for a signal and responding with
-EINTR/-ERESTARTSYS.  That might turn out to be not true, in which
case I guess I won't add that API, as you suggested.

> Also, it is possible that we may have architectures, without
> fine-grained clocks, where we don't initialize the rng until after
> userspace as sharted running.  So it's not clear adding a rnginit
> section makes sense.  Even if we put it as late as possible --- say,
> after "late", what do we do if don't have the CRNG fully
> negotiated after the last of the "late" drivers have been run?

My idea was that it would be eventually inserted on the callback from
add_random_ready_callback. You're right that this would not be okay
for things like filesystems, but maybe it'd be appropriate for things
like crypto/rng.c? Or, perhaps the blocking API on configuration-time
would be better, anyway, for things like that. You seem wary of this
approach, so I'm going to roll with your suggestions above and see how
they work out. It it pans out great, if not, maybe we'll revisit this
down the road once I have a better picture of what the call sites are
like.

Jason
