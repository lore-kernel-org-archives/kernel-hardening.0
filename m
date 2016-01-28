Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
In-Reply-To: <20160128143825.GA17383@www.outflux.net> (Kees Cook's message of
	"Thu, 28 Jan 2016 06:38:25 -0800")
References: <20160128143825.GA17383@www.outflux.net>
Date: Thu, 28 Jan 2016 11:41:17 -0600
Message-ID: <87wpqteh4y.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH v2] sysctl: allow CLONE_NEWUSER to be disabled
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Andy Lutomirski <luto@kernel.org>, "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, Richard Weinberger <richard@nod.at>, Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

> There continue to be unexpected security exposures when users have access
> to CLONE_NEWUSER.

So how does this sucessfully address that issue?

> For admins of systems that do not use user namespaces
> and are running distro kernels with CONFIG_USER_NS enabled, there is
> no way to disable CLONE_NEWUSER. This provides a way for sysadmins to
> disable the feature to reduce their attack surface without needing to
> rebuild their kernels.
>
> This is inspired by a similar restriction in Grsecurity, but adds
> a sysctl.
>

I have already nacked this patch.   Thank you for removing the broken
capability in sysctl check.  But this does not address any of the other
issues I have raised.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Further as far as I can tell this is just about a witch hunt.  Isn't
that what you call a campaign against something when the complaining
party does not understand something persecutes it and does not bother to
try and understand?

I have already told you what kind of direction would be acceptable.  I
gave concrete suggests and here you are wasting our time with this patch
again.

Eric
