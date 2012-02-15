Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 16 Feb 2012 10:41:01 +1100 (EST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <20120215004809.GO20420@outflux.net>
Message-ID: <alpine.LRH.2.02.1202161031260.30179@tundra.namei.org>
References: <20120215004809.GO20420@outflux.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH] Yama: add PR_SET_PTRACER_ANY
To: Kees Cook <keescook@chromium.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, John Johansen <john.johansen@canonical.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 14 Feb 2012, Kees Cook wrote:

> For a process to entirely disable Yama ptrace restrictions, it can use
> the special PR_SET_PTRACER_ANY pid to indicate that any otherwise allowed
> process may ptrace it. This is stronger than calling PR_SET_PTRACER with
> pid "1" because it includes processes in external pid namespaces. This is
> currently needed by the Chrome renderer, since its crash handler (Breakpad)
> runs external to the renderer's pid namespace.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next

-- 
James Morris
<jmorris@namei.org>
