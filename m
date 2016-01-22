Reply-To: kernel-hardening@lists.openwall.com
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
From: Richard Weinberger <richard@nod.at>
Message-ID: <56A2B209.7000403@nod.at>
Date: Fri, 22 Jan 2016 23:49:45 +0100
MIME-Version: 1.0
In-Reply-To: <1453502345-30416-1-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH 0/2] sysctl: allow CLONE_NEWUSER to be disabled
To: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, =?UTF-8?Q?Robert_=c5=9awi=c4=99cki?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Am 22.01.2016 um 23:39 schrieb Kees Cook:
> There continues to be unexpected side-effects and security exposures
> via CLONE_NEWUSER. For many end-users running distro kernels with
> CONFIG_USER_NS enabled, there is no way to disable this feature when
> desired. As such, this creates a sysctl to restrict CLONE_NEWUSER so
> admins not running containers or Chrome can avoid the risks of this
> feature.

Last time such a patch came up I was not thrilled because hiding
a scary feature behind a knob IMHO doesn't make it any better nor helps
finding issues.
But as userns is still a source of a lot of issues and distros enable
it by default a knob for the admin seems to be a good idea by now. ;-\

Thanks,
//richard
