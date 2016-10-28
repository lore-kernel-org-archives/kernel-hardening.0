Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161028195800.GA6193@grsecurity.net>
References: <1477071466-19256-1-git-send-email-michael.leibowitz@intel.com>
 <CAGXu5jLN5NLH+ScR_i+C18EXqektP92vCrb2h8K_pvR0Yb1bYg@mail.gmail.com>
 <CAGXu5jLCCUK0AWBf4V-Djqydd3y3JxT5ccLmg8ATwn7_1-DTaQ@mail.gmail.com>
 <CAGXu5jKpjZ9KbUCsTSPxO7pGqKra+K28aECxvA4VRR9Tfrzh+A@mail.gmail.com> <20161028195800.GA6193@grsecurity.net>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 28 Oct 2016 13:40:11 -0700
Message-ID: <CAGXu5jKqEV9GJ=zgn-aNJw2tv80PQ5Q4VZJ7KgMTGNDXeiz3TA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] Add the randstruct gcc plugin
To: Brad Spengler <spender@grsecurity.net>
Cc: Michael Leibowitz <michael.leibowitz@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>, "Schaufler, Casey" <casey.schaufler@intel.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 28, 2016 at 12:58 PM, Brad Spengler <spender@grsecurity.net> wrote:
> Just curious:
>
> http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/commit/?h=kspp/gcc-plugin/randstruct&id=cd7686ee26b839ad5e0467ac2162b360bf1fa673
>
> "These were found using allyesconfig on x86, arm, and arm64."
>
> Who found them, and whose code is all that?
>
> http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/commit/?h=kspp/gcc-plugin/randstruct&id=6dd5fff4a626c8db8800d76f5096f6efcd2a675f
>
> Who decided on these, whose code is it?
>
> http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/commit/?h=kspp/gcc-plugin/randstruct&id=7169767228cd6d117a0908997d9a3b38bfb6a1b9
>
> Ditto -- did you spend the hours to figure the ARM hunk out?  I only see your
> name there.
>
> Show the world you can do something more than plagiarize code.  This is the
> third time I'm having to warn you guys collectively about this.  How hard
> is it to not plagiarize?

I already said the commit logs needed work. I think I have a
reasonable track record giving you and PaX Team credit for things --
this isn't the final version by a long shot. I wanted to give Michael
something to work from before the weekend got here.

-Kees

-- 
Kees Cook
Nexus Security
