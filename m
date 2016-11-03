Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161103175558.GA1177@laptop.thejh.net>
References: <1478187038-19954-1-git-send-email-wluikil@gmail.com>
 <1478187038-19954-2-git-send-email-wluikil@gmail.com> <CAGXu5jLZnkwK3NRV7qy=fi51_W4rP4-jGzeYSwceuvSz7_Ht8g@mail.gmail.com>
 <20161103175558.GA1177@laptop.thejh.net>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 3 Nov 2016 12:05:22 -0600
Message-ID: <CAGXu5j+FBu1mnbiPa=fMB8Hgq0iUCdoWGhJKJcBukE4n-iF1+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 2/2] procfs/tasks: add a simple per-task procfs hidepid= field
To: Jann Horn <jann@thejh.net>
Cc: Lafcadio Wluiki <wluikil@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 3, 2016 at 11:55 AM, Jann Horn <jann@thejh.net> wrote:
> On Thu, Nov 03, 2016 at 10:12:55AM -0600, Kees Cook wrote:
>> On Thu, Nov 3, 2016 at 9:30 AM, Lafcadio Wluiki <wluikil@gmail.com> wrote:
>> > (Third, rebased submission, since first two submissions yielded no replies.)
>> >
>> > This adds a new per-task hidepid= flag that is honored by procfs when
>> > presenting /proc to the user, in addition to the existing hidepid= mount
>> > option. So far, hidepid= was exclusively a per-pidns setting. Locking
>> > down a set of processes so that they cannot see other user's processes
>> > without affecting the rest of the system thus currently requires
>> > creation of a private PID namespace, with all the complexity it brings,
>> > including maintaining a stub init process as PID 1 and losing the
>> > ability to see processes of the same user on the rest of the system.
> [...]
>> Since this adds a new prctl interface, it's best to Cc linux-arch
>> (which I added now).
>
> Please also CC linux-api for the next iteration, since this is a new
> userspace-facing API.

Oops, thank you. I meant linux-api, not linux-arch. :P

-Kees

-- 
Kees Cook
Nexus Security
