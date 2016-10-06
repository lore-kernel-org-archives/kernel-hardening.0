Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161006135612.GA21342@infradead.org>
References: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
 <20161006133147.GA20206@infradead.org> <476DC76E7D1DF2438D32BFADF679FC561CD14651@ORSMSX103.amr.corp.intel.com>
 <20161006135612.GA21342@infradead.org>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 6 Oct 2016 14:00:41 -0700
Message-ID: <CAGXu5jJsj=4=j1R6aUYiDvdWqY916pJbBdXCEbQFFoyQ0QP4Yw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] printk: introduce kptr_restrict level 3
To: Christoph Hellwig <hch@infradead.org>
Cc: "Roberts, William C" <william.c.roberts@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "corbet@lwn.net" <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 6, 2016 at 6:56 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Oct 06, 2016 at 01:47:47PM +0000, Roberts, William C wrote:
> > On Thu, Oct 6, 2016 at 6:31 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > > So what?  We a) don't care about out of tree modules and b) you could just triviall
> > > fix them up if you care.
> >
> > Out of tree modules still affect core kernel security.
>
> So don't use them.

I'm really interested in keeping these discussions productive.
Declaring that the upstream kernel community (your implied "we")
doesn't care about out-of-tree code is both false and short-sighted.
Huge numbers of people depend on Linux on their phones, their IoT
devices, cars, etc, and huge volumes of those (unfortunately) are
running out-of-tree code.

This isn't about supporting some special interface that a single third
party driver uses; this is about robust engineering and security
practices that benefits everything, even out-of-tree code.

>> I would also bet money, that somewhere
>> In-tree someone has put a %p when they wanted a %pK.
>
> So fix them.

%pK is an ugly situation that I'd like to fix correctly. It was
designed originally as a blacklisting method, when it should have been
designed as a whitelist (as William mentions). This is what will need
fixing (and is what I was suggesting in my original reply to the
patch).

All that said, "so fix them" sounds very much like "just fix the bugs"
which is another troublesome attitude to have for dealing with
potential security flaws. The kernel community already finds/fixes
obvious flaws; the efforts with changes like what William is proposing
are based around assuming (correctly, I can argue) that there are
already bugs present, and they will remain in the kernel for years to
come. Designing the kernel to safely deal with bugs being present is a
fundamental design principle for kernel security self-defense
technologies.

The challenge is not "fix them", the challenge is "design the kernel
to do the right thing even when the bugs are unfixed".

>> So this method is just quite error
>> prone. We currently have a blacklist approach versus whitelist.
>
> Or fix the entire thing, get rid of %pK and always protect %p if you
> can show that it doesn't break anything.
>
> But stop posting patches with bullshit arguments like out of tree
> modules.

As a _singlular_ argument, "it's for out-of-tree code" is weak. As an
_additional_ argument, it has value. Saying "this only helps
out-of-tree code" doesn't carry much weight. Saying "this helps kernel
security, even for out-of-tree code" is perfectly valid. And a wrinkle
in this is that some day, either that out-of-tree code, or brand new
code, will land in the kernel, and we don't want to continue to
require authors be aware of an opt-in security feature. The kernel
should protect itself (and all of itself, including out-of-tree or
future code) by default.

And based on my read of this thread, we all appear to be in violent
agreement. :) "always protect %p" is absolutely the goal, and we can
figure out the best way to get there.

-Kees

-- 
Kees Cook
Nexus Security
