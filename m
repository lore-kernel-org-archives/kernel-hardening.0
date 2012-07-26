Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Wed, 25 Jul 2012 17:29:06 -0700
Message-Id: <1343262548-21743-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [RESEND][PATCH v2012.5 0/2] fs: add link restrictions
To: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Doug Ledford <dledford@redhat.com>, Joe Korty <joe.korty@ccur.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>, James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Resending; originally posted 2012-07-02: https://lkml.org/lkml/2012/7/2/394

This cleans up the various issues that Al Viro pointed out[1], and 
rebases to Linus's current tree.

Thanks,

-Kees

[1] https://lkml.org/lkml/2012/6/30/42
