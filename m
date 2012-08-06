Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <87hasfinik.fsf@xmission.com>
References: <1343262548-21743-1-git-send-email-keescook@chromium.org>
	<1343262548-21743-2-git-send-email-keescook@chromium.org>
	<alpine.LRH.2.02.1208031425530.25196@tundra.namei.org>
	<CAGXu5jKFm3uxwF3hhhzkUJcxJ0zOH89_bAgQGLCEf=g3CpXuHw@mail.gmail.com>
	<87hasfinik.fsf@xmission.com>
Date: Mon, 6 Aug 2012 16:59:22 -0700
Message-ID: <CAGXu5j+8mY1Rr5Uw5BYAhwhKVV_CvT5yu8YDJ1RqOta2NbVfQQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: Re: [kernel-hardening] [PATCH 1/2] fs: add link restrictions
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Doug Ledford <dledford@redhat.com>, Joe Korty <joe.korty@ccur.com>, Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>, James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>
List-ID: <kernel-hardening.lists.openwall.com>

[resend: MUA tricked me into sending HTML email...]

On Mon, Aug 6, 2012 at 4:55 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Kees Cook <keescook@chromium.org> writes:
>
> > On Thu, Aug 2, 2012 at 9:26 PM, James Morris <jmorris@namei.org> wrote:
> >> On Wed, 25 Jul 2012, Kees Cook wrote:
> >>
> >>> This adds symlink and hardlink restrictions to the Linux VFS.
> >>
> >> Is Al happy with this now?
> >
> > Looks like it; thanks for checking. It's in mainline now:
> >
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=800179c9b8a1e796e441674776d11cd4c05d61d7
>
> So there was one trivial little issue with your patch.  You were
> directly comparing kuids instead of using uid_eq.  This only practically
> matters when user namespaces are enabled which is currently impossible
> in 3.6-rc1 :(
>
> I have added the following fixup patch to my for-next branch of
> user-namespace.git
>
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Fri, 3 Aug 2012 09:38:08 -0700
> Subject: [PATCH] userns:  Fix link restrictions to use uid_eq
>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Ah-ha! Thanks for fixing this.

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

--
Kees Cook
Chrome OS Security
