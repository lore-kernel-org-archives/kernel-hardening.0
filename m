Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Wed, 3 Aug 2016 10:28:31 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160803082830.GA3163@gmail.com>
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
Cc: Peter Zijlstra <peterz@infradead.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> > I see 0 up-sides of this approach and, as per the above, a whole bunch of very 
> > serious downsides.
> >
> > A global (esp. default inhibited) knob is too coarse and limiting.
> 
> I haven't suggested it be default inhibit in the upstream Kconfig. And
> having this knob already with the 0, 1, and 2 settings seems
> incomplete to me without this highest level of restriction that 3
> would provide. That seems rather arbitrary to me. :)

The default has no impact on the "it's too coarse and limiting" negative property 
of this patch, which is the show-stopper aspect. Please fix that aspect instead of 
trying to argue around it.

This isn't some narrow debugging mechanism we can turn on/off globally and forget 
about, this is a wide scope performance measurement and event logging 
infrastructure that is being utilized not just by developers but by apps and 
runtimes as well.

> Let me take this another way instead. What would be a better way to provide a 
> mechanism for system owners to disable perf without an LSM? (Since far fewer 
> folks run with an enforcing "big" LSM: I'm seeking as wide a coverage as 
> possible.)

Because in practice what will happen is that if the only option is to do something 
drastic for sekjurity, IT departments will do it - while if there's a more 
flexible mechanism that does not throw out the baby with the bath water that is 
going to be used.

This is as if 20 years ago you had submitted a patch to the early Linux TCP/IP 
networking code to be on/off via a global sysctl switch and told people that 
"in developer mode you can have networking, talk to your admin".

We'd have told you: "this switch is too coarse and limiting, please implement 
something better, like a list of routes which defines which IP ranges are 
accessible, and a privileged range of listen sockets ports and some flexible 
kernel side filtering mechanism to inhibit outgoing/incoming connections".

Global sysctls are way too coarse.

Thanks,

	Ingo
