From: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1492640420-27345-3-git-send-email-tixxdz@gmail.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com> <1492640420-27345-3-git-send-email-tixxdz@gmail.com>
Date: Mon, 24 Apr 2017 13:59:48 +0930
Message-ID: <87r30ifmwz.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH v3 2/2] modules:capabilities: add a per-task modules autoload restriction
To: Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, serge@hallyn.com, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org
Cc: Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Ingo Molnar <mingo@kernel.org>, zendyani@gmail.com, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

Djalal Harouni <tixxdz@gmail.com> writes:
> When value is (1), task must have CAP_SYS_MODULE to be able to trigger a
> module auto-load operation, or CAP_NET_ADMIN for modules with a
> 'netdev-%s' alias.

Sorry, the magic 'netdev-' prefix is a crawling horror.  To do this
properly, you need to hand the capability (if any) from the
request_module() call.  Probably by adding a new request_module_cap and
making request_module() call that, then fixing up the callers.

Cheers,
Rusty.
