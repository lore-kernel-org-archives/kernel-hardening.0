MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170417053052.dz276h26jxwdfhsr@jeyu>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
 <1491513513-84351-2-git-send-email-keescook@chromium.org> <CAGXu5jL6XvC0gSFhtpOKRJ3nR2ZQjz4aaaMyak8PAvuHF2Ee1Q@mail.gmail.com>
 <20170417053052.dz276h26jxwdfhsr@jeyu>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 17 Apr 2017 08:23:59 -0700
Message-ID: <CAGXu5jKqFoY_TQXFa++NY1as2FrjO9=NZVmiFgr3AuW06SFWYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 01/18] gcc-plugins: Add the randstruct plugin
To: Jessica Yu <jeyu@redhat.com>
Cc: Michael Leibowitz <michael.leibowitz@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Apr 16, 2017 at 10:30 PM, Jessica Yu <jeyu@redhat.com> wrote:
> Yes, that would be preferable to using the repeated #ifdef blocks.
> IMO your other patchset which adds name to .modinfo is a cleaner
> solution.

Sounds good. Yeah, after I sent this email I went looking for another
way to find the module name and realized that we probably needed a
general solution. :)

> (PS, I'm still on PTO, but I'll be able to give that a proper look
> after Tues.)

Awesome, thanks!

-Kees

-- 
Kees Cook
Pixel Security
