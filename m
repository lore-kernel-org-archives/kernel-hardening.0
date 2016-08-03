Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 3 Aug 2016 23:44:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20160803214437.GI6879@twins.programming.kicks-ass.net>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
 <20160802095243.GD6862@twins.programming.kicks-ass.net>
 <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
 <20160802203037.GC6879@twins.programming.kicks-ass.net>
 <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
 <87shulix2z.fsf@x220.int.ebiederm.org>
 <CAGXu5j+wrXtp5oDAmyUWf7Gt9mWa4SfuqnnMBW+74UuC0YDD1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+wrXtp5oDAmyUWf7Gt9mWa4SfuqnnMBW+74UuC0YDD1A@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 03, 2016 at 11:53:41AM -0700, Kees Cook wrote:
> > Kees Cook <keescook@chromium.org> writes:
> >
> >> On Tue, Aug 2, 2016 at 1:30 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> Let me take this another way instead. What would be a better way to
> >> provide a mechanism for system owners to disable perf without an LSM?
> >> (Since far fewer folks run with an enforcing "big" LSM: I'm seeking as
> >> wide a coverage as possible.)
> >
> > I vote for sandboxes.  Perhaps seccomp.  Perhaps a per userns sysctl.
> > Perhaps something else.
> 
> Peter, did you happen to see Eric's solution to this problem for
> namespaces? Basically, a per-userns sysctl instead of a global sysctl.
> Is that something that would be acceptable here?

Someone would have to educate me on what a userns is and how that would
help here.
