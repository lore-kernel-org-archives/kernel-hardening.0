Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20111206235815.GA21764@www.outflux.net>
References: <20111206235815.GA21764@www.outflux.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 7 Dec 2011 10:41:59 -0800
Message-ID: <CA+55aFzRz6DcmP8uYaeYAUkpBfePZTYQg-hvERnA9huCQu4X3g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2011.1] fs: symlink restrictions on sticky directories
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Dan Rosenberg <drosenberg@vsecurity.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Dec 6, 2011 at 3:58 PM, Kees Cook <keescook@chromium.org> wrote:
> A long-standing class of security issues is the symlink-based
> time-of-check-time-of-use race, most commonly seen in world-writable
> directories like /tmp.

Ugh. I really dislike the implementation.

Wouldn't it be much nicer to instead actually use the symlink
protection fields, and make the rules be:

 - creating a symlink as root does the traditional "lrwxrwxrwx" thing
 - creating a symlink in a directory you own similarly does "lrwxrwxrwx"
 - creating a symlink anywhere else (which implies either sticky or
world-writable directory) does "lrwx------", so only you can use it.

That seems to be much nicer semantics, and makes the protection
*visible* instead of some kind of hacky run-time random behavior
depending on some invisible config option that people aren't even
aware of.

Of course, it needs to handle renames too (and maybe lchown?), and it
would still need to be an option you enable explicitly, but it seems
much more polite to make things like this something you can actually
see.

No, I have not thought this through deeply, but I really dislike your
kind of "change random semantics in ways that are very hidden and
subtle". The symlink protection approach seems to be much less hidden
and subtle, and should result in largely the same result.

Notably, you can install a system without it on, and turn it on even
after install - who cares if there are *long-term* symlinks with
lrwxrwxrwx and that thus allow all access, it's the racily-created
ones we need to worry about, so it should actually be perfectly ok to
enable the symlink creation protection dynamically. In fact, it could
be a inheritable per-*process* (or per-container) flag rather than a
global flag that says how symlink creation acts.

I dunno.

                    Linus
