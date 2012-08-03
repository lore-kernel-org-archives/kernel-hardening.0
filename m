Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <alpine.LRH.2.02.1208031425530.25196@tundra.namei.org>
References: <1343262548-21743-1-git-send-email-keescook@chromium.org>
	<1343262548-21743-2-git-send-email-keescook@chromium.org>
	<alpine.LRH.2.02.1208031425530.25196@tundra.namei.org>
Date: Fri, 3 Aug 2012 10:01:10 -0700
Message-ID: <CAGXu5jKFm3uxwF3hhhzkUJcxJ0zOH89_bAgQGLCEf=g3CpXuHw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: Re: [kernel-hardening] [PATCH 1/2] fs: add link restrictions
To: James Morris <jmorris@namei.org>
Cc: kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Doug Ledford <dledford@redhat.com>, Joe Korty <joe.korty@ccur.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>, James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 2, 2012 at 9:26 PM, James Morris <jmorris@namei.org> wrote:
> On Wed, 25 Jul 2012, Kees Cook wrote:
>
>> This adds symlink and hardlink restrictions to the Linux VFS.
>
> Is Al happy with this now?

Looks like it; thanks for checking. It's in mainline now:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=800179c9b8a1e796e441674776d11cd4c05d61d7

-Kees

-- 
Kees Cook
Chrome OS Security
