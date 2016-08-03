Reply-To: kernel-hardening@lists.openwall.com
From: "Schaufler, Casey" <casey.schaufler@intel.com>
Date: Wed, 3 Aug 2016 15:42:16 +0000
Message-ID: <99FC4B6EFCEFD44486C35F4C281DC6731F2B9D38@ORSMSX107.amr.corp.intel.com>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
 <20160802095243.GD6862@twins.programming.kicks-ass.net>
 <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
 <20160802203037.GC6879@twins.programming.kicks-ass.net>
 <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
 <20160803144116.GG6879@twins.programming.kicks-ass.net>
In-Reply-To: <20160803144116.GG6879@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: RE: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow
 further restriction of perf_event_open
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>
Cc: Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jonathan
 Corbet <corbet@lwn.net>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Wednesday, August 03, 2016 7:41 AM
> To: Kees Cook <keescook@chromium.org>
> Cc: Jeff Vander Stoep <jeffv@google.com>; Ingo Molnar <mingo@redhat.com>;
> Arnaldo Carvalho de Melo <acme@kernel.org>; Alexander Shishkin
> <alexander.shishkin@linux.intel.com>; linux-doc@vger.kernel.org; kernel-
> hardening@lists.openwall.com; LKML <linux-kernel@vger.kernel.org>;
> Jonathan Corbet <corbet@lwn.net>; Eric W. Biederman
> <ebiederm@xmission.com>
> Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow fur=
ther
> restriction of perf_event_open
>=20
> On Tue, Aug 02, 2016 at 01:51:47PM -0700, Kees Cook wrote:
> > Let me take this another way instead. What would be a better way to
> > provide a mechanism for system owners to disable perf without an LSM?
> > (Since far fewer folks run with an enforcing "big" LSM: I'm seeking as
> > wide a coverage as possible.)
>=20
> Could something like a new capability bit work?


Yes, it could, but we don't have a real good experience
with the advanced use of capabilities. The big distros and
the "OS"s have yet to adopt them seriously. It's the same
sort of issue, really. The granularity gets to you.

> I'm thinking that applications that have network connections already
> drop all possible capabilities (I know, unlikely to be true, but should
> be true for most stuff I hope). This would disable perf for remote code
> execution exploits, including web-browsers and the lot.
>=20
> It would keep perf working for local stuff by default, although
> obviously with pam_cap you can limit this when and where needed.
>=20
> For Android this could mean the JVM explicitly dropping the cap for its
> 'children' while retaining the use itself. And this would also keep perf
> working on the ADB shell stuff.
>=20
>=20
> And, I think this would allow a JIT executable to gain the cap using
> file caps, even when the user using it doesn't have it, which would keep
> things usable even in restricted environments.
>=20
>=20
> Or am I misunderstanding capabilities -- which is entirely possible.
