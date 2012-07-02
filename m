Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20120630091422.GE14083@ZenIV.linux.org.uk>
References: <1340658327-2932-1-git-send-email-keescook@chromium.org>
	<1340658327-2932-2-git-send-email-keescook@chromium.org>
	<20120630091422.GE14083@ZenIV.linux.org.uk>
Date: Sun, 1 Jul 2012 17:43:22 -0700
Message-ID: <CAGXu5j+8KMdX92T6Ma8HBXko4BHGmZKcV1kuR+b38r00r6YZbw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 1/2] fs: add link restrictions
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Doug Ledford <dledford@redhat.com>, Joe Korty <joe.korty@ccur.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>, James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jun 30, 2012 at 2:14 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Jun 25, 2012 at 02:05:26PM -0700, Kees Cook wrote:
>
>> +config PROTECTED_LINKS
>> +     bool "Evaluate vulnerable link conditions"
>> +     default y
>
> Remember Linus' rants about 'default y' in general?

I added these configs due to other people's requests. I am happy to
remove them all and have the sysctls start their life == 1. It would
eliminate all the #ifdef logic too.

>> +     /* Check parent directory mode and owner. */
>
> I suspect that we ought to simply pass that parent directory as argument - caller
> *does* have a reference to it, so we don't need to mess with ->d_lock, etc.

I don't see where the parent is held in either path_openat nor
path_lookupat. What should I be passing into may_follow_link() for the
parent?

>> +                     err = may_follow_link(&link);
>> +                     if (unlikely(err))
>> +                             break;
>
> No.  This is definitely wrong - you are leaking dentries and vfsmount here.

What should I do to avoid the leak? I thought it was avoiding the need
to call put_link because it aborts before calling follow_link.

>> +             error = may_follow_link(&link);
>> +             if (unlikely(error))
>> +                     break;
>
> Ditto.

Same thing here -- it aborts before the follow_link. I must be
misunderstanding something. What am I missing?

Thanks for the feedback! I'll clean up the other things you mentioned as well.

-Kees

-- 
Kees Cook
Chrome OS Security
