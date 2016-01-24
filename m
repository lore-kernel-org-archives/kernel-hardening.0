Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 24 Jan 2016 01:43:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20160124014342.GW17997@ZenIV.linux.org.uk>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
 <1453502345-30416-2-git-send-email-keescook@chromium.org>
 <87oacdyos0.fsf@x220.int.ebiederm.org>
 <20160123222540.GA9740@pc.thejh.net>
 <87mvrvwz72.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mvrvwz72.fsf@x220.int.ebiederm.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] sysctl: expand use of
 proc_dointvec_minmax_sysadmin
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jann Horn <jann@thejh.net>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@amacapital.net>, Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jan 23, 2016 at 07:20:17PM -0600, Eric W. Biederman wrote:

> Yep.  That is about the size of it.  file * used to be passed to the
> sysctl methods but it was removed several years ago because no one was
> using it.

Generally cred would be better...  Alternatively we could eat one more
pointer in task_struct and stash a reference to that sucker there, rather
than adding an explicit argument (again, with cred instead of file).
Not sure...
