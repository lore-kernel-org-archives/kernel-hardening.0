Date: Wed, 29 Nov 2017 01:36:39 -0500
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20171129063639.tuacfa2op6fgj6he@thunk.org>
References: <20171128193243.4fymnjk7fplqw62x@thunk.org>
 <CAGXu5jLtBjLSe5mbe5sYSao1o67ezkkQq_u3md9646rRfi3cCQ@mail.gmail.com>
 <CA+55aFzvaFR1skBFKwT1QPnKqxaLqCuq33FCuYz8DP7MjKkgNg@mail.gmail.com>
 <CAGXu5j+OzbUAcqVBuC8QoY-ZiA9Xw6Uf9kzfzpx9MQHQ1LtxVQ@mail.gmail.com>
 <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com>
 <CAGXu5j+V8+h6kdbz5Det=wsRKjt6Cm0-_n8soLCU2PZ=AvqpJQ@mail.gmail.com>
 <20171128232320.22zo324g5wvo2lce@thunk.org>
 <CAGXu5j+c8AR+3KdXKO1J180ZYZOVqK=-_MGe20g8h+dgf2RWEQ@mail.gmail.com>
 <20171128234920.awfwicihuudw5ogx@thunk.org>
 <CAGXu5j+kXxkctzH79YxOu=45xgamV-5qyR2zL7OiC4POL6EcyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+kXxkctzH79YxOu=45xgamV-5qyR2zL7OiC4POL6EcyA@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Djalal Harouni <tixxdz@gmail.com>, Jonathan Corbet <corbet@lwn.net>, James Morris <james.l.morris@oracle.com>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Geo Kozey <geokozey@mailfence.com>, Tycho Andersen <tycho@docker.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 28, 2017 at 04:18:59PM -0800, Kees Cook wrote:
> There's also a difference between immutable CONFIG options that cannot
> be disabled at runtime, those that can, global sysctls, per-namespace
> controls, etc etc. The kernel is all about providing admins with knobs
> to tweak their performance and security. Suddenly being told that we
> can't create optional improvements is very odd.

I just think that tweakable knobs are mostly pointless.  From my
experience the number of sysadmins that adjust knobs is ***tiny***[1].
Put another way, the effort to determine whether tweaking a knob will
result in breakages or will be safe is as much work as creating a
white list of modules that are allowed to be loaded.

[1] And I say that having providing a lot of knobs for ext4.  :-)

This is why some on the kernel-hardening list have argued for making
the default to be opt-out, which means some users will be breaken (and
their answer to that seems to be, "oh well --- gotta break some eggs
to make an omlette".  Sucks if you're one of the eggs, though.)

And I don't see how systemd magically means no one will be broken.  If
you have a non-root process trying to invoke a line discpline which
has to be loaded as a module, if you flip the switch, that process
will be broken.  How does using systemd make the problem go away?

					- Ted
