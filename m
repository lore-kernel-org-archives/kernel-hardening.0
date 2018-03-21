Date: Wed, 21 Mar 2018 00:05:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v5 0/2] Remove false-positive VLAs when using max()
Message-ID: <20180321000532.GC30522@ZenIV.linux.org.uk>
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
 <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com>
 <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
 <20180316175502.GE30522@ZenIV.linux.org.uk>
 <CA+55aFzsrVF7W+YQye=EeF4Wk3yDOTbb_vSiM8s1zkKbE4JV4Q@mail.gmail.com>
 <CAGXu5jJmAAgaq3VCsUN2yjpHLSc7P-kNrM_4c4cqP=ysFcETXA@mail.gmail.com>
 <CA+55aFwv0VC67cx2W9yrf7qSFKf6ncVRrsVyLGqdmfSBn4yTYw@mail.gmail.com>
 <CAGXu5jJ=ZYpf=30H6hsWn-R-CEVYAgVMHxjmoLUC00QYq0r17g@mail.gmail.com>
 <CA+55aFwxk=tUECYQkd4cog08qW4ZT=r2K7FQXzGnc-zuMc7JQA@mail.gmail.com>
 <CA+55aFwO8KZD_tZwqwL05FbzpKW4Ucd88C0tcR7LJ1utuy3WGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwO8KZD_tZwqwL05FbzpKW4Ucd88C0tcR7LJ1utuy3WGg@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Florian Weimer <fweimer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 20, 2018 at 04:26:52PM -0700, Linus Torvalds wrote:
> On Tue, Mar 20, 2018 at 4:23 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Hmm. So thanks to the diseased mind of Martin Uecker, there's a better
> > test for "__is_constant()":
> >
> >   /* Glory to Martin Uecker <Martin.Uecker@med.uni-goettingen.de> */
> >   #define __is_constant(a) \
> >         (sizeof(int) == sizeof(*(1 ? ((void*)((a) * 0l)) : (int*)1)))
> >
> > that is actually *specified* by the C standard to work, and doesn't
> > even depend on any gcc extensions.
> 
> Well, it does depend on 'sizeof(*(void *)X)' being 1 and the compiler
> not complaining about it, and that sizeof(int) is not 1.
> 
> But since we depend on those things in the kernel anyway, that's fine.

It also depends upon "ICE for null pointer constant purposes" having the
same extensions as "ICE for enum purposes", etc., which is not obvious.

Back in 2007 or so we had a long thread regarding null pointer constants
in sparse; I probably still have notes from back then, but that'll take
some serious digging to find ;-/

What's more, gcc definitely has odd extensions.  Example I remember from
back then:
extern unsigned n;
struct {
	int x : 1 + n - n;
} y;

is accepted.  Used to be quietly accepted with -Wpedantic -std=c99, even,
but that got fixed - with -Wpedantic it does, at least, warn.  What is
and what is not recognized is fairly random - 1 + n - n + 1 + n - n
is recognized as "constant", 1 + n + n + 1 - n - n is not.  Of course,
neither is an ICE.
