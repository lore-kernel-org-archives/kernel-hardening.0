Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <1343262548-21743-1-git-send-email-keescook@chromium.org>
	<1343262548-21743-2-git-send-email-keescook@chromium.org>
	<alpine.LRH.2.02.1208031425530.25196@tundra.namei.org>
	<CAGXu5jKFm3uxwF3hhhzkUJcxJ0zOH89_bAgQGLCEf=g3CpXuHw@mail.gmail.com>
Date: Mon, 06 Aug 2012 16:55:31 -0700
In-Reply-To: <CAGXu5jKFm3uxwF3hhhzkUJcxJ0zOH89_bAgQGLCEf=g3CpXuHw@mail.gmail.com>
	(Kees Cook's message of "Fri, 3 Aug 2012 10:01:10 -0700")
Message-ID: <87hasfinik.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] [PATCH 1/2] fs: add link restrictions
To: Kees Cook <keescook@chromium.org>
Cc: James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Doug Ledford <dledford@redhat.com>, Joe Korty <joe.korty@ccur.com>, Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>, James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

> On Thu, Aug 2, 2012 at 9:26 PM, James Morris <jmorris@namei.org> wrote:
>> On Wed, 25 Jul 2012, Kees Cook wrote:
>>
>>> This adds symlink and hardlink restrictions to the Linux VFS.
>>
>> Is Al happy with this now?
>
> Looks like it; thanks for checking. It's in mainline now:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=800179c9b8a1e796e441674776d11cd4c05d61d7

So there was one trivial little issue with your patch.  You were
directly comparing kuids instead of using uid_eq.  This only practically
matters when user namespaces are enabled which is currently impossible
in 3.6-rc1 :(

I have added the following fixup patch to my for-next branch of
user-namespace.git

From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 3 Aug 2012 09:38:08 -0700
Subject: [PATCH] userns:  Fix link restrictions to use uid_eq

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/namei.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 1b46439..05480a6 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -678,7 +678,7 @@ static inline int may_follow_link(struct path *link, struct nameidata *nd)
 
 	/* Allowed if owner and follower match. */
 	inode = link->dentry->d_inode;
-	if (current_cred()->fsuid == inode->i_uid)
+	if (uid_eq(current_cred()->fsuid, inode->i_uid))
 		return 0;
 
 	/* Allowed if parent directory not sticky and world-writable. */
@@ -687,7 +687,7 @@ static inline int may_follow_link(struct path *link, struct nameidata *nd)
 		return 0;
 
 	/* Allowed if parent directory and link owner match. */
-	if (parent->i_uid == inode->i_uid)
+	if (uid_eq(parent->i_uid, inode->i_uid))
 		return 0;
 
 	path_put_conditional(link, nd);
@@ -757,7 +757,7 @@ static int may_linkat(struct path *link)
 	/* Source inode owner (or CAP_FOWNER) can hardlink all they like,
 	 * otherwise, it must be a safe source.
 	 */
-	if (cred->fsuid == inode->i_uid || safe_hardlink_source(inode) ||
+	if (uid_eq(cred->fsuid, inode->i_uid) || safe_hardlink_source(inode) ||
 	    capable(CAP_FOWNER))
 		return 0;
 
-- 
1.7.5.4
