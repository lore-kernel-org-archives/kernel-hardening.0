Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 3 Aug 2016 16:41:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20160803144116.GG6879@twins.programming.kicks-ass.net>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
 <20160802095243.GD6862@twins.programming.kicks-ass.net>
 <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
 <20160802203037.GC6879@twins.programming.kicks-ass.net>
 <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: Kees Cook <keescook@chromium.org>
Cc: Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 02, 2016 at 01:51:47PM -0700, Kees Cook wrote:
> Let me take this another way instead. What would be a better way to
> provide a mechanism for system owners to disable perf without an LSM?
> (Since far fewer folks run with an enforcing "big" LSM: I'm seeking as
> wide a coverage as possible.)

Could something like a new capability bit work?

I'm thinking that applications that have network connections already
drop all possible capabilities (I know, unlikely to be true, but should
be true for most stuff I hope). This would disable perf for remote code
execution exploits, including web-browsers and the lot.

It would keep perf working for local stuff by default, although
obviously with pam_cap you can limit this when and where needed.

For Android this could mean the JVM explicitly dropping the cap for its
'children' while retaining the use itself. And this would also keep perf
working on the ADB shell stuff.


And, I think this would allow a JIT executable to gain the cap using
file caps, even when the user using it doesn't have it, which would keep
things usable even in restricted environments.


Or am I misunderstanding capabilities -- which is entirely possible.
