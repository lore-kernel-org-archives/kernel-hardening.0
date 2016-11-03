Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 3 Nov 2016 18:55:58 +0100
From: Jann Horn <jann@thejh.net>
Message-ID: <20161103175558.GA1177@laptop.thejh.net>
References: <1478187038-19954-1-git-send-email-wluikil@gmail.com>
 <1478187038-19954-2-git-send-email-wluikil@gmail.com>
 <CAGXu5jLZnkwK3NRV7qy=fi51_W4rP4-jGzeYSwceuvSz7_Ht8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLZnkwK3NRV7qy=fi51_W4rP4-jGzeYSwceuvSz7_Ht8g@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 2/2] procfs/tasks: add a simple per-task procfs hidepid=
 field
To: Kees Cook <keescook@chromium.org>
Cc: Lafcadio Wluiki <wluikil@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 03, 2016 at 10:12:55AM -0600, Kees Cook wrote:
> On Thu, Nov 3, 2016 at 9:30 AM, Lafcadio Wluiki <wluikil@gmail.com> wrote:
> > (Third, rebased submission, since first two submissions yielded no replies.)
> >
> > This adds a new per-task hidepid= flag that is honored by procfs when
> > presenting /proc to the user, in addition to the existing hidepid= mount
> > option. So far, hidepid= was exclusively a per-pidns setting. Locking
> > down a set of processes so that they cannot see other user's processes
> > without affecting the rest of the system thus currently requires
> > creation of a private PID namespace, with all the complexity it brings,
> > including maintaining a stub init process as PID 1 and losing the
> > ability to see processes of the same user on the rest of the system.
[...]
> Since this adds a new prctl interface, it's best to Cc linux-arch
> (which I added now).

Please also CC linux-api for the next iteration, since this is a new
userspace-facing API.
