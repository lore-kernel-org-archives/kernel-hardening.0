Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 7 Nov 2015 22:34:37 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20151107223437.891207864301c26862ae15da@gmail.com>
In-Reply-To: <CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
	<CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: Proposal for kernel self protection features
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Theodore Tso <tytso@google.com>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>

> >     * size_overflow_hash_aux: For out-of-tree modules.
> 
> By out-of-tree, you mean built-out-of-tree? I assume a future

I mean out-of-tree modules e.g., zfs. But the gcc infrastructure
in PaX also supports built-out-of-tree and cross compilation.

> downstream kernel that used size_overflow would have their
> non-upstream code covered during the size_overflow_hash regeneration?
> (Though they'd be on the their own for handling the false positives.)

Yes, everybody can regenerate the hash table (the plugin prints out a message
about missing entries that I parse with a python script). I store functions
from out-of-tree modules in a separate hash table because we don't regenerate it
for every kernel version. 

> >        * gcc intentional overflow: gcc computes some expressions by overflow
> >           when it optimizes. Sadly it is doing this in the front end where
> >           there is no plugin support. Most of these false positives I handle
> >           from the plugin or sometimes I patch the kernel source code.
> >           There are some unsolved issues.
> 
> Has there been any discussion with gcc folks about this problem?

I never tried it. PaXTeam has some open tickets
(e.g., https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61311) for a long time so
because of it I haven't any courage.

> >  * structleak: This plugin forcibly initializes certain local variables
> >     based on the __user attribute that could otherwise leak kernel stack
> >     to userland if they aren't properly initialized by later code.
> >     It has small performance loss.
> 
> Does this operate only on kernel stack structures?

Yes, it does but the coverage can be increased.

> > I think the first plugin can be a simpler plugin e.g., constify or latent_entropy.
> > Please let me know if you want one, more or all of them.
> 
> Well I would love to see all of them upstream. :) As for first steps,
> you've convinced me about the complexity of the size_overflow plugin.
> Perhaps the constify plugin would be a good first target? Can you

Yes, I agree.

> speak to any known bugs it stopped? Having some mention of the threat
> it mitigates would be helpful. (Do I remember correctly that it
> constified security_operations, which was a common target in
> exploits?)

I don't remember any bugs, but I think spender has some exploits that
are stopped by constification :) The constify plugin stops exploits that
want to modify ops structures to control indirect calls through them.

-- 
Emese
