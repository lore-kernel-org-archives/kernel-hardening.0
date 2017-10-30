MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20171030213345.GS12341@eros>
References: <20171030213345.GS12341@eros>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 30 Oct 2017 14:52:38 -0700
Message-ID: <CAGXu5j+3W7ZzxOK5woVkdFP+iQ_Arn9etAhMNFFi349YNey1DQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Merge path for KSPP patches
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 30, 2017 at 2:33 PM, Tobin C. Harding <me@tobin.cc> wrote:
> Does the KSP Project have a tree (and a maintainer)? I see there is this
> tree, but it has been idle for 6 years?
>
> git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-hardening.git

The tree I carry for KSPP carries various things. Presently, gcc
plugin and hardened usercopy changes go via that tree:

https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/refs/heads

https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=for-next/gcc-plugins
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=for-next/usercopy

https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=for-next/kspp

> What is the merge path for kernel hardening patches please?

This depends on where stuff a change is landing. For example,
arch-specific things (like KASLR improvements) go via the
per-architecture trees. Smaller system-wide things go via Andrew
Morton's "mmotm" tree. Larger system-wide things, or things without an
obvious maintainer, go via my trees.

> I am asking this because the next merge window can't be far away. The

Probably a couple weeks.

> patch hashing pointers printed with %p seems to have stabilized. This is
> my first _real_ patch outside of staging though so I am not completely
> sure of the process.
>
> If this is overly pushy, please do say so, I'm new around here and keen
> to learn the correct etiquette.

Since it's small, I think it should likely go via akpm's tree.
However, I tend to carry stuff in a separate kspp tree on kernel.org
just so it can get some build and run testing by the 0day bots.

-Kees

-- 
Kees Cook
Pixel Security
