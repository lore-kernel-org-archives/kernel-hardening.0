From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 7 Nov 2017 13:56:05 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6DD00B3BD1@AcuExch.aculab.com>
References: <1510050731-32446-1-git-send-email-me@tobin.cc>
In-Reply-To: <1510050731-32446-1-git-send-email-me@tobin.cc>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH v4] scripts: add leaking_addresses.pl
To: "'Tobin C. Harding'" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

From: Tobin C. Harding
> Sent: 07 November 2017 10:32
>
> Currently we are leaking addresses from the kernel to user space. This
> script is an attempt to find some of those leakages. Script parses
> `dmesg` output and /proc and /sys files for hex strings that look like
> kernel addresses.
...

Maybe the %p that end up in dmesg (via the kernel message buffer) should
be converted to text in a form that allows the code that reads them to
substitute alternate text for non-root users?

Then the actual addresses will be available to root (who can probably
get most by other means) but not to the casual observer.

	David
