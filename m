Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Mon, 25 Jun 2012 14:05:25 -0700
Message-Id: <1340658327-2932-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2012.4 0/2] fs: add link restrictions
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Doug Ledford <dledford@redhat.com>, Joe Korty <joe.korty@ccur.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>, James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This splits the VFS restrictions from the audit reporting so they can
be reviewed separately. Note that this applies to linux-next (in that
the error/filp handling in namei.c changed[1]).

-Kees

[1] https://lkml.org/lkml/2012/6/25/312
