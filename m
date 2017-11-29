MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFyybavkF8ccQKJsoVAF+MG=J5=e9PxXKU=J_hqCQRZnug@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
 <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
 <1100603534.56586.1511871419952@ichabod.co-bxl> <20171128193243.4fymnjk7fplqw62x@thunk.org>
 <CAGXu5jLtBjLSe5mbe5sYSao1o67ezkkQq_u3md9646rRfi3cCQ@mail.gmail.com>
 <CA+55aFzvaFR1skBFKwT1QPnKqxaLqCuq33FCuYz8DP7MjKkgNg@mail.gmail.com>
 <CAGXu5j+OzbUAcqVBuC8QoY-ZiA9Xw6Uf9kzfzpx9MQHQ1LtxVQ@mail.gmail.com>
 <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com>
 <708003731.69563.1511905898471@ichabod.co-bxl> <CA+55aFzxFQeyk6Mrk50=jzevHpZ78BXz_9nHcHabMWBdM6RC6A@mail.gmail.com>
 <CA+55aFyybavkF8ccQKJsoVAF+MG=J5=e9PxXKU=J_hqCQRZnug@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 28 Nov 2017 16:26:39 -0800
Message-ID: <CAGXu5jLU8LqTYM9SYQADeH9wm2npVu4AEuSqvYqi3S+qtjC-Qw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Geo Kozey <geokozey@mailfence.com>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 28, 2017 at 4:17 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> But at the same time, if people can't even be bothered to try to
> improve the general case, and only do things that you have to opt in
> for, it really isn't much of an improvement. We had this whole

Right, and I'm fine to help with those general improvements. As I
mentioned in another reply, we've been steadily narrowing the
exposures by keeping request_module() from being exposed to "all
possible modules" in many of the places it's been exposed to
userspace:

  7f78e0351394 ("fs: Limit sys_mount to only request filesystem modules.")
  5d26a105b5a7 ("crypto: prefix module autoloading with "crypto-"")
  4943ba16bbc2 ("crypto: include crypto- module prefix in template")

I don't want you to think this is an area where work hasn't already
been done to try to improve things.

> The model that I am a proponent of is to take a softer approach
> initially: don't forbid module loading (because that breaks users),
> but instead _warn_ about non-root module loading. And then we can
> start fixing the cases that we find.

I am totally fine with this. The question I'm hoping to have answered
is, "then what?" We already have concrete examples of module
autoloading that will still be need to stay unprivileged and as-is in
the kernel (even if we remove others). What do you see as the way to
allow an admin to turn those off?

-Kees

-- 
Kees Cook
Pixel Security
