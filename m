Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <20160128143825.GA17383@www.outflux.net>
Date: Thu, 28 Jan 2016 11:48:33 -0600
In-Reply-To: <20160128143825.GA17383@www.outflux.net> (Kees Cook's message of
	"Thu, 28 Jan 2016 06:38:25 -0800")
Message-ID: <87io2degsu.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH v2] sysctl: allow CLONE_NEWUSER to be disabled
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Andy Lutomirski <luto@kernel.org>, "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, Richard Weinberger <richard@nod.at>, Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

> +	if (sysctl_userns_restrict && !(capable(CAP_SYS_ADMIN) &&
> +					capable(CAP_SETUID) &&
> +					capable(CAP_SETGID)))
> +		return -EPERM;
> +

I will also note that the way I have seen containers used this check
adds no security and is not mentioned or justified in any way in your
patch description.

Furthermore this looks like blame shifting.  And quite frankly shifting
the responsibility to users if they get hacked is not an acceptable
attitude.

Eric
