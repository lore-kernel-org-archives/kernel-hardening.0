Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri, 22 Jan 2016 14:39:03 -0800
Message-Id: <1453502345-30416-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 0/2] sysctl: allow CLONE_NEWUSER to be disabled 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, =?UTF-8?q?Robert=20=C5=9Awi=C4=99cki?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

There continues to be unexpected side-effects and security exposures
via CLONE_NEWUSER. For many end-users running distro kernels with
CONFIG_USER_NS enabled, there is no way to disable this feature when
desired. As such, this creates a sysctl to restrict CLONE_NEWUSER so
admins not running containers or Chrome can avoid the risks of this
feature.

-Kees
