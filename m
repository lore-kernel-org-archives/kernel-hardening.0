MIME-Version: 1.0
From: Kees Cook <keescook@google.com>
Date: Wed, 16 Aug 2017 16:20:58 -0700
Message-ID: <CAGXu5jKu6JWC6hw4BYGPA+qatMdd-SiaO2LiJy6XnAfjbU+1Rw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] refactoring timers to avoid init_timer*()
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

So, my earlier patch[1] to add canaries to the timer struct did not
handle many many cases, as I've uncovered. To have a sensible canary,
it needs to be written at function-assignment time, but right now
things are extremely ad-hoc in the timer API, making it non-trivial to
figure out if the code changed the function or if some attacker is
exploiting a flaw to overwrite the timer struct function pointer.

What I'd like to do is to eliminate all the uses of init_timer*() in
favor of setup_timer*() which already includes the function as part of
the initialization (which is where a canary could be generated). There
are a couple cases where a timer user switches the function out
intentionally after setup, but that is the very rare case. Those could
use a new helper that would set the function (and canary) after an
earlier setup_timer() call (or maybe just re-call setup_timer()?).

In the process I noticed that we already have
scripts/coccinelle/api/setup_timer.cocci to detect existing cases of:

init_timer(t);
t->function = func;
t->data = data;

And replace it with: setup_timer(t, func, data);

Another pattern was:

t->expires = when;
add_timer(t);

Which can be replaced with mod_timer(t, when);

So, I've created scripts/coccinelle/api/mod_timer.cocci for the
latter, and done a few passes with manual review. The current result
doesn't fully eliminate init_timer() yet, but it gets much closer. I
just wanted to be sure that this whole clean-up would actually be
welcome before I try to nail down the last many cases.

You can see it here:
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=kspp/timer/refactor-exploded

135 commits (split by maintainer):
 243 files changed, 583 insertions(+), 1055 deletions(-)

-Kees

[1] http://www.openwall.com/lists/kernel-hardening/2017/08/08/2

-- 
Kees Cook
Pixel Security
